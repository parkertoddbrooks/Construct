#!/bin/bash

# init-construct.sh - Enhances CLAUDE.md with CONSTRUCT patterns
# This is Stage 2 of the two-stage initialization process
# Stage 1: User runs /init (creates standard CLAUDE.md)
# Stage 2: User runs this script (enhances with patterns)
# INTERACTIVE_MODE: enabled

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# Plugin registry will be loaded as needed

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSTRUCT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
CONSTRUCT_CORE="$CONSTRUCT_ROOT/CONSTRUCT-CORE"
CONSTRUCT_LAB="$CONSTRUCT_ROOT/CONSTRUCT-LAB"

# Check if running in Claude Code environment
if [ -n "$CLAUDE_CODE" ] || [ -n "$ANTHROPIC_WORKBENCH" ]; then
    # Force interactive mode in Claude Code
    export CONSTRUCT_INTERACTIVE=1
    echo -e "${BLUE}🤖 Claude Code detected - enabling interactive mode${NC}"
fi

# Source library functions
source "$CONSTRUCT_CORE/CONSTRUCT/lib/common-patterns.sh" 2>/dev/null || true
source "$CONSTRUCT_CORE/CONSTRUCT/lib/validation.sh" 2>/dev/null || true
source "$CONSTRUCT_CORE/CONSTRUCT/lib/interactive-support.sh" 2>/dev/null || true

# Function to check if CLAUDE.md is from /init
is_from_init() {
    local claude_file="$1"
    # Check for common /init patterns
    grep -q "This file provides guidance to Claude" "$claude_file" 2>/dev/null || \
    grep -q "AI coding assistant" "$claude_file" 2>/dev/null || \
    grep -q "codebase context" "$claude_file" 2>/dev/null || \
    grep -q "## Project Overview" "$claude_file" 2>/dev/null
}

# Function to check if old CONSTRUCT version
is_old_construct_version() {
    local claude_file="$1"
    grep -q "CONSTRUCT Version" "$claude_file" 2>/dev/null || \
    grep -q "construct-update" "$claude_file" 2>/dev/null || \
    grep -q "ENFORCE THESE RULES" "$claude_file" 2>/dev/null || \
    grep -q "Swift/SwiftUI Truths" "$claude_file" 2>/dev/null || \
    grep -q "🚨 ENFORCE THESE RULES" "$claude_file" 2>/dev/null
}

# Function to detect operating mode
detect_operating_mode() {
    if [ ! -f "CLAUDE.md" ]; then
        echo "error_no_claude"
    elif [ -f ".construct/patterns.yaml" ]; then
        echo "mode_2"  # Existing CONSTRUCT user
    elif is_from_init "CLAUDE.md"; then
        echo "mode_1"  # First-time CONSTRUCT user
    else
        echo "mode_3"  # Legacy migration
    fi
}

# Function to validate plugin exists
validate_plugin_exists() {
    local plugin="$1"
    local plugin_dir="$CONSTRUCT_CORE/patterns/plugins/$plugin"
    
    if [ ! -d "$plugin_dir" ]; then
        return 1
    fi
    
    # Check for required plugin files
    local plugin_name=$(basename "$plugin")
    local plugin_yaml=""
    
    # Try different yaml file names
    for yaml_file in "$plugin_dir/$plugin_name.yaml" "$plugin_dir/pattern.yaml"; do
        if [ -f "$yaml_file" ]; then
            plugin_yaml="$yaml_file"
            break
        fi
    done
    
    if [ -z "$plugin_yaml" ]; then
        return 1
    fi
    
    return 0
}

# Function to analyze CLAUDE.md content from /init
analyze_claude_md_content() {
    local claude_file="$1"
    local recommendations=()
    
    if [ ! -f "$claude_file" ]; then
        return
    fi
    
    # Get content of CLAUDE.md (lowercase for case-insensitive matching)
    local claude_content_lower=$(tr '[:upper:]' '[:lower:]' < "$claude_file")
    
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
            # Split tags and check each one with word boundaries
            local tag_matched=false
            IFS='|' read -ra tag_array <<< "$tags"
            for tag in "${tag_array[@]}"; do
                # Skip generic tags that cause false positives
                case "$tag" in
                    web|testing|async|css|html|mobile) 
                        # For generic terms, require more specific context
                        if [[ "$plugin_path" == "frameworks/web" ]] && echo "$claude_content_lower" | grep -qE "\b(web interface|web development|web framework|flask|django|react|vue|angular)\b"; then
                            tag_matched=true
                            break
                        elif [[ "$plugin_path" == "platforms/web" ]] && echo "$claude_content_lower" | grep -qE "\b(html|css|javascript|frontend|browser)\b"; then
                            tag_matched=true
                            break
                        fi
                        ;;
                    *)
                        # For specific tags, use word boundary matching
                        if echo "$claude_content_lower" | grep -qE "\b$tag\b"; then
                            tag_matched=true
                            break
                        fi
                        ;;
                esac
            done
            
            if [ "$tag_matched" = true ]; then
                recommendations+=("$plugin_path")
            fi
        done
    done
    
    # Return unique recommendations
    printf '%s\n' "${recommendations[@]}" | sort -u | tr '\n' ' '
}

# Function to analyze project structure
analyze_project() {
    local detected_languages=()
    local detected_frameworks=()
    local detected_platforms=()
    
    # Detect languages
    if ls *.swift *.xcodeproj Package.swift 2>/dev/null | grep -q .; then
        detected_languages+=("swift")
    fi
    if ls *.py requirements.txt setup.py pyproject.toml 2>/dev/null | grep -q .; then
        detected_languages+=("python")
    fi
    if ls *.ts *.tsx package.json tsconfig.json 2>/dev/null | grep -q .; then
        detected_languages+=("typescript")
    fi
    if ls *.rs Cargo.toml 2>/dev/null | grep -q .; then
        detected_languages+=("rust")
    fi
    
    # Detect frameworks
    if [ -f "Package.swift" ] && grep -q "SwiftUI" Package.swift 2>/dev/null; then
        detected_frameworks+=("swiftui")
    fi
    if [ -f "package.json" ] && grep -q "react" package.json 2>/dev/null; then
        detected_frameworks+=("react")
    fi
    
    # Detect platforms
    if [ -f "Info.plist" ] || [ -d "*.xcodeproj" ]; then
        detected_platforms+=("ios")
    fi
    
    echo "${detected_languages[@]}"
    echo "${detected_frameworks[@]}"
    echo "${detected_platforms[@]}"
}

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
        
        # Always return the response to the caller to handle
        echo "$response"
        return 0
    fi
    
    # No tools available
    return 1
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
    while IFS=: read -r lang bytes; do
        # Clean up the JSON parsing
        lang=$(echo "$lang" | tr -d '"{,' | xargs)
        bytes=$(echo "$bytes" | tr -d '", ' | xargs)
        [ -z "$lang" ] && continue
        total_bytes=$((total_bytes + bytes))
    done <<< "$(echo "$languages_json" | grep -E '".+": [0-9]+')"
    
    # Process each language
    local recommendations=()
    local missing_patterns=()
    local partial_coverage=()
    
    echo "Language breakdown:"
    while IFS=: read -r lang bytes; do
        # Clean up the JSON parsing
        lang=$(echo "$lang" | tr -d '"{,' | xargs)
        bytes=$(echo "$bytes" | tr -d '", ' | xargs)
        [ -z "$lang" ] && continue
        
        # Calculate percentage
        local percentage=$(awk "BEGIN {printf \"%.1f\", ($bytes / $total_bytes) * 100}")
        
        # Determine plugin availability
        local plugin_status=""
        local plugin_name=""
        
        case "$lang" in
            "Python")
                plugin_status="✅"
                plugin_name="languages/python"
                recommendations+=("languages/python")
                ;;
            "Swift")
                plugin_status="✅"
                plugin_name="languages/swift"
                recommendations+=("languages/swift")
                ;;
            "C#"|"CSharp")
                plugin_status="✅"
                plugin_name="languages/csharp"
                recommendations+=("languages/csharp")
                ;;
            "Shell")
                plugin_status="✅"
                plugin_name="tooling/shell-scripting"
                recommendations+=("tooling/shell-scripting")
                ;;
            "JavaScript"|"TypeScript")
                plugin_status="✅"
                plugin_name="frameworks/web"
                recommendations+=("frameworks/web")
                partial_coverage+=("$lang:$percentage:languages/$( echo $lang | tr '[:upper:]' '[:lower:]' )")
                ;;
            "HTML"|"CSS")
                plugin_status="✅"
                plugin_name="frameworks/web (basic coverage)"
                if [[ ! " ${recommendations[@]} " =~ " frameworks/web " ]]; then
                    recommendations+=("frameworks/web")
                fi
                partial_coverage+=("$lang:$percentage:languages/$( echo $lang | tr '[:upper:]' '[:lower:]' )")
                ;;
            *)
                plugin_status="❌"
                plugin_name="No plugin found"
                missing_patterns+=("$lang:$percentage")
                ;;
        esac
        
        printf "  %-12s %5s%%  %s %s\n" "$lang" "$percentage" "$plugin_status" "$plugin_name"
    done <<< "$(echo "$languages_json" | grep -E '".+": [0-9]+')"
    
    echo ""
    
    # Handle missing patterns
    if [ ${#missing_patterns[@]} -gt 0 ] || [ ${#partial_coverage[@]} -gt 0 ]; then
        echo -e "${YELLOW}📝 Pattern Coverage Analysis:${NC}"
        
        # Show partial coverage
        for item in "${partial_coverage[@]}"; do
            IFS=':' read -r lang percentage plugin <<< "$item"
            echo -e "  $lang ($percentage%) - Basic coverage via frameworks/web"
            echo -e "    → Consider creating $plugin for deeper patterns"
        done
        
        # Show missing patterns
        for item in "${missing_patterns[@]}"; do
            IFS=':' read -r lang percentage <<< "$item"
            echo -e "  $lang ($percentage%) - No pattern coverage"
        done
        
        echo ""
        
        # Ask about creating PRDs
        if is_interactive; then
            echo -e "${YELLOW}Would you like to create PRDs for missing/partial pattern coverage? [y/N]:${NC} "
            read -r create_prds
            
            if [[ "$create_prds" =~ ^[Yy] ]]; then
                create_pattern_prds "${missing_patterns[@]}" "${partial_coverage[@]}"
            fi
        fi
    fi
    
    # Return unique recommendations
    printf '%s\n' "${recommendations[@]}" | sort -u | tr '\n' ' '
}

# Function to create PRDs for missing patterns
create_pattern_prds() {
    local prd_dir="$CONSTRUCT_LAB/AI/PRDs/future"
    mkdir -p "$prd_dir"
    
    echo -e "${BLUE}📝 Creating Pattern PRDs for future development:${NC}"
    
    for item in "$@"; do
        IFS=':' read -r lang percentage plugin <<< "$item"
        
        # Skip if no plugin suggested
        [ -z "$plugin" ] && plugin="languages/$( echo $lang | tr '[:upper:]' '[:lower:]' | tr ' ' '-' )"
        
        local prd_file="$prd_dir/plugin-$(basename $plugin)-pattern.md"
        
        cat > "$prd_file" << EOF
# Pattern Plugin PRD: $plugin

## Overview
Create a CONSTRUCT pattern plugin for $lang development.

## Context
- Detected $percentage% $lang in project during init-construct analysis
- Repository analysis showed need for $lang-specific patterns
- Currently $([ "$percentage" ] && echo "partial" || echo "no") coverage available

## Requirements

### Pattern Content
- Language-specific best practices
- Common anti-patterns to avoid
- Security considerations
- Performance patterns
- Testing patterns

### Validators
- Code quality checks
- Style validation
- Security scanning
- Pattern compliance

### Integration
- Should work with existing patterns
- Consider interactions with frameworks/web (if applicable)
- Support common $lang frameworks and tools

## Priority
$(awk -v p="$percentage" 'BEGIN { 
    if (p > 10) print "High - Significant language presence"
    else if (p > 5) print "Medium - Notable language presence"
    else print "Low - Minor language presence"
}')

## Notes
Generated by init-construct.sh on $(date)
EOF

        echo -e "  ${GREEN}✅ Created: $(basename "$prd_file")${NC}"
    done
    
    # Create summary PRD
    local summary_file="$prd_dir/pattern-coverage-summary.md"
    {
        echo "# Pattern Coverage Summary"
        echo ""
        echo "Generated: $(date)"
        echo ""
        echo "## Missing Pattern Plugins"
        echo ""
        for item in "$@"; do
            IFS=':' read -r lang percentage plugin <<< "$item"
            echo "- $lang ($percentage%) → $plugin"
        done
        echo ""
        echo "## Next Steps"
        echo "1. Review individual PRDs"
        echo "2. Prioritize based on project needs"
        echo "3. Implement patterns incrementally"
    } >> "$summary_file"
    
    echo -e "  ${GREEN}✅ Updated: pattern-coverage-summary.md${NC}"
    echo ""
}

# Function to load plugin registry
load_plugin_registry() {
    local registry_file="$CONSTRUCT_CORE/patterns/plugins/registry.yaml"
    if [ ! -f "$registry_file" ]; then
        echo -e "${YELLOW}⚠️  Plugin registry not found. Running refresh...${NC}"
        "$CONSTRUCT_CORE/CONSTRUCT/scripts/construct/refresh-plugin-registry.sh" >/dev/null 2>&1
    fi
    
    # We don't need to parse the registry for analyze_claude_md_content anymore
    # It will scan directories directly
    
    return 0
}

# Define prompts for interactive mode
show_init_prompts() {
    # Check if patterns.yaml exists
    if [ -f "$PROJECT_ROOT/.construct/patterns.yaml" ]; then
        # Mode 2: Already has patterns
        if is_claude_prompts_mode "$@"; then
            echo "No prompts needed - patterns.yaml already exists"
            echo "Will regenerate from existing patterns"
            return
        fi
        
        echo "This project already has patterns configured."
        echo "Running with --regenerate will update CLAUDE.md from existing patterns."
        echo ""
        echo "No additional inputs needed."
    else
        # Mode 1 or 3: Need to create patterns
        if [ -f "CLAUDE.md" ]; then
            # Analyze project
            local detected=$(analyze_project)
            local languages=$(echo "$detected" | sed -n '1p')
            local frameworks=$(echo "$detected" | sed -n '2p')
            local platforms=$(echo "$detected" | sed -n '3p')
            
            if is_claude_prompts_mode "$@"; then
                echo "1. Pattern plugins to install (comma-separated)"
                echo "   Detected: $languages $frameworks $platforms"
                echo "   Default: Based on project analysis"
                return
            fi
            
            echo "1. Pattern plugins to install"
            echo "   Format: comma-separated list"
            echo ""
            
            # Show recommendations if we detected anything
            if [ -n "$languages$frameworks$platforms" ]; then
                echo "   Based on your project, we recommend:"
                [ -n "$languages" ] && echo "   - languages/$languages"
                [ -n "$frameworks" ] && echo "   - frameworks/$frameworks"
                [ -n "$platforms" ] && echo "   - platforms/$platforms"
                echo ""
            fi
            
            # Load and show available plugins
            if load_plugin_registry; then
                echo "   Available plugins:"
                local registry_file="$CONSTRUCT_CORE/patterns/plugins/registry.yaml"
                if command -v yq &> /dev/null && [ -f "$registry_file" ]; then
                    yq eval '.plugins.core | keys | .[]' "$registry_file" 2>/dev/null | head -10 | sed 's/^/   - /'
                    echo "   ... and more"
                fi
            fi
            
            echo ""
            echo "   Default: Accept recommendations or none if no project detected"
        fi
    fi
}

# Check if should show prompts
if should_show_prompts "$@"; then
    show_script_prompts "$(basename "$0")" show_init_prompts "$@"
    exit 0
fi

# Function to show mode-specific user communication
show_mode_message() {
    local mode="$1"
    
    echo -e "${BLUE}🚀 CONSTRUCT Pattern Enhancement${NC}"
    echo -e "${BLUE}================================${NC}"
    echo ""
    
    case "$mode" in
        mode_1)
            echo -e "${GREEN}🆕 First-time CONSTRUCT user detected${NC}"
            echo "   ✓ Found CLAUDE.md from /init"
            echo "   ✓ No patterns configured yet"
            echo ""
            echo "   We'll help you select the right patterns for your project."
            echo ""
            ;;
        mode_2)
            echo -e "${BLUE}♻️  Existing CONSTRUCT project detected${NC}"
            echo "   ✓ Found .construct/patterns.yaml"
            echo "   ✓ Will refresh patterns from configuration"
            echo ""
            echo "   Updating CLAUDE.md with latest pattern content..."
            echo ""
            ;;
        mode_3)
            echo -e "${YELLOW}🔄 Custom CLAUDE.md detected${NC}"
            if is_old_construct_version "CLAUDE.md"; then
                echo "   ✓ Found old CONSTRUCT version markers"
            else
                echo "   ✓ Found CLAUDE.md with custom patterns"
            fi
            echo "   ✓ No patterns.yaml configuration yet"
            echo ""
            echo "   We'll extract your custom patterns and convert to the plugin system."
            echo "   This preserves all your existing rules while enabling pattern reuse."
            echo ""
            ;;
        error_no_claude)
            echo -e "${RED}❌ No CLAUDE.md found!${NC}"
            echo ""
            echo "   Please run '/init' first to create the base CLAUDE.md"
            echo "   Then run this script to add CONSTRUCT patterns."
            echo ""
            ;;
    esac
}

