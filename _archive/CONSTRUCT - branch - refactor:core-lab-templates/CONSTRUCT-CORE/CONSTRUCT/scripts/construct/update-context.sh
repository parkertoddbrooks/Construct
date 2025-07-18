#!/bin/bash

# Project Context Updater
# Updates PROJECT/CLAUDE.md with current project state

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Source library functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONSTRUCT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
CONSTRUCT_CORE="$CONSTRUCT_ROOT/CONSTRUCT-CORE"
source "$SCRIPTS_ROOT/../lib/common-patterns.sh"
source "$SCRIPTS_ROOT/../lib/validation.sh"
source "$SCRIPTS_ROOT/../lib/file-analysis.sh"
source "$SCRIPTS_ROOT/../lib/template-utils.sh"

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 [PROJECT_DIR]"
    echo ""
    echo "Update project's CLAUDE.md with current state"
    echo ""
    echo "Arguments:"
    echo "  PROJECT_DIR   Directory containing project (default: current directory)"
    echo ""
    echo "This script updates the CLAUDE.md file in the specified project directory"
    echo "with current project state including:"
    echo "  - Git status and recent commits"
    echo "  - Active patterns from .construct/patterns.yaml"
    echo "  - Code quality violations"
    echo "  - Documentation status"
    echo "  - Working location context"
    exit 0
fi

# Accept PROJECT_DIR as parameter, default to current directory
PROJECT_DIR="${1:-.}"
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

# Get CLAUDE.md path for this project
# All projects now use root CLAUDE.md (created by /init and enhanced by construct-init)
CLAUDE_MD="$PROJECT_DIR/CLAUDE.md"

echo -e "${BLUE}🔄 Updating project context...${NC}"
echo "Project: $PROJECT_DIR"


# Function to update auto-sections in CLAUDE.md
update_auto_sections() {
    echo -e "${BLUE}🔄 Updating auto-sections in CLAUDE.md...${NC}"
    
    # Compute current state
    local script_count=$(count_shell_scripts "$PROJECT_DIR")
    local lib_functions=$(count_shell_scripts "$PROJECT_DIR/CONSTRUCT/lib" 2>/dev/null || echo "0")
    local config_files=$(count_yaml_files "$PROJECT_DIR/CONSTRUCT/config" 2>/dev/null || echo "0")
    local current_branch=$(cd "$PROJECT_DIR" && git branch --show-current 2>/dev/null || echo "unknown")
    local last_commit=$(cd "$PROJECT_DIR" && git log -1 --oneline 2>/dev/null || echo "No commits")
    
    # Template status
    local template_status="✅ Valid"
    if ! validate_template_integrity > /dev/null 2>&1; then
        template_status="❌ Issues found"
    fi
    
    # Read current CLAUDE.md content
    local claude_content=$(cat "$CLAUDE_MD")
    local temp_dir="${TMPDIR:-/tmp}"
    
    # Generate library functions list
    local lib_list=""
    if [ -d "$PROJECT_DIR/CONSTRUCT/lib" ]; then
        while IFS= read -r lib; do
            local name=$(basename "$lib" .sh)
            local desc="Shell library function"
            if grep -q "# Purpose:" "$lib" 2>/dev/null; then
                desc=$(grep "# Purpose:" "$lib" | head -1 | sed 's/# Purpose: //')
            fi
            lib_list="${lib_list}- $name.sh - $desc"$'\n'
        done < <(find_shell_scripts "$PROJECT_DIR/CONSTRUCT/lib")
    fi
    
    # Generate config files list
    local config_list=""
    if [ -d "$PROJECT_DIR/CONSTRUCT/config" ]; then
        while IFS= read -r config; do
            local name=$(basename "$config")
            local desc="Configuration file"
            if grep -q "# Purpose:" "$config" 2>/dev/null; then
                desc=$(grep "# Purpose:" "$config" | head -1 | sed 's/# Purpose: //')
            fi
            config_list="${config_list}- $name - $desc"$'\n'
        done < <(find "$PROJECT_DIR/CONSTRUCT/config" -name "*.yaml" -type f)
    fi
    
    # Count additional components
    local patterns_count=0
    local templates_count=0
    local docs_count=0
    
    # Count patterns
    if [ -d "$PROJECT_DIR/CONSTRUCT-CORE/patterns/plugins" ]; then
        patterns_count=$(find "$PROJECT_DIR/CONSTRUCT-CORE/patterns/plugins" -name "pattern.yaml" -type f 2>/dev/null | wc -l | tr -d ' ')
    fi
    
    # Count templates
    if [ -d "$PROJECT_DIR/CONSTRUCT-CORE/TEMPLATES" ]; then
        templates_count=$(find "$PROJECT_DIR/CONSTRUCT-CORE/TEMPLATES" -maxdepth 2 -type d 2>/dev/null | wc -l | tr -d ' ')
    fi
    
    # Count documentation files
    if [ -d "$PROJECT_DIR/CONSTRUCT-LAB/AI/docs" ]; then
        docs_count=$(find "$PROJECT_DIR/CONSTRUCT-LAB/AI/docs" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
    fi
    
    # Update CURRENT-STRUCTURE section
    local structure_content="## 📊 Current Project State (Auto-Updated)
Last updated: $(date '+%Y-%m-%d %H:%M:%S')

### Active Components
- Shell Scripts: $script_count
- Library Functions: $lib_functions
- Pattern Plugins: $patterns_count
- Templates: $templates_count
- Documentation Files: $docs_count
- Configuration Files: $config_files

### Available Resources

#### 🧩 Library Functions
$lib_list
#### ⚙️ Configuration Files
$config_list"
    
    # Update SPRINT-CONTEXT section
    local sprint_content="## 🎯 Current Development Context (Auto-Updated)
**Date**: $(date '+%Y-%m-%d')
**Focus**: Dual-environment development system
**Branch**: $current_branch
**Last Commit**: $last_commit

### Current Focus
- Active patterns and development priorities
- Code quality and architecture compliance
- Documentation coverage and completeness
- Development workflow optimization

### Development Workflow
1. Work in project directory
2. Use project context (this file)
3. Run pattern-specific validators
4. Commit changes with confidence"

    # Generate documentation links
    local arch_link=""
    if [ -f "$PROJECT_DIR/AI/docs/automated/architecture-overview-automated.md" ]; then
        arch_link="- [Architecture Overview](AI/docs/automated/architecture-overview-automated.md) - Complete system architecture"
    else
        arch_link="- Architecture Overview - Run ./CONSTRUCT/scripts/construct/update-architecture.sh to generate"
    fi
    
    local script_link=""
    if [ -f "$PROJECT_DIR/AI/docs/automated/script-reference-automated.md" ]; then
        script_link="- [Script Reference](AI/docs/automated/script-reference-automated.md) - All available scripts and functions"
    else
        script_link="- Script Reference - Run ./CONSTRUCT/scripts/construct/update-architecture.sh to generate"
    fi
    
    local patterns_link=""
    if [ -f "$PROJECT_DIR/AI/docs/automated/development-patterns-automated.md" ]; then
        patterns_link="- [Development Patterns](AI/docs/automated/development-patterns-automated.md) - Standard patterns and conventions"
    else
        patterns_link="- Development Patterns - Run ./CONSTRUCT/scripts/construct/update-architecture.sh to generate"
    fi
    
    local api_link=""
    if [ -f "$PROJECT_DIR/AI/docs/automated/api-reference-automated.md" ]; then
        api_link="- [API Reference](AI/docs/automated/api-reference-automated.md) - Library function documentation"
    else
        api_link="- API Reference - Run ./CONSTRUCT/scripts/construct/update-architecture.sh to generate"
    fi
    
    local structure_link=""
    if [ -f "$PROJECT_DIR/AI/structure/current-structure.md" ]; then
        structure_link="- [Current Structure](AI/structure/current-structure.md) - Quick reference to current state"
    else
        structure_link="- Current Structure - Run ./CONSTRUCT/scripts/construct/scan_construct_structure.sh to generate"
    fi
    
    local quality_link=""
    if [ -d "$PROJECT_DIR/AI/dev-logs/check-quality" ]; then
        local latest_quality=$(ls -t "$PROJECT_DIR/AI/dev-logs/check-quality"/*.md 2>/dev/null | head -1)
        if [ -n "$latest_quality" ]; then
            quality_link="- [Latest Quality Report]($(echo "$latest_quality" | sed "s|$PROJECT_DIR/||")) - Most recent quality validation"
        else
            quality_link="- Latest Quality Report - Run ./CONSTRUCT/scripts/core/check-quality.sh to generate"
        fi
    else
        quality_link="- Latest Quality Report - Run ./CONSTRUCT/scripts/core/check-quality.sh to generate"
    fi
    
    local session_link=""
    if [ -d "$PROJECT_DIR/AI/dev-logs/session-states" ]; then
        session_link="- [Session Summaries](AI/dev-logs/session-states/) - Development session documentation"
    else
        session_link="- Session Summaries - Run ./CONSTRUCT/scripts/dev/session-summary.sh to generate"
    fi
    
    local guide_link=""
    if [ -f "$PROJECT_DIR/AI/docs/automated/improving-CONSTRUCT-guide-automated.md" ]; then
        guide_link="- [Improving CONSTRUCT Guide](AI/docs/automated/improving-CONSTRUCT-guide-automated.md) - How to improve CONSTRUCT itself"
    else
        guide_link="- Improving CONSTRUCT Guide - Run ./CONSTRUCT/scripts/construct/update-architecture.sh to generate"
    fi
    
    # Update DOCUMENTATION-LINKS section  
    local docs_content="## 📚 Documentation Resources (Auto-Updated)

### Architecture Documentation
$arch_link
$script_link
$patterns_link
$api_link

### Structure Analysis
$structure_link
- [Latest Structure Scan](AI/structure/) - Timestamped structure analysis files
- [Structure Archive](AI/structure/_old/) - Previous structure snapshots

### Quality Reports
$quality_link
$session_link

### Development Process
$guide_link"

    # Generate violations content
    local hardcoded_status=""
    if command -v rg &>/dev/null; then
        local hardcoded=$(rg -n "/Users/|/home/" "$PROJECT_DIR/CONSTRUCT-CORE/CONSTRUCT" --type sh 2>/dev/null | head -5)
        if [ -n "$hardcoded" ]; then
            hardcoded_status=$(echo "$hardcoded" | while read -r line; do echo "- $line"; done)
        else
            hardcoded_status="✅ No hardcoded paths found"
        fi
    else
        hardcoded_status="Run ./CONSTRUCT/scripts/core/check-quality.sh to see current violations"
    fi
    
    local missing_docs_status=""
    local missing_docs_count=0
    while IFS= read -r script; do
        if ! grep -q "^# " "$script" 2>/dev/null; then
            if [ $missing_docs_count -lt 5 ]; then
                missing_docs_status="${missing_docs_status}- Missing header: $(basename "$script")"$'\n'
            fi
            missing_docs_count=$((missing_docs_count + 1))
        fi
    done < <(find_shell_scripts "$PROJECT_DIR/CONSTRUCT-CORE/CONSTRUCT/scripts")
    
    if [ $missing_docs_count -eq 0 ]; then
        missing_docs_status="✅ All scripts have documentation headers"
    fi
    
    local duplication_status=""
    if command -v rg &>/dev/null; then
        local dup_patterns=$(rg -c "cd.*dirname.*BASH_SOURCE" "$PROJECT_DIR/CONSTRUCT-CORE/CONSTRUCT" --type sh 2>/dev/null | wc -l | tr -d ' ')
        if [ "$dup_patterns" -gt 5 ]; then
            duplication_status="⚠️ Path resolution pattern used in $dup_patterns files - consider library function"
        else
            duplication_status="✅ Code duplication within acceptable limits"
        fi
    else
        duplication_status="Run ./CONSTRUCT/scripts/core/check-architecture.sh for duplication analysis"
    fi
    
    local template_status_check=""
    if validate_template_integrity >/dev/null 2>&1; then
        template_status_check="✅ Template integrity verified"
    else
        template_status_check="❌ Template integrity issues - run ./CONSTRUCT/scripts/core/check-architecture.sh for details"
    fi
    
    # Update VIOLATIONS section with actual violations
    local violations_content="## ⚠️ Active Violations (Auto-Updated)

### Hardcoded Paths
$hardcoded_status

### Missing Documentation
$missing_docs_status

### Code Duplication
$duplication_status

### Template Issues
$template_status_check"

    # Generate recent files list
    local recent_files=""
    if cd "$CONSTRUCT_ROOT" 2>/dev/null; then
        while IFS= read -r file; do
            if [[ "$file" =~ \.(sh|md|yaml)$ ]]; then
                recent_files="${recent_files}- $file"$'\n'
            fi
        done < <(git log --name-only --oneline -5 2>/dev/null | grep -v "^[a-f0-9]" | head -10 | sort -u)
    fi
    
    # Generate git status
    local git_status_output=""
    if cd "$CONSTRUCT_ROOT" 2>/dev/null; then
        git_status_output=$(git status --porcelain 2>/dev/null | head -10)
    fi
    
    # Update WORKING-LOCATION section
    local working_content="## 📍 Current Working Location (Auto-Updated)

### Recently Modified Files
$recent_files

### Git Status
\`\`\`
$git_status_output
\`\`\`

### Active Development Areas
- CONSTRUCT-LAB/CONSTRUCT/scripts/ - Core development scripts
- CONSTRUCT-LAB/CONSTRUCT/lib/ - Shared library functions  
- CONSTRUCT-LAB/AI/docs/automated/ - Auto-generated documentation
- PROJECT-TEMPLATE/ - Template files for users"

    # Generate symlinks content
    local symlinks_content=""
    if [ -x "$CONSTRUCT_CORE/CONSTRUCT/scripts/construct/check-symlinks.sh" ]; then
        symlinks_content=$("$CONSTRUCT_CORE/CONSTRUCT/scripts/construct/check-symlinks.sh" --list-markdown 2>/dev/null || echo "Error generating symlink list")
    else
        symlinks_content="### 🔗 Active Symlinks (Auto-Updated)
Error: check-symlinks.sh not found or not executable"
    fi

    # Generate PRDs content (CONSTRUCT-specific)
    local prds_content=""
    if [ -d "$PROJECT_DIR/CONSTRUCT-CORE" ] && [ -d "$PROJECT_DIR/CONSTRUCT-LAB" ]; then
        prds_content="### 📋 Active Product Requirements (Auto-Updated)

#### Current Sprint PRDs
"
        # List PRDs in current sprint directory
        if [ -d "$PROJECT_DIR/CONSTRUCT-LAB/AI/PRDs/current-sprint" ]; then
            local prd_count=0
            while IFS= read -r prd_file; do
                if [ -f "$prd_file" ]; then
                    local prd_name=$(basename "$prd_file")
                    prds_content="${prds_content}- [$prd_name](CONSTRUCT-LAB/AI/PRDs/current-sprint/$prd_name)
"
                    prd_count=$((prd_count + 1))
                fi
            done < <(find "$PROJECT_DIR/CONSTRUCT-LAB/AI/PRDs/current-sprint" -name "*.md" -type f 2>/dev/null | sort)
            
            if [ $prd_count -eq 0 ]; then
                prds_content="${prds_content}*No active PRDs in current sprint*
"
            fi
        fi

        prds_content="${prds_content}
#### Active Todos
"
        # List todo items
        if [ -d "$PROJECT_DIR/CONSTRUCT-LAB/AI/todo/current" ]; then
            local todo_count=0
            while IFS= read -r todo_file; do
                if [ -f "$todo_file" ]; then
                    local todo_name=$(basename "$todo_file")
                    prds_content="${prds_content}- [$todo_name](CONSTRUCT-LAB/AI/todo/current/$todo_name)
"
                    todo_count=$((todo_count + 1))
                fi
            done < <(find "$PROJECT_DIR/CONSTRUCT-LAB/AI/todo/current" -maxdepth 1 \( -name "*.md" -o -name "*.markdown" -o -name "*.txt" \) -type f 2>/dev/null | sort)
            
            if [ $todo_count -eq 0 ]; then
                prds_content="${prds_content}*No active todos*
"
            fi
        fi
    else
        prds_content="### 📋 Active Product Requirements (Auto-Updated)
*Run \`construct-update\` to refresh PRD tracking*"
    fi

    # Write each section to temporary files
    echo "$structure_content" > "$temp_dir/structure.txt"
    echo "$sprint_content" > "$temp_dir/sprint.txt"
    echo "$docs_content" > "$temp_dir/docs.txt"
    echo "$violations_content" > "$temp_dir/violations.txt"
    echo "$working_content" > "$temp_dir/working.txt"
    echo "$symlinks_content" > "$temp_dir/symlinks.txt"
    echo "$prds_content" > "$temp_dir/prds.txt"
    
    # Create temporary file with updated content
    local temp_file="$temp_dir/claude_updated.md"
    
    # Use AWK to replace sections, reading content from files
    echo "$claude_content" | awk '
    /<!-- START:CURRENT-STRUCTURE -->/ { 
        print $0
        while ((getline line < "'$temp_dir'/structure.txt") > 0) {
            print line
        }
        close("'$temp_dir'/structure.txt")
        in_section = 1
        next
    }
    /<!-- END:CURRENT-STRUCTURE -->/ && in_section == 1 {
        print $0
        in_section = 0
        next
    }
    /<!-- START:SPRINT-CONTEXT -->/ {
        print $0
        while ((getline line < "'$temp_dir'/sprint.txt") > 0) {
            print line
        }
        close("'$temp_dir'/sprint.txt")
        in_section = 2
        next
    }
    /<!-- END:SPRINT-CONTEXT -->/ && in_section == 2 {
        print $0
        in_section = 0
        next
    }
    /<!-- START:DOCUMENTATION-LINKS -->/ {
        print $0
        while ((getline line < "'$temp_dir'/docs.txt") > 0) {
            print line
        }
        close("'$temp_dir'/docs.txt")
        in_section = 3
        next
    }
    /<!-- END:DOCUMENTATION-LINKS -->/ && in_section == 3 {
        print $0
        in_section = 0
        next
    }
    /<!-- START:VIOLATIONS -->/ {
        print $0
        while ((getline line < "'$temp_dir'/violations.txt") > 0) {
            print line
        }
        close("'$temp_dir'/violations.txt")
        in_section = 4
        next
    }
    /<!-- END:VIOLATIONS -->/ && in_section == 4 {
        print $0
        in_section = 0
        next
    }
    /<!-- START:WORKING-LOCATION -->/ {
        print $0
        while ((getline line < "'$temp_dir'/working.txt") > 0) {
            print line
        }
        close("'$temp_dir'/working.txt")
        in_section = 5
        next
    }
    /<!-- END:WORKING-LOCATION -->/ && in_section == 5 {
        print $0
        in_section = 0
        next
    }
    /<!-- START:ACTIVE-SYMLINKS -->/ {
        print $0
        while ((getline line < "'$temp_dir'/symlinks.txt") > 0) {
            print line
        }
        close("'$temp_dir'/symlinks.txt")
        in_section = 6
        next
    }
    /<!-- END:ACTIVE-SYMLINKS -->/ && in_section == 6 {
        print $0
        in_section = 0
        next
    }
    /<!-- START:ACTIVE-PRDS -->/ {
        print $0
        while ((getline line < "'$temp_dir'/prds.txt") > 0) {
            print line
        }
        close("'$temp_dir'/prds.txt")
        in_section = 7
        next
    }
    /<!-- END:ACTIVE-PRDS -->/ && in_section == 7 {
        print $0
        in_section = 0
        next
    }
    in_section > 0 { next }
    { print }
    ' > "$temp_file"
    
    # Replace original file
    mv "$temp_file" "$CLAUDE_MD"
    
    # Clean up temporary files
    rm -f "$temp_dir/structure.txt" "$temp_dir/sprint.txt" "$temp_dir/docs.txt" "$temp_dir/violations.txt" "$temp_dir/working.txt" "$temp_dir/symlinks.txt" "$temp_dir/prds.txt"
    
    echo -e "${GREEN}✅ Auto-sections updated successfully${NC}"
}

# Main execution
main() {
    echo -e "${GREEN}🚀 Starting project context update...${NC}"
    
    # Validate environment
    validate_environment
    
    # Validate CLAUDE.md exists
    if [ ! -f "$CLAUDE_MD" ]; then
        echo -e "${RED}❌ CLAUDE.md not found at: $CLAUDE_MD${NC}"
        exit 1
    fi
    
    # Update auto-sections
    update_auto_sections
    
    echo -e "${GREEN}✅ Project context updated successfully!${NC}"
    echo -e "${BLUE}📖 View updated context: $CLAUDE_MD${NC}"
    echo ""
    echo "Next steps:"
    echo "  check-architecture $PROJECT_DIR   # Validate patterns"
    echo "  before_coding $PROJECT_DIR func   # Search before coding"
}

# Run main function
main "$@"