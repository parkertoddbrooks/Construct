#!/bin/bash

# extract-legacy-patterns.sh - Extract patterns from existing CLAUDE.md files
# Creates LAB plugins from custom patterns in legacy CLAUDE.md files

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
CONSTRUCT_LAB="$CONSTRUCT_ROOT/CONSTRUCT-LAB"

# Function to check if old CONSTRUCT version
is_old_construct_version() {
    local claude_file="$1"
    grep -q "CONSTRUCT Version" "$claude_file" 2>/dev/null || \
    grep -q "construct-update" "$claude_file" 2>/dev/null || \
    grep -q "ENFORCE THESE RULES" "$claude_file" 2>/dev/null || \
    grep -q "Swift/SwiftUI Truths" "$claude_file" 2>/dev/null || \
    grep -q "🚨 ENFORCE THESE RULES" "$claude_file" 2>/dev/null
}

# Function to extract patterns from existing CLAUDE.md
extract_patterns_from_claude_md() {
    local claude_file="$1"
    local project_name="${2:-$(basename "$(pwd)")}"
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

# Show help
show_help() {
    echo "Usage: $0 [options] <claude-file>"
    echo ""
    echo "Extract patterns from existing CLAUDE.md files into LAB plugins"
    echo ""
    echo "Arguments:"
    echo "  claude-file    Path to CLAUDE.md file to extract from"
    echo ""
    echo "Options:"
    echo "  --project-name NAME    Name for the extracted plugin"
    echo "  --dry-run             Show what would be extracted"
    echo "  -h, --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 CLAUDE.md"
    echo "  $0 --project-name myapp CLAUDE.md.backup"
    echo "  $0 --dry-run old-project/CLAUDE.md"
}

# Parse arguments
CLAUDE_FILE=""
PROJECT_NAME=""
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --project-name)
            PROJECT_NAME="$2"
            shift 2
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
            CLAUDE_FILE="$1"
            shift
            ;;
    esac
done

# Validate arguments
if [ -z "$CLAUDE_FILE" ]; then
    echo -e "${RED}❌ Error: CLAUDE.md file required${NC}"
    show_help
    exit 1
fi

if [ ! -f "$CLAUDE_FILE" ]; then
    echo -e "${RED}❌ Error: File not found: $CLAUDE_FILE${NC}"
    exit 1
fi

# Extract project name if not provided
if [ -z "$PROJECT_NAME" ]; then
    PROJECT_NAME=$(basename "$(pwd)")
fi

# Execute extraction
if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}DRY RUN: Would extract patterns from $CLAUDE_FILE${NC}"
    echo "Project name: $project_name"
    echo "Plugin location: $CONSTRUCT_LAB/patterns/plugins/project-specific/$PROJECT_NAME"
    
    # Show what sections would be extracted
    echo -e "${BLUE}Would extract these sections:${NC}"
    grep -E "^##[[:space:]]+(Rules|Guidelines|Standards|Patterns|Anti-patterns|.*Truths|.*Discoveries|ENFORCE.*|Architecture.*|Development.*)" "$CLAUDE_FILE" || true
else
    plugin_path=$(extract_patterns_from_claude_md "$CLAUDE_FILE" "$PROJECT_NAME")
    echo ""
    echo -e "${GREEN}✅ Extraction complete!${NC}"
    echo "Plugin created at: $plugin_path"
    echo ""
    echo "To use this plugin, add to your patterns.yaml:"
    echo "  - $plugin_path"
fi