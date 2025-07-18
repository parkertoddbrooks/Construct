#!/bin/bash

# recommend-patterns.sh - Intelligent pattern recommendation combining multiple sources
# Analyzes GitHub, CLAUDE.md, and local files to recommend the best patterns

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

# Source library functions
source "$CONSTRUCT_CORE/CONSTRUCT/lib/common-patterns.sh" 2>/dev/null || true

# Function to analyze local project files
analyze_local_files() {
    local detected_languages=()
    local detected_frameworks=()
    local detected_platforms=()
    local detection_reasons=()
    
    # Detect languages with reasons
    if ls *.swift *.xcodeproj Package.swift 2>/dev/null | grep -q .; then
        detected_languages+=("swift")
        local swift_indicators=()
        ls *.swift 2>/dev/null | head -1 >/dev/null && swift_indicators+=("*.swift files")
        [ -f "Package.swift" ] && swift_indicators+=("Package.swift")
        ls *.xcodeproj 2>/dev/null | head -1 >/dev/null && swift_indicators+=("*.xcodeproj")
        detection_reasons+=("languages/swift|${swift_indicators[*]}")
    fi
    
    if ls *.py requirements.txt setup.py pyproject.toml 2>/dev/null | grep -q .; then
        detected_languages+=("python")
        local py_indicators=()
        ls *.py 2>/dev/null | head -1 >/dev/null && py_indicators+=("*.py files")
        [ -f "requirements.txt" ] && py_indicators+=("requirements.txt")
        [ -f "setup.py" ] && py_indicators+=("setup.py")
        [ -f "pyproject.toml" ] && py_indicators+=("pyproject.toml")
        detection_reasons+=("languages/python|${py_indicators[*]}")
    fi
    
    if ls *.ts *.tsx package.json tsconfig.json 2>/dev/null | grep -q .; then
        detected_languages+=("typescript")
        local ts_indicators=()
        ls *.ts *.tsx 2>/dev/null | head -1 >/dev/null && ts_indicators+=("*.ts/*.tsx files")
        [ -f "tsconfig.json" ] && ts_indicators+=("tsconfig.json")
        [ -f "package.json" ] && ts_indicators+=("package.json")
        detection_reasons+=("languages/typescript|${ts_indicators[*]}")
    fi
    
    if ls *.rs Cargo.toml 2>/dev/null | grep -q .; then
        detected_languages+=("rust")
        local rust_indicators=()
        ls *.rs 2>/dev/null | head -1 >/dev/null && rust_indicators+=("*.rs files")
        [ -f "Cargo.toml" ] && rust_indicators+=("Cargo.toml")
        detection_reasons+=("languages/rust|${rust_indicators[*]}")
    fi
    
    # Detect frameworks with reasons
    if [ -f "Package.swift" ] && grep -q "SwiftUI" Package.swift 2>/dev/null; then
        detected_frameworks+=("swiftui")
        detection_reasons+=("frameworks/swiftui|SwiftUI in Package.swift")
    fi
    
    if [ -f "package.json" ]; then
        # Check for various web frameworks
        if grep -q "react" package.json 2>/dev/null; then
            detected_frameworks+=("react")
            detection_reasons+=("frameworks/react|react in package.json")
        fi
        if grep -q "vue" package.json 2>/dev/null; then
            detected_frameworks+=("vue")
            detection_reasons+=("frameworks/vue|vue in package.json")
        fi
        if grep -q "angular" package.json 2>/dev/null; then
            detected_frameworks+=("angular")
            detection_reasons+=("frameworks/angular|angular in package.json")
        fi
        if grep -q "express" package.json 2>/dev/null; then
            detected_frameworks+=("express")
            detection_reasons+=("frameworks/express|express in package.json")
        fi
    fi
    
    # Check Python frameworks
    if [ -f "requirements.txt" ]; then
        if grep -qE "^(flask|Flask)" requirements.txt 2>/dev/null; then
            detected_frameworks+=("flask")
            detection_reasons+=("frameworks/flask|flask in requirements.txt")
        fi
        if grep -qE "^(django|Django)" requirements.txt 2>/dev/null; then
            detected_frameworks+=("django")
            detection_reasons+=("frameworks/django|django in requirements.txt")
        fi
    fi
    
    # Detect platforms with reasons - but be careful not to over-match
    if ls *.xcodeproj 2>/dev/null | grep -q . && [[ " ${detected_languages[@]} " =~ " swift " ]]; then
        detected_platforms+=("ios")
        local ios_indicators=()
        ls *.xcodeproj 2>/dev/null | head -1 >/dev/null && ios_indicators+=("*.xcodeproj")
        [ -f "Info.plist" ] && ios_indicators+=("Info.plist")
        detection_reasons+=("platforms/ios|${ios_indicators[*]}")
        
        # Only recommend mvvm-ios if we also have SwiftUI
        if [[ " ${detected_frameworks[@]} " =~ " swiftui " ]]; then
            detection_reasons+=("architectural/mvvm-ios|iOS + SwiftUI project")
        fi
    fi
    
    # Check for web platform indicators
    if [ -f "index.html" ] || [ -f "public/index.html" ] || [ -d "static" ] || [ -d "public" ]; then
        if [[ " ${detected_frameworks[@]} " =~ " react " ]] || \
           [[ " ${detected_frameworks[@]} " =~ " vue " ]] || \
           [[ " ${detected_frameworks[@]} " =~ " angular " ]] || \
           [[ " ${detected_frameworks[@]} " =~ " flask " ]] || \
           [[ " ${detected_frameworks[@]} " =~ " django " ]]; then
            detected_platforms+=("web")
            detection_reasons+=("platforms/web|Web assets + framework detected")
        fi
    fi
    
    # Return results with reasons
    printf '%s\n' "${detection_reasons[@]}"
}

# Function to merge recommendations intelligently
merge_recommendations() {
    local github_recs="$1"
    local claude_recs="$2"
    local local_recs="$3"
    local mode="${4:-balanced}"
    
    # Use temporary file for scoring since we can't use associative arrays
    local temp_scores=$(mktemp)
    
    # Add GitHub recommendations (high confidence)
    if [ -n "$github_recs" ]; then
        for rec in $github_recs; do
            echo "$rec:3:github" >> "$temp_scores"
        done
    fi
    
    # Add CLAUDE.md recommendations (medium confidence)
    if [ -n "$claude_recs" ]; then
        for rec in $claude_recs; do
            echo "$rec:2:claude" >> "$temp_scores"
        done
    fi
    
    # Add local file recommendations (high confidence for languages, medium for frameworks)
    if [ -n "$local_recs" ]; then
        while IFS='|' read -r plugin reason; do
            [ -z "$plugin" ] && continue
            if [[ "$plugin" =~ ^languages/ ]]; then
                echo "$plugin:3:local" >> "$temp_scores"
            else
                echo "$plugin:2:local" >> "$temp_scores"
            fi
        done <<< "$local_recs"
    fi
    
    # Aggregate scores and sources
    local aggregated=$(mktemp)
    awk -F: '
    {
        plugin = $1
        score = $2
        source = $3
        
        scores[plugin] += score
        if (sources[plugin] != "") {
            sources[plugin] = sources[plugin] " " source
        } else {
            sources[plugin] = source
        }
    }
    END {
        for (plugin in scores) {
            print plugin ":" scores[plugin] ":" sources[plugin]
        }
    }
    ' "$temp_scores" > "$aggregated"
    
    # Sort by score and apply mode filters
    case "$mode" in
        essential)
            # Only language plugins with high confidence
            awk -F: '$1 ~ /^languages\// && $2 >= 3 { print }' "$aggregated" | sort -t: -k2 -nr
            ;;
        balanced)
            # Languages + frameworks with good confidence
            awk -F: '$2 >= 2 && ($1 ~ /^languages\// || $1 ~ /^frameworks\//) { print }' "$aggregated" | sort -t: -k2 -nr
            ;;
        comprehensive)
            # All recommendations with any confidence
            sort -t: -k2 -nr "$aggregated"
            ;;
    esac
    
    # Clean up
    rm -f "$temp_scores" "$aggregated"
}

# Show recommendations with reasoning
show_recommendations() {
    local recommendations="$1"
    local verbose="${2:-false}"
    
    echo -e "${BLUE}📊 Pattern Recommendations:${NC}"
    echo ""
    
    local essential=()
    local recommended=()
    local optional=()
    
    while IFS=':' read -r plugin score sources; do
        [ -z "$plugin" ] && continue
        
        # Categorize by score and type
        if [[ "$plugin" =~ ^languages/ ]] && [ "$score" -ge 3 ]; then
            essential+=("$plugin:$score:$sources")
        elif [ "$score" -ge 4 ]; then
            essential+=("$plugin:$score:$sources")
        elif [ "$score" -ge 2 ]; then
            recommended+=("$plugin:$score:$sources")
        else
            optional+=("$plugin:$score:$sources")
        fi
    done <<< "$recommendations"
    
    # Show essential patterns
    if [ ${#essential[@]} -gt 0 ]; then
        echo -e "${GREEN}✅ Essential patterns (install these):${NC}"
        for item in "${essential[@]}"; do
            IFS=':' read -r plugin score sources <<< "$item"
            echo -n "  - $plugin"
            [ "$verbose" = true ] && echo -n " (detected by: $(echo $sources | xargs))"
            echo ""
        done
        echo ""
    fi
    
    # Show recommended patterns
    if [ ${#recommended[@]} -gt 0 ]; then
        echo -e "${YELLOW}💡 Recommended patterns (consider these):${NC}"
        for item in "${recommended[@]}"; do
            IFS=':' read -r plugin score sources <<< "$item"
            echo -n "  - $plugin"
            [ "$verbose" = true ] && echo -n " (detected by: $(echo $sources | xargs))"
            echo ""
        done
        echo ""
    fi
    
    # Show optional patterns in verbose mode
    if [ "$verbose" = true ] && [ ${#optional[@]} -gt 0 ]; then
        echo -e "${GRAY}○ Optional patterns (weak signals):${NC}"
        for item in "${optional[@]}"; do
            IFS=':' read -r plugin score sources <<< "$item"
            echo "  - $plugin (detected by: $(echo $sources | xargs))"
        done
        echo ""
    fi
}

# Show help
show_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Intelligent pattern recommendation combining GitHub, CLAUDE.md, and local analysis"
    echo ""
    echo "Options:"
    echo "  --github          Include GitHub analysis"
    echo "  --claude FILE     Analyze specific CLAUDE.md file"
    echo "  --mode MODE       Recommendation mode: essential|balanced|comprehensive"
    echo "  --verbose         Show detailed reasoning"
    echo "  --quiet           Only output pattern list"
    echo "  --json            Output as JSON (TODO)"
    echo "  -h, --help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                           # Quick local analysis"
    echo "  $0 --github                  # Full analysis with GitHub"
    echo "  $0 --claude CLAUDE.md.backup # Include original CLAUDE.md"
    echo "  $0 --mode essential --quiet  # Just essential patterns"
}

# Main logic
INCLUDE_GITHUB=false
CLAUDE_FILE=""
MODE="balanced"
VERBOSE=false
QUIET=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --github)
            INCLUDE_GITHUB=true
            shift
            ;;
        --claude)
            CLAUDE_FILE="$2"
            shift 2
            ;;
        --mode)
            MODE="$2"
            shift 2
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --quiet)
            QUIET=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# Validate mode
case "$MODE" in
    essential|balanced|comprehensive) ;;
    *)
        echo -e "${RED}❌ Invalid mode: $MODE${NC}"
        echo "Valid modes: essential, balanced, comprehensive"
        exit 1
        ;;
esac

# Gather recommendations from all sources
github_recommendations=""
claude_recommendations=""
local_recommendations=""

# 1. GitHub analysis
if [ "$INCLUDE_GITHUB" = true ]; then
    [ "$QUIET" != true ] && echo -e "${BLUE}🐙 Analyzing GitHub repository...${NC}"
    github_recommendations=$("$SCRIPT_DIR/analyze-github-patterns.sh" --quiet 2>/dev/null || true)
fi

# 2. CLAUDE.md analysis
if [ -n "$CLAUDE_FILE" ] && [ -f "$CLAUDE_FILE" ]; then
    [ "$QUIET" != true ] && echo -e "${BLUE}📄 Analyzing CLAUDE.md content...${NC}"
    claude_recommendations=$("$SCRIPT_DIR/analyze-claude-content.sh" --quiet "$CLAUDE_FILE" 2>/dev/null || true)
elif [ -f "CLAUDE.md.backup" ]; then
    # Use backup if it exists (original from /init)
    [ "$QUIET" != true ] && echo -e "${BLUE}📄 Analyzing original CLAUDE.md content...${NC}"
    claude_recommendations=$("$SCRIPT_DIR/analyze-claude-content.sh" --quiet "CLAUDE.md.backup" 2>/dev/null || true)
elif [ -f "CLAUDE.md" ]; then
    [ "$QUIET" != true ] && echo -e "${BLUE}📄 Analyzing current CLAUDE.md content...${NC}"
    claude_recommendations=$("$SCRIPT_DIR/analyze-claude-content.sh" --quiet "CLAUDE.md" 2>/dev/null || true)
fi

# 3. Local file analysis
[ "$QUIET" != true ] && echo -e "${BLUE}📁 Analyzing local project files...${NC}"
local_recommendations=$(analyze_local_files)

# Merge recommendations
[ "$QUIET" != true ] && echo ""
merged_recommendations=$(merge_recommendations "$github_recommendations" "$claude_recommendations" "$local_recommendations" "$MODE")

# Output results
if [ "$QUIET" = true ]; then
    # Just output the pattern list
    if [ -n "$merged_recommendations" ]; then
        echo "$merged_recommendations" | cut -d: -f1 | tr '\n' ' '
    fi
else
    show_recommendations "$merged_recommendations" "$VERBOSE"
    
    # Show summary
    pattern_count=$(echo "$merged_recommendations" | grep -c "^" || true)
    echo -e "${BLUE}📋 Summary:${NC}"
    echo "  Analysis mode: $MODE"
    echo "  Patterns found: $pattern_count"
    [ "$INCLUDE_GITHUB" = true ] && echo "  GitHub: ✓" || echo "  GitHub: ✗"
    [ -n "$CLAUDE_FILE" ] && echo "  CLAUDE.md: ✓" || echo "  CLAUDE.md: ✗"
    echo "  Local files: ✓"
fi