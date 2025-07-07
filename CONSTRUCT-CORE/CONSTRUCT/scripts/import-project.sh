#!/bin/bash

# Import Project - Imports existing projects into CONSTRUCT workspace
# Handles git independence, pattern detection, and workspace registration

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

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 <source-path> [project-name]"
    echo ""
    echo "Imports an existing project into CONSTRUCT workspace"
    echo ""
    echo "Arguments:"
    echo "  source-path    Path to existing project (local or git URL)"
    echo "  project-name   Name for workspace project (default: auto-detect)"
    echo ""
    echo "Examples:"
    echo "  $0 ../MyProject                    # Import local project"
    echo "  $0 https://github.com/user/repo   # Clone and import"
    echo "  $0 ../MyProject CustomName        # Import with custom name"
    echo ""
    echo "The project will be imported as Project-{name}/ and maintain"
    echo "its own git repository while being managed by CONSTRUCT."
    exit 0
fi

# Validate arguments
if [ -z "$SOURCE_PATH" ]; then
    echo -e "${RED}❌ Error: Source path required${NC}"
    echo -e "${BLUE}Usage: $0 <source-path> [project-name]${NC}"
    exit 1
fi

# Determine if source is URL or local path
if [[ "$SOURCE_PATH" =~ ^https?:// ]] || [[ "$SOURCE_PATH" =~ ^git@ ]]; then
    IS_REMOTE=true
    # Extract project name from URL if not provided
    if [ -z "$PROJECT_NAME" ]; then
        PROJECT_NAME=$(basename "$SOURCE_PATH" .git)
    fi
else
    IS_REMOTE=false
    # Use directory name if project name not provided
    if [ -z "$PROJECT_NAME" ]; then
        PROJECT_NAME=$(basename "$(cd "$SOURCE_PATH" && pwd)")
    fi
fi

# Sanitize project name for workspace
PROJECT_NAME=$(echo "$PROJECT_NAME" | sed 's/[^a-zA-Z0-9-]/-/g')
WORKSPACE_PROJECT_DIR="$CONSTRUCT_ROOT/Project-$PROJECT_NAME"

echo -e "${BLUE}🚀 CONSTRUCT Project Import${NC}"
echo -e "${BLUE}Source: $SOURCE_PATH${NC}"
echo -e "${BLUE}Workspace Project: Project-$PROJECT_NAME${NC}"
echo ""

# Check if workspace project already exists
if [ -d "$WORKSPACE_PROJECT_DIR" ]; then
    echo -e "${RED}❌ Error: Project-$PROJECT_NAME already exists in workspace${NC}"
    echo -e "${BLUE}Choose a different name or remove existing project${NC}"
    exit 1
fi

# Import the project
if [ "$IS_REMOTE" = true ]; then
    echo -e "${YELLOW}📥 Cloning remote project...${NC}"
    git clone "$SOURCE_PATH" "$WORKSPACE_PROJECT_DIR"
else
    # Validate local path exists
    if [ ! -d "$SOURCE_PATH" ]; then
        echo -e "${RED}❌ Error: Source directory not found: $SOURCE_PATH${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}📁 Copying local project...${NC}"
    cp -r "$SOURCE_PATH" "$WORKSPACE_PROJECT_DIR"
fi

echo -e "${GREEN}✅ Project imported to workspace${NC}"

# Analyze project for patterns
echo -e "${YELLOW}🔍 Analyzing project structure...${NC}"

cd "$WORKSPACE_PROJECT_DIR"

# Get current git info
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
        echo "Symlink target: $SYMLINK_TARGET" > "$CONSTRUCT_ROOT/.construct-workspace/import-history/$PROJECT_NAME-symlink-backup.txt"
        rm "CLAUDE.md"  # Remove symlink
    elif [ -f "CLAUDE.md" ]; then
        echo -e "${YELLOW}📋 Detected monolithic CLAUDE.md${NC}"
        OLD_CONSTRUCT_DETECTED=true
        CONSTRUCT_VERSION="monolithic"
        # Backup old CLAUDE.md
        cp "CLAUDE.md" "$CONSTRUCT_ROOT/.construct-workspace/import-history/$PROJECT_NAME-CLAUDE-backup.md"
        rm "CLAUDE.md"  # Remove old file
    fi
fi

if [ -f "VERSION" ] && grep -q "CONSTRUCT" "VERSION" 2>/dev/null; then
    CONSTRUCT_VERSION=$(cat "VERSION")
    echo -e "${YELLOW}📋 Detected CONSTRUCT version: $CONSTRUCT_VERSION${NC}"
    OLD_CONSTRUCT_DETECTED=true
fi

# Detect languages
echo -e "${YELLOW}🔎 Detecting project languages...${NC}"
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

# Suggest patterns based on detected languages and old CONSTRUCT
SUGGESTED_CORE_PLUGINS=""
SUGGESTED_LAB_PLUGINS=""

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

# Add cross-platform if multiple languages
if [[ "$DETECTED_LANGUAGES" =~ "," ]]; then
    SUGGESTED_CORE_PLUGINS="$SUGGESTED_CORE_PLUGINS,cross-platform/model-sync"
fi

# Create .construct directory and patterns.yaml
echo -e "${YELLOW}🔧 Creating CONSTRUCT configuration...${NC}"
mkdir -p ".construct"

# Generate patterns.yaml
cat > ".construct/patterns.yaml" << EOF
# .construct/patterns.yaml
# Project: $PROJECT_NAME
# Imported: $(date)
# Source: $SOURCE_PATH

# Languages detected in this project
languages: [$(echo "$DETECTED_LANGUAGES" | sed 's/,/, /g' | sed 's/\([^, ]*\)/"\1"/g')]

# Active pattern plugins
plugins: [$(echo "$SUGGESTED_CORE_PLUGINS" | sed 's/,/, /g' | sed 's/\([^, ]*\)/"\1"/g')]

# Project-specific rules (add your custom rules here)
custom_rules: {}

# Pattern overrides (exceptions to base patterns)
overrides: []

# Include external pattern files (optional)
includes: []

# Import metadata
import:
  source: "$SOURCE_PATH"
  date: "$(date)"
  old_construct: $OLD_CONSTRUCT_DETECTED
  construct_version: "$CONSTRUCT_VERSION"
  detected_languages: "$DETECTED_LANGUAGES"
EOF

echo -e "${GREEN}✅ CONSTRUCT configuration created${NC}"

# Update project's .gitignore to exclude generated files
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

# Generate initial CLAUDE.md
echo -e "${YELLOW}⚙️ Generating CLAUDE.md from patterns...${NC}"
"$CONSTRUCT_CORE/CONSTRUCT/scripts/assemble-claude.sh" "." "$SUGGESTED_CORE_PLUGINS" --languages "$DETECTED_LANGUAGES"

# Register project in workspace
echo -e "${YELLOW}📝 Registering project in workspace...${NC}"

# Update workspace registry using yq if available, otherwise use sed
if command -v yq >/dev/null 2>&1; then
    # Use yq for clean YAML manipulation
    yq eval -i ".projects.\"Project-$PROJECT_NAME\".path = \"./Project-$PROJECT_NAME\"" "$WORKSPACE_REGISTRY"
    yq eval -i ".projects.\"Project-$PROJECT_NAME\".repo = \"$REMOTE_URL\"" "$WORKSPACE_REGISTRY"
    yq eval -i ".projects.\"Project-$PROJECT_NAME\".branch = \"$CURRENT_BRANCH\"" "$WORKSPACE_REGISTRY"
    yq eval -i ".projects.\"Project-$PROJECT_NAME\".default_branch = \"$DEFAULT_BRANCH\"" "$WORKSPACE_REGISTRY"
    yq eval -i ".projects.\"Project-$PROJECT_NAME\".patterns = [$(echo "$SUGGESTED_CORE_PLUGINS" | sed 's/,/, /g' | sed 's/\([^, ]*\)/"\1"/g')]" "$WORKSPACE_REGISTRY"
    yq eval -i ".workspace.total_projects = (.workspace.total_projects // 0) + 1" "$WORKSPACE_REGISTRY"
else
    # Fallback to manual registry entry
    echo "  Project-$PROJECT_NAME:" >> "$WORKSPACE_REGISTRY"
    echo "    path: ./Project-$PROJECT_NAME" >> "$WORKSPACE_REGISTRY"
    echo "    repo: $REMOTE_URL" >> "$WORKSPACE_REGISTRY"
    echo "    branch: $CURRENT_BRANCH" >> "$WORKSPACE_REGISTRY"
    echo "    default_branch: $DEFAULT_BRANCH" >> "$WORKSPACE_REGISTRY"
    echo "    patterns: [$(echo "$SUGGESTED_CORE_PLUGINS" | sed 's/,/, /g' | sed 's/\([^, ]*\)/"\1"/g')]" >> "$WORKSPACE_REGISTRY"
fi

# Commit CONSTRUCT configuration to project's git
echo -e "${YELLOW}📦 Committing CONSTRUCT configuration...${NC}"
git add ".construct/patterns.yaml"
if [ -f ".gitignore" ]; then
    git add ".gitignore"
fi

# Check if there are changes to commit
if git diff --staged --quiet; then
    echo -e "${BLUE}ℹ️ No changes to commit${NC}"
else
    git commit -m "feat: Add CONSTRUCT pattern configuration

- Import project into CONSTRUCT workspace
- Configure patterns based on detected languages: $DETECTED_LANGUAGES
- Set up pattern plugins: $SUGGESTED_CORE_PLUGINS
$([ "$OLD_CONSTRUCT_DETECTED" = true ] && echo "- Migrate from old CONSTRUCT version: $CONSTRUCT_VERSION")

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
    echo -e "${GREEN}✅ CONSTRUCT configuration committed${NC}"
fi

# Import complete
echo ""
echo -e "${GREEN}🎉 Project import complete!${NC}"
echo ""
echo -e "${BLUE}📁 Project location: $WORKSPACE_PROJECT_DIR${NC}"
echo -e "${BLUE}📋 Configuration: .construct/patterns.yaml${NC}"
echo -e "${BLUE}🤖 Generated context: CLAUDE.md${NC}"
echo ""
echo -e "${BLUE}📝 Next steps:${NC}"
echo "1. Customize .construct/patterns.yaml for project-specific rules"
echo "2. Consider extracting unique patterns to LAB plugins"
echo "3. Use workspace commands to manage multiple projects"
echo ""
echo -e "${BLUE}💡 Workspace commands:${NC}"
echo "  construct-workspace status    # View all projects"
echo "  construct-workspace update    # Regenerate all CLAUDE.md files"
echo "  construct-workspace analyze   # Find pattern opportunities"
echo ""

if [ "$OLD_CONSTRUCT_DETECTED" = true ]; then
    echo -e "${YELLOW}🔄 Migration Notes:${NC}"
    echo "- Old CONSTRUCT files backed up to .construct-workspace/import-history/"
    echo "- Project migrated to new pattern system"
    echo "- Custom rules preserved in patterns.yaml"
    echo ""
fi

echo -e "${GREEN}🚀 Project '$PROJECT_NAME' is ready for CONSTRUCT-powered development!${NC}"