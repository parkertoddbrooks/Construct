#!/bin/bash

# Workspace Update - Regenerates CLAUDE.md for all projects in workspace
# Useful after updating patterns or adding new plugins

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSTRUCT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
CONSTRUCT_CORE="$CONSTRUCT_ROOT/CONSTRUCT-CORE"
WORKSPACE_REGISTRY="$CONSTRUCT_ROOT/.construct-workspace/registry.yaml"

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 [options] [project-name]"
    echo ""
    echo "Regenerates CLAUDE.md files for workspace projects"
    echo ""
    echo "Arguments:"
    echo "  project-name   Update specific project only (optional)"
    echo ""
    echo "Options:"
    echo "  --help, -h     Show this help"
    echo "  --force        Regenerate even if CLAUDE.md is recent"
    echo "  --dry-run      Show what would be updated without changes"
    echo ""
    echo "Examples:"
    echo "  $0                    # Update all projects"
    echo "  $0 Project-MyApp      # Update specific project"
    echo "  $0 --force            # Force update all projects"
    echo "  $0 --dry-run          # Preview updates"
    exit 0
fi

# Check if workspace exists
if [ ! -f "$WORKSPACE_REGISTRY" ]; then
    echo -e "${RED}❌ No workspace found${NC}"
    echo -e "${BLUE}Run 'import-project.sh' to create your first project${NC}"
    exit 1
fi

FORCE_UPDATE=false
DRY_RUN=false
TARGET_PROJECT=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --force)
            FORCE_UPDATE=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        Project-*)
            TARGET_PROJECT="$1"
            shift
            ;;
        *)
            echo -e "${RED}❌ Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}🔄 CONSTRUCT Workspace Update${NC}"
echo ""

# Check if yq is available
if ! command -v yq >/dev/null 2>&1; then
    echo -e "${RED}❌ yq not installed - required for workspace operations${NC}"
    echo -e "${BLUE}Install with: brew install yq${NC}"
    exit 1
fi

# Get project list
if [ -n "$TARGET_PROJECT" ]; then
    # Check if specific project exists
    if ! yq eval ".projects | has(\"$TARGET_PROJECT\")" "$WORKSPACE_REGISTRY" 2>/dev/null | grep -q "true"; then
        echo -e "${RED}❌ Project not found: $TARGET_PROJECT${NC}"
        echo -e "${BLUE}Available projects:${NC}"
        yq eval '.projects | keys | .[]' "$WORKSPACE_REGISTRY" 2>/dev/null | sed 's/^/  • /'
        exit 1
    fi
    PROJECT_KEYS="$TARGET_PROJECT"
else
    PROJECT_KEYS=$(yq eval '.projects | keys | .[]' "$WORKSPACE_REGISTRY" 2>/dev/null || echo "")
fi

if [ -z "$PROJECT_KEYS" ]; then
    echo -e "${YELLOW}📂 No projects found in workspace${NC}"
    exit 0
fi

PROJECTS_PROCESSED=0
PROJECTS_UPDATED=0
PROJECTS_SKIPPED=0
PROJECTS_FAILED=0

