#!/bin/bash

# CONSTRUCT Quality Checker - Master Script
# Orchestrates pattern-specific quality validation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Accept PROJECT_DIR as first parameter, default to current directory
PROJECT_DIR="${1:-.}"
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

# Detect CONSTRUCT_CORE location (handles both LAB symlink and direct usage)
if [ -d "$SCRIPT_DIR/../../CONSTRUCT-CORE" ]; then
    CONSTRUCT_CORE="$(cd "$SCRIPT_DIR/../../CONSTRUCT-CORE" && pwd)"
else
    # Fallback for different structures
    CONSTRUCT_CORE="$(cd "$SCRIPT_DIR/../.." && pwd)"
fi

# Source common libraries
source "$CONSTRUCT_CORE/CONSTRUCT/lib/common-patterns.sh"
source "$CONSTRUCT_CORE/CONSTRUCT/lib/validation.sh"

echo -e "${BLUE}🔍 CONSTRUCT Quality Validation${NC}"
echo "======================================="
echo "Project: $PROJECT_DIR"
echo ""

# Function to get active patterns
get_active_patterns() {
    local project_dir="$1"
    local patterns_file="$project_dir/.construct/patterns.yaml"
    
    if [ -f "$patterns_file" ]; then
        yq eval '.plugins[]' "$patterns_file" 2>/dev/null || echo ""
    fi
    
    # Always include base quality patterns
    echo "shell-quality"
    echo "code-quality"
}

# Run base quality checks
run_base_quality_checks() {
    echo -e "\n${YELLOW}Running base quality checks...${NC}"
    
    local project_dir="$1"
    local issues_found=0
    
    # Check for TODO/FIXME without context
    echo -n "Checking for undocumented TODOs... "
    local todos=$(grep -r "TODO\|FIXME" "$project_dir" --include="*.sh" --include="*.swift" --include="*.cs" 2>/dev/null | grep -v "TODO.*:" | wc -l)
    if [ "$todos" -gt 0 ]; then
        echo -e "${YELLOW}⚠️  Found $todos TODOs without descriptions${NC}"
        ((issues_found++))
    else
        echo -e "${GREEN}✅ All TODOs documented${NC}"
    fi
    
    # Check for debugging artifacts
    echo -n "Checking for debug code... "
    if grep -r "console\.log\|print(\|echo.*DEBUG" "$project_dir" --include="*.sh" --include="*.swift" --include="*.js" 2>/dev/null | grep -v "^#"; then
        echo -e "${YELLOW}⚠️  Found debugging artifacts${NC}"
        ((issues_found++))
    else
        echo -e "${GREEN}✅ No debug code found${NC}"
    fi
    
    return $issues_found
}

# Main execution
main() {
    local total_issues=0
    local patterns_checked=0
    
    # Run base quality checks
    if ! run_base_quality_checks "$PROJECT_DIR"; then
        ((total_issues+=$?))
    fi
    
    # Get active patterns
    echo -e "\n${YELLOW}Detecting active quality patterns...${NC}"
    local active_patterns=$(get_active_patterns "$PROJECT_DIR")
    
    if [ -z "$active_patterns" ]; then
        echo -e "${YELLOW}No patterns configured, running default checks only${NC}"
    else
        echo "Active quality patterns:"
        echo "$active_patterns" | while read -r pattern; do
            echo "  - $pattern"
        done
    fi
    
    # Run pattern-specific quality checks
    echo -e "\n${YELLOW}Running pattern-specific quality checks...${NC}"
    while IFS= read -r pattern; do
        [ -z "$pattern" ] && continue
        
        local pattern_script="$SCRIPT_DIR/patterns/$pattern/validate-quality.sh"
        
        if [ -f "$pattern_script" ]; then
            echo -e "\n${BLUE}→ Running $pattern quality checks${NC}"
            # Pass PROJECT_DIR as parameter to pattern validators
            if ! bash "$pattern_script" "$PROJECT_DIR"; then
                ((total_issues+=$?))
            fi
            ((patterns_checked++))
        else
            echo -e "${YELLOW}→ No quality checks for pattern: $pattern${NC}"
        fi
    done <<< "$active_patterns"
    
    # Generate quality report in project's AI directory
    local report_dir="$PROJECT_DIR/AI/quality-reports"
    mkdir -p "$report_dir"
    local report_file="$report_dir/quality-report-$(date +%Y-%m-%d--%H-%M-%S).md"
    
    {
        echo "# Quality Report"
        echo "Generated: $(date)"
        echo ""
        echo "## Summary"
        echo "- Patterns checked: $patterns_checked"
        echo "- Total issues: $total_issues"
        echo ""
        echo "## Active Patterns"
        echo "$active_patterns" | while read -r pattern; do
            echo "- $pattern"
        done
    } > "$report_file"
    
    # Summary
    echo -e "\n${BLUE}═══════════════════════════════════════════════${NC}"
    echo -e "${BLUE}Quality Check Summary${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
    echo "Patterns checked: $patterns_checked"
    echo "Total issues found: $total_issues"
    echo "Report generated: $report_file"
    
    if [ $total_issues -eq 0 ]; then
        echo -e "${GREEN}✅ All quality checks passed!${NC}"
        exit 0
    else
        echo -e "${RED}❌ Quality validation found $total_issues issues${NC}"
        exit 1
    fi
}

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 [PROJECT_DIR]"
    echo ""
    echo "CONSTRUCT Quality Validation - Master Script"
    echo ""
    echo "This script orchestrates quality validation across all active patterns."
    echo "It runs base checks and then delegates to pattern-specific validators."
    echo ""
    echo "Arguments:"
    echo "  PROJECT_DIR   Directory to check quality in (default: current directory)"
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                    # Check quality in current directory"
    echo "  $0 .                  # Check quality in current directory"
    echo "  $0 Projects/MyApp/ios # Check quality in specific project"
    echo ""
    echo "Pattern validators are located in:"
    echo "  $SCRIPT_DIR/patterns/*/validate-quality.sh"
    exit 0
fi

# Run main function
main "$@"