#!/bin/bash

# CONSTRUCT Documentation Checker - Master Script
# Orchestrates pattern-specific documentation validation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 [PROJECT_DIR]"
    echo ""
    echo "Check project documentation completeness"
    echo ""
    echo "Arguments:"
    echo "  PROJECT_DIR   Directory to check (default: current directory)"
    echo ""
    echo "This script validates documentation by:"
    echo "  - Checking README files exist"
    echo "  - Validating function documentation"
    echo "  - Running pattern-specific doc validators"
    echo ""
    echo "Exit code: Number of issues found (0 = success)"
    exit 0
fi

# Accept PROJECT_DIR as first parameter, default to current directory
PROJECT_DIR="${1:-.}"
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

# Detect CONSTRUCT_CORE location (handles both LAB symlink and direct usage)
if [ -d "$SCRIPTS_ROOT/../../CONSTRUCT-CORE" ]; then
    CONSTRUCT_CORE="$(cd "$SCRIPTS_ROOT/../../CONSTRUCT-CORE" && pwd)"
else
    # Fallback for different structures
    CONSTRUCT_CORE="$(cd "$SCRIPTS_ROOT/../.." && pwd)"
fi

# Source common libraries
source "$CONSTRUCT_CORE/CONSTRUCT/lib/common-patterns.sh"
source "$CONSTRUCT_CORE/CONSTRUCT/lib/validation.sh"

echo -e "${BLUE}📚 CONSTRUCT Documentation Validation${NC}"
echo "================================================"
echo "Project: $PROJECT_DIR"
echo ""

# Function to get active patterns from patterns.yaml
get_active_patterns() {
    local project_dir="$1"
    local patterns_file="$project_dir/.construct/patterns.yaml"
    
    if [ ! -f "$patterns_file" ]; then
        echo -e "${RED}❌ Error: No .construct/patterns.yaml found${NC}" >&2
        echo -e "${YELLOW}Run 'construct-patterns init' to create one${NC}" >&2
        return 1
    fi
    
    # Check for yq
    if ! command -v yq >/dev/null 2>&1; then
        echo -e "${RED}❌ Error: yq is required to read patterns.yaml${NC}" >&2
        echo -e "${YELLOW}Install yq: https://github.com/mikefarah/yq${NC}" >&2
        return 1
    fi
    
    # Extract active plugins
    yq eval '.plugins[]' "$patterns_file" 2>/dev/null || echo ""
}

# Run base documentation checks
run_base_checks() {
    echo -e "\n${YELLOW}Running base documentation checks...${NC}"
    
    local project_dir="$1"
    local issues_found=0
    
    # Check if patterns.yaml exists
    echo -n "Checking for patterns.yaml... "
    if [ ! -f "$project_dir/.construct/patterns.yaml" ]; then
        echo -e "${RED}❌ Missing .construct/patterns.yaml${NC}"
        ((issues_found++))
    else
        echo -e "${GREEN}✅ patterns.yaml exists${NC}"
    fi
    
    # Check if project has basic structure
    echo -n "Checking project structure... "
    if [ ! -d "$project_dir/AI" ] && [ ! -d "$project_dir/.construct" ]; then
        echo -e "${YELLOW}⚠️  No AI or .construct directory found${NC}"
        ((issues_found++))
    else
        echo -e "${GREEN}✅ Project structure looks good${NC}"
    fi
    
    # Note: All language-specific checks moved to pattern validators
    
    return $issues_found
}

# Main execution
main() {
    local total_issues=0
    local patterns_checked=0
    
    # Run base checks first
    run_base_checks "$PROJECT_DIR"
    local base_exit=$?
    if [ $base_exit -gt 0 ]; then
        ((total_issues+=base_exit))
    fi
    
    # Get active patterns
    echo -e "\n${YELLOW}Detecting active patterns...${NC}"
    local active_patterns=$(get_active_patterns "$PROJECT_DIR")
    
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
        
        # Try new plugin structure first
        local plugin_validator="$CONSTRUCT_CORE/patterns/plugins/$pattern/validators/documentation.sh"
        # Fallback to old location for backward compatibility
        local old_validator="$SCRIPTS_ROOT/patterns/$pattern/validate-documentation.sh"
        
        local validator_script=""
        if [ -f "$plugin_validator" ]; then
            validator_script="$plugin_validator"
        elif [ -f "$old_validator" ]; then
            validator_script="$old_validator"
            echo -e "${YELLOW}  ⚠️  Using legacy validator location for $pattern${NC}"
        fi
        
        if [ -n "$validator_script" ]; then
            echo -e "\n${BLUE}→ Running $pattern documentation checks${NC}"
            # Pass PROJECT_DIR as parameter to pattern validators
            bash "$validator_script" "$PROJECT_DIR"
            local pattern_exit=$?
            if [ $pattern_exit -gt 0 ]; then
                ((total_issues+=pattern_exit))
            fi
            ((patterns_checked++))
        else
            echo -e "${YELLOW}→ No documentation checks for pattern: $pattern${NC}"
        fi
    done <<< "$active_patterns"
    
    # Summary
    echo -e "\n${BLUE}═══════════════════════════════════════════════${NC}"
    echo -e "${BLUE}Documentation Check Summary${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
    echo "Patterns checked: $patterns_checked"
    echo "Total issues found: $total_issues"
    
    if [ $total_issues -eq 0 ]; then
        echo -e "${GREEN}✅ All documentation checks passed!${NC}"
        exit 0
    else
        echo -e "${RED}❌ Documentation validation failed with $total_issues issues${NC}"
        echo -e "${YELLOW}Run individual pattern validators for details${NC}"
        exit 1
    fi
}

# Run main function
main "$@"