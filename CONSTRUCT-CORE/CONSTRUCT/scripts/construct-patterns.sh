#!/bin/bash

# Interactive pattern management
# Shows available patterns, current config, allows toggling

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSTRUCT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
CONSTRUCT_CORE="$CONSTRUCT_ROOT/CONSTRUCT-CORE"

PROJECT_DIR="${1:-.}"
CONFIG_FILE="$PROJECT_DIR/.construct/patterns.yaml"
ASSEMBLE_SCRIPT="$SCRIPT_DIR/assemble-claude.sh"

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 [command] [project-dir]"
    echo ""
    echo "Pattern management for CONSTRUCT projects"
    echo ""
    echo "Commands:"
    echo "  regenerate    Regenerate CLAUDE.md from patterns.yaml"
    echo "  validate      Validate CLAUDE.md hasn't been manually edited"
    echo "  show          Show current pattern configuration"
    echo "  list          List all available patterns"
    echo ""
    echo "Examples:"
    echo "  $0 regenerate ./MyProject"
    echo "  $0 validate"
    echo "  $0 list"
    exit 0
fi

case "${1:-show}" in
    "regenerate")
        echo -e "${YELLOW}⚠️  Regenerating CLAUDE.md will overwrite any manual changes.${NC}"
        read -p "Continue? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Make writable temporarily
            if [ -f "$PROJECT_DIR/CLAUDE.md" ]; then
                chmod +w "$PROJECT_DIR/CLAUDE.md"
            fi
            
            # Read current configuration
            if [ -f "$CONFIG_FILE" ] && command -v yq >/dev/null 2>&1; then
                PLUGINS=$(yq eval '.plugins | join(",")' "$CONFIG_FILE" 2>/dev/null || echo "")
                LANGUAGES=$(yq eval '.languages | join(",")' "$CONFIG_FILE" 2>/dev/null || echo "")
            else
                PLUGINS=""
                LANGUAGES=""
            fi
            
            # Regenerate
            if [ -n "$LANGUAGES" ]; then
                "$ASSEMBLE_SCRIPT" "$PROJECT_DIR" "$PLUGINS" --languages "$LANGUAGES"
            else
                "$ASSEMBLE_SCRIPT" "$PROJECT_DIR" "$PLUGINS"
            fi
            echo -e "${GREEN}✅ CLAUDE.md regenerated from patterns.yaml${NC}"
        else
            echo -e "${BLUE}Regeneration cancelled${NC}"
        fi
        ;;
        
    "validate")
        echo -e "${BLUE}🔍 Validating CLAUDE.md integrity...${NC}"
        
        if [ ! -f "$PROJECT_DIR/CLAUDE.md" ]; then
            echo -e "${YELLOW}⚠️ No CLAUDE.md found in $PROJECT_DIR${NC}"
            exit 0
        fi
        
        # Read current configuration for expected hash
        if [ -f "$CONFIG_FILE" ] && command -v yq >/dev/null 2>&1; then
            PLUGINS=$(yq eval '.plugins | join(",")' "$CONFIG_FILE" 2>/dev/null || echo "")
            LANGUAGES=$(yq eval '.languages | join(",")' "$CONFIG_FILE" 2>/dev/null || echo "")
        else
            PLUGINS=""
            LANGUAGES=""
        fi
        
        # Generate expected hash
        if [ -n "$LANGUAGES" ]; then
            EXPECTED_HASH=$("$ASSEMBLE_SCRIPT" "$PROJECT_DIR" "$PLUGINS" --languages "$LANGUAGES" --dry-run)
        else
            EXPECTED_HASH=$("$ASSEMBLE_SCRIPT" "$PROJECT_DIR" "$PLUGINS" --dry-run)
        fi
        
        # Extract actual hash from file
        ACTUAL_HASH=$(grep "Hash:" "$PROJECT_DIR/CLAUDE.md" 2>/dev/null | awk '{print $2}' || echo "")
        
        if [ "$EXPECTED_HASH" = "$ACTUAL_HASH" ]; then
            echo -e "${GREEN}✅ CLAUDE.md is unmodified${NC}"
        else
            echo -e "${RED}❌ CLAUDE.md has been manually edited!${NC}"
            echo -e "${YELLOW}Expected: $EXPECTED_HASH${NC}"
            echo -e "${YELLOW}Actual: $ACTUAL_HASH${NC}"
            echo -e "${BLUE}Run 'construct-patterns regenerate' to restore${NC}"
            exit 1
        fi
        ;;

    "show")
        echo -e "${BLUE}📋 Current Pattern Configuration${NC}"
        echo -e "${BLUE}Project: $PROJECT_DIR${NC}"
        echo ""
        
        if [ ! -f "$CONFIG_FILE" ]; then
            echo -e "${YELLOW}⚠️ No patterns.yaml found${NC}"
            echo -e "${BLUE}To create one: mkdir -p .construct && cp $CONSTRUCT_CORE/patterns/templates/patterns.yaml .construct/${NC}"
            exit 0
        fi
        
        if command -v yq >/dev/null 2>&1; then
            echo -e "${GREEN}Languages:${NC}"
            yq eval '.languages[]' "$CONFIG_FILE" 2>/dev/null | sed 's/^/  - /' || echo "  (none)"
            echo ""
            
            echo -e "${GREEN}Active Plugins:${NC}"
            yq eval '.plugins[]' "$CONFIG_FILE" 2>/dev/null | sed 's/^/  - /' || echo "  (none)"
            echo ""
            
            echo -e "${GREEN}Custom Rules:${NC}"
            if yq eval '.custom_rules | length' "$CONFIG_FILE" 2>/dev/null | grep -q "0"; then
                echo "  (none)"
            else
                yq eval '.custom_rules' "$CONFIG_FILE" 2>/dev/null | sed 's/^/  /'
            fi
        else
            echo -e "${YELLOW}⚠️ yq not installed, showing raw content:${NC}"
            cat "$CONFIG_FILE"
        fi
        ;;

    "list")
        echo -e "${BLUE}📚 Available Pattern Plugins${NC}"
        echo ""
        
        if [ ! -d "$CONSTRUCT_CORE/patterns/plugins" ]; then
            echo -e "${RED}❌ Pattern plugins directory not found${NC}"
            exit 1
        fi
        
        # List by category
        for category in languages architectural cross-platform tooling; do
            category_dir="$CONSTRUCT_CORE/patterns/plugins/$category"
            if [ -d "$category_dir" ] && [ "$(ls -A "$category_dir" 2>/dev/null)" ]; then
                echo -e "${GREEN}$category:${NC}"
                find "$category_dir" -name "*.md" -type f | while read -r plugin; do
                    plugin_name=$(basename "$plugin" .md)
                    # Extract description from first line of plugin if it exists
                    description=$(head -1 "$plugin" 2>/dev/null | sed 's/^# \[.*\] //' || echo "")
                    echo "  - $category/$plugin_name"
                    if [ -n "$description" ]; then
                        echo "    $description"
                    fi
                done
                echo ""
            fi
        done
        
        echo -e "${BLUE}To use a plugin, add it to your .construct/patterns.yaml file${NC}"
        echo -e "${BLUE}Example: plugins: [\"tooling/shell-scripting\", \"cross-platform/model-sync\"]${NC}"
        ;;
        
    *)
        echo "Usage: construct-patterns [regenerate|validate|show|list] [project-dir]"
        echo "Use --help for more information"
        exit 1
        ;;
esac