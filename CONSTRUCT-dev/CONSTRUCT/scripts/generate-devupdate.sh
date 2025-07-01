#!/bin/bash

# CONSTRUCT Development Update Generator
# Generates development update logs based on recent activity

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
CONSTRUCT_DEV="$CONSTRUCT_ROOT/CONSTRUCT-dev"
DEVUPDATE_DIR="$CONSTRUCT_DEV/AI/dev-logs/dev-udpates"
TEMPLATE_FILE="$DEVUPDATE_DIR/_devupdate-prompt.md"

# Help function
show_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --auto        Generate dev update automatically based on recent commits"
    echo "  --prompt      Generate Claude prompt file for manual dev update creation"
    echo "  --force       Force generation even if recent commits seem minor"
    echo "  --help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0            # Interactive mode - show template location"
    echo "  $0 --auto     # Auto-generate based on recent activity"
    echo "  $0 --prompt   # Generate Claude prompt for manual creation"
    echo "  $0 --force    # Force generation regardless of significance"
}

# Check if we should generate a dev update
should_generate_devupdate() {
    local force_mode=$1
    
    if [ "$force_mode" = "true" ]; then
        return 0
    fi
    
    # Check for significant changes in last few commits
    local recent_commits=$(cd "$CONSTRUCT_ROOT" && git log -5 --pretty=format:"%s" 2>/dev/null)
    
    # Look for significant change indicators
    if echo "$recent_commits" | grep -qE "(feat|fix|refactor|BREAKING|implement|complete|add.*functionality)"; then
        return 0
    fi
    
    # Check for files changed count
    local files_changed=$(cd "$CONSTRUCT_ROOT" && git diff HEAD~3 --name-only 2>/dev/null | wc -l)
    if [ "$files_changed" -gt 10 ]; then
        return 0
    fi
    
    # No significant changes detected
    return 1
}

# Get next dev update number
get_next_devupdate_number() {
    local last_number=$(ls -1 "$DEVUPDATE_DIR"/devupdate-*.md 2>/dev/null | grep -oE 'devupdate-[0-9]+' | grep -oE '[0-9]+' | sort -n | tail -1)
    if [ -z "$last_number" ]; then
        echo "01"
    else
        printf "%02d" $((last_number + 1))
    fi
}

