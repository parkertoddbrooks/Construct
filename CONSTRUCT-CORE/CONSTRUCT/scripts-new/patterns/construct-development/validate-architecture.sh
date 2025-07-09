#!/bin/bash

# CONSTRUCT Development Pattern - Architecture Validator
# Validates CONSTRUCT-specific development patterns and structure

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
CONSTRUCT_LAB="$CONSTRUCT_ROOT/CONSTRUCT-LAB"

echo -e "${BLUE}🏗️  CONSTRUCT Development Pattern Validation${NC}"
echo "-------------------------------------------"

# CONSTRUCT-specific checks
check_symlink_integrity() {
    echo -e "\n${YELLOW}Checking symlink integrity...${NC}"
    local issues=0
    
    # Check if CONSTRUCT directory is symlinked properly
    if [ -L "$CONSTRUCT_LAB/CONSTRUCT" ]; then
        if [ ! -e "$CONSTRUCT_LAB/CONSTRUCT" ]; then
            echo -e "  ${RED}❌ CONSTRUCT symlink is broken${NC}"
            ((issues++))
        else
            echo -e "  ${GREEN}✅ CONSTRUCT symlink is valid${NC}"
        fi
    else
        echo -e "  ${RED}❌ CONSTRUCT should be a symlink to CORE${NC}"
        ((issues++))
    fi
    
    # Check for files that should be symlinks
    local expected_symlinks=(
        "AI/dev-logs/check-quality/README-sym.md"
        "AI/dev-logs/dev-updates/README-sym.md"
        "AI/docs/README-sym.md"
        "AI/todo/README-sym.md"
    )
    
    for symlink in "${expected_symlinks[@]}"; do
        if [ -f "$CONSTRUCT_LAB/$symlink" ] && [ ! -L "$CONSTRUCT_LAB/$symlink" ]; then
            echo -e "  ${RED}❌ $symlink should be a symlink${NC}"
            ((issues++))
        fi
    done
    
    return $issues
}

check_lab_core_separation() {
    echo -e "\n${YELLOW}Checking LAB/CORE separation...${NC}"
    local issues=0
    
    # Check for direct modifications in CORE from LAB scripts
    if grep -r "CONSTRUCT_CORE.*>>" "$CONSTRUCT_LAB" --include="*.sh" 2>/dev/null | grep -v "^#"; then
        echo -e "  ${RED}❌ Found direct writes to CORE from LAB${NC}"
        ((issues++))
    fi
    
    # Check for proper promotion workflow usage
    if [ ! -f "$CONSTRUCT_LAB/tools/promote-to-core.sh" ]; then
        echo -e "  ${YELLOW}⚠️  Missing promotion workflow script${NC}"
        ((issues++))
    fi
    
    return $issues
}

check_template_independence() {
    echo -e "\n${YELLOW}Checking template independence...${NC}"
    local issues=0
    
    # Check for CONSTRUCT-specific code in templates
    local template_dir="$CONSTRUCT_ROOT/PROJECT-TEMPLATE"
    if [ -d "$template_dir" ]; then
        if grep -r "CONSTRUCT_" "$template_dir" --include="*.sh" 2>/dev/null | grep -v "^#"; then
            echo -e "  ${YELLOW}⚠️  Template contains CONSTRUCT-specific references${NC}"
            ((issues++))
        fi
    fi
    
    return $issues
}

check_auto_documentation() {
    echo -e "\n${YELLOW}Checking auto-documentation setup...${NC}"
    local issues=0
    
    # Check for required auto-doc directories
    local required_dirs=(
        "AI/docs/automated"
        "AI/dev-logs/check-quality/automated"
        "AI/dev-logs/dev-updates/automated"
        "AI/structure"
    )
    
    for dir in "${required_dirs[@]}"; do
        if [ ! -d "$CONSTRUCT_LAB/$dir" ]; then
            echo -e "  ${YELLOW}⚠️  Missing auto-doc directory: $dir${NC}"
            ((issues++))
        fi
    done
    
    # Check for auto-update markers in CLAUDE.md
    if [ -f "$CONSTRUCT_LAB/CLAUDE.md" ]; then
        if ! grep -q "<!-- START:.*-->" "$CONSTRUCT_LAB/CLAUDE.md"; then
            echo -e "  ${YELLOW}⚠️  CLAUDE.md missing auto-update markers${NC}"
            ((issues++))
        fi
    fi
    
    return $issues
}

check_script_organization() {
    echo -e "\n${YELLOW}Checking script organization...${NC}"
    local issues=0
    
    # Check for scripts in wrong locations
    if find "$CONSTRUCT_LAB" -name "*.sh" -path "*/AI/*" -not -path "*/scripts/*" 2>/dev/null | grep -q .; then
        echo -e "  ${YELLOW}⚠️  Found scripts outside of scripts/ directories${NC}"
        ((issues++))
    fi
    
    # Check for missing library functions
    if [ -d "$CONSTRUCT_CORE/CONSTRUCT/scripts" ]; then
        local scripts_using_lib=$(grep -l "source.*lib/" "$CONSTRUCT_CORE/CONSTRUCT/scripts/"*.sh 2>/dev/null | wc -l)
        if [ "$scripts_using_lib" -lt 5 ]; then
            echo -e "  ${YELLOW}⚠️  Few scripts using library functions${NC}"
            ((issues++))
        fi
    fi
    
    return $issues
}

# Main validation
main() {
    local total_issues=0
    
    # Run CONSTRUCT-specific checks
    check_symlink_integrity || ((total_issues+=$?))
    check_lab_core_separation || ((total_issues+=$?))
    check_template_independence || ((total_issues+=$?))
    check_auto_documentation || ((total_issues+=$?))
    check_script_organization || ((total_issues+=$?))
    
    # Summary
    echo -e "\n${BLUE}CONSTRUCT Development Pattern Summary${NC}"
    echo "Total issues: $total_issues"
    
    # Return number of issues as exit code
    return $total_issues
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi