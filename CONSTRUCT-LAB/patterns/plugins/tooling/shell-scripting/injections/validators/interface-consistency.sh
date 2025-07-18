#!/bin/bash

# Script Interface Consistency Validator
# Validates that all file-modifying scripts support --dry-run and --help consistently
# Part of: tooling/shell-scripting/injections/consistency-standards

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get project directory from parameter or current directory
PROJECT_DIR="${1:-.}"
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

echo -e "${BLUE}🔍 Validating script interface consistency...${NC}"
echo "Project: $PROJECT_DIR"

ISSUES_FOUND=0

# Find all shell scripts that likely modify files
find_file_modifying_scripts() {
    find "$PROJECT_DIR" -name "*.sh" -type f -perm +111 | while read -r script; do
        # Skip if script is in .git, node_modules, or other common ignore patterns
        if [[ "$script" =~ /.git/|/node_modules/|/_old/|/backup/ ]]; then
            continue
        fi
        
        # Check if script likely modifies files by looking for common patterns
        if grep -l '\(>\|>>\|mv\|cp\|rm\|mkdir\|touch\|chmod\|chown\)' "$script" >/dev/null 2>&1; then
            echo "$script"
        fi
    done
}

# Check if script supports a flag
check_flag_support() {
    local script="$1"
    local flag="$2"
    local description="$3"
    
    # Check if script has the flag in its argument parsing
    if grep -q "\-\-${flag}\|${flag})" "$script" 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Test if script actually responds to flag
test_flag_response() {
    local script="$1"
    local flag="$2"
    
    # Try running the script with the flag
    if timeout 5s "$script" "--$flag" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

echo -e "${YELLOW}Scanning for file-modifying scripts...${NC}"

SCRIPT_COUNT=0
while IFS= read -r script; do
    SCRIPT_COUNT=$((SCRIPT_COUNT + 1))
    script_name="$(basename "$script")"
    
    echo -e "${BLUE}Checking: $script_name${NC}"
    
    # Check --help support
    HELP_ISSUES=0
    if ! check_flag_support "$script" "help" "help flag"; then
        if ! check_flag_support "$script" "h" "help short flag"; then
            echo -e "  ${RED}❌${NC} Missing --help/-h support"
            HELP_ISSUES=1
            ISSUES_FOUND=$((ISSUES_FOUND + 1))
        fi
    fi
    
    if [ $HELP_ISSUES -eq 0 ]; then
        echo -e "  ${GREEN}✅${NC} Supports --help"
    fi
    
    # Check --dry-run support
    DRY_RUN_ISSUES=0
    if ! check_flag_support "$script" "dry-run" "dry-run flag"; then
        echo -e "  ${RED}❌${NC} Missing --dry-run support"
        DRY_RUN_ISSUES=1
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    else
        echo -e "  ${GREEN}✅${NC} Supports --dry-run"
    fi
    
    # Check exit code consistency (scripts should exit 0 on success)
    if grep -q 'exit [^0]' "$script" 2>/dev/null; then
        # This is actually good - using non-zero exit codes
        echo -e "  ${GREEN}✅${NC} Uses meaningful exit codes"
    else
        # Check if script has any exit statements
        if ! grep -q 'exit' "$script" 2>/dev/null; then
            echo -e "  ${YELLOW}⚠️${NC} No explicit exit codes (consider adding)"
        fi
    fi
    
done < <(find_file_modifying_scripts)

echo ""
echo -e "${BLUE}📋 Validation Summary${NC}"
echo "Scripts checked: $SCRIPT_COUNT"

if [ $ISSUES_FOUND -eq 0 ]; then
    echo -e "${GREEN}✅ All scripts follow interface consistency standards${NC}"
    echo -e "${GREEN}✅ No issues found${NC}"
else
    echo -e "${RED}❌ Found $ISSUES_FOUND interface consistency issues${NC}"
    echo ""
    echo -e "${YELLOW}Required fixes:${NC}"
    echo "1. Add --help/-h flag support to all file-modifying scripts"
    echo "2. Add --dry-run flag support to all file-modifying scripts"
    echo "3. Ensure scripts show usage with --help"
    echo "4. Ensure --dry-run shows what would be changed without making changes"
    echo ""
    echo -e "${BLUE}Reference implementation:${NC}"
    echo "See: tooling/shell-scripting/injections/consistency-standards.md"
fi

# Exit with number of issues found (following our own consistency standards!)
exit $ISSUES_FOUND