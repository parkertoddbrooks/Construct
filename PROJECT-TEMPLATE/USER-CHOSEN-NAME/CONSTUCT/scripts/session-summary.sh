#!/bin/bash

# Session Summary Generator
# Creates a summary of the current session for context preservation

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SESSION_DIR="$PROJECT_ROOT/AI/dev-logs/session-states"
TIMESTAMP=$(date +"%Y-%m-%d-%H%M")
TODAY=$(date +"%Y-%m-%d")

# Create session directory if it doesn't exist
mkdir -p "$SESSION_DIR"

# Determine session start (first commit of the day or last summary)
LAST_SUMMARY=$(ls -1 "$SESSION_DIR"/*-session.md 2>/dev/null | tail -1)
if [ -f "$LAST_SUMMARY" ]; then
    SESSION_START=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$LAST_SUMMARY")
else
    SESSION_START=$(git log --format="%ai" --since="$TODAY 00:00:00" --reverse | head -1 | cut -d' ' -f1-2)
fi

# If no commits today, use current time minus 2 hours
if [ -z "$SESSION_START" ]; then
    SESSION_START=$(date -v-2H "+%Y-%m-%d %H:%M:%S")
fi

# Generate summary file
cat > "$SESSION_DIR/$TIMESTAMP-session.md" << EOF
# Session Summary: $(date +"%Y-%m-%d %H:%M")
**Duration**: Since $SESSION_START
**Branch**: $(cd "$PROJECT_ROOT" && git branch --show-current)
**Context Usage**: ~90% (summary triggered)

## 🎯 Quick Start for Next Session
\`\`\`bash
# Run these commands when starting fresh:
run-update    # Updates CLAUDE.md with current state
run-arch      # Updates architecture documentation (optional)
\`\`\`

## 📍 Where We Left Off
### Current Feature/Task
$(cd "$PROJECT_ROOT" && git log -1 --pretty=format:"Working on: %s")

### Recent Work Context (Last 10 commits)
$(cd "$PROJECT_ROOT" && git log -10 --pretty=format:"- %s (%cr)" | head -10)

### Active Files (Recently Modified)
$(cd "$PROJECT_ROOT" && git status --porcelain | grep -E "^( M|M |MM)" | sed 's/^.../- /' | head -10)

## 🔬 Session Progress

### Work Completed This Session
$(cd "$PROJECT_ROOT" && git log --since="$SESSION_START" --pretty=format:"- %s" | head -10)

### Key Changes Made
\`\`\`
$(cd "$PROJECT_ROOT" && git diff --name-status HEAD~5..HEAD 2>/dev/null | head -20)
\`\`\`

## 🏗️ Architecture & Quality Status
### Recent Violations Fixed
$(cd "$PROJECT_ROOT" && git log --since="$SESSION_START" --grep="fix:" --pretty=format:"- %s" | grep -E "(hardcoded|violation|token)" | head -5)

### Current TODOs in Code
$(cd "$PROJECT_ROOT" && grep -r "TODO:" --include="*.swift" . 2>/dev/null | head -5 | sed 's/.*TODO:/- TODO:/')

## 📊 Session Metrics
- **Session Commits**: $(cd "$PROJECT_ROOT" && git log --since="$SESSION_START" --oneline | wc -l | tr -d ' ')
- **Total Today**: $(cd "$PROJECT_ROOT" && git log --since="$TODAY 00:00:00" --oneline | wc -l | tr -d ' ')
- **Files Changed**: $(cd "$PROJECT_ROOT" && git diff --name-only HEAD~5..HEAD 2>/dev/null | sort -u | wc -l | tr -d ' ')
- **Current Branch**: $(cd "$PROJECT_ROOT" && git branch --show-current)
- **Ahead of main**: $(cd "$PROJECT_ROOT" && git rev-list --count origin/main..HEAD 2>/dev/null || echo "0")

## 🚧 Uncommitted Work
\`\`\`
$(cd "$PROJECT_ROOT" && git status --short)
\`\`\`

## 💡 Context Bridge to CLAUDE.md
**CLAUDE.md provides:**
- Current project structure
- Available components
- Architecture violations
- Pattern library

**This summary provides:**
- What you were working on
- Recent changes and context
- Session-specific progress
- Where to continue

## 🎯 Suggested Next Steps
1. Review uncommitted changes above
2. Check recent commits for context
3. Run \`run-update\` to refresh CLAUDE.md
4. Continue with: $(cd "$PROJECT_ROOT" && git log -1 --pretty=format:"%s")

---
*Generated at ~90% context. Start fresh session and run \`run-update\` to continue.*
EOF

echo "✅ Session summary created: AI/dev-logs/session-states/$TIMESTAMP-session.md"
echo ""
echo "📋 Key items captured:"
echo "  - Work completed since $SESSION_START"
echo "  - Technical discoveries and decisions"
echo "  - Current git state"
echo "  - Metrics and statistics"
echo ""
echo "💡 Remember to:"
echo "  1. Review and add any additional context"
echo "  2. Start a fresh Claude session if needed"
echo "  3. Run 'run-update' in the new session"