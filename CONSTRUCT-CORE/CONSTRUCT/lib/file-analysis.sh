#!/bin/bash

# File Analysis Library for CONSTRUCT
# Functions to parse Swift files for MVVM patterns and architecture validation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Find all Swift files in a directory
find_swift_files() {
    local directory="$1"
    find "$directory" -name "*.swift" -type f 2>/dev/null || true
}

# Extract ViewModels from Swift files
find_viewmodels() {
    local directory="$1"
    find_swift_files "$directory" | xargs grep -l "@MainActor.*ViewModel\|class.*ViewModel.*ObservableObject" 2>/dev/null || true
}

# Extract Views from Swift files
find_views() {
    local directory="$1"
    find_swift_files "$directory" | xargs grep -l "struct.*View\|View {" 2>/dev/null || true
}

# Extract Services from Swift files
find_services() {
    local directory="$1"
    find_swift_files "$directory" | xargs grep -l "protocol.*Service\|class.*Service" 2>/dev/null || true
}

# Check for hardcoded values in Swift files
find_hardcoded_values() {
    local directory="$1"
    echo -e "${BLUE}Checking for hardcoded values in $directory${NC}"
    
    # Look for common hardcoded patterns
    find_swift_files "$directory" | xargs grep -n "\\.frame(width: [0-9]\|height: [0-9]\|\.font(.size: [0-9]\|Color(red:\|padding([0-9]" 2>/dev/null || true
}

# Check for MVVM violations
check_mvvm_violations() {
    local directory="$1"
    echo -e "${BLUE}Checking MVVM violations in $directory${NC}"
    
    # Look for business logic in Views
    echo -e "${YELLOW}Checking for business logic in Views:${NC}"
    find_swift_files "$directory" | xargs grep -n "URLSession\|NetworkManager\|APIService\|\.fetch\|\.save\|\.delete" 2>/dev/null || true
    
    # Look for @State with business data
    echo -e "${YELLOW}Checking for @State with business data:${NC}"
    find_swift_files "$directory" | xargs grep -n "@State.*User\|@State.*Product\|@State.*Data\|@State.*Model" 2>/dev/null || true
}

# Count components by type
count_components() {
    local directory="$1"
    
    local viewmodels=$(find_viewmodels "$directory" | wc -l)
    local views=$(find_views "$directory" | wc -l)
    local services=$(find_services "$directory" | wc -l)
    
    echo -e "${GREEN}Component counts in $directory:${NC}"
    echo "ViewModels: $viewmodels"
    echo "Views: $views"
    echo "Services: $services"
}

# Extract design tokens usage
find_design_tokens() {
    local directory="$1"
    echo -e "${BLUE}Design token usage in $directory${NC}"
    
    find_swift_files "$directory" | xargs grep -n "Spacing\.\|Color\.\|Font\.\|tokens\." 2>/dev/null || true
}

# Generate architecture summary
generate_architecture_summary() {
    local directory="$1"
    local output_file="$2"
    
    echo "# Architecture Summary for $directory" > "$output_file"
    echo "Generated: $(date)" >> "$output_file"
    echo "" >> "$output_file"
    
    echo "## Component Counts" >> "$output_file"
    count_components "$directory" >> "$output_file"
    echo "" >> "$output_file"
    
    echo "## MVVM Violations" >> "$output_file"
    check_mvvm_violations "$directory" >> "$output_file"
    echo "" >> "$output_file"
    
    echo "## Hardcoded Values" >> "$output_file"
    find_hardcoded_values "$directory" >> "$output_file"
    echo "" >> "$output_file"
}

# Check if directory follows MVVM structure
validate_mvvm_structure() {
    local directory="$1"
    local issues=0
    
    echo -e "${BLUE}Validating MVVM structure in $directory${NC}"
    
    # Check for proper directory structure
    if [ ! -d "$directory/Features" ]; then
        echo -e "${RED}❌ Missing Features directory${NC}"
        ((issues++))
    fi
    
    if [ ! -d "$directory/Shared" ]; then
        echo -e "${RED}❌ Missing Shared directory${NC}"
        ((issues++))
    fi
    
    if [ ! -d "$directory/Core/DesignSystem" ]; then
        echo -e "${RED}❌ Missing Core/DesignSystem directory${NC}"
        ((issues++))
    fi
    
    # Check for design system files
    if [ ! -f "$directory/Core/DesignSystem/Colors.swift" ]; then
        echo -e "${RED}❌ Missing Colors.swift${NC}"
        ((issues++))
    fi
    
    if [ ! -f "$directory/Core/DesignSystem/Spacing.swift" ]; then
        echo -e "${RED}❌ Missing Spacing.swift${NC}"
        ((issues++))
    fi
    
    if [ $issues -eq 0 ]; then
        echo -e "${GREEN}✅ MVVM structure validation passed${NC}"
    else
        echo -e "${RED}❌ Found $issues structural issues${NC}"
    fi
    
    return $issues
}