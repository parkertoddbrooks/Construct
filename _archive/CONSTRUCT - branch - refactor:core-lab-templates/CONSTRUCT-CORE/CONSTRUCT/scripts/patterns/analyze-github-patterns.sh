#!/bin/bash

# analyze-github-patterns.sh - Analyze GitHub repository for language patterns
# Fetches language statistics from GitHub and recommends CONSTRUCT patterns

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSTRUCT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
CONSTRUCT_CORE="$CONSTRUCT_ROOT/CONSTRUCT-CORE"

# Function to get GitHub repository info
get_github_repo_info() {
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        return 1
    fi
    
    # Try multiple remotes in order of preference
    local remotes=("upstream" "origin" "main" "github")
    local remote_url=""
    
    for remote in "${remotes[@]}"; do
        remote_url=$(git config --get "remote.$remote.url" 2>/dev/null)
        if [ -n "$remote_url" ] && [[ "$remote_url" =~ github\.com ]]; then
            break
        fi
        remote_url=""
    done
    
    if [ -z "$remote_url" ]; then
        return 1
    fi
    
    # Extract owner/repo from various GitHub URL formats
    local owner_repo=""
    if [[ "$remote_url" =~ github\.com[:/]([^/]+)/([^/]+)(\.git)?$ ]]; then
        local owner="${BASH_REMATCH[1]}"
        local repo="${BASH_REMATCH[2]}"
        # Remove .git suffix if present
        repo="${repo%.git}"
        owner_repo="${owner}/${repo}"
    else
        return 1
    fi
    
    echo "$owner_repo"
    return 0
}

# Function to fetch GitHub language stats
fetch_github_languages() {
    local owner_repo="$1"
    
    # Try gh CLI first
    if command -v gh &> /dev/null; then
        local response
        response=$(gh api "repos/$owner_repo/languages" 2>&1)
        if [ $? -eq 0 ]; then
            echo "$response"
            return 0
        fi
    fi
    
    # Fall back to curl
    if command -v curl &> /dev/null; then
        local response=$(curl -s -H "Accept: application/vnd.github.v3+json" \
            "https://api.github.com/repos/$owner_repo/languages")
        
        echo "$response"
        return 0
    fi
    
    # No tools available
    return 1
}

# Function to recommend patterns based on language
recommend_pattern_for_language() {
    local language="$1"
    local percentage="$2"
    
    # Normalize language name
    local normalized=$(echo "$language" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    
    # Direct mappings
    case "$normalized" in
        python) echo "languages/python" ;;
        swift) echo "languages/swift" ;;
        typescript) echo "languages/typescript" ;;
        javascript) echo "languages/javascript" ;;
        rust) echo "languages/rust" ;;
        go) echo "languages/go" ;;
        java) echo "languages/java" ;;
        c++) echo "languages/cpp" ;;
        c) echo "languages/c" ;;
        ruby) echo "languages/ruby" ;;
        shell|bash) echo "languages/bash" ;;
        *) 
            # No direct mapping - would need PRD
            echo ""
            ;;
    esac
}

# Function to analyze GitHub languages and recommend patterns
analyze_github_languages() {
    local owner_repo="$1"
    local languages_json="$2"
    
    echo -e "${BLUE}📊 GitHub Repository Language Analysis${NC}"
    echo -e "${BLUE}Repository: $owner_repo${NC}"
    echo ""
    
    # Calculate total bytes
    local total_bytes=0
    while IFS=: read -r language bytes; do
        bytes=$(echo "$bytes" | tr -d ',' | tr -d ' ' | tr -d '"')
        [ -n "$bytes" ] && [ "$bytes" -eq "$bytes" ] 2>/dev/null && total_bytes=$((total_bytes + bytes))
    done < <(echo "$languages_json" | grep -E '^\s*"[^"]+"\s*:' | sed 's/[{}]//g')
    
    # Process each language
    local recommendations=()
    local missing_patterns=()
    
    echo -e "${YELLOW}Language breakdown:${NC}"
    while IFS=: read -r language bytes; do
        # Clean up the input
        language=$(echo "$language" | tr -d '"' | xargs)
        bytes=$(echo "$bytes" | tr -d ',' | xargs)
        
        [ -z "$language" ] || [ -z "$bytes" ] && continue
        
        # Calculate percentage
        local percentage=0
        if [ $total_bytes -gt 0 ]; then
            percentage=$(awk -v b="$bytes" -v t="$total_bytes" 'BEGIN { printf "%.1f", (b/t)*100 }')
        fi
        
        echo "  - $language: $percentage%"
        
        # Skip if less than 1%
        if (( $(echo "$percentage < 1" | bc -l) )); then
            continue
        fi
        
        # Get pattern recommendation
        local pattern=$(recommend_pattern_for_language "$language" "$percentage")
        
        if [ -n "$pattern" ]; then
            # Check if pattern exists
            if [ -d "$CONSTRUCT_CORE/patterns/plugins/$pattern" ]; then
                recommendations+=("$pattern")
            else
                missing_patterns+=("$language:$percentage:$pattern")
            fi
        else
            missing_patterns+=("$language:$percentage:")
        fi
    done < <(echo "$languages_json" | grep -E '^\s*"[^"]+"\s*:' | sed 's/[{}]//g')
    
    echo ""
    
    # Show recommendations
    if [ ${#recommendations[@]} -gt 0 ]; then
        echo -e "${GREEN}✅ Recommended patterns:${NC}"
        printf '%s\n' "${recommendations[@]}" | sort -u | while read -r rec; do
            echo "   - $rec"
        done
        echo ""
    fi
    
    # Show missing patterns
    if [ ${#missing_patterns[@]} -gt 0 ]; then
        echo -e "${YELLOW}⚠️  Missing patterns for:${NC}"
        for item in "${missing_patterns[@]}"; do
            IFS=':' read -r lang percentage plugin <<< "$item"
            if [ -n "$plugin" ]; then
                echo "   - $lang ($percentage%) → $plugin (not found)"
            else
                echo "   - $lang ($percentage%) → no pattern mapping"
            fi
        done
        echo ""
        echo -e "${BLUE}💡 To create PRDs for missing patterns:${NC}"
        echo "   $0 --generate-prds"
    fi
    
    # Return recommendations for use by other scripts
    printf '%s ' "${recommendations[@]}"
}

# Show help
show_help() {
    echo "Usage: $0 [options] [owner/repo]"
    echo ""
    echo "Analyze GitHub repository languages and recommend CONSTRUCT patterns"
    echo ""
    echo "Options:"
    echo "  --json              Output recommendations as JSON"
    echo "  --generate-prds     Generate PRDs for missing patterns"
    echo "  --quiet             Only output pattern recommendations"
    echo "  -h, --help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                  # Analyze current git repository"
    echo "  $0 facebook/react   # Analyze specific repository"
    echo "  $0 --quiet          # Just get pattern list"
}

# Main logic
OUTPUT_MODE="normal"
GENERATE_PRDS=false
REPO_OVERRIDE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --json)
            OUTPUT_MODE="json"
            shift
            ;;
        --quiet)
            OUTPUT_MODE="quiet"
            shift
            ;;
        --generate-prds)
            GENERATE_PRDS=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            REPO_OVERRIDE="$1"
            shift
            ;;
    esac
done

# Get repository info
if [ -n "$REPO_OVERRIDE" ]; then
    owner_repo="$REPO_OVERRIDE"
else
    owner_repo=$(get_github_repo_info)
    if [ $? -ne 0 ]; then
        [ "$OUTPUT_MODE" != "quiet" ] && echo -e "${RED}❌ Not a GitHub repository${NC}" >&2
        exit 1
    fi
fi

# Fetch language data
languages_json=$(fetch_github_languages "$owner_repo")
if [ $? -ne 0 ] || [ -z "$languages_json" ] || [[ "$languages_json" =~ "Not Found" ]]; then
    [ "$OUTPUT_MODE" != "quiet" ] && echo -e "${YELLOW}⚠️  Could not fetch GitHub language data${NC}" >&2
    exit 1
fi

# Analyze based on output mode
case "$OUTPUT_MODE" in
    quiet)
        # Just output recommendations
        recommendations=$(analyze_github_languages "$owner_repo" "$languages_json" 2>/dev/null | tail -1)
        echo "$recommendations"
        ;;
    json)
        # TODO: Implement JSON output
        echo '{"error": "JSON output not yet implemented"}'
        exit 1
        ;;
    normal)
        # Full analysis output
        analyze_github_languages "$owner_repo" "$languages_json"
        
        # Generate PRDs if requested
        if [ "$GENERATE_PRDS" = true ]; then
            echo ""
            echo -e "${BLUE}📝 Generating PRDs...${NC}"
            echo "$languages_json" | "$SCRIPT_DIR/generate-pattern-prd.sh" --github
        fi
        ;;
esac