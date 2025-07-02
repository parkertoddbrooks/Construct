#!/bin/bash

# CONSTRUCT Symlink Integrity Checker
# Ensures symlinks are maintained and not replaced with regular files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSTRUCT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
CONSTRUCT_LAB="$CONSTRUCT_ROOT/CONSTRUCT-LAB"
CONSTRUCT_CORE="$CONSTRUCT_ROOT/CONSTRUCT-CORE"

echo -e "${BLUE}🔗 Checking CONSTRUCT symlink integrity...${NC}"

# Track violations
VIOLATIONS=0

# Expected symlinks from LAB to CORE
declare -A EXPECTED_SYMLINKS=(
    ["$CONSTRUCT_LAB/CONSTRUCT"]="../CONSTRUCT-CORE/CONSTRUCT"
    ["$CONSTRUCT_LAB/AI/dev-logs/dev-udpates/_devupdate-prompt.md"]="../../../../CONSTRUCT-CORE/AI/dev-logs/dev-updates/_devupdate-prompt.md"
    ["$CONSTRUCT_LAB/AI/dev-logs/check-quality/README.md"]="../../../../CONSTRUCT-CORE/AI/dev-logs/check-quality/README.md"
)

check_symlink() {
    local symlink_path="$1"
    local expected_target="$2"
    local name=$(basename "$symlink_path")
    
    if [ ! -e "$symlink_path" ]; then
        echo -e "${YELLOW}⚠️  Missing expected symlink: $name${NC}"
        echo "   Expected at: $symlink_path"
        echo "   Should point to: $expected_target"
        ((VIOLATIONS++))
        return
    fi
    
    if [ ! -L "$symlink_path" ]; then
        echo -e "${RED}❌ File should be symlink but isn't: $name${NC}"
        echo "   Path: $symlink_path"
        echo "   This should be a symlink to CORE!"
        ((VIOLATIONS++))
        return
    fi
    
    # Check if symlink points to correct target
    local actual_target=$(readlink "$symlink_path")
    if [ "$actual_target" != "$expected_target" ]; then
        echo -e "${YELLOW}⚠️  Symlink points to wrong target: $name${NC}"
        echo "   Expected: $expected_target"
        echo "   Actual: $actual_target"
        ((VIOLATIONS++))
        return
    fi
    
    echo -e "${GREEN}✅ Valid symlink: $name${NC}"
}

check_replaced_symlinks() {
    echo -e "${BLUE}📋 Checking for replaced symlinks...${NC}"
    
    # Check each expected symlink
    for symlink_path in "${!EXPECTED_SYMLINKS[@]}"; do
        check_symlink "$symlink_path" "${EXPECTED_SYMLINKS[$symlink_path]}"
    done
}

check_symlink_editability() {
    echo -e "${BLUE}🔒 Checking symlink edit protection...${NC}"
    
    # Check if our edit scripts have symlink protection
    local scripts_to_check=(
        "$CONSTRUCT_CORE/scripts/update-context.sh"
        "$CONSTRUCT_CORE/scripts/session-summary.sh"
    )
    
    local protected_scripts=0
    for script in "${scripts_to_check[@]}"; do
        if grep -q "if \[ -L" "$script" 2>/dev/null; then
            echo -e "${GREEN}✅ Script has symlink protection: $(basename "$script")${NC}"
            ((protected_scripts++))
        else
            echo -e "${YELLOW}⚠️  Script lacks symlink protection: $(basename "$script")${NC}"
        fi
    done
    
    echo -e "${BLUE}Protected scripts: $protected_scripts/${#scripts_to_check[@]}${NC}"
}

find_broken_symlinks() {
    echo -e "${BLUE}🔍 Searching for broken symlinks...${NC}"
    
    local broken_count=0
    while IFS= read -r -d '' symlink; do
        if [ ! -e "$symlink" ]; then
            echo -e "${RED}❌ Broken symlink: $symlink${NC}"
            ((broken_count++))
            ((VIOLATIONS++))
        fi
    done < <(find "$CONSTRUCT_LAB" -type l -print0 2>/dev/null)
    
    if [ $broken_count -eq 0 ]; then
        echo -e "${GREEN}✅ No broken symlinks found${NC}"
    fi
}

suggest_fixes() {
    if [ $VIOLATIONS -gt 0 ]; then
        echo ""
        echo -e "${YELLOW}📝 Suggested Fixes:${NC}"
        echo ""
        echo "1. To recreate missing symlinks:"
        echo "   cd $CONSTRUCT_LAB"
        echo "   ln -s ../CONSTRUCT-CORE/CONSTRUCT CONSTRUCT"
        echo ""
        echo "2. To convert regular files back to symlinks:"
        echo "   - Back up the current file"
        echo "   - Remove the regular file"
        echo "   - Create the symlink pointing to CORE"
        echo ""
        echo "3. To add symlink protection to scripts:"
        echo "   - Add symlink checks before edit operations"
        echo "   - See $CONSTRUCT_CORE/docs/symlink-promotion-rules.md"
    fi
}

# Generate summary report
generate_summary() {
    echo ""
    echo -e "${BLUE}📋 CONSTRUCT Symlink Integrity Summary${NC}"
    echo "==========================================="
    
    if [ $VIOLATIONS -eq 0 ]; then
        echo -e "${GREEN}✅ SYMLINK INTEGRITY VERIFIED${NC}"
        echo -e "${GREEN}   All symlinks are correctly maintained${NC}"
        echo -e "${GREEN}   LAB properly references CORE files${NC}"
    else
        echo -e "${RED}❌ SYMLINK INTEGRITY ISSUES FOUND${NC}"
        echo -e "${RED}   Found $VIOLATIONS symlink violations${NC}"
        echo -e "${RED}   Please fix issues before continuing${NC}"
    fi
    
    echo ""
    echo "Key principles:"
    echo "  - CORE contains source files"
    echo "  - LAB uses symlinks to reference CORE"
    echo "  - Never edit symlinks directly"
    echo "  - Use promotion workflow for changes"
}

# Main execution
main() {
    check_replaced_symlinks
    echo ""
    check_symlink_editability
    echo ""
    find_broken_symlinks
    
    suggest_fixes
    generate_summary
    
    exit $VIOLATIONS
}

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 [options]"
    echo ""
    echo "CONSTRUCT Symlink Integrity Checker"
    echo ""
    echo "Verifies that:"
    echo "  - Expected symlinks exist and point correctly"
    echo "  - No symlinks have been replaced with regular files"
    echo "  - Scripts have proper symlink protection"
    echo "  - No broken symlinks exist"
    echo ""
    echo "Exit code: Number of violations found"
    exit 0
fi

# Run main function
main "$@"