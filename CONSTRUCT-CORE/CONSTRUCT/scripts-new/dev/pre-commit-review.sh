#!/bin/bash

# Project Pre-Commit Review Script
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
SCRIPTS_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONSTRUCT_CORE="$(cd "$SCRIPTS_ROOT/../.." && pwd)"
source "$CONSTRUCT_CORE/CONSTRUCT/lib/interactive-support.sh"

# Function to show what prompts this script needs
show_pre_commit_prompts() {
    echo "1. Proceed with commit (after successful checks)"
    echo "   Options: [y/n]"
    echo "   Default: n"
    echo ""
    echo "2. Force commit anyway (if checks fail)"
    echo "   Options: [y/n]"
    echo "   Default: n"
}

# Check if should show prompts
if should_show_prompts "$@"; then
    show_script_prompts "$(basename "$0")" show_pre_commit_prompts
    exit 0
fi

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 [PROJECT_DIR]"
    echo ""
    echo "Run all pre-commit checks for a project"
    echo ""
    echo "Arguments:"
    echo "  PROJECT_DIR   Project directory (default: current directory)"
    echo ""
    echo "This script runs all quality checks before committing:"
    echo "  - Update context"
    echo "  - Check architecture"
    echo "  - Update documentation"
    echo "  - Check quality"
    echo "  - Scan structure"
    echo "  - Generate dev update"
    echo "  - Create session summary"
    exit 0
fi

# Accept PROJECT_DIR as parameter, default to current directory
PROJECT_DIR="${1:-.}"
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

echo -e "${BLUE}🏗️  Pre-Commit Review${NC}"
echo "Project: $PROJECT_DIR"
echo "=================================="
echo ""

# Track results
declare -a SCRIPT_RESULTS
declare -a SCRIPT_NAMES

# Function to run and track script results
run_and_track() {
    local script_name=$1
    local script_path=$2
    shift 2  # Remove first two arguments, rest are passed to script
    
    echo -e "${YELLOW}Running $script_name...${NC}"
    echo ""
    
    if [ -f "$script_path" ]; then
        if "$script_path" "$@"; then
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
    else
        SCRIPT_RESULTS+=("⚠️")
        SCRIPT_NAMES+=("$script_name")
        echo -e "${YELLOW}⚠️ $script_name not found at: $script_path${NC}"
    fi
    
    echo ""
    echo "=================================="
    echo ""
}

# Find the scripts directory (could be in PROJECT_DIR/CONSTRUCT or relative to this script)
if [ -d "$PROJECT_DIR/CONSTRUCT/scripts" ]; then
    SCRIPTS_DIR="$PROJECT_DIR/CONSTRUCT/scripts"
elif [ -d "$SCRIPTS_ROOT" ]; then
    SCRIPTS_DIR="$SCRIPTS_ROOT"
else
    echo -e "${RED}❌ Cannot find scripts directory${NC}"
    exit 1
fi

# Run all scripts individually with PROJECT_DIR parameter
run_and_track "update-context" "$SCRIPTS_DIR/construct/update-context.sh" "$PROJECT_DIR"
run_and_track "check-architecture" "$SCRIPTS_DIR/core/check-architecture.sh" "$PROJECT_DIR"
run_and_track "update-architecture" "$SCRIPTS_DIR/construct/update-architecture.sh" "$PROJECT_DIR"
run_and_track "check-quality" "$SCRIPTS_DIR/core/check-quality.sh" "$PROJECT_DIR"
run_and_track "scan-structure" "$SCRIPTS_DIR/construct/scan_project_structure.sh" "$PROJECT_DIR"
run_and_track "check-documentation" "$SCRIPTS_DIR/core/check-documentation.sh" "$PROJECT_DIR"
run_and_track "session-summary" "$SCRIPTS_DIR/dev/session-summary.sh" "$PROJECT_DIR"
# Handle generate-devupdate with arguments properly
echo -e "${YELLOW}Running generate-devupdate...${NC}"
echo ""

if [ -f "$SCRIPTS_DIR/dev/generate-devupdate.sh" ]; then
    if "$SCRIPTS_DIR/dev/generate-devupdate.sh" "$PROJECT_DIR" --auto; then
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
else
    SCRIPT_RESULTS+=("⚠️")
    SCRIPT_NAMES+=("generate-devupdate")
    echo -e "${YELLOW}⚠️ generate-devupdate not found${NC}"
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
STAGED_FILES=$(cd "$PROJECT_DIR" && git status --porcelain 2>/dev/null | wc -l | tr -d ' ' || echo "0")
echo -e "${BLUE}📁 Files to be committed: $STAGED_FILES${NC}"

if [ "$STAGED_FILES" -gt 0 ]; then
    echo ""
    echo -e "${YELLOW}Files that will be committed:${NC}"
    cd "$PROJECT_DIR" && git status --porcelain | head -10
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
    PROCEED=$(yes_no_prompt "${BLUE}Ready to commit. Proceed?${NC}" "n")
    
    if [ "$PROCEED" = "y" ]; then
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
    FORCE=$(yes_no_prompt "${BLUE}Force commit anyway?${NC}" "n")
    
    if [ "$FORCE" = "y" ]; then
        echo ""
        echo -e "${YELLOW}⚠️ Forcing commit despite failures...${NC}"
        exit 0
    else
        echo ""
        echo -e "${RED}🛑 Commit cancelled${NC}"
        exit 1
    fi
fi