# Process each project
while IFS= read -r project_name; do
    if [ -n "$project_name" ]; then
        PROJECT_PATH=$(yq eval ".projects.\"$project_name\".path" "$WORKSPACE_REGISTRY" 2>/dev/null || echo "")
        PROJECT_PATTERNS=$(yq eval ".projects.\"$project_name\".patterns[]" "$WORKSPACE_REGISTRY" 2>/dev/null || echo "")
        
        FULL_PROJECT_PATH="$CONSTRUCT_ROOT/$PROJECT_PATH"
        
        echo -e "${GREEN}🎯 Processing: $project_name${NC}"
        
        # Check if project directory exists
        if [ ! -d "$FULL_PROJECT_PATH" ]; then
            echo -e "${RED}   ❌ Project directory not found: $FULL_PROJECT_PATH${NC}"
            PROJECTS_FAILED=$((PROJECTS_FAILED + 1))
            continue
        fi
        
        cd "$FULL_PROJECT_PATH"
        
        # Check if update is needed (unless forced)
        NEEDS_UPDATE=true
        if [ "$FORCE_UPDATE" = false ] && [ -f "CLAUDE.md" ]; then
            # Check if CLAUDE.md is recent (less than 6 hours old)
            if find "CLAUDE.md" -mtime -0.25 -print -quit | grep -q .; then
                echo -e "${CYAN}   ℹ️ CLAUDE.md is recent, skipping (use --force to update)${NC}"
                NEEDS_UPDATE=false
                PROJECTS_SKIPPED=$((PROJECTS_SKIPPED + 1))
            fi
        fi
        
        if [ "$NEEDS_UPDATE" = true ]; then
            # Convert patterns array to comma-separated string
            PLUGINS_STRING=""
            while IFS= read -r pattern; do
                if [ -n "$pattern" ]; then
                    if [ -z "$PLUGINS_STRING" ]; then
                        PLUGINS_STRING="$pattern"
                    else
                        PLUGINS_STRING="$PLUGINS_STRING,$pattern"
                    fi
                fi
            done <<< "$PROJECT_PATTERNS"
            
            if [ "$DRY_RUN" = true ]; then
                echo -e "${YELLOW}   🔍 Would update with plugins: $PLUGINS_STRING${NC}"
            else
                echo -e "${YELLOW}   🔄 Updating CLAUDE.md with plugins: $PLUGINS_STRING${NC}"
                
                # Get detected languages from patterns.yaml if it exists
                LANGUAGES=""
                if [ -f ".construct/patterns.yaml" ]; then
                    LANGUAGES=$(yq eval '.languages[]' ".construct/patterns.yaml" 2>/dev/null | tr '\n' ',' | sed 's/,$//' || echo "")
                fi
                
                # Run assemble-claude.sh
                if [ -n "$LANGUAGES" ]; then
                    "$CONSTRUCT_CORE/CONSTRUCT/scripts/assemble-claude.sh" "." "$PLUGINS_STRING" --languages "$LANGUAGES"
                else
                    "$CONSTRUCT_CORE/CONSTRUCT/scripts/assemble-claude.sh" "." "$PLUGINS_STRING"
                fi
                
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}   ✅ CLAUDE.md updated successfully${NC}"
                    PROJECTS_UPDATED=$((PROJECTS_UPDATED + 1))
                else
                    echo -e "${RED}   ❌ Failed to update CLAUDE.md${NC}"
                    PROJECTS_FAILED=$((PROJECTS_FAILED + 1))
                fi
            fi
        fi
        
        PROJECTS_PROCESSED=$((PROJECTS_PROCESSED + 1))
        echo ""
    fi
done <<< "$PROJECT_KEYS"

# Summary
echo -e "${PURPLE}📊 Update Summary${NC}"
echo -e "${CYAN}   Projects processed: $PROJECTS_PROCESSED${NC}"

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}   Would update: $PROJECTS_UPDATED${NC}"
    echo -e "${CYAN}   Would skip: $PROJECTS_SKIPPED${NC}"
    if [ $PROJECTS_FAILED -gt 0 ]; then
        echo -e "${RED}   Errors found: $PROJECTS_FAILED${NC}"
    fi
else
    echo -e "${GREEN}   Updated: $PROJECTS_UPDATED${NC}"
    echo -e "${YELLOW}   Skipped: $PROJECTS_SKIPPED${NC}"
    if [ $PROJECTS_FAILED -gt 0 ]; then
        echo -e "${RED}   Failed: $PROJECTS_FAILED${NC}"
    fi
fi

# Recommendations
echo ""
echo -e "${BLUE}💡 Next Steps:${NC}"
if [ $PROJECTS_UPDATED -gt 0 ] && [ "$DRY_RUN" = false ]; then
    echo "  • Review updated CLAUDE.md files in your projects"
    echo "  • Test pattern behavior with updated context"
fi

if [ $PROJECTS_SKIPPED -gt 0 ]; then
    echo "  • Use --force to update recently modified files"
fi

if [ $PROJECTS_FAILED -gt 0 ]; then
    echo "  • Check failed projects and fix any issues"
    echo "  • Run workspace-status for detailed project health"
fi

echo "  • Run workspace-status to see current workspace state"
echo ""