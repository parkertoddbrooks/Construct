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
NC='\033[0m' # No Color

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSTRUCT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
CONSTRUCT_CORE="$CONSTRUCT_ROOT/CONSTRUCT-CORE"

# Source library functions
source "$CONSTRUCT_CORE/CONSTRUCT/lib/common-patterns.sh" 2>/dev/null || true
source "$CONSTRUCT_CORE/CONSTRUCT/lib/validation.sh" 2>/dev/null || true
source "$CONSTRUCT_CORE/CONSTRUCT/lib/interactive-support.sh" 2>/dev/null || true

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

echo -e "${BLUE}🚀 CONSTRUCT Pattern Enhancement${NC}"
echo -e "${BLUE}================================${NC}"

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

# Function to load plugin registry
load_plugin_registry() {
    local registry_file="$CONSTRUCT_CORE/patterns/plugins/registry.yaml"
    if [ ! -f "$registry_file" ]; then
        echo -e "${YELLOW}⚠️  Plugin registry not found. Running refresh...${NC}"
        "$CONSTRUCT_CORE/CONSTRUCT/scripts/construct/refresh-plugin-registry.sh" >/dev/null 2>&1
    fi
    
    # Check if yq is available
    if ! command -v yq &> /dev/null; then
        echo -e "${YELLOW}⚠️  yq not installed. Plugin descriptions will be limited.${NC}"
        return 1
    fi
    
    return 0
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

# Function for interactive plugin selection
interactive_plugin_selection() {
    local recommended_plugins=("$@")
    local selected_plugins=()
    
    echo -e "${BLUE}🔍 Analyzing your project...${NC}"
    echo ""
    
    if [ ${#recommended_plugins[@]} -gt 0 ]; then
        echo -e "${GREEN}📦 Based on your project, we recommend these plugins:${NC}"
        for plugin in "${recommended_plugins[@]}"; do
            echo "  ✓ $plugin"
        done
        echo ""
        
        echo -e "${YELLOW}Accept recommendations? [Y/n/customize]: ${NC}"
        read -r response
        
        case "$response" in
            [nN]|[nN][oO])
                echo "Skipping plugin installation."
                return 1
                ;;
            [cC]|customize)
                # Show all plugins and let user select
                show_available_plugins
                echo ""
                echo -e "${YELLOW}Enter plugins to install (comma-separated, e.g., languages/swift,platforms/ios):${NC}"
                read -r custom_plugins
                IFS=',' read -ra selected_plugins <<< "$custom_plugins"
                ;;
            *)
                # Default: accept recommendations
                selected_plugins=("${recommended_plugins[@]}")
                ;;
        esac
    else
        # No recommendations, show all plugins
        show_available_plugins
        echo ""
        echo -e "${YELLOW}No specific recommendations found. Enter plugins to install (comma-separated):${NC}"
        read -r custom_plugins
        if [ -n "$custom_plugins" ]; then
            IFS=',' read -ra selected_plugins <<< "$custom_plugins"
        fi
    fi
    
    # Trim whitespace from selections
    local cleaned_plugins=()
    for plugin in "${selected_plugins[@]}"; do
        plugin=$(echo "$plugin" | xargs)  # trim whitespace
        [ -n "$plugin" ] && cleaned_plugins+=("$plugin")
    done
    
    echo "${cleaned_plugins[@]}"
}

# Function to extract patterns from existing CLAUDE.md
extract_patterns_from_claude_md() {
    local claude_file="$1"
    local project_name=$(basename "$PROJECT_ROOT")
    local lab_plugin_dir="$CONSTRUCT_ROOT/CONSTRUCT-LAB/patterns/plugins/project-specific/$project_name"
    
    echo -e "${BLUE}📝 Extracting custom patterns from existing CLAUDE.md...${NC}"
    
    # Create LAB plugin directory
    mkdir -p "$lab_plugin_dir/injections"
    
    # Extract custom rules sections
    local in_custom_section=false
    local custom_content=""
    local section_name=""
    
    while IFS= read -r line; do
        # Detect custom sections (look for patterns like ## Rules, ## Guidelines, etc.)
        if [[ "$line" =~ ^##[[:space:]]+(Rules|Guidelines|Standards|Patterns|Anti-patterns) ]]; then
            in_custom_section=true
            section_name=$(echo "$line" | sed 's/^##[[:space:]]*//' | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
            custom_content=""
        elif [[ "$line" =~ ^##[[:space:]] ]] && [ "$in_custom_section" = true ]; then
            # End of custom section - save it
            if [ -n "$custom_content" ]; then
                echo "$custom_content" > "$lab_plugin_dir/injections/$section_name.md"
                echo -e "${GREEN}✅ Extracted: $section_name${NC}"
            fi
            in_custom_section=false
        elif [ "$in_custom_section" = true ]; then
            custom_content+="$line"$'\n'
        fi
    done < "$claude_file"
    
    # Save last section if still in one
    if [ "$in_custom_section" = true ] && [ -n "$custom_content" ]; then
        echo "$custom_content" > "$lab_plugin_dir/injections/$section_name.md"
        echo -e "${GREEN}✅ Extracted: $section_name${NC}"
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
EOF
    
    # Create plugin documentation
    cat > "$lab_plugin_dir/$project_name.md" << EOF
# $project_name Project Patterns

This plugin contains project-specific patterns extracted from the legacy CLAUDE.md file.

## Overview

These patterns were automatically extracted during the migration to the CONSTRUCT pattern system.

## Included Patterns

$(ls "$lab_plugin_dir/injections" 2>/dev/null | sed 's/^/- /')

## Migration Notes

- Extracted on: $(date)
- Original CLAUDE.md backed up as: CLAUDE.md.pre-construct
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
    echo "  --regenerate    Regenerate CLAUDE.md from patterns"
    echo "  --include-parent Include parent directory patterns (for multi-repo)"
    echo "  --dry-run       Show what would be done without making changes"
    echo "  -h, --help      Show this help message"
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

echo -e "${BLUE}📍 Project root: $PROJECT_ROOT${NC}"

# Check if CLAUDE.md exists
if [ ! -f "CLAUDE.md" ]; then
    echo -e "${RED}❌ CLAUDE.md not found!${NC}"
    echo -e "${YELLOW}Please run '/init' first to create the base CLAUDE.md${NC}"
    exit 1
fi

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

# Function to check if CLAUDE.md is from /init
is_from_init() {
    local claude_file="$1"
    # Check for common /init patterns
    grep -q "This file provides guidance to Claude" "$claude_file" 2>/dev/null || \
    grep -q "AI coding assistant" "$claude_file" 2>/dev/null || \
    grep -q "codebase context" "$claude_file" 2>/dev/null
}

# Check if this is Mode 3: Legacy CLAUDE.md without patterns
LEGACY_MODE=false
EXTRACTED_PLUGIN=""
if [ -f "CLAUDE.md" ] && [ ! -f "$PATTERNS_FILE" ] && ! is_from_init "CLAUDE.md"; then
    LEGACY_MODE=true
    echo -e "${YELLOW}🔄 Detected legacy CLAUDE.md - will extract patterns${NC}"
    
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
        
        # Analyze project
        local detected=$(analyze_project)
        local detected_languages=$(echo "$detected" | sed -n '1p')
        local detected_frameworks=$(echo "$detected" | sed -n '2p')
        local detected_platforms=$(echo "$detected" | sed -n '3p')
        
        # Convert to arrays
        IFS=' ' read -ra lang_array <<< "$detected_languages"
        IFS=' ' read -ra fw_array <<< "$detected_frameworks"
        IFS=' ' read -ra plat_array <<< "$detected_platforms"
        
        # Get recommendations
        local recommendations=$(recommend_plugins lang_array fw_array plat_array)
        IFS=' ' read -ra recommended_array <<< "$recommendations"
        
        # Interactive selection
        local selected_plugins=()
        if is_interactive; then
            # Interactive mode - show UI
            IFS=' ' read -ra selected_array <<< "$(interactive_plugin_selection "${recommended_array[@]}")"
            selected_plugins=("${selected_array[@]}")
        else
            # Non-interactive mode - check for piped input
            if [ -t 0 ]; then
                # No piped input - use recommendations
                selected_plugins=("${recommended_array[@]}")
                echo -e "${YELLOW}Using recommended plugins: ${selected_plugins[*]}${NC}"
            else
                # Read piped input
                local piped_input
                read -r piped_input
                if [ -n "$piped_input" ]; then
                    IFS=',' read -ra selected_plugins <<< "$piped_input"
                    # Trim whitespace
                    for i in "${!selected_plugins[@]}"; do
                        selected_plugins[$i]=$(echo "${selected_plugins[$i]}" | xargs)
                    done
                    echo -e "${YELLOW}Using specified plugins: ${selected_plugins[*]}${NC}"
                else
                    # Empty input - use recommendations
                    selected_plugins=("${recommended_array[@]}")
                    echo -e "${YELLOW}Using recommended plugins: ${selected_plugins[*]}${NC}"
                fi
            fi
        fi
        
        # Determine primary language
        local primary_language="${detected_languages:-bash}"
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
        
        # Add extracted plugin if in legacy mode
        if [ "$LEGACY_MODE" = true ] && [ -n "$EXTRACTED_PLUGIN" ]; then
            echo "  - $EXTRACTED_PLUGIN  # Project-specific patterns" >> "$PATTERNS_FILE"
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