# Function to show available plugins
show_available_plugins() {
    local registry_file="$CONSTRUCT_CORE/patterns/plugins/registry.yaml"
    
    echo -e "${BLUE}📦 Available Pattern Plugins:${NC}"
    echo ""
    
    if command -v yq &> /dev/null && [ -f "$registry_file" ]; then
        # Show plugins by category
        for category in languages frameworks platforms architectural tooling; do
            local plugins=$(yq eval ".plugins.core | to_entries | .[] | select(.key | test(\"^$category/\")) | .key" "$registry_file" 2>/dev/null)
            if [ -n "$plugins" ]; then
                echo -e "${YELLOW}$category:${NC}"
                while IFS= read -r plugin; do
                    local desc=$(yq eval ".plugins.core.\"$plugin\".description" "$registry_file" 2>/dev/null)
                    echo "  - $plugin"
                    [ -n "$desc" ] && [ "$desc" != "null" ] && echo "    $desc"
                done <<< "$plugins"
                echo ""
            fi
        done
    else
        # Fallback: scan directories
        echo -e "${YELLOW}Scanning plugin directories...${NC}"
        for category_dir in "$CONSTRUCT_CORE/patterns/plugins"/*; do
            [ -d "$category_dir" ] || continue
            local category=$(basename "$category_dir")
            [[ "$category" == "registry.yaml" ]] && continue
            
            echo -e "${YELLOW}$category:${NC}"
            for plugin_dir in "$category_dir"/*; do
                [ -d "$plugin_dir" ] || continue
                local plugin_name=$(basename "$plugin_dir")
                echo "  - $category/$plugin_name"
            done
            echo ""
        done
    fi
}

# Function to analyze project with detection reasons
analyze_project_with_reasons() {
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
    if [ -f "package.json" ] && grep -q "react" package.json 2>/dev/null; then
        detected_frameworks+=("react")
        detection_reasons+=("frameworks/react|react in package.json")
    fi
    
    # Detect platforms with reasons
    if ls *.xcodeproj Info.plist 2>/dev/null | grep -q .; then
        detected_platforms+=("ios")
        local ios_indicators=()
        ls *.xcodeproj 2>/dev/null | head -1 >/dev/null && ios_indicators+=("*.xcodeproj")
        [ -f "Info.plist" ] && ios_indicators+=("Info.plist")
        detection_reasons+=("platforms/ios|${ios_indicators[*]}")
        
        # Also recommend mvvm-ios for iOS projects
        detection_reasons+=("architectural/mvvm-ios|iOS project detected")
    fi
    
    # Return results with reasons
    printf '%s\n' "${detection_reasons[@]}"
}

# Function to recommend plugins based on project analysis
recommend_plugins() {
    local -n languages=$1
    local -n frameworks=$2
    local -n platforms=$3
    local recommendations=()
    
    # Language recommendations
    for lang in "${languages[@]}"; do
        case "$lang" in
            swift) recommendations+=("languages/swift") ;;
            python) recommendations+=("languages/python") ;;
            typescript) recommendations+=("languages/typescript") ;;
            rust) recommendations+=("languages/rust") ;;
        esac
    done
    
    # Framework recommendations
    for fw in "${frameworks[@]}"; do
        case "$fw" in
            swiftui) recommendations+=("frameworks/swiftui") ;;
            react) recommendations+=("frameworks/react") ;;
        esac
    done
    
    # Platform recommendations
    for platform in "${platforms[@]}"; do
        case "$platform" in
            ios) 
                recommendations+=("platforms/ios")
                recommendations+=("architectural/mvvm-ios")
                ;;
        esac
    done
    
    # Remove duplicates
    local unique_recommendations=($(printf "%s\n" "${recommendations[@]}" | sort -u))
    
    echo "${unique_recommendations[@]}"
}

# Enhanced interactive plugin selection with detection reasons
interactive_plugin_selection_with_reasons() {
    local github_recs="$1"
    local claude_recs="$2"
    local analysis_results="$3"
    
    echo -e "${BLUE}🔍 Analyzing your project...${NC}"
    echo ""
    
    # Show analysis from all three sources
    echo -e "${BLUE}📊 Pattern Detection Analysis:${NC}"
    echo ""
    
    # 1. GitHub says
    if [ -n "$github_recs" ]; then
        echo -e "${GREEN}🐙 GitHub languages detected:${NC}"
        IFS=' ' read -ra github_array <<< "$github_recs"
        for rec in "${github_array[@]}"; do
            echo "   - $rec"
        done
    else
        echo -e "${GRAY}🐙 GitHub: No repository data available${NC}"
    fi
    echo ""
    
    # 2. /init content says
    if [ -n "$claude_recs" ]; then
        echo -e "${GREEN}📄 CLAUDE.md content suggests:${NC}"
        IFS=' ' read -ra claude_array <<< "$claude_recs"
        for rec in "${claude_array[@]}"; do
            echo "   - $rec"
        done
    else
        echo -e "${GRAY}📄 CLAUDE.md: No specific patterns detected${NC}"
    fi
    echo ""
    
    # 3. Local file analysis
    if [ -n "$analysis_results" ]; then
        echo -e "${GREEN}📁 Local files indicate:${NC}"
        while IFS= read -r reason; do
            IFS='|' read -r plugin detected <<< "$reason"
            echo "   - $plugin (found: $detected)"
        done <<< "$analysis_results"
    else
        echo -e "${GRAY}📁 Local files: No patterns detected${NC}"
    fi
    echo ""
    
    # Build smart recommendations (language plugins only)
    local recommended_plugins=()
    local all_detected=()
    
    # Collect all detections
    [ -n "$github_recs" ] && IFS=' ' read -ra temp <<< "$github_recs" && all_detected+=("${temp[@]}")
    [ -n "$claude_recs" ] && IFS=' ' read -ra temp <<< "$claude_recs" && all_detected+=("${temp[@]}")
    while IFS= read -r reason; do
        IFS='|' read -r plugin _ <<< "$reason"
        all_detected+=("$plugin")
    done <<< "$analysis_results"
    
    # Remove duplicates
    all_detected=($(printf "%s\n" "${all_detected[@]}" | sort -u))
    
    # Filter to essential plugins only
    for plugin in "${all_detected[@]}"; do
        case "$plugin" in
            languages/*)
                recommended_plugins+=("$plugin")
                ;;
        esac
    done
    
    # Claude Code's recommendation
    echo -e "${BLUE}🤖 Claude Code recommends starting with:${NC}"
    if [ ${#recommended_plugins[@]} -gt 0 ]; then
        for plugin in "${recommended_plugins[@]}"; do
            echo "   ✓ $plugin (essential)"
        done
    else
        echo "   No essential plugins detected - you can choose from available options"
    fi
    echo ""
    
    # Show decision options
    echo -e "${YELLOW}What would you like to do?${NC}"
    echo "  1) Install recommended essentials only"
    echo "  2) Install all detected patterns"
    echo "  3) Choose specific patterns"
    echo "  4) Skip pattern installation"
    echo ""
    echo -ne "${YELLOW}Your choice [1-4]: ${NC}"
    read -r response
    
    case "$response" in
            1)
                # Install recommended essentials only
                echo -e "${GREEN}✓ Installing essential plugins only${NC}"
                echo "${recommended_plugins[@]}"
                ;;
            2)
                # Install all detected patterns
                echo -e "${GREEN}✓ Installing all detected patterns${NC}"
                echo "${all_detected[@]}"
                ;;
            3)
                # Choose specific patterns
                echo ""
                show_available_plugins
                echo ""
                echo -e "${YELLOW}Enter plugins to install (comma-separated, e.g., languages/python,frameworks/web):${NC}"
                read -r custom_plugins
                
                # Validate each plugin
                IFS=',' read -ra selected_plugins <<< "$custom_plugins"
                local valid_plugins=()
                for plugin in "${selected_plugins[@]}"; do
                    plugin=$(echo "$plugin" | xargs)  # trim whitespace
                    if validate_plugin_exists "$plugin"; then
                        valid_plugins+=("$plugin")
                    else
                        echo -e "${RED}⚠️  Skipping invalid plugin: $plugin${NC}"
                    fi
                done
                echo "${valid_plugins[@]}"
                ;;
            4)
                # Skip
                echo -e "${YELLOW}⚠️  Skipping plugin installation${NC}"
                return 1
                ;;
            *)
                # Default to option 1
                echo -e "${GREEN}✓ Installing essential plugins only (default)${NC}"
                echo "${recommended_plugins[@]}"
                ;;
    esac
}

# Keep old function for compatibility
interactive_plugin_selection() {
    interactive_plugin_selection_with_reasons "$@"
}

# Function to extract patterns from existing CLAUDE.md
extract_patterns_from_claude_md() {
    local claude_file="$1"
    local project_name=$(basename "$PROJECT_ROOT")
    local lab_plugin_dir="$CONSTRUCT_LAB/patterns/plugins/project-specific/$project_name"
    
    echo -e "${BLUE}📝 Extracting custom patterns from existing CLAUDE.md...${NC}"
    
    # Create LAB plugin directory
    mkdir -p "$lab_plugin_dir/injections"
    
    # Track what we extract
    local extracted_sections=()
    
    # Extract custom rules sections with enhanced detection
    local in_custom_section=false
    local custom_content=""
    local section_name=""
    
    while IFS= read -r line; do
        # Detect various types of custom sections (enhanced for old CONSTRUCT)
        if [[ "$line" =~ ^##[[:space:]]+(Rules|Guidelines|Standards|Patterns|Anti-patterns|.*Truths|.*Discoveries|ENFORCE.*|Architecture.*|Development.*) ]] || \
           [[ "$line" =~ ^###[[:space:]]+(.*Rules|.*Guidelines|.*Patterns|.*Standards) ]] || \
           [[ "$line" =~ ^##[[:space:]]*🚨[[:space:]]*(ENFORCE|Rules) ]] || \
           [[ "$line" =~ ^##[[:space:]]*🧪[[:space:]]*(Validated|Discoveries) ]]; then
            
            # Save previous section if exists
            if [ "$in_custom_section" = true ] && [ -n "$custom_content" ]; then
                local safe_name=$(echo "$section_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9-]//g')
                echo "$custom_content" > "$lab_plugin_dir/injections/$safe_name.md"
                extracted_sections+=("$section_name")
                echo -e "${GREEN}✅ Extracted: $section_name${NC}"
            fi
            
            in_custom_section=true
            section_name=$(echo "$line" | sed 's/^#*[[:space:]]*//' | sed 's/^[🚨🧪📚💡⚠️]*[[:space:]]*//')
            custom_content=""
            
        elif [[ "$line" =~ ^##[[:space:]] ]] && [ "$in_custom_section" = true ]; then
            # End of custom section - save it
            if [ -n "$custom_content" ]; then
                local safe_name=$(echo "$section_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9-]//g')
                echo "$custom_content" > "$lab_plugin_dir/injections/$safe_name.md"
                extracted_sections+=("$section_name")
                echo -e "${GREEN}✅ Extracted: $section_name${NC}"
            fi
            in_custom_section=false
        elif [ "$in_custom_section" = true ]; then
            custom_content+="$line"$'\n'
        fi
    done < "$claude_file"
    
    # Save last section if still in one
    if [ "$in_custom_section" = true ] && [ -n "$custom_content" ]; then
        local safe_name=$(echo "$section_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9-]//g')
        echo "$custom_content" > "$lab_plugin_dir/injections/$safe_name.md"
        extracted_sections+=("$section_name")
        echo -e "${GREEN}✅ Extracted: $section_name${NC}"
    fi
    
    # Extract code examples and patterns
    local in_code_block=false
    local code_content=""
    local code_lang=""
    local example_count=0
    
    while IFS= read -r line; do
        if [[ "$line" =~ ^\`\`\`([a-zA-Z]*) ]]; then
            if [ "$in_code_block" = false ]; then
                in_code_block=true
                code_lang="${BASH_REMATCH[1]}"
                code_content=""
            else
                # End of code block - save if it contains patterns
                if [[ "$code_content" =~ (✅|❌|NEVER|ALWAYS|Pattern|Example) ]]; then
                    example_count=$((example_count + 1))
                    echo -e "\n### Example $example_count\n" >> "$lab_plugin_dir/injections/code-examples.md"
                    echo '```'"$code_lang" >> "$lab_plugin_dir/injections/code-examples.md"
                    echo "$code_content" >> "$lab_plugin_dir/injections/code-examples.md"
                    echo '```' >> "$lab_plugin_dir/injections/code-examples.md"
                fi
                in_code_block=false
            fi
        elif [ "$in_code_block" = true ]; then
            code_content+="$line"$'\n'
        fi
    done < "$claude_file"
    
    if [ $example_count -gt 0 ]; then
        echo -e "${GREEN}✅ Extracted: $example_count code pattern examples${NC}"
        extracted_sections+=("Code Examples")
    fi
    
    # Create plugin metadata
    cat > "$lab_plugin_dir/$project_name.yaml" << EOF
name: $project_name
version: 1.0.0
description: Project-specific patterns extracted from legacy CLAUDE.md
author: CONSTRUCT Migration
category: project-specific
tags:
  - project
  - custom
  - migrated
  - legacy
extracted_sections:
$(printf '%s\n' "${extracted_sections[@]}" | sed 's/^/  - /')
migration_date: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
source_type: $(is_old_construct_version "$claude_file" && echo "old_construct" || echo "custom_claude")
EOF
    
    # Create plugin documentation
    cat > "$lab_plugin_dir/$project_name.md" << EOF
# $project_name Project Patterns

This plugin contains project-specific patterns extracted from the legacy CLAUDE.md file.

## Overview

These patterns were automatically extracted during the migration to the CONSTRUCT pattern system.

## Migration Details

- **Extracted on**: $(date)
- **Source Type**: $(is_old_construct_version "$claude_file" && echo "Old CONSTRUCT version" || echo "Custom CLAUDE.md")
- **Original backed up as**: CLAUDE.md.pre-construct

## Extracted Sections

$(printf '%s\n' "${extracted_sections[@]}" | sed 's/^/- /')

## Included Patterns

### Injections
$(ls "$lab_plugin_dir/injections" 2>/dev/null | sed 's/^/- /')

## Usage

This plugin is automatically included in your patterns.yaml configuration.
To modify these patterns, edit the files in:
\`$lab_plugin_dir/injections/\`

## Notes

- Review extracted patterns for accuracy
- Consider moving general patterns to core plugins
- Project-specific rules should remain here
EOF
    
    echo -e "${GREEN}✅ Created LAB plugin: project-specific/$project_name${NC}"
    
    # Return the plugin path
    echo "project-specific/$project_name"
}

# Function to display help
show_help() {
    echo "Usage: $0 [options] [language]"
    echo ""
    echo "Enhances CLAUDE.md with CONSTRUCT patterns after /init"
    echo ""
    echo "Options:"
    echo "  --regenerate     Regenerate CLAUDE.md from patterns"
    echo "  --include-parent Include parent directory patterns (for multi-repo)"
    echo "  --dry-run        Show what would be done without making changes"
    echo "  --interactive,-i Force interactive mode for plugin selection"
    echo "  --debug          Show debug information"
    echo "  -h, --help       Show this help message"
    echo ""
    echo "Language (optional):"
    echo "  python, swift, typescript, etc."
    echo "  If provided, adds language-specific patterns"
    echo ""
    echo "Examples:"
    echo "  $0                    # Enhance with project patterns"
    echo "  $0 python             # Add Python patterns"
    echo "  $0 --regenerate       # Regenerate from current patterns"
    echo "  $0 --include-parent   # Include shared patterns from parent"
}

# Parse command line arguments
REGENERATE=false
INCLUDE_PARENT=false
DRY_RUN=false
LANGUAGE=""
DEBUG=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --regenerate)
            REGENERATE=true
            shift
            ;;
        --include-parent)
            INCLUDE_PARENT=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --debug)
            DEBUG=true
            shift
            ;;
        --interactive|-i)
            export CONSTRUCT_INTERACTIVE=1
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            # Assume it's a language
            LANGUAGE="$1"
            shift
            ;;
    esac
done

# Detect project root (where .git is)
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$PROJECT_ROOT"

# Detect operating mode
MODE=$(detect_operating_mode)

# Show mode-specific message
show_mode_message "$MODE"

# Handle error case
if [ "$MODE" = "error_no_claude" ]; then
    exit 1
fi

echo -e "${BLUE}📍 Project root: $PROJECT_ROOT${NC}"

# Check if this is CONSTRUCT itself
IS_CONSTRUCT=false
if [ -d "$PROJECT_ROOT/CONSTRUCT-CORE" ] && [ -d "$PROJECT_ROOT/CONSTRUCT-LAB" ]; then
    IS_CONSTRUCT=true
    echo -e "${GREEN}✅ Detected CONSTRUCT repository${NC}"
fi

# Find or create .construct directory
CONSTRUCT_DIR="$PROJECT_ROOT/.construct"
if [ ! -d "$CONSTRUCT_DIR" ]; then
    echo -e "${YELLOW}Creating .construct directory...${NC}"
    mkdir -p "$CONSTRUCT_DIR"
fi

# Handle Mode 3: Legacy CLAUDE.md pattern extraction
EXTRACTED_PLUGIN=""
if [ "$MODE" = "mode_3" ]; then
    # Backup original
    cp CLAUDE.md CLAUDE.md.pre-construct
    echo -e "${GREEN}✅ Backed up original as CLAUDE.md.pre-construct${NC}"
    
    # Extract patterns
    EXTRACTED_PLUGIN=$(extract_patterns_from_claude_md "CLAUDE.md")
fi

# Find or create patterns.yaml
PATTERNS_FILE="$CONSTRUCT_DIR/patterns.yaml"
if [ ! -f "$PATTERNS_FILE" ]; then
    echo -e "${YELLOW}Creating patterns.yaml...${NC}"
    
    # Load plugin registry
    load_plugin_registry
    
    if [ "$IS_CONSTRUCT" = true ]; then
        # CONSTRUCT uses construct-dev patterns
        cat > "$PATTERNS_FILE" << 'EOF'
# CONSTRUCT Framework Pattern Configuration
# This configures the patterns used by CONSTRUCT itself

# Languages used in CONSTRUCT development
languages: ["bash", "python"]

# Active pattern plugins
plugins:
  - tooling/construct-dev      # CONSTRUCT-specific development patterns
  - tooling/shell-scripting    # Shell script best practices
  - tooling/unix-philosophy    # Unix design principles
  - documentation/living       # Self-updating documentation

# Custom rules for CONSTRUCT framework
custom_rules:
  scripts:
    - "All scripts must have help output with --help"
    - "Scripts must support interactive mode detection"
    - "Use absolute paths from CONSTRUCT_CORE root"
    - "Exit codes must be meaningful (0=success, >0=errors)"
EOF
        echo -e "${GREEN}✅ Created CONSTRUCT patterns.yaml${NC}"
    else
        # Regular project - use interactive selection
        
        # Try GitHub analysis first
        github_recommendations=""
        repo_info=$(get_github_repo_info)
        if [ $? -eq 0 ] && [ -n "$repo_info" ]; then
            echo -e "${BLUE}🔍 Analyzing GitHub repository...${NC}"
            languages_json=$(fetch_github_languages "$repo_info" 2>/dev/null)
            if [ $? -eq 0 ] && [ -n "$languages_json" ] && [[ ! "$languages_json" =~ "Not Found" ]] && [[ ! "$languages_json" =~ "message" ]]; then
                github_recommendations=$(analyze_github_languages "$repo_info" "$languages_json")
                echo ""
            else
                echo -e "${YELLOW}GitHub repository is private or not accessible, using local analysis...${NC}"
                echo ""
            fi
        fi
        
        # Analyze CLAUDE.md content from /init
        # Always use backup if it exists (original from /init), otherwise current
        claude_to_analyze="CLAUDE.md"
        if [ -f "CLAUDE.md.backup" ]; then
            claude_to_analyze="CLAUDE.md.backup"
        fi
        
        claude_recommendations=$(analyze_claude_md_content "$claude_to_analyze")
        if [ -n "$claude_recommendations" ]; then
            echo -e "${BLUE}📄 Analyzing existing CLAUDE.md content...${NC}"
            echo ""
        fi
        
        # Analyze project with detection reasons
        analysis_results=$(analyze_project_with_reasons)
        
        # Merge all three sources of recommendations
        all_recommendations=()
        
        # Add GitHub recommendations
        if [ -n "$github_recommendations" ]; then
            IFS=' ' read -ra github_array <<< "$github_recommendations"
            all_recommendations+=("${github_array[@]}")
        fi
        
        # Add CLAUDE.md recommendations
        if [ -n "$claude_recommendations" ]; then
            IFS=' ' read -ra claude_array <<< "$claude_recommendations"
            for rec in "${claude_array[@]}"; do
                if [[ ! " ${all_recommendations[@]} " =~ " ${rec} " ]]; then
                    all_recommendations+=("$rec")
                fi
            done
        fi
        
        # Add local detections
        while IFS= read -r reason; do
            IFS='|' read -r plugin _ <<< "$reason"
            if [[ ! " ${all_recommendations[@]} " =~ " ${plugin} " ]]; then
                all_recommendations+=("$plugin")
            fi
        done <<< "$analysis_results"
        
        # Interactive selection with reasons
        selected_plugins=()
        
        # Debug interactive mode detection
        if [ "$DEBUG" = true ]; then
            echo -e "${YELLOW}DEBUG: Checking interactive mode...${NC}"
            echo "CONSTRUCT_INTERACTIVE: '$CONSTRUCT_INTERACTIVE'"
            echo "stdout is terminal: $([ -t 1 ] && echo yes || echo no)"
            echo "stdin is terminal: $([ -t 0 ] && echo yes || echo no)"
            is_interactive && echo "is_interactive returns: true" || echo "is_interactive returns: false"
            echo ""
        fi
        
        if is_interactive; then
            # Interactive mode - show UI with detection reasons
            IFS=' ' read -ra selected_array <<< "$(interactive_plugin_selection_with_reasons "$github_recommendations" "$claude_recommendations" "$analysis_results")"
            selected_plugins=("${selected_array[@]}")
        else
            # Non-interactive mode - only when explicitly piped
            if [ -t 0 ]; then
                # No piped input but not interactive - this shouldn't happen in Claude Code
                # Force interactive mode for better UX
                echo -e "${YELLOW}⚠️  Running in non-interactive terminal. Showing recommendations:${NC}"
                echo ""
                
                # Show analysis from all three sources
                echo -e "${BLUE}📊 Pattern Detection Analysis:${NC}"
                echo ""
                
                # 1. GitHub says
                if [ -n "$github_recommendations" ]; then
                    echo -e "${GREEN}🐙 GitHub languages detected:${NC}"
                    IFS=' ' read -ra github_array <<< "$github_recommendations"
                    for rec in "${github_array[@]}"; do
                        echo "   - $rec"
                    done
                else
                    echo -e "${GRAY}🐙 GitHub: No repository data available${NC}"
                fi
                echo ""
                
                # 2. /init content says
                if [ -n "$claude_recommendations" ]; then
                    echo -e "${GREEN}📄 CLAUDE.md content suggests:${NC}"
                    IFS=' ' read -ra claude_array <<< "$claude_recommendations"
                    for rec in "${claude_array[@]}"; do
                        echo "   - $rec"
                    done
                else
                    echo -e "${GRAY}📄 CLAUDE.md: No patterns detected${NC}"
                fi
                echo ""
                
                # 3. Local file analysis
                if [ -n "$analysis_results" ]; then
                    echo -e "${GREEN}📁 Local files indicate:${NC}"
                    while IFS= read -r reason; do
                        IFS='|' read -r plugin detected <<< "$reason"
                        echo "   - $plugin (found: $detected)"
                    done <<< "$analysis_results"
                else
                    echo -e "${GRAY}📁 Local files: No patterns detected${NC}"
                fi
                echo ""
                
                # Claude Code's recommendation
                echo -e "${BLUE}🤖 Claude Code recommends installing:${NC}"
                
                # Smart recommendation: only language plugins by default
                local smart_recommendations=()
                for plugin in "${all_recommendations[@]}"; do
                    case "$plugin" in
                        languages/*)
                            smart_recommendations+=("$plugin")
                            echo "   ✓ $plugin (primary language)"
                            ;;
                    esac
                done
                
                echo ""
                echo -e "${YELLOW}To install recommended patterns:${NC}"
                echo "   echo '' | $0"
                echo ""
                echo -e "${YELLOW}To choose patterns interactively:${NC}"
                echo "   $0 --interactive"
                echo ""
                echo -e "${YELLOW}To install specific patterns:${NC}"
                echo "   echo 'languages/python,frameworks/web' | $0"
                echo ""
                
                # Use only smart recommendations
                selected_plugins=("${smart_recommendations[@]}")
            else
                # Read piped input
                piped_input=""
                read -r piped_input
                if [ -n "$piped_input" ]; then
                    IFS=',' read -ra selected_plugins <<< "$piped_input"
                    # Trim whitespace
                    for i in "${!selected_plugins[@]}"; do
                        selected_plugins[$i]=$(echo "${selected_plugins[$i]}" | xargs)
                    done
                    echo -e "${YELLOW}Using specified plugins: ${selected_plugins[*]}${NC}"
                else
                    # Empty input - use smart recommendations (language plugins only)
                    local smart_recommendations=()
                    for plugin in "${all_recommendations[@]}"; do
                        case "$plugin" in
                            languages/*)
                                smart_recommendations+=("$plugin")
                                ;;
                        esac
                    done
                    selected_plugins=("${smart_recommendations[@]}")
                    echo -e "${YELLOW}Using essential plugins: ${selected_plugins[*]}${NC}"
                fi
            fi
        fi
        
        # Determine primary language from selected plugins
        primary_language="bash"
        for plugin in "${selected_plugins[@]}"; do
            if [[ "$plugin" =~ ^languages/(.+)$ ]]; then
                primary_language="${BASH_REMATCH[1]}"
                break
            fi
        done
        [ -n "$LANGUAGE" ] && primary_language="$LANGUAGE"
        
        # Create patterns.yaml with selections
        cat > "$PATTERNS_FILE" << EOF
# Project Pattern Configuration
# Generated by construct init

# Primary language
languages: ["$primary_language"]

# Active pattern plugins
plugins:
EOF
        
        # Add selected plugins
        if [ ${#selected_plugins[@]} -gt 0 ]; then
            for plugin in "${selected_plugins[@]}"; do
                echo "  - $plugin" >> "$PATTERNS_FILE"
            done
        else
            echo "  # No plugins selected" >> "$PATTERNS_FILE"
        fi
        
        # Add extracted plugin if in mode 3
        if [ "$MODE" = "mode_3" ] && [ -n "$EXTRACTED_PLUGIN" ]; then
            echo "  - $EXTRACTED_PLUGIN  # Project-specific patterns (auto-extracted)" >> "$PATTERNS_FILE"
            echo -e "${GREEN}✅ Added extracted patterns plugin${NC}"
        fi
        
        cat >> "$PATTERNS_FILE" << 'EOF'

# Custom rules specific to this project
custom_rules: {}

# Include configurations
includes: []

# Overrides for specific files/directories
overrides: []
EOF
        
        echo -e "${GREEN}✅ Created patterns.yaml with selected plugins${NC}"
    fi
fi

# Check for parent patterns if requested
PARENT_PATTERNS=""
if [ "$INCLUDE_PARENT" = true ]; then
    PARENT_DIR="$(dirname "$PROJECT_ROOT")"
    PARENT_PATTERNS_FILE="$PARENT_DIR/.construct/patterns.yaml"
    if [ -f "$PARENT_PATTERNS_FILE" ]; then
        echo -e "${GREEN}✅ Found parent patterns at: $PARENT_PATTERNS_FILE${NC}"
        PARENT_PATTERNS="$PARENT_PATTERNS_FILE"
    fi
fi

# Backup current CLAUDE.md
if [ "$DRY_RUN" = false ]; then
    cp CLAUDE.md CLAUDE.md.backup
    echo -e "${GREEN}✅ Backed up current CLAUDE.md${NC}"
fi

# Load CLAUDE-BASE.md template
CLAUDE_BASE="$CONSTRUCT_CORE/CLAUDE-BASE.md"
if [ ! -f "$CLAUDE_BASE" ]; then
    echo -e "${RED}❌ CLAUDE-BASE.md not found at: $CLAUDE_BASE${NC}"
    exit 1
fi

echo -e "${BLUE}🔄 Enhancing CLAUDE.md with patterns...${NC}"

# Create enhanced CLAUDE.md
if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}DRY RUN: Would enhance CLAUDE.md with:${NC}"
    echo "  - Base template from CLAUDE-BASE.md"
    echo "  - Patterns from: $PATTERNS_FILE"
    [ -n "$PARENT_PATTERNS" ] && echo "  - Parent patterns from: $PARENT_PATTERNS"
    echo "  - Dynamic sections for context"
else
    # For now, just add a marker showing enhancement
    # TODO: Implement full pattern injection system
    
    # Read current CLAUDE.md
    CURRENT_CONTENT=$(cat CLAUDE.md)
    
    # Check if already enhanced
    if grep -q "CONSTRUCT Enhanced" CLAUDE.md; then
        echo -e "${YELLOW}⚠️  CLAUDE.md already enhanced. Use --regenerate to update.${NC}"
        if [ "$REGENERATE" = false ]; then
            exit 0
        fi
    fi
    
    # Function to collect injection content from patterns
    collect_injection_content() {
        local injection_point="$1"
        local content=""
        
        # Read patterns from patterns.yaml
        local plugins=$(grep -E "^  - " "$PATTERNS_FILE" | sed 's/^  - //' | sed 's/#.*//' | xargs)
        
        for plugin in $plugins; do
            local plugin_path="$CONSTRUCT_CORE/patterns/plugins/$plugin"
            local injection_file=""
            
            case "$injection_point" in
                "GUIDELINES")
                    injection_file="$plugin_path/injections/guidelines.md"
                    ;;
                "EXAMPLES")
                    injection_file="$plugin_path/injections/examples.md"
                    ;;
                "COMMANDS")
                    injection_file="$plugin_path/injections/commands.md"
                    ;;
                "AI_GUIDANCE")
                    injection_file="$plugin_path/injections/ai-guidance.md"
                    ;;
                "VALIDATED_DISCOVERIES")
                    injection_file="$plugin_path/injections/validated-discoveries.md"
                    ;;
            esac
            
            if [ -f "$injection_file" ]; then
                if [ -n "$content" ]; then
                    content="$content"$'\n\n'
                fi
                content="$content$(cat "$injection_file")"
            fi
        done
        
        echo "$content"
    }
    
    # Process CLAUDE-BASE.md and inject pattern content
    process_base_template() {
        local base_content=$(cat "$CLAUDE_BASE")
        
        # Replace {{CONSTRUCT:HEADER}} with project info
        local header="# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository."
        base_content="${base_content/\{\{CONSTRUCT:HEADER\}\}/$header}"
        
        # Replace {{CONSTRUCT:PATTERNS}} with active patterns
        local patterns_content="### Active Patterns
\`\`\`yaml
$(cat "$PATTERNS_FILE")
\`\`\`"
        base_content="${base_content/\{\{CONSTRUCT:PATTERNS\}\}/$patterns_content}"
        
        # Collect and inject content for each injection point
        for point in GUIDELINES EXAMPLES COMMANDS AI_GUIDANCE; do
            local content=$(collect_injection_content "$point")
            
            # Special handling for GUIDELINES - also include validated discoveries
            if [ "$point" = "GUIDELINES" ]; then
                local discoveries=$(collect_injection_content "VALIDATED_DISCOVERIES")
                if [ -n "$discoveries" ]; then
                    if [ -n "$content" ]; then
                        content="$content"$'\n\n'"$discoveries"
                    else
                        content="$discoveries"
                    fi
                fi
            fi
            
            if [ -n "$content" ]; then
                base_content="${base_content/\{\{CONSTRUCT:$point\}\}/$content}"
            else
                # Remove empty injection points
                base_content="${base_content/\{\{CONSTRUCT:$point\}\}/}"
            fi
        done
        
        # Handle {{CONSTRUCT:STRUCTURE}} - project structure
        local structure_content=""
        if [ "$IS_CONSTRUCT" = true ]; then
            structure_content="### Repository Structure
\`\`\`
CONSTRUCT/
├── CONSTRUCT-CORE/        # Stable framework components
│   ├── CONSTRUCT/         # Main framework code
│   │   ├── scripts/       # Executable scripts (by category)
│   │   ├── lib/           # Shared functions
│   │   └── config/        # Configuration
│   ├── patterns/plugins/  # Pattern plugin system
│   └── TEMPLATES/         # Project templates
├── CONSTRUCT-LAB/         # Experimental development
└── Projects/              # Git-independent managed projects
\`\`\`"
        else
            # For regular projects, use project-specific structure
            structure_content="### Project Structure
See \`.construct/structure.md\` for project layout."
        fi
        base_content="${base_content/\{\{CONSTRUCT:STRUCTURE\}\}/$structure_content}"
        
        # Handle {{CONSTRUCT:CONTEXT}} - add all dynamic sections
        local context_content="<!-- Dynamic sections updated by construct-update -->

<!-- START:ACTIVE-SYMLINKS -->
### 🔗 Active Symlinks (Auto-Updated)
*Run \`construct-check-symlinks\` to populate*
<!-- END:ACTIVE-SYMLINKS -->

<!-- START:SPRINT-CONTEXT -->
### 🎯 Current Sprint Context (Auto-Updated)
**Date**: [Auto-generated]
**Branch**: $(git branch --show-current 2>/dev/null || echo "unknown")
**Last Commit**: $(git log -1 --oneline 2>/dev/null || echo "No commits yet")

### Current Focus
*Run \`construct-update\` to refresh*
<!-- END:SPRINT-CONTEXT -->

<!-- START:VIOLATIONS -->
### ⚠️ Active Violations (Auto-Updated)
*Run \`construct-check\` to populate*
<!-- END:VIOLATIONS -->

<!-- START:WORKING-LOCATION -->
### 📍 Current Working Location (Auto-Updated)

#### Recently Modified Files
*Run \`construct-update\` to refresh*

#### Git Status
\`\`\`
$(git status --short 2>/dev/null || echo "Not a git repository")
\`\`\`
<!-- END:WORKING-LOCATION -->"
        
        # Add CONSTRUCT-specific sections if this is CONSTRUCT itself
        if [ "$IS_CONSTRUCT" = true ]; then
            context_content="$context_content

<!-- START:DOCUMENTATION-LINKS -->
### 📚 Architecture Documentation (Auto-Updated)
*Run \`construct-arch\` to generate documentation*
<!-- END:DOCUMENTATION-LINKS -->

<!-- START:ACTIVE-PRDS -->
### 📋 Active Product Requirements (Auto-Updated)
*Run \`construct-update\` to refresh PRD tracking*
<!-- END:ACTIVE-PRDS -->"
        fi
        
        base_content="${base_content/\{\{CONSTRUCT:CONTEXT\}\}/$context_content}"
        
        echo "$base_content"
    }
    
    # Function to merge with existing /init content
    merge_with_init_content() {
        local current_content="$1"
        local enhanced_content="$2"
        
        # Extract sections from /init content that should be preserved
        local project_overview=""
        local quick_start=""
        local troubleshooting=""
        local core_principles=""
        
        # Extract Project Overview section if it exists
        if echo "$current_content" | grep -q "^## Project Overview"; then
            project_overview=$(echo "$current_content" | sed -n '/^## Project Overview/,/^##[^#]/p' | sed '$d')
        fi
        
        # Extract Quick Start section if it exists
        if echo "$current_content" | grep -q "^## Quick Start"; then
            quick_start=$(echo "$current_content" | sed -n '/^## Quick Start/,/^##[^#]/p' | sed '$d')
        fi
        
        # Extract Core Development Principles if it exists (from /init)
        if echo "$current_content" | grep -q "^## Core Development Principles"; then
            core_principles=$(echo "$current_content" | sed -n '/^## Core Development Principles/,/^##[^#]/p' | sed '$d')
        fi
        
        # Extract Troubleshooting section if it exists
        if echo "$current_content" | grep -q "^## Troubleshooting"; then
            troubleshooting=$(echo "$current_content" | sed -n '/^## Troubleshooting/,/^##[^#]/p' | sed '$d')
        fi
        
        # Build merged content
        local merged=""
        
        # Start with header and enhancement marker
        merged="<!-- CONSTRUCT Enhanced: $(date -u +"%Y-%m-%d %H:%M:%S UTC") -->
<!-- 
╔══════════════════════════════════════════════════════════════════════════════╗
║                      PATTERN-ENHANCED CONTEXT FILE                           ║
╠══════════════════════════════════════════════════════════════════════════════╣
║ This file is managed by both Claude Code (/init) and CONSTRUCT patterns.    ║
║                                                                              ║
║ ⚠️  WARNING: Manual edits may be lost when:                                  ║
║   • Running /init (replaces entire file)                                     ║
║   • Running construct-init (rebuilds from patterns)                          ║
║   • Inside dynamic sections (updated by construct-update)                    ║
║                                                                              ║
║ 💡 BETTER APPROACH: Instead of editing this file:                            ║
║   • Add project rules → .construct/patterns.yaml                             ║
║   • Create reusable patterns → pattern plugins                               ║
║   • Let CONSTRUCT manage the content                                         ║
║                                                                              ║
║ See: CONSTRUCT-CORE/patterns/PATTERN-GUIDE.md for details                    ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository."
        
        # Add Project Overview if it exists
        if [ -n "$project_overview" ]; then
            merged="$merged

$project_overview"
        fi
        
        # Add Quick Start if it exists
        if [ -n "$quick_start" ]; then
            merged="$merged

$quick_start"
        fi
        
        # Add Core Development Principles if it exists
        if [ -n "$core_principles" ]; then
            merged="$merged

$core_principles"
        fi
        
        # Extract all pattern-injected content from enhanced version
        # This includes everything between patterns and dynamic sections
        local pattern_section_start=$(echo "$enhanced_content" | grep -n "^## Pattern System" | cut -d: -f1)
        local dynamic_section_start=$(echo "$enhanced_content" | grep -n "^<!-- Dynamic sections" | cut -d: -f1)
        
        if [ -n "$pattern_section_start" ] && [ -n "$dynamic_section_start" ]; then
            # Extract all content between Pattern System and dynamic sections
            local pattern_content=$(echo "$enhanced_content" | sed -n "${pattern_section_start},${dynamic_section_start}p" | sed '$d')
            if [ -n "$pattern_content" ]; then
                merged="$merged

$pattern_content"
            fi
        fi
        
        # Add Troubleshooting if it exists
        if [ -n "$troubleshooting" ]; then
            merged="$merged

$troubleshooting"
        fi
        
        # Add dynamic sections
        local dynamic_sections=$(echo "$enhanced_content" | sed -n '/^<!-- Dynamic sections/,$p')
        if [ -n "$dynamic_sections" ]; then
            merged="$merged

$dynamic_sections"
        fi
        
        echo "$merged"
    }
    
    # Check if CLAUDE.md was created by /init
    INIT_CREATED=false
    if grep -q "## Project Overview" CLAUDE.md && grep -q "## Quick Start" CLAUDE.md; then
        INIT_CREATED=true
        echo -e "${GREEN}✅ Detected /init-created CLAUDE.md${NC}"
    fi
    
    # Create enhanced version
    if [ "$INIT_CREATED" = true ]; then
        # Intelligently merge with /init content
        echo -e "${BLUE}🔄 Merging with /init content...${NC}"
        
        # Process base template
        enhanced_content=$(process_base_template)
        
        # Merge with existing content
        merge_with_init_content "$CURRENT_CONTENT" "$enhanced_content" > CLAUDE.md.enhanced
    else
        # No /init content, use standard processing
        {
            # Add enhancement header
            echo "<!-- CONSTRUCT Enhanced: $(date -u +"%Y-%m-%d %H:%M:%S UTC") -->"
            echo ""
            
            # Process base template with injections
            process_base_template
            
        } > CLAUDE.md.enhanced
    fi
    
    # Replace CLAUDE.md
    mv CLAUDE.md.enhanced CLAUDE.md
    
    echo -e "${GREEN}✅ CLAUDE.md enhanced successfully!${NC}"
fi

# Show next steps
echo ""
echo -e "${BLUE}📋 Next Steps:${NC}"
echo "1. Review the enhanced CLAUDE.md"
echo "2. Run 'construct-update' to refresh dynamic sections"
echo "3. Start developing with pattern guidance!"

if [ "$IS_CONSTRUCT" = true ]; then
    echo ""
    echo -e "${YELLOW}Note: Since this is CONSTRUCT itself, remember to:${NC}"
    echo "- Work in CONSTRUCT-LAB for new features"
    echo "- Test patterns before promoting to CORE"
    echo "- Update documentation as you develop"
fi

exit 0