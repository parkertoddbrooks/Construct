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

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSTRUCT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
CONSTRUCT_CORE="$CONSTRUCT_ROOT/CONSTRUCT-CORE"
CONSTRUCT_LAB="$CONSTRUCT_ROOT/CONSTRUCT-LAB"
PATTERNS_DIR="$CONSTRUCT_CORE/CONSTRUCT/scripts/patterns"

# Check if running in Claude Code environment
if [ -n "$CLAUDE_CODE" ] || [ -n "$ANTHROPIC_WORKBENCH" ]; then
    export CONSTRUCT_INTERACTIVE=1
fi

# Source library functions
source "$CONSTRUCT_CORE/CONSTRUCT/lib/common-patterns.sh" 2>/dev/null || true
source "$CONSTRUCT_CORE/CONSTRUCT/lib/validation.sh" 2>/dev/null || true
source "$CONSTRUCT_CORE/CONSTRUCT/lib/interactive-support.sh" 2>/dev/null || true

# Function to check if CLAUDE.md is from /init
is_from_init() {
    local claude_file="$1"
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

# Function to show available plugins
show_available_plugins() {
    echo -e "${BLUE}📦 Available Pattern Plugins:${NC}"
    echo ""
    
    # Scan plugin directories
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
}

# Interactive prompts function
show_construct_prompts() {
    # Simplified output for Claude
    if is_claude_prompts_mode "$@"; then
        echo "1. Pattern plugins to install (comma-separated)"
        echo "   Options: Run with --show-prompts for full list"
        return
    fi
    
    echo "1. Pattern plugins to install"
    echo "   Format: comma-separated list"
    echo "   Example: languages/python,frameworks/web"
    echo ""
    echo "   Based on analysis, consider:"
    # This would show recommendations in actual use
    echo "   - Check detected languages and frameworks"
    echo "   - Include essential patterns only by default"
    echo ""
    echo "   Default: Accept recommendations or none if no project detected"
}

# Function to display help
show_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Enhances CLAUDE.md with CONSTRUCT patterns after /init"
    echo ""
    echo "Options:"
    echo "  --regenerate     Regenerate CLAUDE.md from patterns"
    echo "  --show-prompts   Show what inputs are needed (for Claude Code)"
    echo "  --claude-prompts Simplified prompt output (for Claude Code)"
    echo "  --interactive    Force interactive mode for plugin selection"
    echo "  -h, --help       Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                    # Enhance with project patterns"
    echo "  $0 --regenerate       # Regenerate from current patterns"
    echo "  $0 --show-prompts     # See what will be asked"
}

# Parse command line arguments
REGENERATE=false
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --regenerate)
            REGENERATE=true
            shift
            ;;
        --show-prompts|--claude-prompts)
            show_script_prompts "$(basename "$0")" show_construct_prompts "$@"
            exit 0
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
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# Check if should show prompts (from interactive-support.sh)
if should_show_prompts "$@"; then
    show_script_prompts "$(basename "$0")" show_construct_prompts "$@"
    exit 0
fi

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
    
    # Extract patterns using our new script
    EXTRACTED_PLUGIN=$("$PATTERNS_DIR/extract-legacy-patterns.sh" CLAUDE.md 2>&1 | tail -1)
    echo ""
fi

