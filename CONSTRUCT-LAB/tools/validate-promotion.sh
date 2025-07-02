#!/bin/bash

# CONSTRUCT Promotion Validator - Validates files before promotion
# Run this before promote-to-core.sh to catch issues early

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONSTRUCT_ROOT="$(cd "$LAB_ROOT/.." && pwd)"
CORE_ROOT="$CONSTRUCT_ROOT/CONSTRUCT-CORE"

# Promotion manifest
PROMOTION_MANIFEST="$LAB_ROOT/PROMOTE-TO-CORE.yaml"

echo -e "${BLUE}🔍 CONSTRUCT Promotion Validator${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Validation results
ERRORS=0
WARNINGS=0

# Check if promotion manifest exists
if [ ! -f "$PROMOTION_MANIFEST" ]; then
    echo -e "${RED}❌ Error: Promotion manifest not found${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Found promotion manifest${NC}"
echo ""

# Function to validate a promotion entry
validate_promotion_entry() {
    local source="$1"
    local dest="$2"
    local description="$3"
    local bump_version="$4"
    
    echo -e "${BLUE}Validating promotion:${NC}"
    echo "  Source: $source"
    echo "  Dest: $dest"
    
    # Check if source exists
    if [ ! -f "$LAB_ROOT/$source" ]; then
        echo -e "${RED}  ❌ Source file not found: $source${NC}"
        ERRORS=$((ERRORS + 1))
        return
    fi
    
    # Check if source is executable (for scripts)
    if [[ "$source" == *.sh ]]; then
        if [ ! -x "$LAB_ROOT/$source" ]; then
            echo -e "${YELLOW}  ⚠️  Warning: Script is not executable: $source${NC}"
            WARNINGS=$((WARNINGS + 1))
        fi
        
        # Check for bash shebang
        if ! head -n1 "$LAB_ROOT/$source" | grep -q "^#!/bin/bash"; then
            echo -e "${YELLOW}  ⚠️  Warning: Script missing #!/bin/bash: $source${NC}"
            WARNINGS=$((WARNINGS + 1))
        fi
        
        # Check for set -e
        if ! grep -q "^set -e" "$LAB_ROOT/$source"; then
            echo -e "${YELLOW}  ⚠️  Warning: Script missing 'set -e': $source${NC}"
            WARNINGS=$((WARNINGS + 1))
        fi
    fi
    
    # Check if destination already exists
    if [ -f "$dest" ]; then
        echo -e "${YELLOW}  ⚠️  Note: Destination exists and will be replaced${NC}"
    fi
    
    # Validate bump_version
    if [[ ! "$bump_version" =~ ^(major|minor|patch)$ ]]; then
        echo -e "${RED}  ❌ Invalid bump_version: $bump_version (must be major/minor/patch)${NC}"
        ERRORS=$((ERRORS + 1))
    fi
    
    # Check description
    if [ -z "$description" ]; then
        echo -e "${YELLOW}  ⚠️  Warning: No description provided${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
    
    echo -e "${GREEN}  ✅ Validation complete${NC}"
    echo ""
}

# Simple YAML parser for validation
# In production, use proper YAML parsing
echo -e "${BLUE}Checking promotion entries...${NC}"
echo ""

# For now, just check if there are any active (non-commented) promotions
active_promotions=$(grep -E "^[[:space:]]*-[[:space:]]*type:" "$PROMOTION_MANIFEST" 2>/dev/null | wc -l || echo "0")

if [ "$active_promotions" -eq 0 ]; then
    echo -e "${YELLOW}⚠️  No active promotions found${NC}"
    echo ""
    echo "To add promotions:"
    echo "1. Edit $PROMOTION_MANIFEST"
    echo "2. Uncomment or add promotion entries"
    echo "3. Run this validator again"
    exit 0
fi

echo -e "${GREEN}✅ Found $active_promotions active promotion(s)${NC}"
echo ""

# Additional checks
echo -e "${BLUE}Running additional checks...${NC}"

# Check CONSTRUCT-CORE exists
if [ ! -d "$CORE_ROOT" ]; then
    echo -e "${RED}❌ CONSTRUCT-CORE directory not found${NC}"
    ERRORS=$((ERRORS + 1))
else
    echo -e "${GREEN}✅ CONSTRUCT-CORE directory exists${NC}"
fi

# Check VERSION file
if [ ! -f "$CORE_ROOT/VERSION" ]; then
    echo -e "${YELLOW}⚠️  VERSION file not found (will be created)${NC}"
    WARNINGS=$((WARNINGS + 1))
else
    current_version=$(cat "$CORE_ROOT/VERSION")
    echo -e "${GREEN}✅ Current CORE version: $current_version${NC}"
fi

# Check for uncommitted changes in LAB
if [ -d "$LAB_ROOT/.git" ]; then
    if ! git -C "$LAB_ROOT" diff --quiet; then
        echo -e "${YELLOW}⚠️  Warning: Uncommitted changes in LAB${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Validation Summary${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed! Ready to promote.${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Validation passed with $WARNINGS warning(s)${NC}"
    echo ""
    echo "You can proceed with promotion, but review the warnings first."
    exit 0
else
    echo -e "${RED}❌ Validation failed with $ERRORS error(s) and $WARNINGS warning(s)${NC}"
    echo ""
    echo "Please fix the errors before attempting promotion."
    exit 1
fi