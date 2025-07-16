#!/bin/bash

# Performance validator for web framework patterns
# Checks for common performance issues

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get project root
PROJECT_ROOT="${1:-$(pwd)}"
cd "$PROJECT_ROOT"

echo -e "${BLUE}⚡ Web Performance Validation${NC}"
echo "================================================"

ISSUES_FOUND=0

# Check for large bundle imports
echo -e "${YELLOW}Checking for non-tree-shakeable imports...${NC}"
if grep -r "import \* as" --include="*.js" --include="*.jsx" --include="*.ts" --include="*.tsx" . 2>/dev/null | grep -v node_modules | grep -v test | grep -v ".d.ts"; then
    echo -e "${YELLOW}⚠️  Found wildcard imports - may increase bundle size${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ No wildcard imports found${NC}"
fi

# Check for synchronous scripts
echo -e "${YELLOW}Checking for render-blocking scripts...${NC}"
if grep -r "<script[^>]*src=" --include="*.html" . 2>/dev/null | grep -v "defer\|async" | grep -v node_modules; then
    echo -e "${YELLOW}⚠️  Found scripts without async/defer${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ All scripts properly loaded${NC}"
fi

# Check for missing image dimensions
echo -e "${YELLOW}Checking for images without dimensions...${NC}"
if grep -r "<img[^>]*>" --include="*.html" --include="*.jsx" --include="*.tsx" . 2>/dev/null | grep -v "width\|height" | grep -v node_modules | head -5 | grep -q .; then
    echo -e "${YELLOW}⚠️  Found images without width/height - causes layout shift${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ Images have proper dimensions${NC}"
fi

# Check for missing lazy loading
echo -e "${YELLOW}Checking for images without lazy loading...${NC}"
if grep -r "<img[^>]*>" --include="*.html" --include="*.jsx" --include="*.tsx" . 2>/dev/null | grep -v "loading=" | grep -v node_modules | head -5 | grep -q .; then
    echo -e "${YELLOW}⚠️  Found images without loading attribute${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ Images use lazy loading${NC}"
fi

# Check for inefficient array operations in loops
echo -e "${YELLOW}Checking for array operations in loops...${NC}"
if grep -r "\.forEach\|\.map\|\.filter.*\.forEach\|\.map\|\.filter" --include="*.js" --include="*.jsx" --include="*.ts" --include="*.tsx" . 2>/dev/null | grep -v node_modules | grep -v test | head -5 | grep -q .; then
    echo -e "${YELLOW}⚠️  Found chained array operations - consider optimizing${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ Array operations look efficient${NC}"
fi

# Check for missing debounce on input handlers
echo -e "${YELLOW}Checking for undebounced input handlers...${NC}"
if grep -r "onChange=.*search\|filter\|query" --include="*.jsx" --include="*.tsx" . 2>/dev/null | grep -v "debounce\|throttle" | grep -v node_modules | head -5 | grep -q .; then
    echo -e "${YELLOW}⚠️  Found search/filter inputs without debounce${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ Input handlers properly debounced${NC}"
fi

# Check package.json for bundle size
if [ -f "package.json" ]; then
    echo -e "${YELLOW}Checking for large dependencies...${NC}"
    # Check for known large libraries without tree-shaking
    if grep -E "moment[^-]|lodash[^-]" package.json | grep -v "lodash-es" | grep -q .; then
        echo -e "${YELLOW}⚠️  Found large libraries - consider lighter alternatives${NC}"
        echo "  - moment → date-fns or dayjs"
        echo "  - lodash → lodash-es or native methods"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    else
        echo -e "${GREEN}✅ No obviously large dependencies${NC}"
    fi
fi

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo -e "${BLUE}Performance Check Summary${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo "Total performance issues found: $ISSUES_FOUND"

if [ $ISSUES_FOUND -eq 0 ]; then
    echo -e "${GREEN}✅ All performance checks passed!${NC}"
else
    echo -e "${YELLOW}⚠️  Performance optimizations available${NC}"
fi

exit $ISSUES_FOUND