# Find or create patterns.yaml
PATTERNS_FILE="$CONSTRUCT_DIR/patterns.yaml"
if [ ! -f "$PATTERNS_FILE" ] || [ "$MODE" = "mode_1" ] || [ "$MODE" = "mode_3" ]; then
    if [ -f "$PATTERNS_FILE" ] && [ "$MODE" = "mode_1" ]; then
        echo -e "${YELLOW}⚠️  Patterns file exists but no /init content detected${NC}"
        echo "Proceeding with pattern selection..."
    fi
    
    echo -e "${YELLOW}Creating patterns.yaml...${NC}"
    
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
  - tooling/error-handling     # Error handling patterns
  - tooling/shell-quality      # Shell quality standards

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
        # Regular project - use pattern recommendation
        echo -e "${BLUE}🔍 Analyzing project for pattern recommendations...${NC}"
        echo ""
        
        # Get recommendations from all sources (raw format for parsing)
        recommendations=$("$PATTERNS_DIR/recommend-patterns.sh" --github --claude CLAUDE.md.backup --mode essential --quiet 2>&1 | tail -1 || \
                         "$PATTERNS_DIR/recommend-patterns.sh" --claude CLAUDE.md.backup --mode essential --quiet 2>&1 | tail -1 || \
                         "$PATTERNS_DIR/recommend-patterns.sh" --mode essential --quiet 2>&1 | tail -1 || true)
        
        # Parse recommendations to get essential patterns (space-separated list)
        essential_patterns=()
        if [ -n "$recommendations" ]; then
            # recommendations is a space-separated list
            IFS=' ' read -ra essential_patterns <<< "$recommendations"
        fi
        
        # Determine primary language
        primary_language="bash"
        for plugin in "${essential_patterns[@]}"; do
            if [[ "$plugin" =~ ^languages/(.+)$ ]]; then
                primary_language="${BASH_REMATCH[1]}"
                break
            fi
        done
        
        # Interactive selection
        selected_plugins=()
        
        if is_interactive; then
            # Show recommendations and get user choice
            "$PATTERNS_DIR/recommend-patterns.sh" --github --claude CLAUDE.md.backup --mode balanced 2>/dev/null || \
            "$PATTERNS_DIR/recommend-patterns.sh" --claude CLAUDE.md.backup --mode balanced 2>/dev/null || \
            "$PATTERNS_DIR/recommend-patterns.sh" --mode balanced 2>/dev/null || true
            
            echo ""
            echo -e "${YELLOW}What would you like to do?${NC}"
            echo "  1) Install essential patterns only"
            echo "  2) Choose specific patterns"
            echo "  3) Skip pattern installation"
            echo ""
            echo -ne "${YELLOW}Your choice [1-3]: ${NC}"
            read -r response
            
            case "$response" in
                1|"")
                    selected_plugins=("${essential_patterns[@]}")
                    echo -e "${GREEN}✓ Installing essential patterns${NC}"
                    ;;
                2)
                    echo ""
                    show_available_plugins
                    echo ""
                    echo -e "${YELLOW}Enter plugins to install (comma-separated):${NC}"
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
                    selected_plugins=("${valid_plugins[@]}")
                    ;;
                3)
                    echo -e "${YELLOW}⚠️  Skipping plugin installation${NC}"
                    selected_plugins=()
                    ;;
            esac
        else
            # Non-interactive mode
            if [ -t 0 ]; then
                # No piped input - show recommendations and exit
                "$PATTERNS_DIR/recommend-patterns.sh" --github --claude CLAUDE.md.backup --mode essential 2>/dev/null || \
                "$PATTERNS_DIR/recommend-patterns.sh" --claude CLAUDE.md.backup --mode essential 2>/dev/null || \
                "$PATTERNS_DIR/recommend-patterns.sh" --mode essential 2>/dev/null || \
                echo -e "${GRAY}No recommendations available${NC}"
                
                echo ""
                echo -e "${YELLOW}To install recommended patterns:${NC}"
                echo "   echo '' | $0"
                echo ""
                echo -e "${YELLOW}To choose patterns interactively:${NC}"
                echo "   $0 --interactive"
                echo ""
                echo -e "${YELLOW}To install specific patterns:${NC}"
                echo "   echo 'languages/python,frameworks/web' | $0"
                
                exit 0
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
                    # Empty input - use essential recommendations only
                    selected_plugins=("${essential_patterns[@]}")
                    echo -e "${YELLOW}Using essential plugins: ${selected_plugins[*]}${NC}"
                fi
            fi
        fi
        
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

# Backup current CLAUDE.md
if [ "$DRY_RUN" = false ] && [ -f "CLAUDE.md" ]; then
    cp CLAUDE.md CLAUDE.md.backup
    echo -e "${GREEN}✅ Backed up current CLAUDE.md${NC}"
fi

# Enhance CLAUDE.md with patterns using assemble-claude.sh
echo -e "${BLUE}🔄 Enhancing CLAUDE.md with patterns...${NC}"

# Read the plugins from patterns.yaml to pass to assemble-claude.sh
if [ -f "$PATTERNS_FILE" ] && command -v yq >/dev/null 2>&1; then
    # Extract plugins list from patterns.yaml
    PLUGINS_LIST=$(yq eval '.plugins[]' "$PATTERNS_FILE" 2>/dev/null | tr '\n' ',' | sed 's/,$//')
    
    if [ -n "$PLUGINS_LIST" ]; then
        echo -e "${YELLOW}  Plugins to apply: $PLUGINS_LIST${NC}"
        
        # Preserve the /init content by backing it up
        if [ -f "CLAUDE.md" ] && ! grep -q "CONSTRUCT Enhanced" CLAUDE.md 2>/dev/null; then
            cp CLAUDE.md CLAUDE.md.from-init
            echo -e "${GREEN}✅ Preserved /init content as backup${NC}"
        fi
        
        # Use assemble-claude.sh to create enhanced CLAUDE.md
        ASSEMBLE_SCRIPT="$CONSTRUCT_CORE/CONSTRUCT/scripts/construct/assemble-claude.sh"
        if [ -x "$ASSEMBLE_SCRIPT" ]; then
            "$ASSEMBLE_SCRIPT" "$PROJECT_ROOT" "$PLUGINS_LIST"
            
            # Check if enhancement was successful
            if [ -f "CLAUDE.md" ] && grep -q "DO NOT EDIT THIS FILE" CLAUDE.md 2>/dev/null; then
                echo -e "${GREEN}✅ Successfully enhanced CLAUDE.md with pattern content${NC}"
            else
                echo -e "${RED}❌ Pattern enhancement failed, restoring backup${NC}"
                if [ -f "CLAUDE.md.backup" ]; then
                    mv CLAUDE.md.backup CLAUDE.md
                fi
                exit 1
            fi
        else
            echo -e "${RED}❌ assemble-claude.sh not found: $ASSEMBLE_SCRIPT${NC}"
            exit 1
        fi
    else
        echo -e "${YELLOW}⚠️  No plugins found in patterns.yaml${NC}"
        # Just add enhancement marker without pattern content
        if ! grep -q "CONSTRUCT Enhanced" CLAUDE.md 2>/dev/null; then
            {
                echo "<!-- CONSTRUCT Enhanced: $(date -u +"%Y-%m-%d %H:%M:%S UTC") -->"
                echo ""
                cat CLAUDE.md
            } > CLAUDE.md.tmp && mv CLAUDE.md.tmp CLAUDE.md
            echo -e "${GREEN}✅ Added CONSTRUCT enhancement marker${NC}"
        fi
    fi
else
    echo -e "${YELLOW}⚠️  Could not read patterns.yaml or yq not installed${NC}"
    # Fallback to just adding marker
    if ! grep -q "CONSTRUCT Enhanced" CLAUDE.md 2>/dev/null; then
        {
            echo "<!-- CONSTRUCT Enhanced: $(date -u +"%Y-%m-%d %H:%M:%S UTC") -->"
            echo ""
            cat CLAUDE.md
        } > CLAUDE.md.tmp && mv CLAUDE.md.tmp CLAUDE.md
        echo -e "${GREEN}✅ Added CONSTRUCT enhancement marker${NC}"
    fi
fi

echo ""
echo -e "${GREEN}✅ CONSTRUCT initialization complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Review .construct/patterns.yaml"
echo "  2. Run 'construct-update' to populate dynamic sections"
echo "  3. Start coding with enhanced AI assistance!"