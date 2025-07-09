#!/bin/bash

# CONSTRUCT Development Architecture Checker
# Validates shell/Python organization and patterns in CONSTRUCT-LAB

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
source "$CONSTRUCT_DEV/CONSTRUCT/lib/template-utils.sh"

echo -e "${BLUE}🏗️ Checking CONSTRUCT development architecture...${NC}"

# Track violations
VIOLATIONS=0

check_shell_script_quality() {
    echo -e "${BLUE}📝 Checking shell script quality...${NC}"
    
    local script_issues=0
    
    # Find all shell scripts
    local scripts=$(find "$CONSTRUCT_DEV" -name "*.sh" -type f)
    
    for script in $scripts; do
        echo -e "${YELLOW}Checking: $(basename "$script")${NC}"
        
        # Check for shebang
        if ! head -1 "$script" | grep -q "^#!/"; then
            echo -e "${RED}❌ Missing shebang: $script${NC}"
            ((script_issues++))
        fi
        
        # Check for set -e (error handling)
        if ! grep -q "set -e" "$script"; then
            echo -e "${RED}❌ Missing 'set -e': $script${NC}"
            ((script_issues++))
        fi
        
        # Check syntax
        if ! bash -n "$script" 2>/dev/null; then
            echo -e "${RED}❌ Syntax error: $script${NC}"
            ((script_issues++))
        fi
        
        # Check for hardcoded paths
        if grep -q "/Users/\|/home/\|^/tmp/" "$script" | grep -v "# Example\|# TODO\|TMPDIR"; then
            echo -e "${RED}❌ Hardcoded paths found: $script${NC}"
            ((script_issues++))
        fi
        
        # Check for proper error messages
        if ! grep -q "echo.*❌\|echo.*✅" "$script"; then
            echo -e "${YELLOW}⚠️ Consider adding user-friendly error messages: $script${NC}"
        fi
    done
    
    if [ $script_issues -eq 0 ]; then
        echo -e "${GREEN}✅ All shell scripts pass quality checks${NC}"
    else
        echo -e "${RED}❌ Found $script_issues shell script issues${NC}"
        VIOLATIONS=$((VIOLATIONS + script_issues))
    fi
}

check_directory_structure() {
    echo -e "${BLUE}📁 Checking directory structure...${NC}"
    
    local structure_issues=0
    
    # Required directories in CONSTRUCT-LAB
    local required_dirs=("AI" "CONSTRUCT/lib" "CONSTRUCT/config" "CONSTRUCT/scripts")
    
    for dir in "${required_dirs[@]}"; do
        if [ ! -d "$CONSTRUCT_DEV/$dir" ]; then
            echo -e "${RED}❌ Missing required directory: $dir${NC}"
            ((structure_issues++))
        else
            echo -e "${GREEN}✅ Required directory exists: $dir${NC}"
        fi
    done
    
    # Check TEMPLATES at root level
    if [ ! -d "$CONSTRUCT_ROOT/TEMPLATES" ]; then
        echo -e "${YELLOW}⚠️  TEMPLATES directory not found (optional for development)${NC}"
    else
        echo -e "${GREEN}✅ Required directory exists: TEMPLATES${NC}"
    fi
    
    # Check for proper file organization
    if [ ! -f "$CONSTRUCT_DEV/CLAUDE.md" ]; then
        echo -e "${RED}❌ Missing CONSTRUCT development context: CLAUDE.md${NC}"
        ((structure_issues++))
    fi
    
    # Check lib functions exist
    local lib_files=("file-analysis.sh" "template-utils.sh" "validation.sh")
    for lib_file in "${lib_files[@]}"; do
        if [ ! -f "$CONSTRUCT_DEV/CONSTRUCT/lib/$lib_file" ]; then
            echo -e "${RED}❌ Missing library function: lib/$lib_file${NC}"
            ((structure_issues++))
        fi
    done
    
    # Check config files exist
    local config_files=("mvvm-rules.yaml" "quality-gates.yaml")
    for config_file in "${config_files[@]}"; do
        if [ ! -f "$CONSTRUCT_DEV/CONSTRUCT/config/$config_file" ]; then
            echo -e "${RED}❌ Missing configuration: config/$config_file${NC}"
            ((structure_issues++))
        fi
    done
    
    if [ $structure_issues -eq 0 ]; then
        echo -e "${GREEN}✅ Directory structure is correct${NC}"
    else
        echo -e "${RED}❌ Found $structure_issues structure issues${NC}"
        VIOLATIONS=$((VIOLATIONS + structure_issues))
    fi
}

check_code_duplication() {
    echo -e "${BLUE}🔄 Checking for code duplication...${NC}"
    
    local duplication_issues=0
    
    # Look for common patterns that should be in lib functions
    local common_patterns=("validate_directory" "validate_file" "find.*-name.*\\.sh")
    
    for pattern in "${common_patterns[@]}"; do
        local occurrences=$(find "$CONSTRUCT_DEV" -name "*.sh" -exec grep -l "$pattern" {} \; 2>/dev/null | wc -l)
        
        if [ "$occurrences" -gt 3 ]; then
            echo -e "${YELLOW}⚠️ Pattern '$pattern' appears in $occurrences files - consider extracting to lib/${NC}"
        fi
    done
    
    # Check for duplicate function definitions
    local function_names=$(find "$CONSTRUCT_DEV" -name "*.sh" -exec grep -h "^[a-zA-Z_][a-zA-Z0-9_]*(" {} \; 2>/dev/null | cut -d'(' -f1 | sort | uniq -d)
    
    if [ -n "$function_names" ]; then
        echo -e "${YELLOW}⚠️ Duplicate function names found:${NC}"
        echo "$function_names"
        ((duplication_issues++))
    fi
    
    if [ $duplication_issues -eq 0 ]; then
        echo -e "${GREEN}✅ No significant code duplication found${NC}"
    else
        echo -e "${YELLOW}⚠️ Found $duplication_issues duplication issues${NC}"
    fi
}

