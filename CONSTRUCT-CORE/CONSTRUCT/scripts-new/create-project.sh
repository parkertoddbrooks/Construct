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
CONSTRUCT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
CONSTRUCT_CORE="$CONSTRUCT_ROOT/CONSTRUCT-CORE"

PROJECT_DIR="${1:-.}"
PROJECT_TYPE="${2:-interactive}"

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
    echo "What type of project is this?"
    echo "1. iOS App (Swift + MVVM)"
    echo "2. Web App (TypeScript/React)"
    echo "3. Backend API (C#/.NET)"
    echo "4. Full Stack (Multiple languages)"
    echo "5. Custom configuration"
    echo "6. Analyze existing project"
    echo ""
    read -p "Select type (1-6): " TYPE_CHOICE
    
    case $TYPE_CHOICE in
        1) PROJECT_TYPE="ios" ;;
        2) PROJECT_TYPE="web" ;;
        3) PROJECT_TYPE="api" ;;
        4) PROJECT_TYPE="fullstack" ;;
        5) PROJECT_TYPE="custom" ;;
        6) PROJECT_TYPE="existing" ;;
        *) echo -e "${RED}❌ Invalid selection${NC}"; exit 1 ;;
    esac
fi

# Configure patterns based on project type
case $PROJECT_TYPE in
    "ios")
        LANGUAGES="swift"
        SUGGESTED_PLUGINS="tooling/shell-scripting"
        DESCRIPTION="iOS App with Swift and MVVM patterns"
        ;;
    "web")
        LANGUAGES="typescript"
        SUGGESTED_PLUGINS="tooling/shell-scripting"
        DESCRIPTION="Web application with TypeScript/React"
        ;;
    "api")
        LANGUAGES="csharp"
        SUGGESTED_PLUGINS="tooling/shell-scripting"
        DESCRIPTION="Backend API with C#/.NET"
        ;;
    "fullstack")
        echo "Which languages will this project use?"
        echo "Enter comma-separated list (e.g., swift,csharp,typescript):"
        read -p "Languages: " LANGUAGES
        SUGGESTED_PLUGINS="cross-platform/model-sync,tooling/shell-scripting"
        DESCRIPTION="Full-stack application with multiple languages"
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
            echo -e "${YELLOW}⚠️ No recognized languages detected${NC}"
            read -p "Enter languages manually (comma-separated): " LANGUAGES
        fi
        
        # Suggest patterns based on detected languages
        SUGGESTED_PLUGINS="tooling/shell-scripting"
        if [[ "$LANGUAGES" =~ "," ]]; then
            SUGGESTED_PLUGINS="${SUGGESTED_PLUGINS},cross-platform/model-sync"
        fi
        
        DESCRIPTION="Existing project with detected patterns"
        ;;
    "custom")
        read -p "Languages (comma-separated): " LANGUAGES
        SUGGESTED_PLUGINS="tooling/shell-scripting"
        DESCRIPTION="Custom project configuration"
        ;;
    *)
        echo -e "${RED}❌ Unknown project type: $PROJECT_TYPE${NC}"
        exit 1
        ;;
esac

# Show available additional plugins
echo ""
echo -e "${BLUE}📦 Available Pattern Plugins:${NC}"

if [ -d "$CONSTRUCT_CORE/patterns/plugins" ]; then
    # List by category
    for category in languages architectural cross-platform tooling; do
        category_dir="$CONSTRUCT_CORE/patterns/plugins/$category"
        if [ -d "$category_dir" ] && [ "$(ls -A "$category_dir" 2>/dev/null)" ]; then
            echo -e "${GREEN}$category:${NC}"
            find "$category_dir" -name "*.md" -type f | while read -r plugin; do
                plugin_name=$(basename "$plugin" .md)
                # Extract description from first line if it exists
                description=$(head -1 "$plugin" 2>/dev/null | sed 's/^# \[.*\] //' || echo "")
                echo "  - $category/$plugin_name"
                if [ -n "$description" ] && [ "$description" != "$(head -1 "$plugin")" ]; then
                    echo "    $description"
                fi
            done
            echo ""
        fi
    done
else
    echo -e "${YELLOW}⚠️ Pattern plugins directory not found${NC}"
fi

echo "Additional pattern plugins (comma-separated, or press enter for suggested):"
echo -e "${BLUE}Suggested: $SUGGESTED_PLUGINS${NC}"
read -p "Additional plugins: " ADDITIONAL_PLUGINS

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
if [ ! -d "$PROJECT_DIR/AI" ] && [ -d "$CONSTRUCT_CORE/AI/template-structure" ]; then
    echo -e "${YELLOW}🧠 Applying AI template structure...${NC}"
    cp -r "$CONSTRUCT_CORE/AI/template-structure/AI" "$PROJECT_DIR/"
    echo -e "${GREEN}✅ AI template structure applied${NC}"
fi

# Generate CLAUDE.md with selected patterns and languages
echo -e "${YELLOW}⚙️ Generating CLAUDE.md...${NC}"
if [ -x "$CONSTRUCT_CORE/CONSTRUCT/scripts/assemble-claude.sh" ]; then
    "$CONSTRUCT_CORE/CONSTRUCT/scripts/assemble-claude.sh" "$PROJECT_DIR" "$ALL_PLUGINS" --languages "$LANGUAGES"
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