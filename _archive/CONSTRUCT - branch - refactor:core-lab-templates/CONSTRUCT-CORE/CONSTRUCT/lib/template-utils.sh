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
    # From /CONSTRUCT-LAB/CONSTRUCT/lib -> /CONSTRUCT-LAB -> /CONSTRUCT
    echo "$(dirname "$(dirname "$(dirname "$script_dir")")")"
}

# Get path to template directory
get_template_dir() {
    echo "$(get_construct_root)/TEMPLATES"
}

# Get the path to the template project structure
get_template_project_dir() {
    # For now, we'll use swift-ios as the primary template
    echo "$(get_template_dir)/swift-ios"
}

# Detect if we're in a user project or template context
detect_context() {
    local current_dir="$(pwd)"
    local construct_root="$(get_construct_root)"
    
    # Check if we're in TEMPLATES (template context)
    if [[ "$current_dir" == *"TEMPLATES"* ]]; then
        echo "template"
        return 0
    fi
    
    # Check if we're in CONSTRUCT-LAB (development context)
    if [[ "$current_dir" == *"CONSTRUCT-LAB"* ]]; then
        echo "development"
        return 0
    fi
    
    # Default to development context
    echo "development"
}

# Get project directories based on context
get_project_context() {
    local context="$(detect_context)"
    
    case "$context" in
        "template")
            # We're validating the template itself
            echo "template_validation"
            ;;
        "development")
            # We're in CONSTRUCT development, validating template structure
            echo "template_validation"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Validate template structure (for template development)
