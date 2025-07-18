#!/bin/bash

# Documentation Coverage Check Script
# Ensures CONSTRUCT development has proper documentation standards

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

echo -e "${BLUE}📚 Running CONSTRUCT Documentation Coverage Checks...${NC}"
echo ""

VIOLATIONS=0

# Check 1: Scripts without header comments
echo -e "${BLUE}### 1. Checking script documentation headers...${NC}"
check_script_headers() {
    local missing_headers=0
    
    find "$CONSTRUCT_DEV" -name "*.sh" -type f | while read -r script; do
        # Check for proper header documentation
        if ! head -5 "$script" | grep -q "^#.*[Dd]escription\|^#.*What.*does\|^#.*Purpose"; then
            echo -e "${RED}❌ Missing header documentation: $(basename "$script")${NC}"
            ((missing_headers++))
        fi
    done
    
    if [ $missing_headers -eq 0 ]; then
        echo -e "${GREEN}✅ All scripts have documentation headers${NC}"
    else
        echo -e "${YELLOW}   Fix: Add description comments at top of scripts${NC}"
        VIOLATIONS=$((VIOLATIONS + missing_headers))
    fi
}
check_script_headers
echo ""

# Check 2: README files in key directories
echo -e "${BLUE}### 2. Checking README coverage...${NC}"
check_readme_coverage() {
    local missing_readmes=0
    local key_dirs=("lib" "config" "tests" "CONSTRUCT/scripts")
    
    for dir in "${key_dirs[@]}"; do
        if [ -d "$CONSTRUCT_DEV/$dir" ] && [ ! -f "$CONSTRUCT_DEV/$dir/README.md" ]; then
            echo -e "${RED}❌ Missing README: $dir/README.md${NC}"
            ((missing_readmes++))
        else
            echo -e "${GREEN}✅ README exists: $dir/README.md${NC}"
        fi
    done
    
    if [ $missing_readmes -eq 0 ]; then
        echo -e "${GREEN}✅ All key directories have READMEs${NC}"
    else
        echo -e "${YELLOW}   Fix: Add README.md files to document directory purposes${NC}"
        VIOLATIONS=$((VIOLATIONS + missing_readmes))
    fi
}
check_readme_coverage
echo ""

# Check 3: Function documentation in lib files
echo -e "${BLUE}### 3. Checking library function documentation...${NC}"
check_function_docs() {
    local undocumented_functions=0
    
    find "$CONSTRUCT_DEV/CONSTRUCT/lib" -name "*.sh" -type f | while read -r lib_file; do
        echo -e "${YELLOW}Checking: $(basename "$lib_file")${NC}"
        
        # Find function definitions
        local functions=$(grep -n "^[a-zA-Z_][a-zA-Z0-9_]*(" "$lib_file" | cut -d':' -f1)
        
        for line_num in $functions; do
            local func_name=$(sed -n "${line_num}p" "$lib_file" | cut -d'(' -f1)
            
            # Check if function has documentation comment before it
            local prev_line=$((line_num - 1))
            if [ $prev_line -gt 0 ]; then
                local comment=$(sed -n "${prev_line}p" "$lib_file")
                if [[ ! "$comment" =~ ^#.*[A-Za-z] ]]; then
                    echo -e "${YELLOW}⚠️ Function lacks documentation: $func_name${NC}"
                    ((undocumented_functions++))
                fi
            fi
        done
    done
    
    if [ $undocumented_functions -eq 0 ]; then
        echo -e "${GREEN}✅ All library functions are documented${NC}"
    else
        echo -e "${YELLOW}   Fix: Add comment before each function explaining purpose${NC}"
    fi
}
check_function_docs
echo ""

# Check 4: Configuration file documentation
echo -e "${BLUE}### 4. Checking configuration documentation...${NC}"
check_config_docs() {
    local undocumented_configs=0
    
    find "$CONSTRUCT_DEV/CONSTRUCT/config" -name "*.yaml" -type f | while read -r config_file; do
        echo -e "${YELLOW}Checking: $(basename "$config_file")${NC}"
        
        # Check for description comments
        if ! head -10 "$config_file" | grep -q "^#.*[Dd]escription\|^#.*Purpose\|^#.*Configuration"; then
            echo -e "${YELLOW}⚠️ Configuration lacks header documentation: $(basename "$config_file")${NC}"
            ((undocumented_configs++))
        fi
        
        # Check for section comments
        local sections=$(grep -c "^[a-zA-Z_][a-zA-Z0-9_]*:" "$config_file" | tr -d ' \n' || echo "0")
        local comments=$(grep -c "^#.*:" "$config_file" 2>/dev/null | tr -d ' \n' || echo "0")
        
        if [ "$comments" -lt $((sections / 2)) ]; then
            echo -e "${YELLOW}⚠️ Configuration sections need more comments: $(basename "$config_file")${NC}"
        fi
    done
    
    if [ $undocumented_configs -eq 0 ]; then
        echo -e "${GREEN}✅ Configuration files are well documented${NC}"
    else
        echo -e "${YELLOW}   Fix: Add header and section comments to YAML files${NC}"
    fi
}
check_config_docs
echo ""

# Check 5: Script usage examples
echo -e "${BLUE}### 5. Checking script usage documentation...${NC}"
check_script_usage() {
    local scripts_no_usage=0
    
    find "$CONSTRUCT_DEV/CONSTRUCT/scripts" -name "*.sh" -type f | while read -r script; do
        # Check if script shows usage when run without args or with --help
        if ! grep -q "usage\|Usage\|USAGE\|help\|--help\|-h" "$script"; then
            echo -e "${YELLOW}⚠️ Script lacks usage documentation: $(basename "$script")${NC}"
            ((scripts_no_usage++))
        fi
    done
    
    if [ $scripts_no_usage -eq 0 ]; then
        echo -e "${GREEN}✅ Scripts provide usage documentation${NC}"
    else
        echo -e "${YELLOW}   Fix: Add usage examples to scripts${NC}"
    fi
}
check_script_usage
echo ""

# Check 6: Todo and development documentation
echo -e "${BLUE}### 6. Checking development documentation...${NC}"
check_dev_docs() {
    local missing_dev_docs=0
    
    # Check for key development docs
    local dev_files=("AI/todo/future/implement-dual-dev-environments.md" "AI/docs/automated/improving-CONSTRUCT-guide-automated.md")
    
    for doc_file in "${dev_files[@]}"; do
        if [ -f "$CONSTRUCT_DEV/$doc_file" ]; then
            echo -e "${GREEN}✅ Development doc exists: $doc_file${NC}"
        else
            echo -e "${RED}❌ Missing development doc: $doc_file${NC}"
            ((missing_dev_docs++))
        fi
    done
    
    if [ $missing_dev_docs -eq 0 ]; then
        echo -e "${GREEN}✅ Development documentation is complete${NC}"
    else
        echo -e "${YELLOW}   Fix: Create missing development documentation${NC}"
        VIOLATIONS=$((VIOLATIONS + missing_dev_docs))
    fi
}
check_dev_docs
echo ""

# Generate summary
echo -e "${BLUE}📋 CONSTRUCT Documentation Coverage Summary${NC}"
echo "============================================="

if [ $VIOLATIONS -eq 0 ]; then
    echo -e "${GREEN}✅ DOCUMENTATION CHECK PASSED${NC}"
    echo -e "${GREEN}   All CONSTRUCT documentation standards met${NC}"
    echo -e "${GREEN}   Code is well documented and maintainable${NC}"
else
    echo -e "${YELLOW}⚠️ DOCUMENTATION NEEDS IMPROVEMENT${NC}"
    echo -e "${YELLOW}   Found $VIOLATIONS documentation issues${NC}"
    echo -e "${YELLOW}   Consider improving documentation coverage${NC}"
fi

echo ""
echo "Documentation standards checked:"
echo "  - Script header documentation"
echo "  - README coverage in key directories"
echo "  - Library function documentation"
echo "  - Configuration file documentation"
echo "  - Script usage examples"
echo "  - Development documentation"
echo ""
echo "Next steps:"
echo "  ./CONSTRUCT/scripts/update-context.sh      # Update development context"
echo "  ./CONSTRUCT/scripts/check-architecture.sh  # Validate architecture"

# Exit with violation count (0 = success)
exit $VIOLATIONS