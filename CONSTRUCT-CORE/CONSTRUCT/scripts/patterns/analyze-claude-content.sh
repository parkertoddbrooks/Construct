#!/bin/bash

# analyze-claude-content.sh - Analyze CLAUDE.md content for pattern recommendations
# Scans CLAUDE.md content and recommends patterns based on keywords/tags

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

# Function to analyze CLAUDE.md content
analyze_claude_md_content() {
    local claude_file="$1"
    local verbose="${2:-false}"
    local recommendations=()
    
    if [ ! -f "$claude_file" ]; then
        return
    fi
    
    # Get content of CLAUDE.md (lowercase for case-insensitive matching)
    local claude_content_lower=$(tr '[:upper:]' '[:lower:]' < "$claude_file")
    
    [ "$verbose" = true ] && echo -e "${BLUE}📄 Analyzing CLAUDE.md content...${NC}"
    
    # Directly scan plugin directories instead of using registry
    for category_dir in "$CONSTRUCT_CORE"/patterns/plugins/*/; do
        [ -d "$category_dir" ] || continue
        
        local category=$(basename "$category_dir")
        
        for plugin_dir in "$category_dir"*/; do
            [ -d "$plugin_dir" ] || continue
            
            local plugin=$(basename "$plugin_dir")
            local plugin_path="$category/$plugin"
            
            # Look for pattern.yaml or plugin.yaml
            local yaml_file=""
            for yaml in "$plugin_dir/pattern.yaml" "$plugin_dir/$plugin.yaml"; do
                if [ -f "$yaml" ]; then
                    yaml_file="$yaml"
                    break
                fi
            done
            
            [ -z "$yaml_file" ] && continue
            
            # Extract tags from yaml metadata for detection
            local tags=""
            
            # Extract tags from the yaml file
            if grep -q "tags:" "$yaml_file"; then
                tags=$(awk '/^tags:/{flag=1; next} /^[^ ]/{flag=0} flag && /^[ ]+- / {gsub(/^[ ]+- /, ""); print}' "$yaml_file" | tr '\n' '|' | sed 's/|$//')
            fi
            
            # If no tags, skip this plugin
            if [ -z "$tags" ]; then
                continue
            fi
            
            # Check if any tags match in CLAUDE.md with word boundaries
            local tag_matched=false
            local matched_tag=""
            IFS='|' read -ra tag_array <<< "$tags"
            for tag in "${tag_array[@]}"; do
                # Skip generic tags that cause false positives
                case "$tag" in
                    web|testing|async|css|html|mobile) 
                        # For generic terms, require more specific context
                        if [[ "$plugin_path" == "frameworks/web" ]] && echo "$claude_content_lower" | grep -qE "\b(web interface|web development|web framework|flask|django|react|vue|angular)\b"; then
                            tag_matched=true
                            matched_tag="$tag (with context)"
                            break
                        elif [[ "$plugin_path" == "platforms/web" ]] && echo "$claude_content_lower" | grep -qE "\b(html|css|javascript|frontend|browser)\b"; then
                            tag_matched=true
                            matched_tag="$tag (with context)"
                            break
                        fi
                        ;;
                    *)
                        # For specific tags, use word boundary matching
                        if echo "$claude_content_lower" | grep -qE "\b$tag\b"; then
                            tag_matched=true
                            matched_tag="$tag"
                            break
                        fi
                        ;;
                esac
            done
            
            if [ "$tag_matched" = true ]; then
                recommendations+=("$plugin_path")
                [ "$verbose" = true ] && echo -e "${GREEN}  ✓ Found match for $plugin_path (tag: $matched_tag)${NC}"
            fi
        done
    done
    
    # Return unique recommendations
    printf '%s\n' "${recommendations[@]}" | sort -u | tr '\n' ' '
}

# Function to check if CLAUDE.md is from /init
is_from_init() {
    local claude_file="$1"
    # Check for common /init patterns
    grep -q "This file provides guidance to Claude" "$claude_file" 2>/dev/null || \
    grep -q "AI coding assistant" "$claude_file" 2>/dev/null || \
    grep -q "codebase context" "$claude_file" 2>/dev/null || \
    grep -q "## Project Overview" "$claude_file" 2>/dev/null
}

# Function to extract key information from CLAUDE.md
extract_claude_info() {
    local claude_file="$1"
    
    echo -e "${BLUE}📄 Extracting key information from CLAUDE.md...${NC}"
    
    # Extract project type/language mentions
    echo -e "${YELLOW}Languages mentioned:${NC}"
    grep -i -E "\b(python|swift|typescript|javascript|rust|go|java|ruby)\b" "$claude_file" | head -5 || echo "  None found"
    
    echo -e "${YELLOW}Frameworks mentioned:${NC}"
    grep -i -E "\b(flask|django|react|vue|angular|swiftui|rails|spring)\b" "$claude_file" | head -5 || echo "  None found"
    
    echo -e "${YELLOW}Key patterns mentioned:${NC}"
    grep -i -E "\b(web|api|mobile|cli|desktop|serverless|microservice)\b" "$claude_file" | head -5 || echo "  None found"
}

# Show help
show_help() {
    echo "Usage: $0 [options] <claude-file>"
    echo ""
    echo "Analyze CLAUDE.md content for pattern recommendations"
    echo ""
    echo "Arguments:"
    echo "  claude-file    Path to CLAUDE.md file to analyze"
    echo ""
    echo "Options:"
    echo "  --verbose       Show detailed analysis"
    echo "  --info          Extract key information"
    echo "  --quiet         Only output recommendations"
    echo "  -h, --help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 CLAUDE.md"
    echo "  $0 --verbose CLAUDE.md.backup"
    echo "  $0 --quiet CLAUDE.md"
}

# Parse arguments
CLAUDE_FILE=""
VERBOSE=false
INFO_MODE=false
QUIET_MODE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --verbose)
            VERBOSE=true
            shift
            ;;
        --info)
            INFO_MODE=true
            shift
            ;;
        --quiet)
            QUIET_MODE=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            CLAUDE_FILE="$1"
            shift
            ;;
    esac
done

# Validate arguments
if [ -z "$CLAUDE_FILE" ]; then
    if [ "$QUIET_MODE" != true ]; then
        echo -e "${RED}❌ Error: CLAUDE.md file required${NC}"
        show_help
    fi
    exit 1
fi

if [ ! -f "$CLAUDE_FILE" ]; then
    if [ "$QUIET_MODE" != true ]; then
        echo -e "${RED}❌ Error: File not found: $CLAUDE_FILE${NC}"
    fi
    exit 1
fi

# Execute analysis
if [ "$INFO_MODE" = true ]; then
    extract_claude_info "$CLAUDE_FILE"
elif [ "$QUIET_MODE" = true ]; then
    # Just output recommendations
    analyze_claude_md_content "$CLAUDE_FILE" false
else
    # Full analysis
    if is_from_init "$CLAUDE_FILE"; then
        echo -e "${GREEN}✅ CLAUDE.md appears to be from /init${NC}"
    else
        echo -e "${YELLOW}⚠️  CLAUDE.md may be custom or legacy${NC}"
    fi
    echo ""
    
    recommendations=$(analyze_claude_md_content "$CLAUDE_FILE" "$VERBOSE")
    
    if [ -n "$recommendations" ]; then
        echo ""
        echo -e "${GREEN}📋 Recommended patterns based on content:${NC}"
        for rec in $recommendations; do
            echo "  - $rec"
        done
    else
        echo -e "${GRAY}No pattern recommendations found based on content${NC}"
    fi
fi