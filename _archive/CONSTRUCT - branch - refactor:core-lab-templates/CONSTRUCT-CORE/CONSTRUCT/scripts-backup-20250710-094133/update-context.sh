#!/bin/bash

# CONSTRUCT Development Context Updater
# Updates CONSTRUCT-LAB/AI/CLAUDE.md with current CONSTRUCT development state

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
source "$SCRIPT_DIR/../lib/validation.sh"
source "$SCRIPT_DIR/../lib/file-analysis.sh"
source "$SCRIPT_DIR/../lib/template-utils.sh"

# Get project directories using library functions
CONSTRUCT_ROOT=$(get_construct_root)
CONSTRUCT_DEV=$(get_construct_dev)
CLAUDE_MD="$CONSTRUCT_DEV/CLAUDE.md"

echo -e "${BLUE}🔄 Updating CONSTRUCT development context...${NC}"


# Function to update auto-sections in CLAUDE.md
update_auto_sections() {
    echo -e "${BLUE}🔄 Updating auto-sections in CLAUDE.md...${NC}"
    
    # Compute current state
    local script_count=$(count_shell_scripts "$CONSTRUCT_DEV")
    local lib_functions=$(count_shell_scripts "$CONSTRUCT_DEV/CONSTRUCT/lib")
    local config_files=$(count_yaml_files "$CONSTRUCT_DEV/CONSTRUCT/config")
    local current_branch=$(cd "$CONSTRUCT_ROOT" && git branch --show-current 2>/dev/null || echo "unknown")
    local last_commit=$(cd "$CONSTRUCT_ROOT" && git log -1 --oneline 2>/dev/null || echo "No commits")
    
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
    while IFS= read -r lib; do
        local name=$(basename "$lib" .sh)
        local desc="Shell library function"
        if grep -q "# Purpose:" "$lib" 2>/dev/null; then
            desc=$(grep "# Purpose:" "$lib" | head -1 | sed 's/# Purpose: //')
        fi
        lib_list="${lib_list}- $name.sh - $desc"$'\n'
    done < <(find_shell_scripts "$CONSTRUCT_DEV/CONSTRUCT/lib")
    
    # Generate config files list
    local config_list=""
    while IFS= read -r config; do
        local name=$(basename "$config")
        local desc="Configuration file"
        if grep -q "# Purpose:" "$config" 2>/dev/null; then
            desc=$(grep "# Purpose:" "$config" | head -1 | sed 's/# Purpose: //')
        fi
        config_list="${config_list}- $name - $desc"$'\n'
    done < <(find "$CONSTRUCT_DEV/CONSTRUCT/config" -name "*.yaml" -type f)
    
    # Update CURRENT-STRUCTURE section
    local structure_content="## 📊 Current Project State (Auto-Updated)
Last updated: $(date '+%Y-%m-%d %H:%M:%S')

### Active Components
- **Shell Scripts**: $script_count files
- **Library Functions**: $lib_functions files
- **Configuration Files**: $config_files files  
- **Documentation Files**: $(find "$CONSTRUCT_DEV/AI/docs" -name "*.md" 2>/dev/null | wc -l) files

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
- CONSTRUCT development environment (shell/Python tools)
- USER project environment (Swift MVVM templates)
- Cross-environment analysis and improvement system
- Auto-generating documentation and validation

### Development Workflow
1. Work in CONSTRUCT-LAB/ directory
2. Use CONSTRUCT development context (this file)
3. Test changes against PROJECT-TEMPLATE/
4. Ensure template users aren't affected"

    # Generate documentation links
    local arch_link=""
    if [ -f "$CONSTRUCT_DEV/AI/docs/automated/architecture-overview-automated.md" ]; then
        arch_link="- [Architecture Overview](AI/docs/automated/architecture-overview-automated.md) - Complete system architecture"
    else
        arch_link="- Architecture Overview - Run ./CONSTRUCT/scripts/update-architecture.sh to generate"
    fi
    
    local script_link=""
    if [ -f "$CONSTRUCT_DEV/AI/docs/automated/script-reference-automated.md" ]; then
        script_link="- [Script Reference](AI/docs/automated/script-reference-automated.md) - All available scripts and functions"
    else
        script_link="- Script Reference - Run ./CONSTRUCT/scripts/update-architecture.sh to generate"
    fi
    
    local patterns_link=""
    if [ -f "$CONSTRUCT_DEV/AI/docs/automated/development-patterns-automated.md" ]; then
        patterns_link="- [Development Patterns](AI/docs/automated/development-patterns-automated.md) - Standard patterns and conventions"
    else
        patterns_link="- Development Patterns - Run ./CONSTRUCT/scripts/update-architecture.sh to generate"
    fi
    
    local api_link=""
    if [ -f "$CONSTRUCT_DEV/AI/docs/automated/api-reference-automated.md" ]; then
        api_link="- [API Reference](AI/docs/automated/api-reference-automated.md) - Library function documentation"
    else
        api_link="- API Reference - Run ./CONSTRUCT/scripts/update-architecture.sh to generate"
    fi
    
    local structure_link=""
    if [ -f "$CONSTRUCT_DEV/AI/structure/current-structure.md" ]; then
        structure_link="- [Current Structure](AI/structure/current-structure.md) - Quick reference to current state"
    else
        structure_link="- Current Structure - Run ./CONSTRUCT/scripts/scan_construct_structure.sh to generate"
    fi
    
    local quality_link=""
    if [ -d "$CONSTRUCT_DEV/AI/dev-logs/check-quality" ]; then
        local latest_quality=$(ls -t "$CONSTRUCT_DEV/AI/dev-logs/check-quality"/*.md 2>/dev/null | head -1)
        if [ -n "$latest_quality" ]; then
            quality_link="- [Latest Quality Report]($(echo "$latest_quality" | sed "s|$CONSTRUCT_DEV/||")) - Most recent quality validation"
        else
            quality_link="- Latest Quality Report - Run ./CONSTRUCT/scripts/check-quality.sh to generate"
        fi
    else
        quality_link="- Latest Quality Report - Run ./CONSTRUCT/scripts/check-quality.sh to generate"
    fi
    
    local session_link=""
    if [ -d "$CONSTRUCT_DEV/AI/dev-logs/session-states" ]; then
        session_link="- [Session Summaries](AI/dev-logs/session-states/) - Development session documentation"
    else
        session_link="- Session Summaries - Run ./CONSTRUCT/scripts/session-summary.sh to generate"
    fi
    
    local guide_link=""
    if [ -f "$CONSTRUCT_DEV/AI/docs/automated/improving-CONSTRUCT-guide-automated.md" ]; then
        guide_link="- [Improving CONSTRUCT Guide](AI/docs/automated/improving-CONSTRUCT-guide-automated.md) - How to improve CONSTRUCT itself"
    else
        guide_link="- Improving CONSTRUCT Guide - Run ./CONSTRUCT/scripts/update-architecture.sh to generate"
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
        local hardcoded=$(rg -n "/Users/|/home/" "$CONSTRUCT_DEV/CONSTRUCT" --type sh 2>/dev/null | head -5)
        if [ -n "$hardcoded" ]; then
            hardcoded_status=$(echo "$hardcoded" | while read -r line; do echo "- $line"; done)
        else
            hardcoded_status="✅ No hardcoded paths found"
        fi
    else
        hardcoded_status="Run ./CONSTRUCT/scripts/check-quality.sh to see current violations"
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
    done < <(find_shell_scripts "$CONSTRUCT_DEV/CONSTRUCT/scripts")
    
    if [ $missing_docs_count -eq 0 ]; then
        missing_docs_status="✅ All scripts have documentation headers"
    fi
    
    local duplication_status=""
    if command -v rg &>/dev/null; then
        local dup_patterns=$(rg -c "cd.*dirname.*BASH_SOURCE" "$CONSTRUCT_DEV/CONSTRUCT" --type sh 2>/dev/null | wc -l | tr -d ' ')
        if [ "$dup_patterns" -gt 5 ]; then
            duplication_status="⚠️ Path resolution pattern used in $dup_patterns files - consider library function"
        else
            duplication_status="✅ Code duplication within acceptable limits"
        fi
    else
        duplication_status="Run ./CONSTRUCT/scripts/check-architecture.sh for duplication analysis"
    fi
    
    local template_status_check=""
    if validate_template_integrity >/dev/null 2>&1; then
        template_status_check="✅ Template integrity verified"
    else
        template_status_check="❌ Template integrity issues - run ./CONSTRUCT/scripts/check-architecture.sh for details"
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
    if [ -x "$CONSTRUCT_DEV/CONSTRUCT/scripts/check-symlinks.sh" ]; then
        symlinks_content=$("$CONSTRUCT_DEV/CONSTRUCT/scripts/check-symlinks.sh" --list-markdown 2>/dev/null || echo "Error generating symlink list")
    else
        symlinks_content="### 🔗 Active Symlinks (Auto-Updated)
Error: check-symlinks.sh not found or not executable"
    fi

    # Write each section to temporary files
    echo "$structure_content" > "$temp_dir/structure.txt"
    echo "$sprint_content" > "$temp_dir/sprint.txt"
    echo "$docs_content" > "$temp_dir/docs.txt"
    echo "$violations_content" > "$temp_dir/violations.txt"
    echo "$working_content" > "$temp_dir/working.txt"
    echo "$symlinks_content" > "$temp_dir/symlinks.txt"
    
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
    in_section > 0 { next }
    { print }
    ' > "$temp_file"
    
    # Replace original file
    mv "$temp_file" "$CLAUDE_MD"
    
    # Clean up temporary files
    rm -f "$temp_dir/structure.txt" "$temp_dir/sprint.txt" "$temp_dir/docs.txt" "$temp_dir/violations.txt" "$temp_dir/working.txt"
    
    echo -e "${GREEN}✅ Auto-sections updated successfully${NC}"
}

# Main execution
main() {
    echo -e "${GREEN}🚀 Starting CONSTRUCT development context update...${NC}"
    
    # Validate environment
    validate_environment
    
    # Validate CLAUDE.md exists
    if [ ! -f "$CLAUDE_MD" ]; then
        echo -e "${RED}❌ CLAUDE.md not found at: $CLAUDE_MD${NC}"
        exit 1
    fi
    
    # Update auto-sections
    update_auto_sections
    
    echo -e "${GREEN}✅ CONSTRUCT development context updated successfully!${NC}"
    echo -e "${BLUE}📖 View updated context: $CLAUDE_MD${NC}"
    echo ""
    echo "Next steps:"
    echo "  ./CONSTRUCT/scripts/check-architecture.sh   # Validate CONSTRUCT patterns"
    echo "  ./CONSTRUCT/scripts/before_coding.sh func   # Search before coding"
}

# Run main function
main "$@"