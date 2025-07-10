#!/bin/bash

# Workspace Status - Shows status of all projects in CONSTRUCT workspace
# Displays registry information, git status, and pattern configurations

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
WORKSPACE_REGISTRY="$CONSTRUCT_ROOT/.construct-workspace/registry.yaml"

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 [options]"
    echo ""
    echo "Shows status of all projects in CONSTRUCT workspace"
    echo ""
    echo "Options:"
    echo "  --help, -h     Show this help"
    echo "  --detailed     Show detailed git status for each project"
    echo "  --patterns     Show pattern plugin usage across projects"
    echo ""
    echo "Examples:"
    echo "  $0                    # Show basic workspace status"
    echo "  $0 --detailed         # Include git details for each project"
    echo "  $0 --patterns         # Show pattern usage analysis"
    exit 0
fi

# Check if workspace exists
if [ ! -f "$WORKSPACE_REGISTRY" ]; then
    echo -e "${RED}❌ No workspace found${NC}"
    echo -e "${BLUE}Run 'import-project.sh' to create your first project${NC}"
    exit 1
fi

DETAILED=false
SHOW_PATTERNS=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --detailed)
            DETAILED=true
            shift
            ;;
        --patterns)
            SHOW_PATTERNS=true
            shift
            ;;
        *)
            echo -e "${RED}❌ Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}🚀 CONSTRUCT Workspace Status${NC}"
echo ""

# Parse workspace registry
if command -v yq >/dev/null 2>&1; then
    # Use yq for proper YAML parsing
    WORKSPACE_VERSION=$(yq eval '.construct.version' "$WORKSPACE_REGISTRY" 2>/dev/null || echo "unknown")
    WORKSPACE_BRANCH=$(yq eval '.construct.branch' "$WORKSPACE_REGISTRY" 2>/dev/null || echo "unknown")
    TOTAL_PROJECTS=$(yq eval '.workspace.total_projects' "$WORKSPACE_REGISTRY" 2>/dev/null || echo "0")
    
    echo -e "${PURPLE}📋 Workspace Info${NC}"
    echo -e "${CYAN}   CONSTRUCT Version: $WORKSPACE_VERSION${NC}"
    echo -e "${CYAN}   Current Branch: $WORKSPACE_BRANCH${NC}"
    echo -e "${CYAN}   Total Projects: $TOTAL_PROJECTS${NC}"
    echo ""
    
    # Get project list
    PROJECT_KEYS=$(yq eval '.projects | keys | .[]' "$WORKSPACE_REGISTRY" 2>/dev/null || echo "")
    
    if [ -z "$PROJECT_KEYS" ]; then
        echo -e "${YELLOW}📂 No projects found in workspace${NC}"
        echo -e "${BLUE}Use 'import-project.sh <path>' to add your first project${NC}"
        exit 0
    fi
    
    echo -e "${PURPLE}📁 Projects (${TOTAL_PROJECTS})${NC}"
    echo ""
    
    # Process each project
    while IFS= read -r project_name; do
        if [ -n "$project_name" ]; then
            PROJECT_PATH=$(yq eval ".projects.\"$project_name\".path" "$WORKSPACE_REGISTRY" 2>/dev/null || echo "")
            PROJECT_REPO=$(yq eval ".projects.\"$project_name\".repo" "$WORKSPACE_REGISTRY" 2>/dev/null || echo "")
            PROJECT_BRANCH=$(yq eval ".projects.\"$project_name\".branch" "$WORKSPACE_REGISTRY" 2>/dev/null || echo "")
            PROJECT_PATTERNS=$(yq eval ".projects.\"$project_name\".patterns[]" "$WORKSPACE_REGISTRY" 2>/dev/null || echo "")
            
            FULL_PROJECT_PATH="$CONSTRUCT_ROOT/$PROJECT_PATH"
            
            echo -e "${GREEN}🎯 $project_name${NC}"
            echo -e "${CYAN}   Path: $PROJECT_PATH${NC}"
            echo -e "${CYAN}   Repo: $PROJECT_REPO${NC}"
            echo -e "${CYAN}   Branch: $PROJECT_BRANCH${NC}"
            
            # Check if project directory exists
            if [ -d "$FULL_PROJECT_PATH" ]; then
                cd "$FULL_PROJECT_PATH"
                
                # Basic git status
                if [ -d ".git" ]; then
                    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
                    UNCOMMITTED_CHANGES=$(git status --porcelain 2>/dev/null | wc -l | xargs)
                    UNPUSHED_COMMITS=$(git log @{u}..HEAD --oneline 2>/dev/null | wc -l | xargs || echo "0")
                    
                    if [ "$CURRENT_BRANCH" != "$PROJECT_BRANCH" ]; then
                        echo -e "${YELLOW}   ⚠️ Branch mismatch: on $CURRENT_BRANCH, expected $PROJECT_BRANCH${NC}"
                    fi
                    
                    if [ "$UNCOMMITTED_CHANGES" -gt 0 ]; then
                        echo -e "${YELLOW}   📝 $UNCOMMITTED_CHANGES uncommitted changes${NC}"
                    fi
                    
                    if [ "$UNPUSHED_COMMITS" -gt 0 ]; then
                        echo -e "${YELLOW}   📤 $UNPUSHED_COMMITS unpushed commits${NC}"
                    fi
                    
                    if [ "$UNCOMMITTED_CHANGES" -eq 0 ] && [ "$UNPUSHED_COMMITS" -eq 0 ] && [ "$CURRENT_BRANCH" == "$PROJECT_BRANCH" ]; then
                        echo -e "${GREEN}   ✅ Git status clean${NC}"
                    fi
                    
                    # Detailed git status if requested
                    if [ "$DETAILED" = true ] && [ "$UNCOMMITTED_CHANGES" -gt 0 ]; then
                        echo -e "${BLUE}   📋 Git Status:${NC}"
                        git status --short 2>/dev/null | sed 's/^/      /'
                    fi
                else
                    echo -e "${RED}   ❌ No git repository${NC}"
                fi
                
                # Check CLAUDE.md status
                if [ -f "CLAUDE.md" ]; then
                    CLAUDE_AGE=$(find "CLAUDE.md" -mtime +1 2>/dev/null && echo "old" || echo "recent")
                    if [ "$CLAUDE_AGE" = "old" ]; then
                        echo -e "${YELLOW}   🤖 CLAUDE.md needs regeneration (>1 day old)${NC}"
                    else
                        echo -e "${GREEN}   🤖 CLAUDE.md up to date${NC}"
                    fi
                else
                    echo -e "${RED}   ❌ Missing CLAUDE.md${NC}"
                fi
                
                # Show active patterns
                if [ -n "$PROJECT_PATTERNS" ]; then
                    echo -e "${BLUE}   🧩 Patterns:${NC}"
                    while IFS= read -r pattern; do
                        if [ -n "$pattern" ]; then
                            echo -e "${CYAN}      • $pattern${NC}"
                        fi
                    done <<< "$PROJECT_PATTERNS"
                else
                    echo -e "${YELLOW}   ⚠️ No patterns configured${NC}"
                fi
                
            else
                echo -e "${RED}   ❌ Project directory not found: $FULL_PROJECT_PATH${NC}"
            fi
            
            echo ""
        fi
    done <<< "$PROJECT_KEYS"
    
    # Pattern analysis if requested
    if [ "$SHOW_PATTERNS" = true ]; then
        echo -e "${PURPLE}🧩 Pattern Usage Analysis${NC}"
        echo ""
        
        # Count pattern usage
        declare -A pattern_count
        while IFS= read -r project_name; do
            if [ -n "$project_name" ]; then
                PROJECT_PATTERNS=$(yq eval ".projects.\"$project_name\".patterns[]" "$WORKSPACE_REGISTRY" 2>/dev/null || echo "")
                while IFS= read -r pattern; do
                    if [ -n "$pattern" ]; then
                        pattern_count["$pattern"]=$((${pattern_count["$pattern"]} + 1))
                    fi
                done <<< "$PROJECT_PATTERNS"
            fi
        done <<< "$PROJECT_KEYS"
        
        # Display pattern usage
        for pattern in "${!pattern_count[@]}"; do
            count=${pattern_count[$pattern]}
            echo -e "${CYAN}$pattern${NC}: ${GREEN}$count project(s)${NC}"
        done
        
        echo ""
    fi
    
