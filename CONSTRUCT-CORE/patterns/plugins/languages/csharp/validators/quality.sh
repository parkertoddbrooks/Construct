#!/bin/bash

# C# Language Pattern - Quality Validator
# Validates C# code quality standards

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

echo -e "${BLUE}#️⃣ C# Language Quality Validation${NC}"
echo "----------------------------------"

# C#-specific quality checks
check_csharp_naming() {
    local file="$1"
    local issues=0
    
    # Check for non-PascalCase classes/interfaces
    if grep -E "class [a-z]|interface [a-z]" "$file"; then
        echo -e "  ${RED}❌ Classes/Interfaces should use PascalCase${NC}"
        ((issues++))
    fi
    
    # Check for public fields (should be properties)
    if grep -E "public [a-zA-Z<>]+ [a-z]+;" "$file" | grep -v "const"; then
        echo -e "  ${YELLOW}⚠️  Public fields should be properties${NC}"
        ((issues++))
    fi
    
    # Check for underscore prefix on private fields
    if grep -E "private [a-zA-Z<>]+ [a-zA-Z]" "$file" | grep -v "_[a-z]"; then
        echo -e "  ${YELLOW}⚠️  Private fields should start with underscore${NC}"
        ((issues++))
    fi
    
    return $issues
}

check_csharp_async() {
    local file="$1"
    local issues=0
    
    # Check for async methods without Async suffix
    if grep -E "async Task.*\(" "$file" | grep -v "Async\("; then
        echo -e "  ${YELLOW}⚠️  Async methods should end with 'Async'${NC}"
        ((issues++))
    fi
    
    # Check for .Result usage (blocking)
    if grep -q "\.Result" "$file"; then
        echo -e "  ${RED}❌ Using .Result (use await instead)${NC}"
        ((issues++))
    fi
    
    # Check for Task.Run in API controllers
    if grep -q "Controller" "$file" && grep -q "Task.Run" "$file"; then
        echo -e "  ${YELLOW}⚠️  Task.Run in controller (avoid in ASP.NET)${NC}"
        ((issues++))
    fi
    
    # Check for async void (except event handlers)
    if grep -E "async void" "$file" | grep -v "EventHandler"; then
        echo -e "  ${RED}❌ async void methods (use async Task)${NC}"
        ((issues++))
    fi
    
    return $issues
}

check_csharp_null_safety() {
    local file="$1"
    local issues=0
    
    # Check for nullable reference types usage
    if ! grep -q "#nullable enable" "$file"; then
        echo -e "  ${YELLOW}⚠️  Consider enabling nullable reference types${NC}"
        ((issues++))
    fi
    
    # Check for null checks on non-nullable
    if grep -E "!= null\s*\)" "$file" | grep -v "?"; then
        echo -e "  ${YELLOW}⚠️  Null checks on possibly non-nullable types${NC}"
        ((issues++))
    fi
    
    # Check for string.IsNullOrEmpty usage
    if grep -q "== null.*==.*\"\"" "$file"; then
        echo -e "  ${YELLOW}⚠️  Use string.IsNullOrEmpty() instead${NC}"
        ((issues++))
    fi
    
    return $issues
}

check_csharp_patterns() {
    local file="$1"
    local issues=0
    
    # Check for var usage consistency
    local var_count=$(grep -c "var " "$file" || true)
    local explicit_count=$(grep -E "(string|int|bool|List<|Dictionary<)" "$file" | grep "=" | wc -l)
    if [ "$var_count" -gt 0 ] && [ "$explicit_count" -gt "$var_count" ]; then
        echo -e "  ${YELLOW}⚠️  Inconsistent var usage${NC}"
        ((issues++))
    fi
    
    # Check for using statements
    if grep -q "SqlConnection\|FileStream\|HttpClient" "$file"; then
        if ! grep -q "using (" "$file"; then
            echo -e "  ${YELLOW}⚠️  IDisposable objects without using statements${NC}"
            ((issues++))
        fi
    fi
    
    # Check for LINQ vs foreach
    if grep -c "foreach" "$file" > 5; then
        echo -e "  ${YELLOW}⚠️  Consider LINQ for collection operations${NC}"
        ((issues++))
    fi
    
    return $issues
}

# Main validation
main() {
    local total_issues=0
    local files_checked=0
    
    echo "Scanning C# files..."
    
    # Find all C# files
    while IFS= read -r -d '' csharp_file; do
        echo -e "\n${YELLOW}Quality check: $(basename "$csharp_file")${NC}"
        
        local file_issues=0
        
        # Run C# quality checks
        check_csharp_naming "$csharp_file" || ((file_issues+=$?))
        check_csharp_async "$csharp_file" || ((file_issues+=$?))
        check_csharp_null_safety "$csharp_file" || ((file_issues+=$?))
        check_csharp_patterns "$csharp_file" || ((file_issues+=$?))
        
        if [ $file_issues -eq 0 ]; then
            echo -e "  ${GREEN}✅ Meets C# quality standards${NC}"
        else
            echo -e "  ${RED}Quality issues: $file_issues${NC}"
            ((total_issues+=file_issues))
        fi
        
        ((files_checked++))
    done < <(find "$CONSTRUCT_ROOT" -name "*.cs" -type f -print0)
    
    # Summary
    echo -e "\n${BLUE}C# Quality Summary${NC}"
    echo "Files checked: $files_checked"
    echo "Total quality issues: $total_issues"
    
    return $total_issues
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi