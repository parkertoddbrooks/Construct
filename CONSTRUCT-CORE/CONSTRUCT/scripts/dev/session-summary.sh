#!/bin/bash

# CONSTRUCT Development Session Summary Generator
# Creates a summary of the current CONSTRUCT development session for context preservation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Source library functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSTRUCT_CORE="$(cd "$SCRIPT_DIR/../../.." && pwd)"
source "$CONSTRUCT_CORE/CONSTRUCT/lib/common-patterns.sh"

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 [PROJECT_DIR]"
    echo ""
    echo "Generate a development session summary for CONSTRUCT projects"
    echo ""
    echo "Arguments:"
    echo "  PROJECT_DIR   Directory to analyze (default: current directory)"
    echo ""
    echo "This script creates a session summary including:"
    echo "  - Git status and recent commits"
    echo "  - Active patterns and languages"
    echo "  - Recent work and changes"
    echo "  - Next steps for continuation"
    echo ""
    echo "The summary is saved to AI/dev-logs/session-states/"
    exit 0
fi

# Accept PROJECT_DIR as parameter, default to CONSTRUCT-LAB
PROJECT_DIR="${1:-.}"
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

# Determine if this is a project or CONSTRUCT development
if [ -f "$PROJECT_DIR/.construct/patterns.yaml" ]; then
    # This is a project
    SESSION_DIR="$PROJECT_DIR/AI/dev-logs/session-states/automated"
    IS_PROJECT=true
else
    # This is CONSTRUCT development
    CONSTRUCT_ROOT=$(get_construct_root)
    CONSTRUCT_DEV=$(get_construct_dev)
    SESSION_DIR="$CONSTRUCT_DEV/AI/dev-logs/session-states/automated"
    PROJECT_DIR="$CONSTRUCT_ROOT"
    IS_PROJECT=false
fi

TIMESTAMP=$(date +"%Y-%m-%d-%H%M")
TODAY=$(date +"%Y-%m-%d")

echo -e "${BLUE}📝 Generating CONSTRUCT development session summary...${NC}"

# Create session directory if it doesn't exist
mkdir -p "$SESSION_DIR"

# Determine session start
LAST_SUMMARY=$(ls -1 "$SESSION_DIR"/*-construct-session.md 2>/dev/null | tail -1)
if [ -f "$LAST_SUMMARY" ]; then
    SESSION_START=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$LAST_SUMMARY" 2>/dev/null || date -v-2H "+%Y-%m-%d %H:%M:%S")
else
    SESSION_START=$(cd "$PROJECT_DIR" && git log --format="%ai" --since="$TODAY 00:00:00" --reverse | head -1 | cut -d' ' -f1-2)
fi

# If no commits today, use current time minus 2 hours
if [ -z "$SESSION_START" ]; then
    SESSION_START=$(date -v-2H "+%Y-%m-%d %H:%M:%S")
fi

# Get repository info
eval $(get_repo_info "$PROJECT_DIR")

# Get current development state
CURRENT_BRANCH=$(cd "$PROJECT_DIR" && git branch --show-current 2>/dev/null || echo "unknown")
LAST_COMMIT=$(cd "$PROJECT_DIR" && git log -1 --pretty=format:"%s" 2>/dev/null || echo "No commits")
UNCOMMITTED_FILES=$(cd "$PROJECT_DIR" && git status --porcelain 2>/dev/null | wc -l || echo "0")

# Count components based on project type
if [ "$IS_PROJECT" = true ]; then
    # For projects, count project files
    SCRIPT_COUNT=$(find "$PROJECT_DIR" -name "*.sh" -type f 2>/dev/null | wc -l || echo "0")
    LIB_FUNCTIONS=$(find "$PROJECT_DIR" -name "*.swift" -o -name "*.ts" -o -name "*.cs" -type f 2>/dev/null | wc -l || echo "0")
    CONFIG_FILES=$(find "$PROJECT_DIR/.construct" -name "*.yaml" -type f 2>/dev/null | wc -l || echo "0")
else
    # For CONSTRUCT development
    SCRIPT_COUNT=$(find "$CONSTRUCT_DEV" -name "*.sh" -type f 2>/dev/null | wc -l || echo "0")
    LIB_FUNCTIONS=$(find "$CONSTRUCT_DEV/CONSTRUCT/lib" -name "*.sh" -type f 2>/dev/null | wc -l || echo "0")
    CONFIG_FILES=$(find "$CONSTRUCT_DEV/CONSTRUCT/config" -name "*.yaml" -type f 2>/dev/null | wc -l || echo "0")
fi

# Generate summary file
cat > "$SESSION_DIR/$TIMESTAMP-construct-session.md" << EOF
# CONSTRUCT Development Session Summary: $(date +"%Y-%m-%d %H:%M")
**Duration**: Since $SESSION_START
**Repo**: $REPO_NAME
**Remote**: $REMOTE_URL
**Branch**: $CURRENT_BRANCH
**Context Usage**: ~90% (summary triggered)

## 🎯 Quick Start for Next Session
\`\`\`bash
# Run these commands when starting fresh:
cd CONSTRUCT-LAB/
./CONSTRUCT/scripts/update-context.sh       # Updates CONSTRUCT development context
./CONSTRUCT/scripts/check-architecture.sh   # Validates CONSTRUCT patterns
./CONSTRUCT/scripts/before_coding.sh func   # Search before coding
\`\`\`

## 📍 Where We Left Off

### Current Task/Feature
Working on: $LAST_COMMIT

### Recent Development (Last 10 commits)
$(cd "$CONSTRUCT_ROOT" && git log -10 --pretty=format:"- %s (%cr)" 2>/dev/null | head -10)

### Active Files (Recently Modified)
$(cd "$CONSTRUCT_ROOT" && git status --porcelain 2>/dev/null | grep -E "^( M|M |MM)" | sed 's/^.../- /' | head -10)

### Project Status
- **Project Type**: $PROJECT_TYPE
- **Active Patterns**: $PATTERNS
- **Shell Scripts**: $SCRIPT_COUNT
$([ $SWIFT_COUNT -gt 0 ] && echo "- **Swift Files**: $SWIFT_COUNT")
$([ $JS_COUNT -gt 0 ] && echo "- **JavaScript/TypeScript Files**: $JS_COUNT")
$([ $PY_COUNT -gt 0 ] && echo "- **Python Files**: $PY_COUNT")
- **Uncommitted Changes**: $UNCOMMITTED_FILES

## 🔧 Development Context

### Active Development Areas
$(cd "$PROJECT_DIR" && find . -name "*.sh" -newer "$SESSION_DIR/../.." 2>/dev/null | head -5 | sed 's|^./|- |' || echo "- No recent script changes")

### Key Project Components
$(if [ -f "$PROJECT_DIR/CLAUDE.md" ]; then echo "- **CLAUDE.md**: ✅ Found"; else echo "- **CLAUDE.md**: ❌ Missing"; fi)
$(if [ -f "$PROJECT_DIR/README.md" ]; then echo "- **README.md**: ✅ Found"; else echo "- **README.md**: ❌ Missing"; fi)
$(if [ -d "$PROJECT_DIR/.construct" ]; then echo "- **.construct/**: ✅ CONSTRUCT patterns configured"; else echo "- **.construct/**: ❌ Not a CONSTRUCT project"; fi)
$(if [ -d "$PROJECT_DIR/AI" ]; then echo "- **AI/**: ✅ AI documentation structure"; else echo "- **AI/**: ❌ AI documentation missing"; fi)

## 🚀 Next Development Session

### Detected Next Steps
$(if [[ "$PROJECT_DIR" == *"CONSTRUCT"* ]]; then
    echo "1. Continue CONSTRUCT system development"
    echo "2. Enhance pattern-based architecture"
    echo "3. Improve project-aware scripts"
    echo "4. Test multi-project support"
else
    if [ $SWIFT_COUNT -gt 0 ]; then
        echo "1. Continue iOS/Swift development"
        echo "2. Review MVVM architecture compliance"
        echo "3. Update UI components"
        echo "4. Test on devices"
    elif [ $JS_COUNT -gt 0 ]; then
        echo "1. Continue web development"
        echo "2. Review component architecture"
        echo "3. Update dependencies"
        echo "4. Run tests"
    else
        echo "1. Continue project development"
        echo "2. Review architecture"
        echo "3. Update documentation"
        echo "4. Run quality checks"
    fi
fi)

### Development Workflow Commands
\`\`\`bash
# Navigate to project
cd $PROJECT_DIR

# Update context and validate
$(if [ -f "$PROJECT_DIR/CONSTRUCT/scripts/construct/update-context.sh" ]; then
    echo "./CONSTRUCT/scripts/construct/update-context.sh .    # Update context"
    echo "./CONSTRUCT/scripts/core/check-architecture.sh .   # Validate architecture"
    echo "./CONSTRUCT/scripts/core/before_coding.sh search   # Search before creating"
else
    echo "# Review project documentation"
    echo "# Update CLAUDE.md or README.md"
    echo "# Run project-specific commands"
fi)
\`\`\`

### Key Files for Next Session
- **Project Context**: $([ -f "$PROJECT_DIR/CLAUDE.md" ] && echo "$PROJECT_DIR/CLAUDE.md" || echo "Create CLAUDE.md for AI context")
- **Documentation**: $([ -d "$PROJECT_DIR/AI/docs" ] && echo "$PROJECT_DIR/AI/docs/" || echo "No AI documentation found")
- **Patterns Config**: $([ -f "$PROJECT_DIR/.construct/patterns.yaml" ] && echo "$PROJECT_DIR/.construct/patterns.yaml" || echo "Not a CONSTRUCT project")
- **Recent Changes**: Review git log and uncommitted files

## 💡 Recent Insights
$(if [[ "$PROJECT_DIR" == *"CONSTRUCT"* ]]; then
    echo "- Pattern-based architecture enables flexible project support"
    echo "- Scripts now work with any project directory"
    echo "- Context-aware behavior based on .construct/patterns.yaml"
    echo "- Recursive improvement: CONSTRUCT improving itself"
else
    echo "- Development patterns established in current sprint"
    echo "- Architecture decisions documented"
    echo "- Code quality maintained through session"
    echo "- Progress tracked in version control"
fi)

## 🤖 For Claude Context Transfer
$(if [[ "$PROJECT_DIR" == *"CONSTRUCT"* ]]; then
    echo "This session focused on making CONSTRUCT scripts project-aware. Scripts now accept PROJECT_DIR parameters and work with any project structure, not just CONSTRUCT itself. Pattern-based behavior allows scripts to adapt to different project types."
else
    echo "This session focused on $PROJECT_NAME development. Key changes include recent commits, file modifications, and architectural decisions. Review the git log and CLAUDE.md for specific implementation details."
fi)

---
**Session preserved at**: $(date)
**Total Development Time**: Since $SESSION_START
**Next Action**: Start new Claude session and run update-context.sh
EOF

echo -e "${GREEN}✅ Development session summary saved${NC}"
echo -e "${BLUE}📁 Location: $SESSION_DIR/$TIMESTAMP-session.md${NC}"
echo ""
echo -e "${YELLOW}🔄 For next session:${NC}"
echo "1. Start fresh Claude session"
echo "2. Navigate to: cd $PROJECT_DIR"
if [ -f "$PROJECT_DIR/CONSTRUCT/scripts/construct/update-context.sh" ]; then
    echo "3. Run: ./CONSTRUCT/scripts/construct/update-context.sh ."
    echo "4. Read: CLAUDE.md for current context"
else
    echo "3. Review: $([ -f "$PROJECT_DIR/CLAUDE.md" ] && echo "CLAUDE.md" || echo "project documentation")"
    echo "4. Continue development"
fi