#!/bin/bash

# Construct Quality Check Script
# Comprehensive quality validation for SwiftUI projects

# Get script directory and project root
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../../.." && pwd )"
VIOLATIONS=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🛡️  Construct Quality Check${NC}"
echo "=========================="
echo ""

# Check 1: Constants enum (forbidden pattern)
check_constants_enum() {
    echo "1. Checking for Constants enum..."
    
    constants=$(grep -r "enum Constants\|enum AppConstants\|enum K {" \
        --include="*.swift" \
        "$PROJECT_ROOT/Template" \
        2>/dev/null)
    
    if [ -n "$constants" ]; then
        echo -e "${RED}❌ Found Constants enum (forbidden pattern):${NC}"
        echo "$constants" | head -3
        VIOLATIONS=$((VIOLATIONS + 1))
    else
        echo -e "${GREEN}✅ No Constants enum found${NC}"
    fi
    echo ""
}

# Check 2: Token usage verification
check_token_usage() {
    echo "2. Verifying token usage..."
    
    # Count token files
    token_files=$(find "$PROJECT_ROOT/Template" -name "*Tokens.swift" -type f | wc -l | tr -d ' ')
    
    if [ "$token_files" -eq 0 ]; then
        echo -e "${YELLOW}⚠️  No token files found${NC}"
    else
        # Check if tokens are being used
        token_usage=$(grep -r "tokens\." --include="*.swift" "$PROJECT_ROOT/Template" 2>/dev/null | wc -l | tr -d ' ')
        
        if [ "$token_usage" -lt 10 ]; then
            echo -e "${YELLOW}⚠️  Low token usage detected (only $token_usage uses)${NC}"
            VIOLATIONS=$((VIOLATIONS + 1))
        else
            echo -e "${GREEN}✅ Good token usage ($token_usage uses across $token_files files)${NC}"
        fi
    fi
    echo ""
}

# Check 3: MARK organization
check_mark_organization() {
    echo "3. Checking MARK organization..."
    
    files_without_marks=0
    for swift_file in $(find "$PROJECT_ROOT/Template" -name "*.swift" -type f); do
        if ! grep -q "// MARK:" "$swift_file"; then
            files_without_marks=$((files_without_marks + 1))
        fi
    done
    
    if [ "$files_without_marks" -gt 5 ]; then
        echo -e "${YELLOW}⚠️  $files_without_marks files lack MARK organization${NC}"
    else
        echo -e "${GREEN}✅ Good MARK usage${NC}"
    fi
    echo ""
}

# Check 4: Background flash prevention
check_background_patterns() {
    echo "4. Checking background flash prevention..."
    
    # Check for single-layer backgrounds
    single_layer=$(grep -r "\.background(.*Color\|\.ignoresSafeArea" \
        --include="*.swift" \
        "$PROJECT_ROOT/Template" \
        2>/dev/null | \
        grep -v "ZStack" | \
        grep -v "// Multi-layer")
    
    if [ -n "$single_layer" ]; then
        echo -e "${YELLOW}⚠️  Single-layer backgrounds found (may cause flashes):${NC}"
        echo "$single_layer" | head -3
        echo -e "${YELLOW}   Use multi-layer ZStack pattern${NC}"
    else
        echo -e "${GREEN}✅ Background patterns look good${NC}"
    fi
    echo ""
}

# Check 5: Async/await patterns
check_async_patterns() {
    echo "5. Checking async/await patterns..."
    
    # Check for completion handlers
    completion_handlers=$(grep -r "completion:.*@escaping\|completionHandler:" \
        --include="*.swift" \
        "$PROJECT_ROOT/Template" \
        2>/dev/null)
    
    if [ -n "$completion_handlers" ]; then
        echo -e "${YELLOW}⚠️  Completion handlers found (use async/await):${NC}"
        echo "$completion_handlers" | head -3
        VIOLATIONS=$((VIOLATIONS + 1))
    else
        echo -e "${GREEN}✅ Using modern async/await${NC}"
    fi
    echo ""
}

# Check 6: @MainActor usage
check_mainactor() {
    echo "6. Checking @MainActor on ViewModels..."
    
    viewmodels_without=$(find "$PROJECT_ROOT/Template" -name "*ViewModel.swift" -type f | while read -r file; do
        if ! grep -q "@MainActor" "$file"; then
            basename "$file"
        fi
    done)
    
    if [ -n "$viewmodels_without" ]; then
        echo -e "${RED}❌ ViewModels missing @MainActor:${NC}"
        echo "$viewmodels_without"
        VIOLATIONS=$((VIOLATIONS + 1))
    else
        echo -e "${GREEN}✅ All ViewModels use @MainActor${NC}"
    fi
    echo ""
}

