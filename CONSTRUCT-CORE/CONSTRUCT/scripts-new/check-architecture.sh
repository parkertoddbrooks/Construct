#!/bin/bash

# CONSTRUCT Architecture Checker - Master Script
# Orchestrates pattern-specific architecture validation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSTRUCT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
CONSTRUCT_CORE="$CONSTRUCT_ROOT/CONSTRUCT-CORE"

# Source common libraries
source "$CONSTRUCT_CORE/CONSTRUCT/lib/common-patterns.sh"
source "$CONSTRUCT_CORE/CONSTRUCT/lib/validation.sh"

echo -e "${BLUE}🏗️  CONSTRUCT Architecture Validation${NC}"
echo "================================================"

# Function to get active patterns from patterns.yaml
get_active_patterns() {
    local patterns_file="${1:-$CONSTRUCT_ROOT/.construct/patterns.yaml}"
    
    if [ -f "$patterns_file" ]; then
        # Extract active plugins
        yq eval '.plugins[]' "$patterns_file" 2>/dev/null || echo ""
    fi
    
    # Always include base CONSTRUCT patterns
    echo "construct-development"
    echo "shell-scripting"
}

# Run base architecture checks
run_base_checks() {
    echo -e "\n${YELLOW}Running base architecture checks...${NC}"
    
    # Check for common architectural issues
    local issues_found=0
    
    # Check for hardcoded paths
    echo -n "Checking for hardcoded paths... "
    if grep -r "/Users\|/home" "$CONSTRUCT_ROOT" --include="*.sh" --exclude-dir=".git" >/dev/null 2>&1; then
        echo -e "${RED}❌ Found hardcoded paths${NC}"
        ((issues_found++))
    else
        echo -e "${GREEN}✅ No hardcoded paths${NC}"
    fi
    
    # Check for proper error handling
    echo -n "Checking for error handling... "
    local scripts_without_set_e=$(find "$CONSTRUCT_ROOT" -name "*.sh" -type f -exec grep -L "set -e" {} \; 2>/dev/null | wc -l)
    if [ "$scripts_without_set_e" -gt 0 ]; then
        echo -e "${YELLOW}⚠️  $scripts_without_set_e scripts missing 'set -e'${NC}"
        ((issues_found++))
    else
        echo -e "${GREEN}✅ All scripts have error handling${NC}"
    fi
    
    return $issues_found
}

# Main execution
main() {
    local total_issues=0
    local patterns_checked=0
    
    # Run base checks first
    if ! run_base_checks; then
        ((total_issues+=$?))
    fi
    
    # Get active patterns
    echo -e "\n${YELLOW}Detecting active patterns...${NC}"
    local active_patterns=$(get_active_patterns)
    
    if [ -z "$active_patterns" ]; then
        echo -e "${YELLOW}No patterns configured, running default checks only${NC}"
    else
        echo "Active patterns:"
        echo "$active_patterns" | while read -r pattern; do
            echo "  - $pattern"
        done
    fi
    
    # Run pattern-specific checks
    echo -e "\n${YELLOW}Running pattern-specific checks...${NC}"
    while IFS= read -r pattern; do
        [ -z "$pattern" ] && continue
        
        local pattern_script="$SCRIPT_DIR/patterns/$pattern/validate-architecture.sh"
        
        if [ -f "$pattern_script" ]; then
            echo -e "\n${BLUE}→ Running $pattern architecture checks${NC}"
            if ! bash "$pattern_script"; then
                ((total_issues+=$?))
            fi
            ((patterns_checked++))
        else
            echo -e "${YELLOW}→ No architecture checks for pattern: $pattern${NC}"
        fi
    done <<< "$active_patterns"
    
    # Summary
    echo -e "\n${BLUE}═══════════════════════════════════════════════${NC}"
    echo -e "${BLUE}Architecture Check Summary${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
    echo "Patterns checked: $patterns_checked"
    echo "Total issues found: $total_issues"
    
    if [ $total_issues -eq 0 ]; then
        echo -e "${GREEN}✅ All architecture checks passed!${NC}"
        exit 0
    else
        echo -e "${RED}❌ Architecture validation failed with $total_issues issues${NC}"
        echo -e "${YELLOW}Run individual pattern validators for details${NC}"
        exit 1
    fi
}

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 [options]"
    echo ""
    echo "CONSTRUCT Architecture Validation - Master Script"
    echo ""
    echo "This script orchestrates architecture validation across all active patterns."
    echo "It runs base checks and then delegates to pattern-specific validators."
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message"
    echo ""
    echo "Pattern validators are located in:"
    echo "  $SCRIPT_DIR/patterns/*/validate-architecture.sh"
    exit 0
fi

# Run main function
main "$@"