validate_template_structure() {
    local template_dir="$(get_template_dir)"
    local issues=0
    
    echo -e "${BLUE}Validating TEMPLATES structure...${NC}"
    
    # Check main template directory exists
    if [ ! -d "$template_dir" ]; then
        echo -e "${YELLOW}⚠️ TEMPLATES directory not found (optional for development)${NC}"
        return 0  # Don't fail for missing templates in development
    fi
    
    # If templates exist, do basic validation
    local template_count=$(find "$template_dir" -maxdepth 1 -type d | wc -l | tr -d ' ')
    if [ $template_count -le 1 ]; then
        echo -e "${YELLOW}⚠️ No templates found in TEMPLATES directory${NC}"
        return 0  # Don't fail, just warn
    fi
    
    # Check each template has basic structure
    for template in "$template_dir"/*; do
        if [ -d "$template" ] && [ "$(basename "$template")" != "TEMPLATES" ]; then
            local template_name=$(basename "$template")
            echo -e "${BLUE}Checking template: $template_name${NC}"
            
            # Minimal requirements for a template
            if [ ! -d "$template/AI" ]; then
                echo -e "${YELLOW}⚠️ Missing AI directory in $template_name (will be created by construct-setup)${NC}"
            fi
            
            # Check for CONSTRUCT symlink
            if [ ! -e "$template/CONSTRUCT" ]; then
                echo -e "${YELLOW}⚠️ Missing CONSTRUCT symlink in $template_name${NC}"
            elif [ -L "$template/CONSTRUCT" ]; then
                echo -e "${GREEN}✅ CONSTRUCT symlink exists in $template_name${NC}"
            fi
        fi
    done
    
    if [ $issues -eq 0 ]; then
        echo -e "${GREEN}✅ Template validation complete${NC}"
    else
        echo -e "${YELLOW}⚠️ Found $issues minor template issues (non-blocking)${NC}"
    fi
    
    return 0  # Always return success for now
}

# Validate user project structure (for actual user projects using dynamic detection)
validate_user_project_structure() {
    local project_root="$1"
    local issues=0
    
    if [ -z "$project_root" ]; then
        echo -e "${RED}❌ Project root not provided${NC}"
        return 1
    fi
    
    echo -e "${BLUE}Validating user project structure: $(basename "$project_root")${NC}"
    
    # Source the project detection library if available
    local detection_lib="$project_root/AI/lib/project-detection.sh"
    if [ -f "$detection_lib" ]; then
        source "$detection_lib"
        
        # Use dynamic detection
        if ! verify_project_structure 2>/dev/null; then
            echo -e "${RED}❌ Project structure validation failed${NC}"
            ((issues++))
        else
            echo -e "${GREEN}✅ User project structure is valid${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️ Project detection library not found, skipping validation${NC}"
        ((issues++))
    fi
    
    return $issues
}

# Main validation function that determines context and validates appropriately
validate_template_integrity() {
    local context="$(get_project_context)"
    local issues=0
    
    case "$context" in
        "template_validation")
            validate_template_structure
            issues=$?
            ;;
        *)
            echo -e "${YELLOW}⚠️ Unknown context, defaulting to template validation${NC}"
            validate_template_structure
            issues=$?
            ;;
    esac
    
    return $issues
}

# Check for template contamination (user-specific content in templates)
check_template_contamination() {
    local template_dir="$(get_template_dir)"
    local contamination=0
    
    echo -e "${BLUE}Checking for template contamination...${NC}"
    
    # Look for common contamination patterns
    local patterns=(
        "RUN"
        "/Users/"
        "parker"
        "specific-project-name"
    )
    
    for pattern in "${patterns[@]}"; do
        # Check for contamination but exclude Xcode project files and directories
        local matches=$(find "$template_dir" -type f \
            -not -name "*.pbxproj" \
            -not -name "*.xcworkspacedata" \
            -not -name "*.xcscheme" \
            -not -path "*/.git/*" \
            -exec grep -l "$pattern" {} \; 2>/dev/null | head -1)
        
        if [ -n "$matches" ]; then
            echo -e "${RED}❌ Found potential contamination: $pattern${NC}"
            echo "   In: $matches"
            ((contamination++))
        fi
    done
    
    if [ $contamination -eq 0 ]; then
        echo -e "${GREEN}✅ Templates are clean of contamination${NC}"
    else
        echo -e "${RED}❌ Found $contamination contamination issues${NC}"
    fi
    
    return $contamination
}

# Test template independence (ensure templates work standalone)
test_template_independence() {
    local template_project="$(get_template_project_dir)"
    local issues=0
    
    echo -e "${BLUE}Testing template independence...${NC}"
    
    # Check that template scripts don't reference CONSTRUCT development paths
    if grep -r "CONSTRUCT-LAB" "$template_project/AI/scripts" 2>/dev/null; then
        echo -e "${RED}❌ Template scripts reference CONSTRUCT development paths${NC}"
        ((issues++))
    fi
    
    # Check for placeholder patterns
    local placeholder_patterns=(
        "USER-CHOSEN-NAME"
        "TEMPLATES" 
        "{{.*}}"
    )
    
    local found_placeholders=0
    for pattern in "${placeholder_patterns[@]}"; do
        if grep -r "$pattern" "$template_project" --exclude-dir=".git" 2>/dev/null | head -1 >/dev/null; then
            ((found_placeholders++))
        fi
    done
    
    if [ $found_placeholders -eq 0 ]; then
        echo -e "${YELLOW}⚠️ No placeholder patterns found - ensure templates use proper placeholders${NC}"
    else
        echo -e "${GREEN}✅ Template uses placeholder patterns${NC}"
    fi
    
    if [ $issues -eq 0 ]; then
        echo -e "${GREEN}✅ Template independence test passed${NC}"
    else
        echo -e "${RED}❌ Found $issues template independence issues${NC}"
    fi
    
    return $issues
}

# Get available template scripts
get_template_scripts() {
    local template_project="$(get_template_project_dir)"
    find "$template_project/AI/scripts" -name "*.sh" -type f 2>/dev/null | sort
}

# Get template script count
get_template_script_count() {
    get_template_scripts | wc -l | tr -d ' '
}

# Validate template scripts have proper structure
validate_template_scripts() {
    local scripts="$(get_template_scripts)"
    local issues=0
    
    echo -e "${BLUE}Validating template scripts...${NC}"
    
    while IFS= read -r script; do
        if [ -f "$script" ]; then
            # Check for project detection library usage
            if ! grep -q "project-detection.sh" "$script"; then
                echo -e "${YELLOW}⚠️ Script $(basename "$script") doesn't use project detection library${NC}"
            fi
            
            # Check for proper error handling
            if ! grep -q "set -e" "$script"; then
                echo -e "${YELLOW}⚠️ Script $(basename "$script") missing 'set -e'${NC}"
            fi
        fi
    done <<< "$scripts"
    
    local script_count="$(get_template_script_count)"
    echo -e "${GREEN}✅ Validated $script_count template scripts${NC}"
    
    return $issues
}