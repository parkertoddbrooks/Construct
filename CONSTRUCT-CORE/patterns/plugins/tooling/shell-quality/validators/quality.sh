#!/bin/bash

# Shell Quality Pattern - Quality Validator
# Validates shell script quality standards

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
CONSTRUCT_CORE="$(cd "$PATTERNS_ROOT/../.." && pwd)"
CONSTRUCT_ROOT="$(cd "$CONSTRUCT_CORE/.." && pwd)"

echo -e "${BLUE}🐚 Shell Script Quality Validation${NC}"
echo "----------------------------------"

# Quality checks for shell scripts
check_script_documentation() {
    local file="$1"
    local issues=0
    
    # Check for file header documentation
    if ! head -n 10 "$file" | grep -q "^# .*Description\|^# .*Purpose"; then
        echo -e "  ${YELLOW}⚠️  Missing file header documentation${NC}"
        ((issues++))
    fi
    
    # Check for usage information
    if grep -q "getopts\|--help" "$file"; then
        if ! grep -q "Usage:" "$file"; then
            echo -e "  ${YELLOW}⚠️  Has options but missing usage documentation${NC}"
            ((issues++))
        fi
    fi
    
    return $issues
}

check_code_style() {
    local file="$1"
    local issues=0
    
    # Check for inconsistent indentation
    if grep -q "^  [^ ]" "$file" && grep -q "^    [^ ]" "$file"; then
        echo -e "  ${YELLOW}⚠️  Inconsistent indentation (mix of 2 and 4 spaces)${NC}"
        ((issues++))
    fi
    
    # Check for line length
    local long_lines=$(awk 'length > 100' "$file" | wc -l)
    if [ "$long_lines" -gt 5 ]; then
        echo -e "  ${YELLOW}⚠️  $long_lines lines exceed 100 characters${NC}"
        ((issues++))
    fi
    
    # Check for trailing whitespace
    if grep -q "[[:space:]]$" "$file"; then
        echo -e "  ${YELLOW}⚠️  Contains trailing whitespace${NC}"
        ((issues++))
    fi
    
    return $issues
}

check_variable_naming() {
    local file="$1"
    local issues=0
    
    # Check for lowercase global variables
    if grep -E "^[a-z_]+=" "$file" | grep -v "local" | grep -v "readonly"; then
        echo -e "  ${YELLOW}⚠️  Global variables should be UPPERCASE${NC}"
        ((issues++))
    fi
    
    # Check for undeclared variables
    if grep -E "\$[a-zA-Z_]+" "$file" | grep -v "\${" | grep -v "local\|readonly\|export" | grep -q "[a-z]"; then
        echo -e "  ${YELLOW}⚠️  Possibly using undeclared variables${NC}"
        ((issues++))
    fi
    
    return $issues
}

check_function_quality() {
    local file="$1"
    local issues=0
    
    # Check for functions without local variables
    if grep -A5 "^[a-zA-Z_]*().*{" "$file" | grep -q "^[[:space:]]*[a-z_]*=.*" | grep -v "local"; then
        echo -e "  ${YELLOW}⚠️  Functions using variables without 'local' declaration${NC}"
        ((issues++))
    fi
    
    # Check for exit vs return in functions
    if grep -A10 "^[a-zA-Z_]*().*{" "$file" | grep -q "exit [0-9]"; then
        echo -e "  ${YELLOW}⚠️  Functions using 'exit' instead of 'return'${NC}"
        ((issues++))
    fi
    
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
        # Skip scripts-backup directory
        [[ "$script" == *"/scripts-backup"* ]] && continue
        
        echo -e "\n${YELLOW}Quality check: $(basename "$script")${NC}"
        
        local file_issues=0
        
        # Run quality checks
        check_script_documentation "$script" || ((file_issues+=$?))
        check_code_style "$script" || ((file_issues+=$?))
        check_variable_naming "$script" || ((file_issues+=$?))
        check_function_quality "$script" || ((file_issues+=$?))
        
        if [ $file_issues -eq 0 ]; then
            echo -e "  ${GREEN}✅ Meets quality standards${NC}"
        else
            echo -e "  ${RED}Quality issues: $file_issues${NC}"
            ((total_issues+=file_issues))
        fi
        
        ((files_checked++))
    done < <(find "$PROJECT_DIR" -name "*.sh" -type f -print0)
    
    # Summary
    echo -e "\n${BLUE}Shell Quality Summary${NC}"
    echo "Files checked: $files_checked"
    echo "Total quality issues: $total_issues"
    
    return $total_issues
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi