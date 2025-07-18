#!/bin/bash

# Security validator for web framework patterns
# Checks for common security vulnerabilities

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

echo -e "${BLUE}🔒 Web Security Validation${NC}"
echo "================================================"

ISSUES_FOUND=0

# Check for hardcoded API keys
echo -e "${YELLOW}Checking for exposed API keys...${NC}"
if grep -r "api[_-]?key.*=.*['\"][a-zA-Z0-9]{20,}" --include="*.js" --include="*.jsx" --include="*.ts" --include="*.tsx" . 2>/dev/null | grep -v node_modules | grep -v test; then
    echo -e "${RED}❌ Found potential API keys in frontend code${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ No exposed API keys found${NC}"
fi

# Check for localStorage sensitive data
echo -e "${YELLOW}Checking for sensitive data in localStorage...${NC}"
if grep -r "localStorage\.setItem.*\(password\|token\|secret\|key\)" --include="*.js" --include="*.jsx" --include="*.ts" --include="*.tsx" . 2>/dev/null | grep -v node_modules | grep -v test; then
    echo -e "${RED}❌ Found sensitive data being stored in localStorage${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ No sensitive localStorage usage found${NC}"
fi

# Check for eval() usage
echo -e "${YELLOW}Checking for dangerous eval() usage...${NC}"
if grep -r "eval\s*(" --include="*.js" --include="*.jsx" --include="*.ts" --include="*.tsx" . 2>/dev/null | grep -v node_modules | grep -v test | grep -v eslint; then
    echo -e "${RED}❌ Found eval() usage - security risk${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ No eval() usage found${NC}"
fi

# Check for innerHTML usage
echo -e "${YELLOW}Checking for unsafe innerHTML usage...${NC}"
if grep -r "innerHTML\s*=" --include="*.js" --include="*.jsx" --include="*.ts" --include="*.tsx" . 2>/dev/null | grep -v node_modules | grep -v test; then
    echo -e "${YELLOW}⚠️  Found innerHTML usage - ensure content is sanitized${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ No innerHTML usage found${NC}"
fi

# Check for HTTP in production
echo -e "${YELLOW}Checking for insecure HTTP URLs...${NC}"
if grep -r "http://" --include="*.js" --include="*.jsx" --include="*.ts" --include="*.tsx" --include="*.env.production" . 2>/dev/null | grep -v node_modules | grep -v localhost | grep -v "127.0.0.1" | grep -v test | grep -v comment; then
    echo -e "${RED}❌ Found HTTP URLs in production code${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ No insecure HTTP URLs found${NC}"
fi

# Check for SQL injection vulnerabilities
echo -e "${YELLOW}Checking for potential SQL injection...${NC}"
if grep -r "query.*\${.*}" --include="*.js" --include="*.ts" . 2>/dev/null | grep -v node_modules | grep -v test; then
    echo -e "${YELLOW}⚠️  Found string interpolation in queries - use parameterized queries${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ No obvious SQL injection patterns found${NC}"
fi

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo -e "${BLUE}Security Check Summary${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo "Total security issues found: $ISSUES_FOUND"

if [ $ISSUES_FOUND -eq 0 ]; then
    echo -e "${GREEN}✅ All security checks passed!${NC}"
else
    echo -e "${RED}❌ Security issues need attention${NC}"
fi

exit $ISSUES_FOUND