check_documentation() {
    echo -e "${BLUE}📚 Checking documentation coverage...${NC}"
    
    local doc_issues=0
    
    # Check for README files in key directories
    local dirs_needing_readme=("lib" "config" "tests")
    
    for dir in "${dirs_needing_readme[@]}"; do
        if [ -d "$CONSTRUCT_DEV/$dir" ] && [ ! -f "$CONSTRUCT_DEV/$dir/README.md" ]; then
            echo -e "${YELLOW}⚠️ Missing README: $dir/README.md${NC}"
            ((doc_issues++))
        fi
    done
    
    # Check for function documentation in lib files
    local lib_files=$(find "$CONSTRUCT_DEV/CONSTRUCT/lib" -name "*.sh" -type f)
    
    for lib_file in $lib_files; do
        if ! grep -q "^#.*" "$lib_file"; then
            echo -e "${YELLOW}⚠️ Missing documentation comments: $lib_file${NC}"
            ((doc_issues++))
        fi
    done
    
    if [ $doc_issues -eq 0 ]; then
        echo -e "${GREEN}✅ Documentation coverage is good${NC}"
    else
        echo -e "${YELLOW}⚠️ Found $doc_issues documentation issues${NC}"
    fi
}

check_template_integrity() {
    echo -e "${BLUE}🎯 Checking template integrity...${NC}"
    
    local template_issues=0
    
    # Use existing template validation functions
    if ! validate_template_integrity; then
        ((template_issues++))
    fi
    
    if ! check_template_contamination; then
        ((template_issues++))
    fi
    
    if ! test_template_independence; then
        ((template_issues++))
    fi
    
    if [ $template_issues -eq 0 ]; then
        echo -e "${GREEN}✅ Template integrity verified${NC}"
    else
        echo -e "${RED}❌ Found $template_issues template issues${NC}"
        VIOLATIONS=$((VIOLATIONS + template_issues))
    fi
}

check_configuration_validity() {
    echo -e "${BLUE}⚙️ Checking configuration files...${NC}"
    
    local config_issues=0
    
    # Check YAML files are valid
    local yaml_files=$(find "$CONSTRUCT_DEV/CONSTRUCT/config" -name "*.yaml" -type f)
    
    for yaml_file in $yaml_files; do
        # Basic YAML validation (checking for colons and proper structure)
        if ! grep -q ":" "$yaml_file"; then
            echo -e "${RED}❌ Invalid YAML structure: $yaml_file${NC}"
            ((config_issues++))
        fi
        
        # Check for required sections
        case "$(basename "$yaml_file")" in
            "mvvm-rules.yaml")
                if ! grep -q "rules:" "$yaml_file"; then
                    echo -e "${RED}❌ Missing 'rules:' section: $yaml_file${NC}"
                    ((config_issues++))
                fi
                ;;
            "quality-gates.yaml")
                if ! grep -q "thresholds:" "$yaml_file"; then
                    echo -e "${RED}❌ Missing 'thresholds:' section: $yaml_file${NC}"
                    ((config_issues++))
                fi
                ;;
        esac
    done
    
    if [ $config_issues -eq 0 ]; then
        echo -e "${GREEN}✅ Configuration files are valid${NC}"
    else
        echo -e "${RED}❌ Found $config_issues configuration issues${NC}"
        VIOLATIONS=$((VIOLATIONS + config_issues))
    fi
}

# Generate summary report
generate_summary() {
    echo -e "\n${BLUE}📋 CONSTRUCT Development Architecture Summary${NC}"
    echo "=============================================="
    
    if [ $VIOLATIONS -eq 0 ]; then
        echo -e "${GREEN}✅ ARCHITECTURE CHECK PASSED${NC}"
        echo -e "${GREEN}   All CONSTRUCT development patterns are correct${NC}"
        echo -e "${GREEN}   Ready for continued development${NC}"
    else
        echo -e "${RED}❌ ARCHITECTURE CHECK FAILED${NC}"
        echo -e "${RED}   Found $VIOLATIONS total violations${NC}"
        echo -e "${RED}   Please fix issues before continuing${NC}"
    fi
    
    echo ""
    echo "Run individual checks:"
    echo "  - Shell script quality"
    echo "  - Directory structure"
    echo "  - Code duplication"
    echo "  - Documentation coverage"
    echo "  - Template integrity"
    echo "  - Configuration validity"
    echo ""
    echo "Next steps:"
    echo "  ./CONSTRUCT/scripts/update-context.sh  # Update development context"
    echo "  ./CONSTRUCT/scripts/before_coding.sh   # Check before adding features"
}

# Main execution
main() {
    echo -e "${GREEN}🚀 Starting CONSTRUCT development architecture check...${NC}"
    
    # Validate environment
    validate_environment
    
    # Run all checks
    check_shell_script_quality
    echo ""
    check_directory_structure
    echo ""
    check_code_duplication
    echo ""
    check_documentation
    echo ""
    check_template_integrity
    echo ""
    check_configuration_validity
    
    # Generate summary
    generate_summary
    
    # Exit with appropriate code
    exit $VIOLATIONS
}

# Run main function
main "$@"