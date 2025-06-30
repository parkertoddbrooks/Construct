#!/bin/bash

# Template Utilities Library for CONSTRUCT
# Functions for managing templates and ensuring template integrity

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the CONSTRUCT root directory
get_construct_root() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    echo "$(dirname "$(dirname "$script_dir")")"
}

# Get paths to key directories
get_templates_dir() {
    echo "$(get_construct_root)/CONSTUCT-dev/Templates"
}

# Get the path to the user project directory
get_user_project_dir() {
    echo "$(get_construct_root)/USER-project-files"
}

# Validate template integrity
validate_template_integrity() {
    local templates_dir="$(get_templates_dir)"
    local issues=0
    
    echo -e "${BLUE}Validating template integrity...${NC}"
    
    # Check for required template directories
    if [ ! -d "$templates_dir/iOS-App" ]; then
        echo -e "${RED}❌ Missing Templates/iOS-App directory${NC}"
        ((issues++))
    fi
    
    if [ ! -d "$templates_dir/Watch-App" ]; then
        echo -e "${RED}❌ Missing Templates/Watch-App directory${NC}"
        ((issues++))
    fi
    
    if [ ! -d "$templates_dir/AI" ]; then
        echo -e "${RED}❌ Missing Templates/AI directory${NC}"
        ((issues++))
    fi
    
    # Check for required template files
    if [ ! -f "$templates_dir/AI/CLAUDE.template.md" ]; then
        echo -e "${RED}❌ Missing CLAUDE.template.md${NC}"
        ((issues++))
    fi
    
    # Check for Xcode project template
    if [ ! -d "$templates_dir/iOS-App/ConstructTemplate.xcodeproj" ]; then
        echo -e "${RED}❌ Missing ConstructTemplate.xcodeproj${NC}"
        ((issues++))
    fi
    
    if [ $issues -eq 0 ]; then
        echo -e "${GREEN}✅ Template integrity validation passed${NC}"
    else
        echo -e "${RED}❌ Found $issues template issues${NC}"
    fi
    
    return $issues
}

# Check for CONSTRUCT-specific references in templates
check_template_contamination() {
    local templates_dir="$(get_templates_dir)"
    local contamination=0
    
    echo -e "${BLUE}Checking for template contamination...${NC}"
    
    # Look for hardcoded CONSTRUCT references
    local construct_refs=$(find "$templates_dir" -type f -name "*.swift" -o -name "*.md" | xargs grep -l "CONSTRUCT\|construct-dev" 2>/dev/null || true)
    
    if [ -n "$construct_refs" ]; then
        echo -e "${RED}❌ Found CONSTRUCT references in templates:${NC}"
        echo "$construct_refs"
        ((contamination++))
    fi
    
    # Check for absolute paths
    local abs_paths=$(find "$templates_dir" -type f -name "*.swift" -o -name "*.md" | xargs grep -l "/Users/\|/home/\|^[[:space:]]*/tmp/" 2>/dev/null | grep -v "# Example\|# TODO\|TMPDIR" || true)
    
    if [ -n "$abs_paths" ]; then
        echo -e "${RED}❌ Found absolute paths in templates:${NC}"
        echo "$abs_paths"
        ((contamination++))
    fi
    
    if [ $contamination -eq 0 ]; then
        echo -e "${GREEN}✅ Templates are clean of contamination${NC}"
    else
        echo -e "${RED}❌ Found $contamination contamination issues${NC}"
    fi
    
    return $contamination
}

# Extract patterns from USER-project-files for template improvement
extract_user_patterns() {
    local user_project_dir="$(get_user_project_dir)"
    local output_file="$1"
    
    echo -e "${BLUE}Extracting patterns from USER-project-files...${NC}"
    
    # Source file analysis functions
    source "$(dirname "${BASH_SOURCE[0]}")/file-analysis.sh"
    
    echo "# User Project Patterns" > "$output_file"
    echo "Extracted: $(date)" >> "$output_file"
    echo "" >> "$output_file"
    
    # Analyze iOS app structure
    if [ -d "$user_project_dir/PROJECT-name/iOS-App" ]; then
        echo "## iOS App Patterns" >> "$output_file"
        local temp_dir="${TMPDIR:-/tmp}"
        generate_architecture_summary "$user_project_dir/PROJECT-name/iOS-App" "$temp_dir/ios_summary.md"
        cat "$temp_dir/ios_summary.md" >> "$output_file"
        rm "$temp_dir/ios_summary.md" 2>/dev/null || true
    fi
    
    # Analyze Watch app structure
    if [ -d "$user_project_dir/PROJECT-name/Watch-App" ]; then
        echo "## Watch App Patterns" >> "$output_file"
        generate_architecture_summary "$user_project_dir/PROJECT-name/Watch-App" "/tmp/watch_summary.md"
        cat "/tmp/watch_summary.md" >> "$output_file"
        rm "/tmp/watch_summary.md"
    fi
    
    echo -e "${GREEN}✅ Patterns extracted to $output_file${NC}"
}

# Compare USER-project-files structure against templates
compare_user_vs_templates() {
    local user_project_dir="$(get_user_project_dir)"
    local templates_dir="$(get_templates_dir)"
    
    echo -e "${BLUE}Comparing USER-project-files vs Templates...${NC}"
    
    # Check if USER structure diverges from template structure
    local differences=0
    
    # Compare directory structures
    if [ -d "$user_project_dir/PROJECT-name/iOS-App" ] && [ -d "$templates_dir/iOS-App" ]; then
        echo -e "${YELLOW}Comparing iOS app structures:${NC}"
        
        # This would need more sophisticated comparison logic
        # For now, just basic directory presence check
        local user_dirs=$(find "$user_project_dir/PROJECT-name/iOS-App" -type d | sort)
        local template_dirs=$(find "$templates_dir/iOS-App" -type d | sort)
        
        # Simple comparison - in practice, this would be more nuanced
        if [ "$user_dirs" != "$template_dirs" ]; then
            echo -e "${YELLOW}⚠️ iOS directory structures differ${NC}"
            ((differences++))
        fi
    fi
    
    return $differences
}

# Test template can be used independently
test_template_independence() {
    local temp_dir=$(mktemp -d)
    local templates_dir="$(get_templates_dir)"
    local test_passed=0
    
    echo -e "${BLUE}Testing template independence...${NC}"
    
    # Copy templates to temp directory
    cp -r "$templates_dir"/* "$temp_dir/"
    
    # Test that templates don't reference CONSTRUCT development paths
    local bad_refs=$(find "$temp_dir" -type f -exec grep -l "/CONSTUCT-dev/\|/USER-project-files/" {} \; 2>/dev/null || true)
    
    if [ -n "$bad_refs" ]; then
        echo -e "${RED}❌ Templates reference CONSTRUCT development paths:${NC}"
        echo "$bad_refs"
        test_passed=1
    fi
    
    # Test placeholder replacement would work
    local placeholders=$(find "$temp_dir" -type f -exec grep -l "{{.*}}" {} \; 2>/dev/null || true)
    
    if [ -n "$placeholders" ]; then
        echo -e "${GREEN}✅ Found placeholder files ready for replacement:${NC}"
        echo "$placeholders"
    else
        echo -e "${YELLOW}⚠️ No placeholder files found - ensure templates use {{PROJECT_NAME}} etc.${NC}"
    fi
    
    # Clean up
    rm -rf "$temp_dir"
    
    if [ $test_passed -eq 0 ]; then
        echo -e "${GREEN}✅ Template independence test passed${NC}"
    else
        echo -e "${RED}❌ Template independence test failed${NC}"
    fi
    
    return $test_passed
}

# Generate template status report
generate_template_report() {
    local output_file="$1"
    
    echo "# Template Status Report" > "$output_file"
    echo "Generated: $(date)" >> "$output_file"
    echo "" >> "$output_file"
    
    echo "## Template Integrity" >> "$output_file"
    validate_template_integrity >> "$output_file" 2>&1
    echo "" >> "$output_file"
    
    echo "## Template Contamination Check" >> "$output_file"
    check_template_contamination >> "$output_file" 2>&1
    echo "" >> "$output_file"
    
    echo "## Template Independence Test" >> "$output_file"
    test_template_independence >> "$output_file" 2>&1
    echo "" >> "$output_file"
    
    echo -e "${GREEN}✅ Template report generated: $output_file${NC}"
}