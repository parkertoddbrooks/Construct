#!/bin/bash

# CONSTRUCT Commit with Review
# Runs pre-commit review, then commits if approved

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
CONSTRUCT_DEV="$CONSTRUCT_ROOT/CONSTRUCT-dev"

# Check if we're in the right directory
if [ ! -d "$CONSTRUCT_ROOT/.git" ]; then
    echo -e "${RED}❌ Not in a git repository${NC}"
    exit 1
fi

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "CONSTRUCT Commit with Review"
    echo ""
    echo "Usage: $0 [git commit options]"
    echo ""
    echo "This script:"
    echo "1. Runs all pre-commit checks with full visibility"
    echo "2. Shows a summary of results"
    echo "3. Asks for confirmation before committing"
    echo "4. Executes git commit with your provided arguments"
    echo ""
    echo "Examples:"
    echo "  $0 -m \"Your commit message\""
    echo "  $0 -m \"feat: Add new feature\" --no-verify"
    echo ""
    exit 0
fi

# Check if commit message provided
if [ $# -eq 0 ]; then
    echo -e "${RED}❌ No commit arguments provided${NC}"
    echo "Usage: $0 -m \"commit message\" [other git commit options]"
    echo "Use $0 --help for more information"
    exit 1
fi

echo -e "${BLUE}🏗️  CONSTRUCT Commit with Review${NC}"
echo "=================================="
echo ""

# Change to project root
cd "$CONSTRUCT_ROOT"

# Stage any unstaged changes
echo -e "${YELLOW}📁 Staging changes...${NC}"
git add -A
echo ""

# Run pre-commit review
echo -e "${BLUE}🔍 Running pre-commit review...${NC}"
echo ""

if "$CONSTRUCT_DEV/CONSTRUCT/scripts/pre-commit-review.sh"; then
    echo ""
    echo -e "${GREEN}✅ Pre-commit review approved${NC}"
    echo ""
    
    # Execute the git commit with all provided arguments
    echo -e "${BLUE}🚀 Executing: git commit $*${NC}"
    echo ""
    
    git commit "$@"
    
    echo ""
    echo -e "${GREEN}✅ Commit successful!${NC}"
    echo -e "${BLUE}Trust The Process.${NC}"
    
else
    echo ""
    echo -e "${RED}❌ Pre-commit review failed or was cancelled${NC}"
    echo ""
    echo "No commit was made."
    exit 1
fi