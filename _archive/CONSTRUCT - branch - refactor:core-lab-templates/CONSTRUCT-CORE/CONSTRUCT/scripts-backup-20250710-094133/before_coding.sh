#!/bin/bash

# CONSTRUCT Development Pre-Coding Guidance
# Shows what exists before creating new CONSTRUCT functionality

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Source library functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common-patterns.sh"

# Get project directories using library functions
CONSTRUCT_ROOT=$(get_construct_root)
CONSTRUCT_DEV=$(get_construct_dev)

# Source library functions
source "$CONSTRUCT_DEV/CONSTRUCT/lib/validation.sh"
source "$CONSTRUCT_DEV/CONSTRUCT/lib/file-analysis.sh"
source "$CONSTRUCT_DEV/CONSTRUCT/lib/template-utils.sh"

# Function to search for
SEARCH_TERM="$1"

echo -e "${BLUE}🔍 CONSTRUCT Development Pre-Coding Check${NC}"

if [ -z "$SEARCH_TERM" ]; then
    echo -e "${YELLOW}Usage: $0 <function_name|feature|pattern>${NC}"
    echo ""
    echo "Examples:"
    echo "  $0 validate_file        # Search for validation functions"
    echo "  $0 template             # Search for template-related code"
    echo "  $0 update-context       # Search for context update functionality"
    echo ""
    exit 1
fi

echo -e "${BLUE}🎯 Searching for: '$SEARCH_TERM' in CONSTRUCT development...${NC}"
echo ""

check_existing_functions() {
    echo -e "${BLUE}📚 Checking existing library functions...${NC}"
    
    local lib_files=$(find "$CONSTRUCT_DEV/CONSTRUCT/lib" -name "*.sh" -type f)
    local found_functions=0
    
    for lib_file in $lib_files; do
        local matches=$(grep -n "^[a-zA-Z_][a-zA-Z0-9_]*.*$SEARCH_TERM" "$lib_file" 2>/dev/null || true)
        
        if [ -n "$matches" ]; then
            echo -e "${GREEN}✅ Found in $(basename "$lib_file"):${NC}"
            echo "$matches" | while read -r line; do
                echo "   $line"
            done
            ((found_functions++))
        fi
    done
    
    if [ $found_functions -eq 0 ]; then
        echo -e "${YELLOW}   No existing functions found matching '$SEARCH_TERM'${NC}"
    fi
    echo ""
}

check_existing_scripts() {
    echo -e "${BLUE}🔧 Checking existing scripts...${NC}"
    
    local script_files=$(find "$CONSTRUCT_DEV" -name "*.sh" -type f -not -path "*/CONSTRUCT/lib/*")
    local found_scripts=0
    
    for script_file in $script_files; do
        if grep -l "$SEARCH_TERM" "$script_file" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Found in $(basename "$script_file"):${NC}"
            local matches=$(grep -n "$SEARCH_TERM" "$script_file" | head -3)
            echo "$matches" | while read -r line; do
                echo "   $line"
            done
            ((found_scripts++))
        fi
    done
    
    if [ $found_scripts -eq 0 ]; then
        echo -e "${YELLOW}   No existing scripts found matching '$SEARCH_TERM'${NC}"
    fi
    echo ""
}

check_configuration() {
    echo -e "${BLUE}⚙️ Checking configuration files...${NC}"
    
    local config_files=$(find "$CONSTRUCT_DEV/CONSTRUCT/config" -name "*.yaml" -type f)
    local found_configs=0
    
    for config_file in $config_files; do
        if grep -l "$SEARCH_TERM" "$config_file" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Found in $(basename "$config_file"):${NC}"
            local matches=$(grep -n "$SEARCH_TERM" "$config_file" | head -3)
            echo "$matches" | while read -r line; do
                echo "   $line"
            done
            ((found_configs++))
        fi
    done
    
    if [ $found_configs -eq 0 ]; then
        echo -e "${YELLOW}   No configuration found matching '$SEARCH_TERM'${NC}"
    fi
    echo ""
}

check_documentation() {
    echo -e "${BLUE}📖 Checking documentation...${NC}"
    
    local doc_files=$(find "$CONSTRUCT_DEV" -name "*.md" -type f)
    local found_docs=0
    
    for doc_file in $doc_files; do
        if grep -l "$SEARCH_TERM" "$doc_file" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Found in $(basename "$doc_file"):${NC}"
            local matches=$(grep -n "$SEARCH_TERM" "$doc_file" | head -2)
            echo "$matches" | while read -r line; do
                echo "   $line"
            done
            ((found_docs++))
        fi
    done
    
    if [ $found_docs -eq 0 ]; then
        echo -e "${YELLOW}   No documentation found matching '$SEARCH_TERM'${NC}"
    fi
    echo ""
}

check_templates() {
    echo -e "${BLUE}🎯 Checking templates...${NC}"
    
    local template_files=$(find "$CONSTRUCT_DEV/Templates" -type f 2>/dev/null || true)
    local found_templates=0
    
    for template_file in $template_files; do
        if grep -l "$SEARCH_TERM" "$template_file" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Found in template: $(basename "$template_file")${NC}"
            local matches=$(grep -n "$SEARCH_TERM" "$template_file" | head -2)
            echo "$matches" | while read -r line; do
                echo "   $line"
            done
            ((found_templates++))
        fi
    done
    
    if [ $found_templates -eq 0 ]; then
        echo -e "${YELLOW}   No templates found matching '$SEARCH_TERM'${NC}"
    fi
    echo ""
}

suggest_patterns() {
    echo -e "${BLUE}💡 Suggestions based on search term...${NC}"
    
    case "$SEARCH_TERM" in
        *validate*|*check*)
            echo -e "${GREEN}✨ For validation functions:${NC}"
            echo "   - Add to lib/validation.sh"
            echo "   - Follow pattern: validate_something()"
            echo "   - Include error messages with colors"
            echo "   - Return 0 for success, 1 for failure"
            ;;
        *template*)
            echo -e "${GREEN}✨ For template functions:${NC}"
            echo "   - Add to lib/template-utils.sh"
            echo "   - Check template integrity first"
            echo "   - Use existing template validation patterns"
            echo "   - Consider contamination checks"
            ;;
        *update*|*context*)
            echo -e "${GREEN}✨ For context update functions:${NC}"
            echo "   - Check existing update-context.sh"
            echo "   - Use sed for auto-section updates"
            echo "   - Follow CLAUDE.md comment patterns"
            echo "   - Update multiple sections consistently"
            ;;
        *analyze*|*analysis*)
            echo -e "${GREEN}✨ For analysis functions:${NC}"
            echo "   - Add to lib/file-analysis.sh"
            echo "   - Use find and grep patterns"
            echo "   - Generate summary reports"
            echo "   - Consider dual-context needs"
            ;;
        *)
            echo -e "${GREEN}✨ General suggestions:${NC}"
            echo "   - Check existing lib/ functions first"
            echo "   - Follow established naming patterns"
            echo "   - Add proper error handling (set -e)"
            echo "   - Include user-friendly output colors"
            echo "   - Update relevant configuration files"
            ;;
    esac
    echo ""
}

show_next_steps() {
    echo -e "${BLUE}🚀 Next Steps${NC}"
    echo "=============="
    echo ""
    echo "Before creating new functionality:"
    echo "  1. Review existing implementations above"
    echo "  2. Check if enhancement is better than new creation"
    echo "  3. Consider which file/directory is appropriate"
    echo "  4. Follow established patterns and conventions"
    echo ""
    echo "Recommended workflow:"
    echo "  ./CONSTRUCT/scripts/check-architecture.sh    # Verify current state"
    echo "  # ... make your changes ..."
    echo "  ./CONSTRUCT/scripts/update-context.sh        # Update development context"
    echo "  ./CONSTRUCT/scripts/check-architecture.sh    # Verify changes"
    echo ""
    echo "Available resources:"
    echo "  - lib/ functions for reusable code"
    echo "  - config/ YAML for configuration-driven features"
    echo "  - PROJECT-TEMPLATE/ for user-facing templates"
    echo "  - tests/ for validation (when implemented)"
}

# Main execution
main() {
    echo -e "${GREEN}🚀 Starting CONSTRUCT pre-coding check for '$SEARCH_TERM'...${NC}"
    echo ""
    
    # Validate environment
    validate_environment
    
    # Run all checks
    check_existing_functions
    check_existing_scripts
    check_configuration
    check_documentation
    check_templates
    suggest_patterns
    show_next_steps
    
    echo -e "${GREEN}✅ Pre-coding check complete!${NC}"
}

# Run main function
main "$@"