# Check 7: View/ViewModel separation
check_separation() {
    echo "7. Checking View/ViewModel separation..."
    
    # Check for @Published in Views
    published_in_views=$(grep -l "@Published" $(find "$PROJECT_ROOT/Template" -name "*View.swift" -type f) 2>/dev/null)
    
    if [ -n "$published_in_views" ]; then
        echo -e "${RED}❌ @Published found in Views:${NC}"
        echo "$published_in_views" | while read -r file; do
            echo "  - $(basename "$file")"
        done
        VIOLATIONS=$((VIOLATIONS + 1))
    else
        echo -e "${GREEN}✅ Clean View/ViewModel separation${NC}"
    fi
    echo ""
}

# Check 8: NavigationView usage (deprecated)
check_navigation() {
    echo "8. Checking for deprecated NavigationView..."
    
    nav_view=$(grep -r "NavigationView" \
        --include="*.swift" \
        "$PROJECT_ROOT/Template" \
        2>/dev/null | \
        grep -v "NavigationStack\|navigationViewStyle")
    
    if [ -n "$nav_view" ]; then
        echo -e "${YELLOW}⚠️  NavigationView usage found (use NavigationStack):${NC}"
        echo "$nav_view" | head -3
    else
        echo -e "${GREEN}✅ Using modern navigation${NC}"
    fi
    echo ""
}

# Check 9: Accessibility
check_accessibility() {
    echo "9. Checking accessibility..."
    
    # Check images without labels
    images_no_label=$(grep -r "Image(\|systemName:" \
        --include="*.swift" \
        "$PROJECT_ROOT/Template" \
        2>/dev/null | \
        grep -B1 -A1 "Image" | \
        grep -v "accessibilityLabel\|decorative" | \
        wc -l | tr -d ' ')
    
    if [ "$images_no_label" -gt 10 ]; then
        echo -e "${YELLOW}⚠️  Many images lack accessibility labels${NC}"
    else
        echo -e "${GREEN}✅ Good accessibility coverage${NC}"
    fi
    echo ""
}

# Check 10: Test coverage
check_tests() {
    echo "10. Checking test coverage..."
    
    # Count test files
    test_files=$(find "$PROJECT_ROOT/Template/Tests" -name "*Test*.swift" -type f 2>/dev/null | wc -l | tr -d ' ')
    
    # Count source files
    source_files=$(find "$PROJECT_ROOT/Template/iOS-App" -name "*.swift" -type f 2>/dev/null | wc -l | tr -d ' ')
    
    if [ "$test_files" -eq 0 ]; then
        echo -e "${YELLOW}⚠️  No test files found${NC}"
    elif [ "$source_files" -gt 0 ] && [ "$test_files" -lt $((source_files / 4)) ]; then
        echo -e "${YELLOW}⚠️  Low test coverage (only $test_files test files for $source_files source files)${NC}"
    else
        echo -e "${GREEN}✅ Test files present ($test_files files)${NC}"
    fi
    echo ""
}

# Check 11: Performance patterns
check_performance() {
    echo "11. Checking performance patterns..."
    
    # Check for heavy operations in body
    heavy_in_body=$(grep -r "\.onAppear.*Task\|\.task.*sleep\|for.*in.*\.onAppear" \
        --include="*View.swift" \
        "$PROJECT_ROOT/Template" \
        2>/dev/null)
    
    # Check for proper lazy loading
    large_foreach=$(grep -r "ForEach.*\.indices\|ForEach.*0\.\.\<" \
        --include="*.swift" \
        "$PROJECT_ROOT/Template" \
        2>/dev/null | \
        grep -v "LazyVStack\|LazyHStack")
    
    if [ -n "$heavy_in_body" ] || [ -n "$large_foreach" ]; then
        echo -e "${YELLOW}⚠️  Potential performance issues found${NC}"
    else
        echo -e "${GREEN}✅ Following performance best practices${NC}"
    fi
    echo ""
}

# Summary
echo "=========================="
echo -e "${BLUE}Quality Check Summary:${NC}"
echo ""

if [ $VIOLATIONS -eq 0 ]; then
    echo -e "${GREEN}✅ All quality checks passed!${NC}"
    echo -e "${GREEN}Your code meets Construct quality standards.${NC}"
    echo ""
    echo -e "${BLUE}Trust The Process.${NC}"
    exit 0
else
    echo -e "${RED}❌ Found $VIOLATIONS quality issues${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Fix the violations above"
    echo "2. Run 'construct-protect' again"
    echo "3. Use 'construct-check' for architecture issues"
    exit 1
fi