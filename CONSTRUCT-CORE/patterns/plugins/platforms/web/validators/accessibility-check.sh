#!/bin/bash

# Accessibility validator for web platform patterns
# Checks for common a11y issues

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

echo -e "${BLUE}♿ Web Accessibility Validation${NC}"
echo "================================================"

ISSUES_FOUND=0

# Check for images without alt text
echo -e "${YELLOW}Checking for images without alt text...${NC}"
if grep -r "<img[^>]*>" --include="*.html" --include="*.jsx" --include="*.tsx" . 2>/dev/null | grep -v "alt=" | grep -v node_modules | head -5 | grep -q .; then
    echo -e "${RED}❌ Found images without alt attributes${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ All images have alt text${NC}"
fi

# Check for missing form labels
echo -e "${YELLOW}Checking for form inputs without labels...${NC}"
if grep -r "<input[^>]*>" --include="*.html" --include="*.jsx" --include="*.tsx" . 2>/dev/null | grep -v "aria-label\|aria-labelledby" | grep -v "type=\"submit\"\|type=\"button\"\|type=\"hidden\"" | grep -v node_modules | head -5 | grep -q .; then
    echo -e "${YELLOW}⚠️  Found inputs possibly missing labels${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ Form inputs properly labeled${NC}"
fi

# Check for missing lang attribute
echo -e "${YELLOW}Checking for HTML lang attribute...${NC}"
if grep -r "<html" --include="*.html" . 2>/dev/null | grep -v "lang=" | grep -v node_modules | head -1 | grep -q .; then
    echo -e "${RED}❌ Found HTML without lang attribute${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ HTML lang attribute present${NC}"
fi

# Check for heading hierarchy
echo -e "${YELLOW}Checking heading hierarchy...${NC}"
if grep -r "<h[3-6]" --include="*.html" --include="*.jsx" --include="*.tsx" . 2>/dev/null | grep -v node_modules > /tmp/headings.tmp; then
    # Simple check: look for h3 without preceding h2
    if grep -B5 "<h3" /tmp/headings.tmp 2>/dev/null | grep -v "<h2\|<h1" | grep -q "<h3"; then
        echo -e "${YELLOW}⚠️  Possible heading hierarchy issues${NC}"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    else
        echo -e "${GREEN}✅ Heading hierarchy looks good${NC}"
    fi
    rm -f /tmp/headings.tmp
else
    echo -e "${GREEN}✅ No heading issues detected${NC}"
fi

# Check for clickable divs/spans
echo -e "${YELLOW}Checking for non-semantic clickable elements...${NC}"
if grep -r "onClick=\|@click=\|v-on:click=" --include="*.jsx" --include="*.tsx" --include="*.vue" . 2>/dev/null | grep "<div\|<span" | grep -v node_modules | head -5 | grep -q .; then
    echo -e "${YELLOW}⚠️  Found div/span with click handlers - use button instead${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ Click handlers on semantic elements${NC}"
fi

# Check for color contrast in CSS
echo -e "${YELLOW}Checking for potential color contrast issues...${NC}"
if [ -f "package.json" ]; then
    # Look for common low-contrast color combinations
    if grep -r "color:.*#[cdef].*background.*#[cdef]\|background.*#[cdef].*color:.*#[cdef]" --include="*.css" --include="*.scss" . 2>/dev/null | grep -v node_modules | head -1 | grep -q .; then
        echo -e "${YELLOW}⚠️  Found potential low contrast color combinations${NC}"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    else
        echo -e "${GREEN}✅ No obvious contrast issues${NC}"
    fi
fi

# Check for keyboard navigation
echo -e "${YELLOW}Checking for keyboard navigation support...${NC}"
if grep -r "onKeyDown\|@keydown\|v-on:keydown" --include="*.jsx" --include="*.tsx" --include="*.vue" . 2>/dev/null | grep -v node_modules | grep -q .; then
    echo -e "${GREEN}✅ Keyboard event handlers found${NC}"
else
    echo -e "${YELLOW}⚠️  Limited keyboard event handling detected${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
fi

# Check for ARIA usage
echo -e "${YELLOW}Checking ARIA attribute usage...${NC}"
if grep -r "role=\|aria-" --include="*.html" --include="*.jsx" --include="*.tsx" . 2>/dev/null | grep -v node_modules | grep -q .; then
    echo -e "${GREEN}✅ ARIA attributes in use${NC}"
else
    echo -e "${BLUE}ℹ️  No ARIA attributes found (may be okay if using semantic HTML)${NC}"
fi

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo -e "${BLUE}Accessibility Check Summary${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo "Total accessibility issues found: $ISSUES_FOUND"

if [ $ISSUES_FOUND -eq 0 ]; then
    echo -e "${GREEN}✅ All accessibility checks passed!${NC}"
else
    echo -e "${YELLOW}⚠️  Accessibility improvements needed${NC}"
    echo ""
    echo "Consider using automated tools like:"
    echo "  - axe DevTools"
    echo "  - WAVE"
    echo "  - Lighthouse"
fi

exit $ISSUES_FOUND