#!/bin/bash

# iOS UI Library Pattern - Usage Validator
# Validates proper usage of iOS UI components

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
CONSTRUCT_CORE="$CONSTRUCT_ROOT/CONSTRUCT-CORE"

echo -e "${BLUE}📱 iOS UI Library Pattern Validation${NC}"
echo "------------------------------------"

# Check if this is an iOS project
is_ios_project() {
    if find "$CONSTRUCT_ROOT" -name "*.swift" -o -name "*.xcodeproj" | head -1 | grep -q .; then
        return 0
    else
        echo -e "${YELLOW}Not an iOS project, skipping iOS UI validation${NC}"
        return 1
    fi
}

# Validate iOS UI component usage
check_ui_components() {
    local file="$1"
    local issues=0
    
    # Check for hardcoded frames instead of using components
    if grep -E "\.frame\(width:\s*[0-9]+.*height:\s*[0-9]+" "$file"; then
        echo -e "  ${RED}❌ Hardcoded frame values instead of design tokens${NC}"
        ((issues++))
    fi
    
    # Check for native Button usage instead of AppleButton
    if grep -E "^[[:space:]]*Button\(" "$file" | grep -v "AppleButton"; then
        echo -e "  ${YELLOW}⚠️  Using SwiftUI Button instead of AppleButton${NC}"
        ((issues++))
    fi
    
    # Check for NavigationView (deprecated)
    if grep -q "NavigationView" "$file"; then
        echo -e "  ${YELLOW}⚠️  Using deprecated NavigationView${NC}"
        ((issues++))
    fi
    
    # Check for background implementation
    if grep -q "\.background(Color\." "$file"; then
        if ! grep -q "ZStack.*background.*ignoresSafeArea" "$file"; then
            echo -e "  ${YELLOW}⚠️  Possible background flash issue${NC}"
            ((issues++))
        fi
    fi
    
    return $issues
}

check_accessibility() {
    local file="$1"
    local issues=0
    
    # Check for images without accessibility labels
    if grep -q "Image(" "$file"; then
        local images=$(grep -c "Image(" "$file")
        local labels=$(grep -c "accessibilityLabel" "$file")
        if [ "$labels" -lt "$images" ]; then
            echo -e "  ${YELLOW}⚠️  Some images lack accessibility labels${NC}"
            ((issues++))
        fi
    fi
    
    # Check for fixed font sizes
    if grep -E "\.font\(\.system\(size:\s*[0-9]+" "$file"; then
        echo -e "  ${YELLOW}⚠️  Using fixed font sizes instead of dynamic type${NC}"
        ((issues++))
    fi
    
    return $issues
}

generate_component_report() {
    local report_file="$1"
    local components_used=""
    
    # Scan for Apple components
    while IFS= read -r -d '' swift_file; do
        if grep -q "Apple" "$swift_file"; then
            local found_components=$(grep -o "Apple[A-Z][a-zA-Z]*" "$swift_file" | sort -u)
            if [ -n "$found_components" ]; then
                components_used+="### $(basename "$swift_file")\n"
                components_used+="$found_components\n\n"
            fi
        fi
    done < <(find "$CONSTRUCT_ROOT" -name "*.swift" -type f -print0)
    
    if [ -n "$components_used" ]; then
        {
            echo "## iOS UI Components Used"
            echo ""
            echo -e "$components_used"
        } >> "$report_file"
    fi
}

# Main validation
main() {
    if ! is_ios_project; then
        return 0
    fi
    
    local total_issues=0
    local files_checked=0
    
    echo "Scanning Swift UI files..."
    
    # Find all Swift files with UI code
    while IFS= read -r -d '' swift_file; do
        # Skip if not a View file
        if ! grep -q "View\|SwiftUI" "$swift_file"; then
            continue
        fi
        
        echo -e "\n${YELLOW}Checking: $(basename "$swift_file")${NC}"
        
        local file_issues=0
        
        # Run checks
        check_ui_components "$swift_file" || ((file_issues+=$?))
        check_accessibility "$swift_file" || ((file_issues+=$?))
        
        if [ $file_issues -eq 0 ]; then
            echo -e "  ${GREEN}✅ Follows iOS UI patterns${NC}"
        else
            echo -e "  ${RED}Found $file_issues UI issues${NC}"
            ((total_issues+=file_issues))
        fi
        
        ((files_checked++))
    done < <(find "$CONSTRUCT_ROOT" -name "*.swift" -type f -print0)
    
    # Generate component usage report
    local report_dir="$CONSTRUCT_ROOT/AI/docs/automated"
    mkdir -p "$report_dir"
    local report_file="$report_dir/ios-ui-usage-$(date +%Y-%m-%d).md"
    
    {
        echo "# iOS UI Library Usage Report"
        echo "Generated: $(date)"
        echo ""
        echo "## Summary"
        echo "- Files checked: $files_checked"
        echo "- Total issues: $total_issues"
        echo ""
    } > "$report_file"
    
    generate_component_report "$report_file"
    
    # Summary
    echo -e "\n${BLUE}iOS UI Pattern Summary${NC}"
    echo "Files checked: $files_checked"
    echo "Total issues: $total_issues"
    echo "Report: $report_file"
    
    return $total_issues
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi