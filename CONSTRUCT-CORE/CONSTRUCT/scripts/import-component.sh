#!/bin/bash

# Import Component - Adds a repository component to existing multi-repo project
# Usage: import-component.sh <source-path> <project-name> <component-name>

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
WORKSPACE_REGISTRY="$CONSTRUCT_ROOT/.construct-workspace/registry.yaml"

SOURCE_PATH="$1"
PROJECT_NAME="$2"
COMPONENT_NAME="$3"

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 <source-path> <project-name> <component-name>"
    echo ""
    echo "Adds a repository component to an existing multi-repo project"
    echo ""
    echo "Arguments:"
    echo "  source-path      Path to component repository (local or git URL)"
    echo "  project-name     Existing project name in workspace"
    echo "  component-name   Name for this component (ios, backend, web, etc.)"
    echo ""
    echo "Examples:"
    echo "  $0 ../ios-app MyApp ios                     # Add iOS component"
    echo "  $0 https://github.com/team/api MyApp backend # Add backend component"
    echo "  $0 ../web-frontend MyApp web                # Add web component"
    echo ""
    echo "This command:"
    echo "  1. Imports the repository to Projects/{project}/{component}/"
    echo "  2. Preserves the component's git history"
    echo "  3. Creates component-specific .construct/ configuration"
    echo "  4. Updates the workspace registry"
    echo "  5. Inherits shared patterns from project level"
    exit 0
fi

# Validate arguments
if [ -z "$SOURCE_PATH" ] || [ -z "$PROJECT_NAME" ] || [ -z "$COMPONENT_NAME" ]; then
    echo -e "${RED}❌ Error: All arguments required${NC}"
    echo -e "${BLUE}Usage: $0 <source-path> <project-name> <component-name>${NC}"
    exit 1
fi

# Sanitize names
PROJECT_NAME=$(echo "$PROJECT_NAME" | sed 's/[^a-zA-Z0-9-]/-/g')
COMPONENT_NAME=$(echo "$COMPONENT_NAME" | sed 's/[^a-zA-Z0-9-]/-/g')

PROJECT_DIR="$CONSTRUCT_ROOT/Projects/$PROJECT_NAME"
COMPONENT_DIR="$PROJECT_DIR/$COMPONENT_NAME"

echo -e "${BLUE}🚀 CONSTRUCT Component Import${NC}"
echo -e "${BLUE}Source: $SOURCE_PATH${NC}"
echo -e "${BLUE}Project: $PROJECT_NAME${NC}"
echo -e "${BLUE}Component: $COMPONENT_NAME${NC}"
echo -e "${BLUE}Destination: Projects/$PROJECT_NAME/$COMPONENT_NAME${NC}"
echo ""

# Check if project exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}❌ Error: Project '$PROJECT_NAME' does not exist${NC}"
    echo -e "${BLUE}Create project first with: import-project.sh <source> $PROJECT_NAME${NC}"
    echo -e "${BLUE}Or check existing projects with: workspace-status${NC}"
    exit 1
fi

# Check if component already exists
if [ -d "$COMPONENT_DIR" ]; then
    echo -e "${RED}❌ Error: Component '$COMPONENT_NAME' already exists in project '$PROJECT_NAME'${NC}"
    echo -e "${BLUE}Choose a different component name${NC}"
    exit 1
fi

# Determine if source is URL or local path
if [[ "$SOURCE_PATH" =~ ^https?:// ]] || [[ "$SOURCE_PATH" =~ ^git@ ]]; then
    IS_REMOTE=true
else
    IS_REMOTE=false
    # Validate local path exists
    if [ ! -d "$SOURCE_PATH" ]; then
        echo -e "${RED}❌ Error: Source directory not found: $SOURCE_PATH${NC}"
        exit 1
    fi
fi

# Create component directory
mkdir -p "$COMPONENT_DIR"

# Import the component repository
if [ "$IS_REMOTE" = true ]; then
    echo -e "${YELLOW}📥 Cloning remote component...${NC}"
    git clone "$SOURCE_PATH" "$COMPONENT_DIR"
else
    echo -e "${YELLOW}📁 Copying local component...${NC}"
    cp -r "$SOURCE_PATH/." "$COMPONENT_DIR/"
fi

echo -e "${GREEN}✅ Component repository imported${NC}"

# Analyze component for patterns
echo -e "${YELLOW}🔍 Analyzing component structure...${NC}"

cd "$COMPONENT_DIR"

# Get git info
if [ -d ".git" ]; then
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
    REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "$SOURCE_PATH")
    DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")
    echo -e "${GREEN}✅ Git repository detected${NC}"
    echo -e "${BLUE}   Current branch: $CURRENT_BRANCH${NC}"
    echo -e "${BLUE}   Remote: $REMOTE_URL${NC}"
else
    echo -e "${YELLOW}⚠️ No git repository found, initializing...${NC}"
    git init
    CURRENT_BRANCH="main"
    REMOTE_URL="$SOURCE_PATH"
    DEFAULT_BRANCH="main"
fi

# Detect old CONSTRUCT installation
OLD_CONSTRUCT_DETECTED=false
CONSTRUCT_VERSION=""

if [ -f "CLAUDE.md" ]; then
    if [ -L "CLAUDE.md" ]; then
        echo -e "${YELLOW}📋 Detected symlinked CLAUDE.md (old CONSTRUCT)${NC}"
        OLD_CONSTRUCT_DETECTED=true
        CONSTRUCT_VERSION="symlinked"
        # Backup old symlink target
        SYMLINK_TARGET=$(readlink "CLAUDE.md")
        mkdir -p "$CONSTRUCT_ROOT/.construct-workspace/import-history"
        echo "Symlink target: $SYMLINK_TARGET" > "$CONSTRUCT_ROOT/.construct-workspace/import-history/$PROJECT_NAME-$COMPONENT_NAME-symlink-backup.txt"
        rm "CLAUDE.md"  # Remove symlink
    elif [ -f "CLAUDE.md" ]; then
        echo -e "${YELLOW}📋 Detected monolithic CLAUDE.md${NC}"
        OLD_CONSTRUCT_DETECTED=true
        CONSTRUCT_VERSION="monolithic"
        # Backup old CLAUDE.md
        mkdir -p "$CONSTRUCT_ROOT/.construct-workspace/import-history"
        cp "CLAUDE.md" "$CONSTRUCT_ROOT/.construct-workspace/import-history/$PROJECT_NAME-$COMPONENT_NAME-CLAUDE-backup.md"
        rm "CLAUDE.md"  # Remove old file
    fi
fi

# Detect languages
echo -e "${YELLOW}🔎 Detecting component languages...${NC}"
DETECTED_LANGUAGES=""

if find . -name "*.swift" -type f | head -1 | grep -q .; then
    DETECTED_LANGUAGES="swift"
    echo -e "${GREEN}  ✅ Swift detected${NC}"
fi

if find . -name "*.cs" -type f | head -1 | grep -q .; then
    if [ -n "$DETECTED_LANGUAGES" ]; then
        DETECTED_LANGUAGES="$DETECTED_LANGUAGES,csharp"
    else
        DETECTED_LANGUAGES="csharp"
    fi
    echo -e "${GREEN}  ✅ C# detected${NC}"
fi

if find . -name "*.ts" -o -name "*.tsx" -type f | head -1 | grep -q .; then
    if [ -n "$DETECTED_LANGUAGES" ]; then
        DETECTED_LANGUAGES="$DETECTED_LANGUAGES,typescript"
    else
        DETECTED_LANGUAGES="typescript"
    fi
    echo -e "${GREEN}  ✅ TypeScript detected${NC}"
fi

if [ -z "$DETECTED_LANGUAGES" ]; then
    echo -e "${YELLOW}  ⚠️ No recognized languages detected${NC}"
    DETECTED_LANGUAGES="generic"
fi

# Suggest patterns based on detected languages
SUGGESTED_CORE_PLUGINS=""

case "$DETECTED_LANGUAGES" in
    *swift*)
        SUGGESTED_CORE_PLUGINS="languages/swift,tooling/shell-scripting"
        ;;
    *csharp*)
        SUGGESTED_CORE_PLUGINS="languages/csharp,tooling/shell-scripting"
        ;;
    *typescript*)
        SUGGESTED_CORE_PLUGINS="languages/typescript,tooling/shell-scripting"
        ;;
    *)
        SUGGESTED_CORE_PLUGINS="tooling/shell-scripting"
        ;;
esac

# Create component .construct directory and patterns.yaml
echo -e "${YELLOW}🔧 Creating component CONSTRUCT configuration...${NC}"
mkdir -p ".construct"

# Generate component-level patterns.yaml
cat > ".construct/patterns.yaml" << EOF
# .construct/patterns.yaml - Component Level: $PROJECT_NAME/$COMPONENT_NAME
# Component-specific patterns (inherits from project level)

# Languages detected in this component
languages: [$(echo "$DETECTED_LANGUAGES" | sed 's/,/, /g' | sed 's/\([^, ]*\)/"\1"/g')]

# Component-specific pattern plugins
plugins: [$(echo "$SUGGESTED_CORE_PLUGINS" | sed 's/,/, /g' | sed 's/\([^, ]*\)/"\1"/g')]

# Component-specific rules
custom_rules: {}

# Component-specific overrides
overrides: []

# Component metadata
component:
  name: "$COMPONENT_NAME"
  project: "$PROJECT_NAME"
  languages: "$DETECTED_LANGUAGES"
  imported: "$(date)"
  source: "$SOURCE_PATH"
  old_construct: $OLD_CONSTRUCT_DETECTED
  construct_version: "$CONSTRUCT_VERSION"

# Includes project-level patterns automatically
includes:
  - "../.construct/patterns.yaml"  # Project-level shared patterns
EOF

echo -e "${GREEN}✅ Component CONSTRUCT configuration created${NC}"

# Update component's .gitignore
if [ ! -f ".gitignore" ]; then
    echo -e "${YELLOW}📝 Creating .gitignore...${NC}"
    cat > ".gitignore" << 'EOF'
# CONSTRUCT generated files (do not commit)
CLAUDE.md
CLAUDE-temp.md

# OS files
.DS_Store
Thumbs.db
EOF
else
    # Add CONSTRUCT exclusions if not already present
    if ! grep -q "CLAUDE.md" ".gitignore"; then
        echo -e "${YELLOW}📝 Updating .gitignore...${NC}"
        echo "" >> ".gitignore"
        echo "# CONSTRUCT generated files (do not commit)" >> ".gitignore"
        echo "CLAUDE.md" >> ".gitignore"
        echo "CLAUDE-temp.md" >> ".gitignore"
    fi
fi

# Generate initial CLAUDE.md for component
echo -e "${YELLOW}⚙️ Generating component CLAUDE.md...${NC}"
"$CONSTRUCT_CORE/CONSTRUCT/scripts/assemble-claude.sh" "." "$SUGGESTED_CORE_PLUGINS" --languages "$DETECTED_LANGUAGES"

# Update workspace registry
echo -e "${YELLOW}📝 Updating workspace registry...${NC}"

if command -v yq >/dev/null 2>&1; then
    # Check if project exists in registry and convert to multi-repo if needed
    PROJECT_EXISTS=$(yq eval ".projects | has(\"$PROJECT_NAME\")" "$WORKSPACE_REGISTRY" 2>/dev/null)
    
    if [ "$PROJECT_EXISTS" = "true" ]; then
        # Check current project type
        PROJECT_TYPE=$(yq eval ".projects.\"$PROJECT_NAME\".type // \"monorepo\"" "$WORKSPACE_REGISTRY" 2>/dev/null)
        
        if [ "$PROJECT_TYPE" = "monorepo" ]; then
            echo -e "${YELLOW}🔄 Converting project to multi-repo structure...${NC}"
            # Convert existing monorepo entry to multi-repo structure
            EXISTING_PATH=$(yq eval ".projects.\"$PROJECT_NAME\".path" "$WORKSPACE_REGISTRY" 2>/dev/null)
            EXISTING_REPO=$(yq eval ".projects.\"$PROJECT_NAME\".repo" "$WORKSPACE_REGISTRY" 2>/dev/null)
            EXISTING_BRANCH=$(yq eval ".projects.\"$PROJECT_NAME\".branch" "$WORKSPACE_REGISTRY" 2>/dev/null)
            EXISTING_PATTERNS=$(yq eval ".projects.\"$PROJECT_NAME\".patterns" "$WORKSPACE_REGISTRY" 2>/dev/null)
            
            # Update project type and structure
            yq eval -i ".projects.\"$PROJECT_NAME\".type = \"multi-repo\"" "$WORKSPACE_REGISTRY"
            yq eval -i "del(.projects.\"$PROJECT_NAME\".path)" "$WORKSPACE_REGISTRY"
            yq eval -i "del(.projects.\"$PROJECT_NAME\".repo)" "$WORKSPACE_REGISTRY"
            yq eval -i "del(.projects.\"$PROJECT_NAME\".branch)" "$WORKSPACE_REGISTRY"
            yq eval -i "del(.projects.\"$PROJECT_NAME\".patterns)" "$WORKSPACE_REGISTRY"
            
            # Move existing data to main component if it exists
            if [ -d "$PROJECT_DIR" ] && [ "$EXISTING_PATH" != "null" ]; then
                yq eval -i ".projects.\"$PROJECT_NAME\".components.main.path = \"$EXISTING_PATH\"" "$WORKSPACE_REGISTRY"
                yq eval -i ".projects.\"$PROJECT_NAME\".components.main.repo = \"$EXISTING_REPO\"" "$WORKSPACE_REGISTRY"
                yq eval -i ".projects.\"$PROJECT_NAME\".components.main.branch = \"$EXISTING_BRANCH\"" "$WORKSPACE_REGISTRY"
                yq eval -i ".projects.\"$PROJECT_NAME\".components.main.patterns = $EXISTING_PATTERNS" "$WORKSPACE_REGISTRY"
            fi
        fi
        
        # Add new component
        yq eval -i ".projects.\"$PROJECT_NAME\".components.\"$COMPONENT_NAME\".path = \"./Projects/$PROJECT_NAME/$COMPONENT_NAME\"" "$WORKSPACE_REGISTRY"
        yq eval -i ".projects.\"$PROJECT_NAME\".components.\"$COMPONENT_NAME\".repo = \"$REMOTE_URL\"" "$WORKSPACE_REGISTRY"
        yq eval -i ".projects.\"$PROJECT_NAME\".components.\"$COMPONENT_NAME\".branch = \"$CURRENT_BRANCH\"" "$WORKSPACE_REGISTRY"
        yq eval -i ".projects.\"$PROJECT_NAME\".components.\"$COMPONENT_NAME\".default_branch = \"$DEFAULT_BRANCH\"" "$WORKSPACE_REGISTRY"
        yq eval -i ".projects.\"$PROJECT_NAME\".components.\"$COMPONENT_NAME\".patterns = [$(echo "$SUGGESTED_CORE_PLUGINS" | sed 's/,/, /g' | sed 's/\([^, ]*\)/"\1"/g')]" "$WORKSPACE_REGISTRY"
    else
        echo -e "${RED}❌ Error: Project '$PROJECT_NAME' not found in workspace registry${NC}"
        echo -e "${BLUE}Create project first with: import-project.sh${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Error: yq not installed - required for workspace operations${NC}"
    echo -e "${BLUE}Install with: brew install yq${NC}"
    exit 1
fi

# Commit component configuration
echo -e "${YELLOW}📦 Committing component CONSTRUCT configuration...${NC}"
git add ".construct/patterns.yaml"
if [ -f ".gitignore" ]; then
    git add ".gitignore"
fi

# Check if there are changes to commit
if git diff --staged --quiet; then
    echo -e "${BLUE}ℹ️ No changes to commit${NC}"
else
    git commit -m "feat: Add CONSTRUCT component configuration

- Import $COMPONENT_NAME component into $PROJECT_NAME project
- Configure patterns based on detected languages: $DETECTED_LANGUAGES
- Set up component patterns: $SUGGESTED_CORE_PLUGINS
$([ "$OLD_CONSTRUCT_DETECTED" = true ] && echo "- Migrate from old CONSTRUCT version: $CONSTRUCT_VERSION")

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
    echo -e "${GREEN}✅ Component CONSTRUCT configuration committed${NC}"
fi

# Import complete
echo ""
echo -e "${GREEN}🎉 Component import complete!${NC}"
echo ""
echo -e "${BLUE}📁 Component location: Projects/$PROJECT_NAME/$COMPONENT_NAME${NC}"
echo -e "${BLUE}📋 Configuration: .construct/patterns.yaml${NC}"
echo -e "${BLUE}🤖 Generated context: CLAUDE.md${NC}"
echo -e "${BLUE}🔗 Inherits from: Projects/$PROJECT_NAME/.construct/patterns.yaml${NC}"
echo ""
echo -e "${BLUE}📝 Next steps:${NC}"
echo "1. Customize .construct/patterns.yaml for component-specific rules"
echo "2. Update project-level shared patterns in Projects/$PROJECT_NAME/.construct/"
echo "3. Consider extracting unique patterns to LAB plugins"
echo ""
echo -e "${BLUE}💡 Workspace commands:${NC}"
echo "  workspace-status              # View all projects and components"
echo "  workspace-update              # Regenerate all CLAUDE.md files"
echo "  workspace-analyze             # Find pattern opportunities"
echo ""

if [ "$OLD_CONSTRUCT_DETECTED" = true ]; then
    echo -e "${YELLOW}🔄 Migration Notes:${NC}"
    echo "- Old CONSTRUCT files backed up to .construct-workspace/import-history/"
    echo "- Component migrated to new pattern system"
    echo "- Custom rules preserved in patterns.yaml"
    echo ""
fi

echo -e "${GREEN}🚀 Component '$COMPONENT_NAME' is ready for CONSTRUCT-powered development!${NC}"