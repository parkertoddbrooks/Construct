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
source "$SCRIPT_DIR/../lib/common-patterns.sh"

# Get project directories using library functions
CONSTRUCT_ROOT=$(get_construct_root)
CONSTRUCT_DEV=$(get_construct_dev)
SESSION_DIR="$CONSTRUCT_DEV/AI/dev-logs/session-states/automated"
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
    SESSION_START=$(cd "$CONSTRUCT_ROOT" && git log --format="%ai" --since="$TODAY 00:00:00" --reverse | head -1 | cut -d' ' -f1-2)
fi

# If no commits today, use current time minus 2 hours
if [ -z "$SESSION_START" ]; then
    SESSION_START=$(date -v-2H "+%Y-%m-%d %H:%M:%S")
fi

# Get current development state
CURRENT_BRANCH=$(cd "$CONSTRUCT_ROOT" && git branch --show-current 2>/dev/null || echo "unknown")
LAST_COMMIT=$(cd "$CONSTRUCT_ROOT" && git log -1 --pretty=format:"%s" 2>/dev/null || echo "No commits")
UNCOMMITTED_FILES=$(cd "$CONSTRUCT_ROOT" && git status --porcelain 2>/dev/null | wc -l || echo "0")

# Count CONSTRUCT components
SCRIPT_COUNT=$(find "$CONSTRUCT_DEV" -name "*.sh" -type f | wc -l)
LIB_FUNCTIONS=$(find "$CONSTRUCT_DEV/CONSTRUCT/lib" -name "*.sh" -type f | wc -l)
CONFIG_FILES=$(find "$CONSTRUCT_DEV/CONSTRUCT/config" -name "*.yaml" -type f | wc -l)

# Generate summary file
cat > "$SESSION_DIR/$TIMESTAMP-construct-session.md" << EOF
# CONSTRUCT Development Session Summary: $(date +"%Y-%m-%d %H:%M")
**Duration**: Since $SESSION_START
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

## 📍 Where We Left Off in CONSTRUCT Development

### Current CONSTRUCT Task/Feature
Working on: $LAST_COMMIT

### Recent CONSTRUCT Development (Last 10 commits)
$(cd "$CONSTRUCT_ROOT" && git log -10 --pretty=format:"- %s (%cr)" 2>/dev/null | head -10)

### Active CONSTRUCT Files (Recently Modified)
$(cd "$CONSTRUCT_ROOT" && git status --porcelain 2>/dev/null | grep -E "^( M|M |MM)" | sed 's/^.../- /' | head -10)

### CONSTRUCT Component Status
- **Shell Scripts**: $SCRIPT_COUNT
- **Library Functions**: $LIB_FUNCTIONS
- **Configuration Files**: $CONFIG_FILES
- **Uncommitted Changes**: $UNCOMMITTED_FILES

## 🔧 CONSTRUCT Development Context

### Active Development Areas
$(cd "$CONSTRUCT_DEV" && find . -name "*.sh" -newer "$SESSION_DIR/../.." 2>/dev/null | head -5 | sed 's|^./|- |' || echo "- No recent script changes")

### Key CONSTRUCT Scripts Status
- **update-context.sh**: $([ -f "$CONSTRUCT_DEV/CONSTRUCT/scripts/update-context.sh" ] && echo "✅ Implemented" || echo "❌ Missing")
- **check-architecture.sh**: $([ -f "$CONSTRUCT_DEV/CONSTRUCT/scripts/check-architecture.sh" ] && echo "✅ Implemented" || echo "❌ Missing")
- **before_coding.sh**: $([ -f "$CONSTRUCT_DEV/CONSTRUCT/scripts/before_coding.sh" ] && echo "✅ Implemented" || echo "❌ Missing")

### Template Status
$(if [ -d "$CONSTRUCT_DEV/Templates" ]; then echo "✅ Templates directory exists"; else echo "❌ Templates directory missing"; fi)

## 🚀 Next CONSTRUCT Development Session

### Immediate Priorities
1. Continue dual development environment implementation
2. Complete missing template components
3. Implement USER-project-files script integration
4. Test template repository workflow

### Development Workflow Commands
\`\`\`bash
# CONSTRUCT Development Environment
cd CONSTRUCT-LAB/
./CONSTRUCT/scripts/update-context.sh      # Update development context
./CONSTRUCT/scripts/check-architecture.sh  # Validate CONSTRUCT architecture
./CONSTRUCT/scripts/before_coding.sh xyz   # Search existing before creating

# Cross-Environment Analysis (when ready)
./CONSTRUCT/scripts/analyze-user-project.sh # Analyze USER-project-files patterns
\`\`\`

### Key Files for Next Session
- **CONSTRUCT Context**: CONSTRUCT-LAB/AI/CLAUDE.md
- **Development Status**: Auto-generated section shows current state
- **Active PRDs**: construct-template-repository-prd.md
- **Implementation Plan**: implement-dual-dev-environments.md

## 💡 Recent CONSTRUCT Insights
- Dual development environments working (shell vs Swift domains)
- Auto-updating context successful for CONSTRUCT development
- Architecture validation finds real issues in CONSTRUCT itself
- Recursive improvement: CONSTRUCT improving itself with its own tools

## 🤖 For Claude Context Transfer
This session focused on implementing dual development environments for CONSTRUCT. The system now has parallel AI-assisted workflows for both CONSTRUCT development (shell/Python) and user projects (Swift). Key achievement: CONSTRUCT can now improve itself using its own methodology.

---
**Session preserved at**: $(date)
**Total Development Time**: Since $SESSION_START
**Next Action**: Start new Claude session and run update-context.sh
EOF

echo -e "${GREEN}✅ CONSTRUCT development session summary saved${NC}"
echo -e "${BLUE}📁 Location: $SESSION_DIR/$TIMESTAMP-construct-session.md${NC}"
echo ""
echo -e "${YELLOW}🔄 For next session:${NC}"
echo "1. Start fresh Claude session"
echo "2. Run: cd CONSTRUCT-LAB/ && ./CONSTRUCT/scripts/update-context.sh"
echo "3. Read: AI/CLAUDE.md for current context"
echo "4. Continue with dual environment implementation"