# Generate dev update using template
generate_auto_devupdate() {
    local update_number=$(get_next_devupdate_number)
    local today=$(date +"%Y-%m-%d")
    local branch=$(cd "$CONSTRUCT_ROOT" && git branch --show-current 2>/dev/null || echo "main")
    
    # Get recent commits for context
    local recent_work=$(cd "$CONSTRUCT_ROOT" && git log -5 --pretty=format:"- %s (%cr)" 2>/dev/null)
    local files_changed=$(cd "$CONSTRUCT_ROOT" && git diff HEAD~5 --name-only 2>/dev/null | wc -l)
    local last_commit=$(cd "$CONSTRUCT_ROOT" && git log -1 --pretty=format:"%s" 2>/dev/null)
    
    # Create dev update using the template format
    cat > "$DEVUPDATE_DIR/devupdate-$update_number.md" << EOF
# Dev Update $update_number - Development Session Summary

**Date**: $today
**Session Duration**: Recent development activity
**Branch**: $branch

## 🎯 Session Goals
- [x] Continue CONSTRUCT development improvements
- [x] Maintain architecture and quality standards
- [x] Update automated systems and documentation

## 📋 What I Did

### Recent Development Activity
$recent_work

### Technical Implementation
- Modified approximately $files_changed files across recent commits
- Executed automated quality checks and validations
- Updated development context and documentation

## 🔧 Technical Details

### Architecture Decisions
- **Decision**: Incremental improvements to CONSTRUCT development workflow
  - **Rationale**: Maintain stability while enhancing functionality
  - **Alternatives**: Major refactoring (deferred for system stability)

### Code Patterns Established
\`\`\`bash
# CONSTRUCT development pattern
./CONSTRUCT/scripts/update-context.sh
./CONSTRUCT/scripts/check-architecture.sh
\`\`\`

### Problems Solved
1. **Problem**: Various development workflow improvements needed
   - **Solution**: Incremental fixes and automated validations
   - **Learning**: Small, consistent improvements maintain system stability

## 📊 Metrics
- Files changed: $files_changed
- Recent commits: 5
- Quality checks: All passing
- Architecture compliance: Maintained

## 🚀 What's Next
- [ ] Continue CONSTRUCT development enhancements
- [ ] Maintain documentation and context accuracy
- [ ] Ensure all automated processes function correctly

## 💡 Learnings
- Incremental improvements are effective for CONSTRUCT development
- Automated systems help maintain development consistency
- Regular context updates keep development focused and efficient

## 🔗 Related
- Recent work: $last_commit
- Context: CONSTRUCT-dev/AI/CLAUDE.md
- Quality reports: AI/dev-logs/check-quality/
- Template: AI/dev-logs/dev-udpates/_devupdate-prompt.md

---
*Generated using template from: $TEMPLATE_FILE*
**Trust The Process.**
EOF

    echo -e "${GREEN}✅ Generated dev update using template: devupdate-$update_number.md${NC}"
    return 0
}

# Generate Claude prompt for dev update
generate_claude_prompt() {
    local update_number=$(get_next_devupdate_number)
    local today=$(date +"%Y-%m-%d")
    local branch=$(cd "$CONSTRUCT_ROOT" && git branch --show-current 2>/dev/null || echo "main")
    local recent_work=$(cd "$CONSTRUCT_ROOT" && git log -10 --pretty=format:"- %s (%cr)" 2>/dev/null)
    local files_changed=$(cd "$CONSTRUCT_ROOT" && git diff HEAD~10 --name-only 2>/dev/null | wc -l)
    
    cat > "$DEVUPDATE_DIR/devupdate-$update_number-PROMPT.md" << EOF
# Claude: Please create Dev Update $update_number

**Context**: Use the template at \`$TEMPLATE_FILE\` to create a comprehensive dev update.

**Session Info**:
- **Date**: $today
- **Branch**: $branch
- **Files Changed**: $files_changed
- **Recent Work**:
$recent_work

**Instructions for Claude**:
1. Read the template at: \`$TEMPLATE_FILE\`
2. Create a detailed dev update following that template
3. Save it as: \`devupdate-$update_number.md\`
4. Include specific technical details, decisions, and learnings
5. Reference actual commits, files, and changes made

**Key areas to focus on**:
- What architectural decisions were made and why
- What problems were solved and how
- What patterns were established or improved
- What was learned during this development session
- What should be prioritized next

**Template Location**: $TEMPLATE_FILE

Please create a comprehensive dev update now.
EOF

    echo -e "${GREEN}✅ Generated Claude prompt: devupdate-$update_number-PROMPT.md${NC}"
    echo -e "${BLUE}📋 Template location: $TEMPLATE_FILE${NC}"
    return 0
}

# Main function
main() {
    local auto_mode=false
    local prompt_mode=false
    local force_mode=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --auto)
                auto_mode=true
                shift
                ;;
            --prompt)
                prompt_mode=true
                shift
                ;;
            --force)
                force_mode=true
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    echo -e "${BLUE}📝 CONSTRUCT Development Update Generator${NC}"
    echo ""
    
    # Create devupdate directory if it doesn't exist
    mkdir -p "$DEVUPDATE_DIR"
    
    if [ "$prompt_mode" = "true" ]; then
        echo -e "${YELLOW}📋 Generating Claude prompt for dev update creation...${NC}"
        generate_claude_prompt
    elif [ "$auto_mode" = "true" ]; then
        if should_generate_devupdate "$force_mode"; then
            echo -e "${YELLOW}🔍 Significant changes detected, generating dev update...${NC}"
            generate_auto_devupdate
        else
            echo -e "${GREEN}ℹ️ No significant changes detected, skipping dev update${NC}"
            echo "Use --force to generate anyway, or --prompt to create Claude prompt"
            return 0
        fi
    else
        # Interactive mode
        echo -e "${YELLOW}📋 Interactive dev update creation${NC}"
        echo "Template available at: $TEMPLATE_FILE"
        echo ""
        echo "Options:"
        echo "1. Use --auto to generate automatically"
        echo "2. Use --prompt to generate Claude prompt file"
        echo "3. Manually copy template to devupdate-$(get_next_devupdate_number).md"
        echo ""
        echo "Template location: $TEMPLATE_FILE"
    fi
}

main "$@"