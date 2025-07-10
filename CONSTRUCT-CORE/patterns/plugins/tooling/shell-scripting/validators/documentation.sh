#!/bin/bash

# Shell Scripting Pattern - Documentation Validator
# Validates shell script documentation standards

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PATTERNS_ROOT="$(cd "$PLUGIN_ROOT/../.." && pwd)"
CONSTRUCT_ROOT="$(cd "$PATTERNS_ROOT/../.." && pwd)"
CONSTRUCT_CORE="$CONSTRUCT_ROOT/CONSTRUCT-CORE"

echo -e "${BLUE}🐚 Shell Script Documentation Validation${NC}"
echo "----------------------------------------"

# Documentation checks for shell scripts
check_script_headers() {
    local file="$1"
    local issues=0
    
    # Check for script description in first 5 lines
    if ! head -5 "$file" | grep -q "^#.*[Dd]escription\|^#.*What.*does\|^#.*Purpose"; then
        echo -e "  ${YELLOW}⚠️  Missing header documentation${NC}"
        ((issues++))
    fi
    
    # Check for shebang
    if ! head -1 "$file" | grep -q "^#!/bin/bash"; then
        echo -e "  ${YELLOW}⚠️  Missing or incorrect shebang${NC}"
        ((issues++))
    fi
    
    return $issues
}

check_function_documentation() {
    local file="$1"
    local issues=0
    
    # Find function definitions
    local functions=$(grep -n "^[a-zA-Z_][a-zA-Z0-9_]*(" "$file" 2>/dev/null | cut -d':' -f1)
    
    for line_num in $functions; do
        local func_name=$(sed -n "${line_num}p" "$file" | cut -d'(' -f1)
        
        # Check if function has documentation comment before it
        local prev_line=$((line_num - 1))
        if [ $prev_line -gt 0 ]; then
            local comment=$(sed -n "${prev_line}p" "$file")
            if [[ ! "$comment" =~ ^#.*[A-Za-z] ]]; then
                echo -e "  ${YELLOW}⚠️  Function lacks documentation: $func_name${NC}"
                ((issues++))
            fi
        fi
    done
    
    return $issues
}

check_usage_documentation() {
    local file="$1"
    local issues=0
    
    # Check if script shows usage help
    if ! grep -q "usage\|Usage\|USAGE\|help\|--help\|-h" "$file"; then
        # Only warn if script accepts parameters
        if grep -q "\$1\|\$@\|getopts" "$file"; then
            echo -e "  ${YELLOW}⚠️  Script accepts parameters but lacks usage documentation${NC}"
            ((issues++))
        fi
    fi
    
    return $issues
}

check_readme_files() {
    local project_dir="$1"
    local issues=0
    
    # Check for README in directories containing shell scripts
    local script_dirs=$(find "$project_dir" -name "*.sh" -type f -exec dirname {} \; | sort -u)
    
    while IFS= read -r dir; do
        # Skip hidden directories and common excludes
        [[ "$dir" == *"/.git/"* ]] && continue
        [[ "$dir" == *"/node_modules/"* ]] && continue
        
        # Check if this directory has multiple scripts
        local script_count=$(find "$dir" -maxdepth 1 -name "*.sh" -type f | wc -l)
        
        if [ "$script_count" -gt 2 ] && [ ! -f "$dir/README.md" ]; then
            echo -e "${YELLOW}⚠️  Directory with $script_count scripts lacks README: $dir${NC}"
            ((issues++))
        fi
    done <<< "$script_dirs"
    
    return $issues
}

# Main validation
main() {
    # Accept PROJECT_DIR as parameter, default to current directory
    local PROJECT_DIR="${1:-.}"
    PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
    
    local total_issues=0
    local files_checked=0
    
    echo "Scanning for shell scripts in: $PROJECT_DIR"
    
    # Find all shell scripts in the project
    while IFS= read -r -d '' script; do
        # Skip scripts-new directory
        [[ "$script" == *"/scripts-new/"* ]] && continue
        
        echo -e "\n${YELLOW}Documentation check: $(basename "$script")${NC}"
        
        local file_issues=0
        
        # Run documentation checks
        check_script_headers "$script" || ((file_issues+=$?))
        check_function_documentation "$script" || ((file_issues+=$?))
        check_usage_documentation "$script" || ((file_issues+=$?))
        
        if [ $file_issues -eq 0 ]; then
            echo -e "  ${GREEN}✅ Well documented${NC}"
        else
            echo -e "  ${RED}Documentation issues: $file_issues${NC}"
            ((total_issues+=file_issues))
        fi
        
        ((files_checked++))
    done < <(find "$PROJECT_DIR" -name "*.sh" -type f -print0)
    
    # Check for README files
    echo -e "\n${YELLOW}Checking for README files...${NC}"
    check_readme_files "$PROJECT_DIR" || ((total_issues+=$?))
    
    # Summary
    echo -e "\n${BLUE}Shell Script Documentation Summary${NC}"
    echo "Files checked: $files_checked"
    echo "Total documentation issues: $total_issues"
    
    return $total_issues
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi