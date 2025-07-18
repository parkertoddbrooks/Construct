#!/bin/bash

# Orchestration Pattern Validator
# Checks shell scripts for monolithic anti-patterns

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../../../.." && pwd)"

# Source common functions
source "$PROJECT_ROOT/CONSTRUCT-CORE/CONSTRUCT/lib/common-patterns.sh"

echo -e "${BLUE}🔍 Checking orchestration patterns...${NC}"

# Check for monolithic scripts
check_monolithic_scripts() {
    local issues=0
    
    while IFS= read -r -d '' script; do
        local line_count=$(wc -l < "$script")
        local function_count=$(grep -c "^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*(" "$script" 2>/dev/null || echo 0)
        
        # Check if script is too long
        if [ "$line_count" -gt 50 ]; then
            echo -e "${YELLOW}⚠️ Monolithic script: $(basename "$script") ($line_count lines)${NC}"
            issues=$((issues + 1))
        fi
        
        # Check if script has many functions but no lib separation
        if [ "$function_count" -gt 3 ]; then
            local script_dir=$(dirname "$script")
            if [ ! -d "$script_dir/../lib" ] && [ ! -d "$script_dir/lib" ]; then
                echo -e "${YELLOW}⚠️ Complex script without lib: $(basename "$script") ($function_count functions)${NC}"
                issues=$((issues + 1))
            fi
        fi
        
    done < <(find "$PROJECT_ROOT" -name "*.sh" -type f -not -path "*/.*" -print0)
    
    return $issues
}

# Check for duplicate logic
check_duplicate_logic() {
    local issues=0
    
    # Look for common function patterns that should be in lib
    local common_patterns=(
        "get_script_dir"
        "get_project_root"
        "validate_input"
        "cleanup_temp"
        "show_help"
    )
    
    for pattern in "${common_patterns[@]}"; do
        local matches=$(grep -r "$pattern" "$PROJECT_ROOT" --include="*.sh" | wc -l | tr -d ' ')
        if [ "$matches" -gt 2 ]; then
            echo -e "${YELLOW}⚠️ Duplicate pattern '$pattern' found in $matches files${NC}"
            echo "  Consider moving to lib/common-patterns.sh"
            issues=$((issues + 1))
        fi
    done
    
    return $issues
}

# Main validation
main() {
    local total_issues=0
    
    echo -e "${BLUE}Checking for monolithic scripts...${NC}"
    if ! check_monolithic_scripts; then
        total_issues=$((total_issues + $?))
    fi
    
    echo -e "${BLUE}Checking for duplicate logic...${NC}"
    if ! check_duplicate_logic; then
        total_issues=$((total_issues + $?))
    fi
    
    # Summary
    if [ $total_issues -eq 0 ]; then
        echo -e "${GREEN}✅ All scripts follow orchestration patterns${NC}"
    else
        echo -e "${YELLOW}⚠️ Found $total_issues orchestration issues${NC}"
        echo ""
        echo "💡 Recommendations:"
        echo "  - Split scripts >50 lines into main + lib"
        echo "  - Extract common functions to lib/"
        echo "  - Use orchestration pattern for complex scripts"
    fi
    
    return $total_issues
}

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0"
    echo "Validates shell scripts follow orchestration patterns"
    echo ""
    echo "Checks for:"
    echo "  - Monolithic scripts >50 lines"
    echo "  - Scripts with >3 functions without lib separation"
    echo "  - Duplicate logic that should be in lib/"
    echo ""
    echo "Exit code = number of issues found"
    exit 0
fi

main "$@"