#!/bin/bash

# Create Project - Sets up new projects with pattern configuration
# Creates project structure, applies AI template, and configures patterns

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSTRUCT_CORE="$(cd "$SCRIPT_DIR/../../.." && pwd)"
CONSTRUCT_ROOT="$(cd "$CONSTRUCT_CORE/.." && pwd)"

# Source libraries
source "$CONSTRUCT_CORE/CONSTRUCT/lib/template-location.sh"
source "$CONSTRUCT_CORE/CONSTRUCT/lib/interactive-support.sh"

# Function to show what prompts this script needs
show_create_project_prompts() {
    # Simplified output for Claude
    if is_claude_prompts_mode "$@"; then
        echo "1. Additional plugins? [default/list]"
        return
    fi
    
    echo "1. Project type (if not specified as argument)"
    echo "   Options: [ios|web|api|fullstack|custom|existing]"
    echo "   Default: interactive selection"
    echo ""
    echo "2. Additional pattern plugins"
    echo "   Format: comma-separated list"
    echo "   Example: languages/swift,mvvm-architecture"
    echo "   Default: (suggested based on project type)"
}

# Check if should show prompts
if should_show_prompts "$@"; then
    show_script_prompts "$(basename "$0")" show_create_project_prompts "$@"
    exit 0
fi

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 [project-dir] [project-type]"
    echo ""
    echo "Creates a new project with CONSTRUCT pattern configuration"
    echo ""
    echo "Parameters:"
    echo "  project-dir    Target directory (default: current directory)"
    echo "  project-type   Project type or 'interactive' for guided setup"
    echo ""
    echo "Project Types:"
    echo "  ios           iOS App (Swift + MVVM)"
    echo "  web           Web App (TypeScript/React)"
    echo "  api           Backend API (C#/.NET)"
    echo "  fullstack     Full Stack (Multiple languages)"
    echo "  custom        Custom configuration"
    echo "  existing      Analyze existing project"
    echo "  interactive   Guided setup (default)"
    echo ""
    echo "Examples:"
    echo "  $0 ./MyApp ios"
    echo "  $0 . existing"
    echo "  $0 ../NewProject interactive"
    exit 0
fi

PROJECT_DIR="${1:-.}"
PROJECT_TYPE="${2:-interactive}"

# Validate project directory
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}❌ Error: Project directory not found: $PROJECT_DIR${NC}"
    echo -e "${BLUE}Create it first: mkdir -p '$PROJECT_DIR'${NC}"
    exit 1
fi

# Make project directory absolute
PROJECT_DIR=$(cd "$PROJECT_DIR" && pwd)

echo -e "${BLUE}🚀 CONSTRUCT Project Setup${NC}"
echo -e "${BLUE}Project: $PROJECT_DIR${NC}"
echo ""

# Interactive project type selection
if [[ "$PROJECT_TYPE" == "interactive" ]]; then
    if is_interactive; then
        echo "What type of project is this?"
        echo "1. iOS App (Swift + MVVM)"
        echo "2. Web App (TypeScript/React)"
        echo "3. Backend API (C#/.NET)"
        echo "4. Full Stack (Multiple languages)"
        echo "5. Custom configuration"
        echo "6. Analyze existing project"
        echo ""
    fi
    
    TYPE_CHOICE=$(get_input_with_default "Select type (1-6)" "1")
    
    case $TYPE_CHOICE in
        1) PROJECT_TYPE="ios" ;;
        2) PROJECT_TYPE="web" ;;
        3) PROJECT_TYPE="api" ;;
        4) PROJECT_TYPE="fullstack" ;;
        5) PROJECT_TYPE="custom" ;;
        6) PROJECT_TYPE="existing" ;;
        *) show_error "Invalid selection: $TYPE_CHOICE"; exit 1 ;;
    esac
fi

# Load project sets configuration
PROJECT_SETS_FILE="$CONSTRUCT_CORE/patterns/templates/project-sets.yaml"

# Configure patterns based on project type
if [ -f "$PROJECT_SETS_FILE" ] && command -v yq &> /dev/null; then
    # Read from project-sets.yaml
    case $PROJECT_TYPE in
        "ios"|"web"|"api"|"construct-dev"|"run-app")
            LANGUAGES=$(yq eval ".project_sets.$PROJECT_TYPE.languages[]" "$PROJECT_SETS_FILE" 2>/dev/null | tr '\n' ',' | sed 's/,$//')
            SUGGESTED_PLUGINS=$(yq eval ".project_sets.$PROJECT_TYPE.plugins[]" "$PROJECT_SETS_FILE" 2>/dev/null | tr '\n' ',' | sed 's/,$//')
            DESCRIPTION=$(yq eval ".project_sets.$PROJECT_TYPE.description" "$PROJECT_SETS_FILE" 2>/dev/null)
            ;;
        "fullstack")
            # Special handling for fullstack - still interactive
            if is_interactive; then
                echo "Which languages will this project use?"
                echo "Enter comma-separated list (e.g., swift,csharp,typescript):"
            fi
            DEFAULT_LANGUAGES=$(yq eval ".project_sets.fullstack.languages[]" "$PROJECT_SETS_FILE" 2>/dev/null | tr '\n' ',' | sed 's/,$//')
            LANGUAGES=$(get_input_with_default "Languages" "$DEFAULT_LANGUAGES")
            SUGGESTED_PLUGINS=$(yq eval ".project_sets.fullstack.plugins[]" "$PROJECT_SETS_FILE" 2>/dev/null | tr '\n' ',' | sed 's/,$//')
            DESCRIPTION=$(yq eval ".project_sets.fullstack.description" "$PROJECT_SETS_FILE" 2>/dev/null)
            ;;
        "existing")
            echo -e "${BLUE}🔍 Analyzing existing project...${NC}"
            
            # Detect languages from file extensions
            DETECTED_LANGUAGES=""
        if find "$PROJECT_DIR" -name "*.swift" -type f | head -1 | grep -q .; then
            DETECTED_LANGUAGES="swift"
        fi
        if find "$PROJECT_DIR" -name "*.cs" -type f | head -1 | grep -q .; then
            DETECTED_LANGUAGES="${DETECTED_LANGUAGES},csharp"
        fi
        if find "$PROJECT_DIR" -name "*.ts" -o -name "*.tsx" -type f | head -1 | grep -q .; then
            DETECTED_LANGUAGES="${DETECTED_LANGUAGES},typescript"
        fi
        
        # Clean up leading comma
        DETECTED_LANGUAGES="${DETECTED_LANGUAGES#,}"
        
        if [ -n "$DETECTED_LANGUAGES" ]; then
            echo -e "${GREEN}✅ Detected languages: $DETECTED_LANGUAGES${NC}"
            LANGUAGES="$DETECTED_LANGUAGES"
        else
            show_warning "No recognized languages detected"
            LANGUAGES=$(get_input_with_default "Enter languages manually (comma-separated)" "")
        fi
        
        # Suggest patterns based on detected languages
        SUGGESTED_PLUGINS="tooling/shell-scripting"
        if [[ "$LANGUAGES" =~ "," ]]; then
            SUGGESTED_PLUGINS="${SUGGESTED_PLUGINS},cross-platform/model-sync"
        fi
        
        DESCRIPTION="Existing project with detected patterns"
        ;;
        "custom")
            LANGUAGES=$(get_input_with_default "Languages (comma-separated)" "")
            SUGGESTED_PLUGINS="tooling/shell-scripting"
            DESCRIPTION="Custom project configuration"
            ;;
        *)
            echo -e "${RED}❌ Unknown project type: $PROJECT_TYPE${NC}"
            exit 1
            ;;
    esac
else
    # Fallback when yq is not available
    echo -e "${YELLOW}⚠️  yq not found - using defaults${NC}"
    case $PROJECT_TYPE in
        "ios")
            LANGUAGES="swift"
            SUGGESTED_PLUGINS="languages/swift,architectural/mvvm-ios,frameworks/swiftui,platforms/ios,tooling/shell-scripting"
            DESCRIPTION="iOS App with Swift and MVVM patterns"
            ;;
        "web")
            LANGUAGES="typescript"
            SUGGESTED_PLUGINS="languages/typescript,frameworks/react,tooling/shell-scripting,tooling/error-handling"
            DESCRIPTION="Web application with TypeScript/React"
            ;;
        "api")
            LANGUAGES="csharp"
            SUGGESTED_PLUGINS="languages/csharp,tooling/shell-scripting,tooling/error-handling"
            DESCRIPTION="Backend API with C#/.NET"
            ;;
        "construct-dev")
            LANGUAGES="python"
            SUGGESTED_PLUGINS="tooling/construct-dev,tooling/shell-scripting,tooling/shell-quality,tooling/unix-philosophy"
            DESCRIPTION="CONSTRUCT development environment"
            ;;
        "fullstack")
            if is_interactive; then
                echo "Which languages will this project use?"
                echo "Enter comma-separated list (e.g., swift,csharp,typescript):"
            fi
            LANGUAGES=$(get_input_with_default "Languages" "swift,csharp,typescript")
            SUGGESTED_PLUGINS="languages/swift,languages/csharp,cross-platform/model-sync,tooling/shell-scripting"
            DESCRIPTION="Full-stack application with multiple languages"
            ;;
        "existing")
            echo -e "${BLUE}🔍 Analyzing existing project...${NC}"
            LANGUAGES=$(get_input_with_default "Languages (comma-separated)" "")
            SUGGESTED_PLUGINS="tooling/shell-scripting"
            DESCRIPTION="Existing project"
            ;;
        "custom")
            LANGUAGES=$(get_input_with_default "Languages (comma-separated)" "")
            SUGGESTED_PLUGINS="tooling/shell-scripting"
            DESCRIPTION="Custom project configuration"
            ;;
        *)
            echo -e "${RED}❌ Unknown project type: $PROJECT_TYPE${NC}"
            exit 1
            ;;
    esac
fi

# Show available additional plugins
echo ""
echo -e "${BLUE}📦 Available Pattern Plugins:${NC}"

# Use registry if available, otherwise scan directories
REGISTRY_FILE="$CONSTRUCT_CORE/patterns/plugins/registry.yaml"
if [ -f "$REGISTRY_FILE" ] && command -v yq &> /dev/null; then
    # Show from registry
    echo -e "${GREEN}From Plugin Registry:${NC}"
    
    # Get all plugin paths and descriptions
    yq eval '.plugins.core | to_entries | .[] | "\(.key)|\(.value.description)"' "$REGISTRY_FILE" 2>/dev/null | while IFS='|' read -r plugin desc; do
        if [ -n "$plugin" ]; then
            echo "  - $plugin"
            [ -n "$desc" ] && [ "$desc" != "null" ] && echo "    $desc"
        fi
    done
    
    # Check for LAB plugins
    if yq eval '.plugins.lab' "$REGISTRY_FILE" &>/dev/null; then
        echo ""
        echo -e "${GREEN}Project-specific (LAB):${NC}"
        yq eval '.plugins.lab | to_entries | .[] | "\(.key)|\(.value.description)"' "$REGISTRY_FILE" 2>/dev/null | while IFS='|' read -r plugin desc; do
            if [ -n "$plugin" ]; then
                echo "  - $plugin"
                [ -n "$desc" ] && [ "$desc" != "null" ] && echo "    $desc"
            fi
        done
    fi
elif [ -d "$CONSTRUCT_CORE/patterns/plugins" ]; then
    # Fallback: scan directories
    echo -e "${YELLOW}(Registry not available, scanning directories)${NC}"
    for category in languages architectural cross-platform frameworks platforms tooling; do
        category_dir="$CONSTRUCT_CORE/patterns/plugins/$category"
        if [ -d "$category_dir" ] && [ "$(ls -A "$category_dir" 2>/dev/null)" ]; then
            echo -e "${GREEN}$category:${NC}"
            for plugin_dir in "$category_dir"/*; do
                [ -d "$plugin_dir" ] || continue
                plugin_name=$(basename "$plugin_dir")
                echo "  - $category/$plugin_name"
            done
        fi
    done
else
    echo -e "${YELLOW}⚠️ Pattern plugins directory not found${NC}"
fi

if is_interactive; then
    echo "Additional pattern plugins (comma-separated, or press enter for suggested):"
    echo -e "${BLUE}Suggested: $SUGGESTED_PLUGINS${NC}"
fi
ADDITIONAL_PLUGINS=$(get_input_with_default "Additional plugins" "")

# Combine all plugins
if [ -n "$ADDITIONAL_PLUGINS" ]; then
    ALL_PLUGINS="${SUGGESTED_PLUGINS},${ADDITIONAL_PLUGINS}"
else
    ALL_PLUGINS="$SUGGESTED_PLUGINS"
fi

# Remove duplicates and clean up
ALL_PLUGINS=$(echo "$ALL_PLUGINS" | tr ',' '\n' | sort -u | tr '\n' ',' | sed 's/,$//')

echo ""
echo -e "${BLUE}📋 Project Configuration Summary:${NC}"
echo "  Languages: $LANGUAGES"
echo "  Plugins: $ALL_PLUGINS"
echo "  Description: $DESCRIPTION"
echo ""

# Create .construct directory and configuration
echo -e "${YELLOW}🔧 Creating pattern configuration...${NC}"
mkdir -p "$PROJECT_DIR/.construct"

# Copy default patterns.yaml template
if [ -f "$CONSTRUCT_CORE/patterns/templates/patterns.yaml" ]; then
    cp "$CONSTRUCT_CORE/patterns/templates/patterns.yaml" "$PROJECT_DIR/.construct/patterns.yaml"
else
    # Create minimal patterns.yaml if template doesn't exist
    cat > "$PROJECT_DIR/.construct/patterns.yaml" << 'EOF'
# .construct/patterns.yaml
# Project-specific pattern configuration

languages: []
plugins: []
custom_rules: {}
overrides: []
includes: []
EOF
fi

# Update patterns.yaml with selections using simple text replacement
# (yq would be better but might not be available)
if command -v yq >/dev/null 2>&1; then
    # Use yq if available
    yq eval -i ".languages = [$(echo "$LANGUAGES" | sed 's/,/", "/g' | sed 's/^/"/;s/$/"/')]" "$PROJECT_DIR/.construct/patterns.yaml"
    yq eval -i ".plugins = [$(echo "$ALL_PLUGINS" | sed 's/,/", "/g' | sed 's/^/"/;s/$/"/')]" "$PROJECT_DIR/.construct/patterns.yaml"
else
    # Fallback to sed replacement
    # Build language array string - escape special chars for sed
    LANG_ARRAY=$(echo "$LANGUAGES" | sed 's/,/, /g' | sed 's/\([^, ]*\)/"\1"/g' | sed 's/\//\\\//g')
    PLUGIN_ARRAY=$(echo "$ALL_PLUGINS" | sed 's/,/, /g' | sed 's/\([^, ]*\)/"\1"/g' | sed 's/\//\\\//g')
    
    # Replace languages line - escape brackets for sed
    sed -i.bak "s/^languages: \\[\\]/languages: [$LANG_ARRAY]/" "$PROJECT_DIR/.construct/patterns.yaml"
    
    # Replace plugins line - escape brackets for sed
    sed -i.bak "s/^plugins: \\[\\]/plugins: [$PLUGIN_ARRAY]/" "$PROJECT_DIR/.construct/patterns.yaml"
    
    # Remove backup file
    rm -f "$PROJECT_DIR/.construct/patterns.yaml.bak"
fi

echo -e "${GREEN}✅ Pattern configuration created: .construct/patterns.yaml${NC}"

# Apply AI template structure if it doesn't exist
AI_TEMPLATE_DIR=$(get_ai_template_dir)
if [ ! -d "$PROJECT_DIR/AI" ] && [ -d "$AI_TEMPLATE_DIR/AI" ]; then
    echo -e "${YELLOW}🧠 Applying AI template structure...${NC}"
    cp -r "$AI_TEMPLATE_DIR/AI" "$PROJECT_DIR/"
    echo -e "${GREEN}✅ AI template structure applied${NC}"
fi

# Generate CLAUDE.md with selected patterns and languages
echo -e "${YELLOW}⚙️ Generating CLAUDE.md...${NC}"
if [ -x "$CONSTRUCT_CORE/CONSTRUCT/scripts/construct/assemble-claude.sh" ]; then
    "$CONSTRUCT_CORE/CONSTRUCT/scripts/construct/assemble-claude.sh" "$PROJECT_DIR" "$ALL_PLUGINS" --languages "$LANGUAGES"
    echo -e "${GREEN}✅ CLAUDE.md generated with selected patterns${NC}"
else
    echo -e "${YELLOW}⚠️ assemble-claude.sh not found, CLAUDE.md not generated${NC}"
fi

# Create basic .gitignore if it doesn't exist
if [ ! -f "$PROJECT_DIR/.gitignore" ]; then
    echo -e "${YELLOW}📝 Creating .gitignore...${NC}"
    cat > "$PROJECT_DIR/.gitignore" << 'EOF'
# CONSTRUCT generated files
CLAUDE-temp.md

# OS files
.DS_Store
Thumbs.db

# Editor files
.vscode/
.idea/
*.swp
*.swo

# Dependencies
node_modules/
EOF
    echo -e "${GREEN}✅ Basic .gitignore created${NC}"
fi

# Project setup complete
echo ""
echo -e "${GREEN}🎉 Project setup complete!${NC}"
echo ""
echo -e "${BLUE}📁 Project structure:${NC}"
echo "  $PROJECT_DIR/"
echo "  ├── .construct/patterns.yaml  # Pattern configuration"
if [ -d "$PROJECT_DIR/AI" ]; then
    echo "  ├── AI/                      # Development context"
fi
if [ -f "$PROJECT_DIR/CLAUDE.md" ]; then
    echo "  ├── CLAUDE.md                # Generated context (read-only)"
fi
echo "  └── .gitignore               # Git ignore rules"
echo ""
echo -e "${BLUE}📝 Next steps:${NC}"
echo "1. Edit .construct/patterns.yaml to customize patterns"
echo "2. Add project-specific rules to custom_rules section"
echo "3. Run: construct-patterns regenerate  # To update CLAUDE.md"
echo "4. Start developing with AI-aware context!"
echo ""
echo -e "${BLUE}💡 Pattern Management:${NC}"
echo "  construct-patterns show      # View current configuration"
echo "  construct-patterns validate  # Check CLAUDE.md integrity"
echo "  construct-patterns list      # See all available patterns"
echo ""

# Add pattern configuration to git (but not CLAUDE.md)
if command -v git >/dev/null 2>&1 && [ -d "$PROJECT_DIR/.git" ]; then
    echo -e "${YELLOW}📦 Adding pattern configuration to git...${NC}"
    cd "$PROJECT_DIR"
    git add .construct/patterns.yaml
    if [ -f ".gitignore" ]; then
        git add .gitignore
    fi
    if [ -d "AI" ]; then
        git add AI/
    fi
    echo -e "${GREEN}✅ Pattern configuration staged for commit${NC}"
    echo -e "${BLUE}Note: CLAUDE.md is generated - don't commit it directly${NC}"
fi

echo ""
echo -e "${BLUE}🚀 Project '$PROJECT_DIR' is ready for development!${NC}"