else
    # Fallback for systems without yq
    echo -e "${YELLOW}⚠️ yq not installed, showing basic registry info${NC}"
    echo ""
    echo -e "${PURPLE}📋 Registry Contents:${NC}"
    cat "$WORKSPACE_REGISTRY"
fi

# Workspace health summary
echo -e "${PURPLE}📊 Workspace Health${NC}"
cd "$CONSTRUCT_ROOT"

# Check for orphaned project directories
ORPHANED_DIRS=()
if [ -d "$CONSTRUCT_ROOT/Projects" ]; then
    for dir in "$CONSTRUCT_ROOT/Projects"/*/; do
        if [ -d "$dir" ]; then
            dir_name=$(basename "$dir")
            if command -v yq >/dev/null 2>&1; then
                if ! yq eval ".projects | has(\"$dir_name\")" "$WORKSPACE_REGISTRY" 2>/dev/null | grep -q "true"; then
                    ORPHANED_DIRS+=("$dir_name")
                fi
            fi
        fi
    done
fi

if [ ${#ORPHANED_DIRS[@]} -gt 0 ]; then
    echo -e "${YELLOW}⚠️ Orphaned directories found:${NC}"
    for dir in "${ORPHANED_DIRS[@]}"; do
        echo -e "${CYAN}   • $dir${NC}"
    done
    echo -e "${BLUE}   Consider removing or importing these directories${NC}"
else
    echo -e "${GREEN}✅ No orphaned directories${NC}"
fi

# Check workspace integrity
if [ -d ".construct-workspace" ]; then
    echo -e "${GREEN}✅ Workspace directory exists${NC}"
else
    echo -e "${RED}❌ Missing .construct-workspace directory${NC}"
fi

echo ""
echo -e "${BLUE}💡 Workspace Commands:${NC}"
echo "  workspace-status --detailed    # Show detailed project status"
echo "  workspace-status --patterns    # Show pattern usage analysis"
echo "  workspace-update               # Regenerate all CLAUDE.md files"
echo "  workspace-analyze              # Find pattern opportunities"
echo "  import-project.sh <path>       # Import new project"
echo ""