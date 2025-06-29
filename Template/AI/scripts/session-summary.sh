#!/bin/bash

# Construct Session Summary Generator
# Creates comprehensive summary when context is ~90% full

# Get script directory and project root
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../../.." && pwd )"
SESSION_DIR="$PROJECT_ROOT/AI/dev-logs/session-states"
TIMESTAMP=$(date +%Y-%m-%d-%H%M)

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create session directory if it doesn't exist
mkdir -p "$SESSION_DIR"

# Session file
SESSION_FILE="$SESSION_DIR/${TIMESTAMP}-session.md"

echo -e "${BLUE}📊 Generating Construct Session Summary...${NC}"
echo ""

# Generate session summary
cat > "$SESSION_FILE" << EOF
# Session Summary: $(date '+%Y-%m-%d %H:%M')
**Duration**: Since session start
**Branch**: $(cd "$PROJECT_ROOT" && git branch --show-current 2>/dev/null || echo 'main')
**Context Usage**: ~90% (summary triggered)

## 🎯 Quick Start for Next Session
\`\`\`bash
# Run these commands when starting fresh:
construct-update    # Updates CLAUDE.md with current state
construct-check     # Check for any violations
\`\`\`

## 📍 Where We Left Off
### Current Feature/Task
Working on: [Describe current task]

### Recent Work Context (Last 10 commits)
EOF

# Add recent commits
cd "$PROJECT_ROOT" 2>/dev/null && git log --oneline -10 >> "$SESSION_FILE" 2>/dev/null || echo "- No git history yet" >> "$SESSION_FILE"

# Add active files
cat >> "$SESSION_FILE" << EOF

### Active Files (Recently Modified)
EOF

find "$PROJECT_ROOT/Template" -name "*.swift" -type f -mtime -1 2>/dev/null | head -10 | while read -r file; do
    echo "- ${file#$PROJECT_ROOT/}" >> "$SESSION_FILE"
done

# Add session progress
cat >> "$SESSION_FILE" << EOF

## 🔬 Session Progress

### Work Completed This Session
- [Summary of completed work]
- [Key decisions made]
- [Problems solved]

### Key Changes Made
\`\`\`
EOF

cd "$PROJECT_ROOT" 2>/dev/null && git status --short >> "$SESSION_FILE" 2>/dev/null || echo "No git changes" >> "$SESSION_FILE"

cat >> "$SESSION_FILE" << 'EOF'
```

## 🏗️ Architecture & Quality Status
### Recent Violations Fixed
- [List any violations that were resolved]

### Current Violations
- [List any remaining violations]

### Patterns Established
- [New patterns introduced this session]
EOF

# Add current todos if any exist
if [ -f "$PROJECT_ROOT/AI/dev-logs/todos.md" ]; then
    echo "" >> "$SESSION_FILE"
    echo "## 📝 Current TODOs" >> "$SESSION_FILE"
    cat "$PROJECT_ROOT/AI/dev-logs/todos.md" >> "$SESSION_FILE" 2>/dev/null
fi

# Add metrics
cat >> "$SESSION_FILE" << EOF

## 📊 Session Metrics
- **Files Changed**: $(find "$PROJECT_ROOT/Template" -name "*.swift" -type f -mtime -1 2>/dev/null | wc -l | tr -d ' ')
- **Components Added**: [Count of new components]
- **Tests Written**: [Count of new tests]
- **Violations Fixed**: [Count of fixed violations]

## 🚧 Uncommitted Work
\`\`\`
EOF

cd "$PROJECT_ROOT" 2>/dev/null && git status --porcelain >> "$SESSION_FILE" 2>/dev/null || echo "No uncommitted changes" >> "$SESSION_FILE"

cat >> "$SESSION_FILE" << 'EOF'
```

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
3. Run `construct-update` to refresh CLAUDE.md
4. Continue with: [Specific next task]

## 📝 Dev Log Reminder
Consider creating a dev-log if significant work was completed:
- Template: `Template/AI/dev-logs/_devupdate-prompt.md`
- Create as: `AI/dev-logs/devupdate-XX.md`

---
*Generated at ~90% context. Start fresh session and run `construct-update` to continue.*
*Trust The Process.*
EOF

# Create a quick reference file
QUICK_REF="$SESSION_DIR/latest-session.md"
cp "$SESSION_FILE" "$QUICK_REF"

# Success message
echo -e "${GREEN}✅ Session summary created successfully!${NC}"
echo ""
echo "Files created:"
echo "  - $SESSION_FILE"
echo "  - $QUICK_REF (quick reference)"
echo ""
echo -e "${YELLOW}⚠️  Context is ~90% full${NC}"
echo ""
echo "Next steps:"
echo "1. Review the session summary above"
echo "2. Commit any important changes"
echo "3. Start a fresh Claude session"
echo "4. Run 'construct-update' in the new session"
echo ""
echo -e "${BLUE}Trust The Process.${NC}"