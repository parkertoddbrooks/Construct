#!/bin/bash

# Shell Scripting Pattern - Architecture Validator
# Validates shell script best practices and patterns

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

# Source pattern-specific libraries
source "$CONSTRUCT_CORE/CONSTRUCT/lib/shell-scripting/validation.sh" 2>/dev/null || true
source "$CONSTRUCT_CORE/CONSTRUCT/lib/common-patterns.sh"

echo -e "${BLUE}🐚 Shell Scripting Pattern Validation${NC}"
echo "-------------------------------------"

# Pattern-specific configuration
SHELL_CONFIG="$CONSTRUCT_CORE/CONSTRUCT/config/shell-scripting/rules.yaml"

# Validation functions
check_shell_script_structure() {
    local file="$1"
    local issues=0
    
    # Check for shebang
    if ! head -n 1 "$file" | grep -q "^#!/bin/bash"; then
        echo -e "  ${RED}❌ Missing or incorrect shebang${NC}"
        ((issues++))
    fi
    
    # Check for set -e
    if ! grep -q "set -e" "$file"; then
        echo -e "  ${YELLOW}⚠️  Missing 'set -e' for error handling${NC}"
        ((issues++))
    fi
    
    # Check for proper function documentation
    if grep -q "^[a-zA-Z_]*().*{" "$file"; then
        local funcs=$(grep -E "^[a-zA-Z_]+\(\)" "$file" | wc -l)
        local docs=$(grep -B2 "^[a-zA-Z_]+\(\)" "$file" | grep -c "^#" || true)
        if [ "$docs" -lt "$funcs" ]; then
            echo -e "  ${YELLOW}⚠️  Some functions lack documentation${NC}"
            ((issues++))
        fi
    fi
    
    # Check for color definitions
    if grep -q "echo.*\\\033" "$file" && ! grep -q "NC=.*033.*0m" "$file"; then
        echo -e "  ${YELLOW}⚠️  Using colors without NC (No Color) reset${NC}"
        ((issues++))
    fi
    
    return $issues
}

check_path_handling() {
    local file="$1"
    local issues=0
    
    # Check for hardcoded paths
    if grep -E "/Users/|/home/|/opt/" "$file" | grep -v "^#"; then
        echo -e "  ${RED}❌ Hardcoded paths detected${NC}"
        ((issues++))
    fi
    
    # Check for proper path resolution
    if grep -q "dirname.*BASH_SOURCE" "$file"; then
        if ! grep -q "cd.*dirname.*pwd" "$file"; then
            echo -e "  ${YELLOW}⚠️  Using dirname without cd && pwd pattern${NC}"
            ((issues++))
        fi
    fi
    
    return $issues
}

check_error_handling() {
    local file="$1"
    local issues=0
    
    # Check for commands without error checking
    if grep -E "^[[:space:]]*(cp|mv|rm|mkdir)" "$file" | grep -v "||" | grep -v "&&" | grep -v "if"; then
        echo -e "  ${YELLOW}⚠️  Some commands lack error checking${NC}"
        ((issues++))
    fi
    
    # Check for silent operations
    if grep -E "2>/dev/null[[:space:]]*$" "$file" | grep -v "|| true"; then
        echo -e "  ${YELLOW}⚠️  Suppressing errors without fallback${NC}"
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
        # Skip scripts-backup directory to avoid recursion
        [[ "$script" == *"/scripts-backup"* ]] && continue
        
        echo -e "\n${YELLOW}Checking: $(basename "$script")${NC}"
        
        local file_issues=0
        
        # Run checks
        check_shell_script_structure "$script" || ((file_issues+=$?))
        check_path_handling "$script" || ((file_issues+=$?))
        check_error_handling "$script" || ((file_issues+=$?))
        
        if [ $file_issues -eq 0 ]; then
            echo -e "  ${GREEN}✅ All checks passed${NC}"
        else
            echo -e "  ${RED}Found $file_issues issues${NC}"
            ((total_issues+=file_issues))
        fi
        
        ((files_checked++))
    done < <(find "$PROJECT_DIR" -name "*.sh" -type f -print0)
    
    # Summary
    echo -e "\n${BLUE}Shell Scripting Pattern Summary${NC}"
    echo "Files checked: $files_checked"
    echo "Total issues: $total_issues"
    
    # Return number of issues as exit code
    return $total_issues
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi