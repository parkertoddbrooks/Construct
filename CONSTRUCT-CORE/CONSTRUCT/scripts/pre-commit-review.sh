#!/bin/bash

# CONSTRUCT Pre-Commit Review Script
# Runs all pre-commit checks individually with full visibility, then asks for commit confirmation

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

echo -e "${BLUE}🏗️  CONSTRUCT Pre-Commit Review${NC}"
echo "=================================="
echo ""

# Track results
declare -a SCRIPT_RESULTS
declare -a SCRIPT_NAMES

# Function to run and track script results
run_and_track() {
    local script_name=$1
    local script_path=$2
    
    echo -e "${YELLOW}Running $script_name...${NC}"
    echo ""
    
    if "$script_path"; then
        SCRIPT_RESULTS+=("✅")
        SCRIPT_NAMES+=("$script_name")
        echo ""
        echo -e "${GREEN}✅ $script_name completed successfully${NC}"
    else
        SCRIPT_RESULTS+=("❌")
        SCRIPT_NAMES+=("$script_name")
        echo ""
        echo -e "${RED}❌ $script_name failed${NC}"
    fi
    
    echo ""
    echo "=================================="
    echo ""
}

# Run all scripts individually
run_and_track "update-context" "$CONSTRUCT_DEV/CONSTRUCT/scripts/update-context.sh"
run_and_track "check-architecture" "$CONSTRUCT_DEV/CONSTRUCT/scripts/check-architecture.sh"
run_and_track "update-architecture" "$CONSTRUCT_DEV/CONSTRUCT/scripts/update-architecture.sh"
run_and_track "check-quality" "$CONSTRUCT_DEV/CONSTRUCT/scripts/check-quality.sh"
run_and_track "scan-structure" "$CONSTRUCT_DEV/CONSTRUCT/scripts/scan_construct_structure.sh"
run_and_track "check-documentation" "$CONSTRUCT_DEV/CONSTRUCT/scripts/check-documentation.sh"
run_and_track "session-summary" "$CONSTRUCT_DEV/CONSTRUCT/scripts/session-summary.sh"
# Handle generate-devupdate with arguments properly
echo -e "${YELLOW}Running generate-devupdate...${NC}"
echo ""

if cd "$CONSTRUCT_DEV" && ./CONSTRUCT/scripts/generate-devupdate.sh --auto; then
    SCRIPT_RESULTS+=("✅")
    SCRIPT_NAMES+=("generate-devupdate")
    echo ""
    echo -e "${GREEN}✅ generate-devupdate completed successfully${NC}"
else
    SCRIPT_RESULTS+=("❌")
    SCRIPT_NAMES+=("generate-devupdate")
    echo ""
    echo -e "${RED}❌ generate-devupdate failed${NC}"
fi

echo ""
echo "=================================="
echo ""

# Display summary
echo -e "${BLUE}📋 Pre-Commit Check Summary${NC}"
echo "============================"
echo ""

for i in "${!SCRIPT_NAMES[@]}"; do
    echo -e "${SCRIPT_RESULTS[$i]} ${SCRIPT_NAMES[$i]}"
done

echo ""

# Count results
PASSED=0
FAILED=0
for result in "${SCRIPT_RESULTS[@]}"; do
    if [[ "$result" == "✅" ]]; then
        ((PASSED++))
    else
        ((FAILED++))
    fi
done

echo -e "${BLUE}Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}"
echo ""

# Check for uncommitted changes that would be staged
STAGED_FILES=$(cd "$CONSTRUCT_ROOT" && git status --porcelain | wc -l | tr -d ' ')
echo -e "${BLUE}📁 Files to be committed: $STAGED_FILES${NC}"

if [ "$STAGED_FILES" -gt 0 ]; then
    echo ""
    echo -e "${YELLOW}Files that will be committed:${NC}"
    cd "$CONSTRUCT_ROOT" && git status --porcelain | head -10
    if [ "$STAGED_FILES" -gt 10 ]; then
        echo "... and $((STAGED_FILES - 10)) more files"
    fi
fi

echo ""
echo "=================================="

# Ask for confirmation
if [ "$FAILED" -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed!${NC}"
    echo ""
    echo -e "${BLUE}Ready to commit. Proceed? (y/n):${NC}"
    read -r response
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo ""
        echo -e "${GREEN}🚀 Proceeding with commit...${NC}"
        exit 0
    else
        echo ""
        echo -e "${YELLOW}⏸️ Commit cancelled by user${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Some checks failed${NC}"
    echo ""
    echo "Fix the failing checks before committing."
    echo ""
    echo -e "${BLUE}Force commit anyway? (y/n):${NC}"
    read -r response
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo ""
        echo -e "${YELLOW}⚠️ Forcing commit despite failures...${NC}"
        exit 0
    else
        echo ""
        echo -e "${RED}🛑 Commit cancelled${NC}"
        exit 1
    fi
fi