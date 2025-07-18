#!/bin/bash

# check-construct-structure.sh - Validates CONSTRUCT development structure
# This validator ensures CONSTRUCT follows its own architectural patterns

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get project root
PROJECT_ROOT="${1:-$(pwd)}"
cd "$PROJECT_ROOT"

echo -e "${BLUE}🔍 Checking CONSTRUCT structure...${NC}"

ISSUES=0

# Check if this is CONSTRUCT repository
if [ ! -d "CONSTRUCT-CORE" ] || [ ! -d "CONSTRUCT-LAB" ]; then
    echo -e "${YELLOW}⚠️  Not a CONSTRUCT repository, skipping CONSTRUCT-specific checks${NC}"
    exit 0
fi

# Check for required directories
REQUIRED_DIRS=(
    "CONSTRUCT-CORE/CONSTRUCT/scripts/core"
    "CONSTRUCT-CORE/CONSTRUCT/scripts/construct"
    "CONSTRUCT-CORE/CONSTRUCT/scripts/dev"
    "CONSTRUCT-CORE/CONSTRUCT/scripts/workspace"
    "CONSTRUCT-CORE/CONSTRUCT/lib"
    "CONSTRUCT-CORE/CONSTRUCT/config"
    "CONSTRUCT-CORE/patterns"
    "CONSTRUCT-LAB/AI/docs"
    "CONSTRUCT-LAB/AI/PRDs"
    "CONSTRUCT-LAB/patterns"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        echo -e "${RED}❌ Missing required directory: $dir${NC}"
        ISSUES=$((ISSUES + 1))
    fi
done

# Check for key symlinks
echo -e "${BLUE}Checking symlinks...${NC}"
if [ -L "CONSTRUCT-LAB/CONSTRUCT" ]; then
    if [ ! -e "CONSTRUCT-LAB/CONSTRUCT" ]; then
        echo -e "${RED}❌ Broken symlink: CONSTRUCT-LAB/CONSTRUCT${NC}"
        ISSUES=$((ISSUES + 1))
    fi
else
    echo -e "${RED}❌ Missing symlink: CONSTRUCT-LAB/CONSTRUCT should link to ../CONSTRUCT-CORE/CONSTRUCT${NC}"
    ISSUES=$((ISSUES + 1))
fi

# Check for patterns.yaml
if [ ! -f ".construct/patterns.yaml" ]; then
    echo -e "${RED}❌ Missing .construct/patterns.yaml${NC}"
    ISSUES=$((ISSUES + 1))
else
    # Check if construct-dev pattern is active
    if ! grep -q "tooling/construct-dev" ".construct/patterns.yaml"; then
        echo -e "${YELLOW}⚠️  construct-dev pattern not active in patterns.yaml${NC}"
        echo "  Consider adding: plugins: [\"tooling/construct-dev\"]"
    fi
fi

# Check for hardcoded paths in scripts
echo -e "${BLUE}Checking for hardcoded paths...${NC}"
if grep -r "/Users\|/home\|/opt" CONSTRUCT-CORE/CONSTRUCT/scripts --include="*.sh" 2>/dev/null | grep -v "^Binary"; then
    echo -e "${RED}❌ Found hardcoded paths in scripts${NC}"
    ISSUES=$((ISSUES + 1))
fi

# Summary
echo ""
if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}✅ All CONSTRUCT structure checks passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Found $ISSUES structure issues${NC}"
    exit 1
fi