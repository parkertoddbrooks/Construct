#!/bin/bash

# Python Language Pattern - Quality Validator
# Validates Python code quality standards

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

# Accept PROJECT_DIR as parameter
PROJECT_DIR="${1:-.}"
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

echo -e "${BLUE}🐍 Python Language Quality Validation${NC}"
echo "--------------------------------------"
echo "Project: $PROJECT_DIR"
echo ""

# Python-specific quality checks
check_python_style() {
    local file="$1"
    local issues=0
    
    # Check for camelCase functions (not __init__ style)
    if grep -E "def [a-z]+[A-Z]" "$file" | grep -v "def __"; then
        echo -e "  ${YELLOW}⚠️  Functions should use snake_case${NC}"
        ((issues++))
    fi
    
    # Check for tab indentation
    if grep -P "\t" "$file"; then
        echo -e "  ${YELLOW}⚠️  Use spaces for indentation, not tabs${NC}"
        ((issues++))
    fi
    
    # Check for bare except
    if grep -E "except:" "$file"; then
        echo -e "  ${RED}❌ Bare except clause found${NC}"
        ((issues++))
    fi
    
    return $issues
}

# Main validation
main() {
    local total_issues=0
    local files_checked=0
    
    # Find all Python files
    while IFS= read -r -d '' file; do
        if [[ -f "$file" ]]; then
            echo -e "\n${YELLOW}Checking: ${file#$PROJECT_DIR/}${NC}"
            
            if check_python_style "$file"; then
                echo -e "  ${GREEN}✅ No issues found${NC}"
            else
                total_issues=$((total_issues + $?))
            fi
            
            ((files_checked++))
        fi
    done < <(find "$PROJECT_DIR" -name "*.py" -type f -not -path "*/venv/*" -not -path "*/__pycache__/*" -print0)
    
    # Summary
    echo -e "\n${BLUE}Summary${NC}"
    echo "Files checked: $files_checked"
    echo "Total issues: $total_issues"
    
    if [ $total_issues -eq 0 ]; then
        echo -e "${GREEN}✅ All Python quality checks passed${NC}"
    else
        echo -e "${YELLOW}⚠️  Found $total_issues quality issues${NC}"
    fi
    
    return $total_issues
}

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 [PROJECT_DIR]"
    echo "Validates Python code quality standards"
    echo ""
    echo "Checks for:"
    echo "  - snake_case naming conventions"
    echo "  - Space indentation (not tabs)"
    echo "  - Specific exception handling"
    exit 0
fi

main