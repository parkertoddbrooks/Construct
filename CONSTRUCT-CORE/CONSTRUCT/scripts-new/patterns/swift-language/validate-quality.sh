#!/bin/bash

# Swift Language Pattern - Quality Validator
# Validates Swift code quality standards

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATTERN_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONSTRUCT_ROOT="$(cd "$PATTERN_ROOT/../../../.." && pwd)"

echo -e "${BLUE}🦉 Swift Language Quality Validation${NC}"
echo "------------------------------------"

# Swift-specific quality checks
check_swift_naming() {
    local file="$1"
    local issues=0
    
    # Check for non-camelCase variables
    if grep -E "let [A-Z_]+ =|var [A-Z_]+ =" "$file" | grep -v "static"; then
        echo -e "  ${YELLOW}⚠️  Variables should use camelCase${NC}"
        ((issues++))
    fi
    
    # Check for snake_case (not Swift convention)
    if grep -E "func [a-z]+_[a-z]+|let [a-z]+_[a-z]+|var [a-z]+_[a-z]+" "$file"; then
        echo -e "  ${YELLOW}⚠️  Found snake_case naming (use camelCase)${NC}"
        ((issues++))
    fi
    
    # Check for types starting with lowercase
    if grep -E "class [a-z]|struct [a-z]|enum [a-z]" "$file"; then
        echo -e "  ${RED}❌ Types should start with uppercase${NC}"
        ((issues++))
    fi
    
    return $issues
}

check_swift_safety() {
    local file="$1"
    local issues=0
    
    # Check for force unwrapping
    local force_unwraps=$(grep -o "!" "$file" | grep -v "!=" | wc -l)
    if [ "$force_unwraps" -gt 3 ]; then
        echo -e "  ${YELLOW}⚠️  Excessive force unwrapping (!) - $force_unwraps instances${NC}"
        ((issues++))
    fi
    
    # Check for implicitly unwrapped optionals
    if grep -E "var.*:.*!" "$file" | grep -v "@IBOutlet"; then
        echo -e "  ${YELLOW}⚠️  Implicitly unwrapped optionals (consider regular optionals)${NC}"
        ((issues++))
    fi
    
    # Check for try! usage
    if grep -q "try!" "$file"; then
        echo -e "  ${RED}❌ Using try! (use do-catch or try?)${NC}"
        ((issues++))
    fi
    
    return $issues
}

check_swift_concurrency() {
    local file="$1"
    local issues=0
    
    # Check for @MainActor on ViewModels
    if grep -q "class.*ViewModel" "$file"; then
        if ! grep -B2 "class.*ViewModel" "$file" | grep -q "@MainActor"; then
            echo -e "  ${YELLOW}⚠️  ViewModel missing @MainActor annotation${NC}"
            ((issues++))
        fi
    fi
    
    # Check for DispatchQueue.main usage (should use async/await)
    if grep -q "DispatchQueue.main" "$file"; then
        echo -e "  ${YELLOW}⚠️  Using DispatchQueue instead of async/await${NC}"
        ((issues++))
    fi
    
    # Check for completion handlers
    if grep -E "completion:.*\(@escaping.*\) ->" "$file"; then
        echo -e "  ${YELLOW}⚠️  Using completion handlers (consider async/await)${NC}"
        ((issues++))
    fi
    
    return $issues
}

check_swift_documentation() {
    local file="$1"
    local issues=0
    
    # Check for public functions without documentation
    if grep -E "public func|open func" "$file"; then
        local public_funcs=$(grep -c "public func\|open func" "$file")
        local doc_comments=$(grep -B1 "public func\|open func" "$file" | grep -c "///" || true)
        if [ "$doc_comments" -lt "$public_funcs" ]; then
            echo -e "  ${YELLOW}⚠️  Public functions missing documentation${NC}"
            ((issues++))
        fi
    fi
    
    # Check for TODO/FIXME without ticket numbers
    if grep -E "// TODO|// FIXME" "$file" | grep -v "TODO.*[A-Z]+-[0-9]"; then
        echo -e "  ${YELLOW}⚠️  TODOs without ticket numbers${NC}"
        ((issues++))
    fi
    
    return $issues
}

# Main validation
main() {
    local total_issues=0
    local files_checked=0
    
    echo "Scanning Swift files..."
    
    # Find all Swift files
    while IFS= read -r -d '' swift_file; do
        echo -e "\n${YELLOW}Quality check: $(basename "$swift_file")${NC}"
        
        local file_issues=0
        
        # Run Swift quality checks
        check_swift_naming "$swift_file" || ((file_issues+=$?))
        check_swift_safety "$swift_file" || ((file_issues+=$?))
        check_swift_concurrency "$swift_file" || ((file_issues+=$?))
        check_swift_documentation "$swift_file" || ((file_issues+=$?))
        
        if [ $file_issues -eq 0 ]; then
            echo -e "  ${GREEN}✅ Meets Swift quality standards${NC}"
        else
            echo -e "  ${RED}Quality issues: $file_issues${NC}"
            ((total_issues+=file_issues))
        fi
        
        ((files_checked++))
    done < <(find "$CONSTRUCT_ROOT" -name "*.swift" -type f -print0)
    
    # Summary
    echo -e "\n${BLUE}Swift Quality Summary${NC}"
    echo "Files checked: $files_checked"
    echo "Total quality issues: $total_issues"
    
    return $total_issues
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi