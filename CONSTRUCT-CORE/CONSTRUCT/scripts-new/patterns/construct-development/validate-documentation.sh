#!/bin/bash

# CONSTRUCT Development Pattern - Documentation Validator
# Validates CONSTRUCT-specific documentation standards

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATTERN_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONSTRUCT_ROOT="$(cd "$PATTERN_ROOT/../../../.." && pwd)"
CONSTRUCT_CORE="$CONSTRUCT_ROOT/CONSTRUCT-CORE"

echo -e "${BLUE}🏗️  CONSTRUCT Development Documentation Validation${NC}"
echo "------------------------------------------------"

# CONSTRUCT-specific documentation checks
check_ai_documentation() {
    local project_dir="$1"
    local issues=0
    
    echo -e "\n${YELLOW}Checking AI documentation structure...${NC}"
    
    # Check for CLAUDE.md
    if [ ! -f "$project_dir/CLAUDE.md" ]; then
        echo -e "  ${RED}❌ Missing CLAUDE.md in project root${NC}"
        ((issues++))
    else
        echo -e "  ${GREEN}✅ CLAUDE.md exists${NC}"
    fi
    
    # Check for AI directory structure
    if [ -d "$project_dir/AI" ]; then
        # Check for key subdirectories
        local ai_dirs=("docs" "todo" "dev-logs" "structure")
        for dir in "${ai_dirs[@]}"; do
            if [ ! -d "$project_dir/AI/$dir" ]; then
                echo -e "  ${YELLOW}⚠️  Missing AI/$dir directory${NC}"
                ((issues++))
            fi
        done
        
        # Check for README in AI directory
        if [ ! -f "$project_dir/AI/README.md" ] && [ ! -f "$project_dir/AI/README-sym.md" ]; then
            echo -e "  ${YELLOW}⚠️  Missing README in AI directory${NC}"
            ((issues++))
        fi
    else
        echo -e "  ${YELLOW}⚠️  No AI directory found${NC}"
        ((issues++))
    fi
    
    return $issues
}

check_todo_documentation() {
    local project_dir="$1"
    local issues=0
    
    echo -e "\n${YELLOW}Checking todo documentation...${NC}"
    
    if [ -d "$project_dir/AI/todo" ]; then
        # Check for current directory
        if [ ! -d "$project_dir/AI/todo/current" ]; then
            echo -e "  ${YELLOW}⚠️  Missing AI/todo/current directory${NC}"
            ((issues++))
        fi
        
        # Check for future directory
        if [ ! -d "$project_dir/AI/todo/future" ]; then
            echo -e "  ${YELLOW}⚠️  Missing AI/todo/future directory${NC}"
            ((issues++))
        fi
        
        # Check for README
        if [ ! -f "$project_dir/AI/todo/README.md" ] && [ ! -f "$project_dir/AI/todo/README-sym.md" ]; then
            echo -e "  ${YELLOW}⚠️  Missing README in AI/todo${NC}"
            ((issues++))
        fi
    fi
    
    return $issues
}

check_dev_logs() {
    local project_dir="$1"
    local issues=0
    
    echo -e "\n${YELLOW}Checking dev logs documentation...${NC}"
    
    if [ -d "$project_dir/AI/dev-logs" ]; then
        # Check for session states
        if [ ! -d "$project_dir/AI/dev-logs/session-states" ]; then
            echo -e "  ${YELLOW}⚠️  Missing AI/dev-logs/session-states directory${NC}"
            ((issues++))
        fi
        
        # Check for dev updates
        if [ ! -d "$project_dir/AI/dev-logs/dev-updates" ]; then
            echo -e "  ${YELLOW}⚠️  Missing AI/dev-logs/dev-updates directory${NC}"
            ((issues++))
        fi
        
        # Check for README
        if [ ! -f "$project_dir/AI/dev-logs/README.md" ] && [ ! -f "$project_dir/AI/dev-logs/README-sym.md" ]; then
            echo -e "  ${YELLOW}⚠️  Missing README in AI/dev-logs${NC}"
            ((issues++))
        fi
    fi
    
    return $issues
}

check_pattern_documentation() {
    local project_dir="$1"
    local issues=0
    
    echo -e "\n${YELLOW}Checking pattern documentation...${NC}"
    
    # Check if patterns directory exists
    if [ -d "$project_dir/patterns" ]; then
        # Check for README
        if [ ! -f "$project_dir/patterns/README.md" ]; then
            echo -e "  ${YELLOW}⚠️  Missing README in patterns directory${NC}"
            ((issues++))
        fi
        
        # Check each pattern subdirectory
        for pattern_dir in "$project_dir/patterns"/*; do
            if [ -d "$pattern_dir" ]; then
                local pattern_name=$(basename "$pattern_dir")
                
                # Check for pattern README
                if [ ! -f "$pattern_dir/README.md" ]; then
                    echo -e "  ${YELLOW}⚠️  Missing README for pattern: $pattern_name${NC}"
                    ((issues++))
                fi
                
                # Check for validate scripts documentation
                if [ -f "$pattern_dir/validate-architecture.sh" ] || [ -f "$pattern_dir/validate-quality.sh" ]; then
                    if ! grep -q "Purpose\|Description" "$pattern_dir"/validate-*.sh 2>/dev/null; then
                        echo -e "  ${YELLOW}⚠️  Pattern validators lack documentation: $pattern_name${NC}"
                        ((issues++))
                    fi
                fi
            fi
        done
    fi
    
    return $issues
}

check_architectural_docs() {
    local project_dir="$1"
    local issues=0
    
    echo -e "\n${YELLOW}Checking architectural documentation...${NC}"
    
    # Check for key architecture docs
    if [ -d "$project_dir/AI/docs" ]; then
        local arch_docs=("architecture-overview" "development-patterns" "script-reference")
        
        for doc in "${arch_docs[@]}"; do
            if ! find "$project_dir/AI/docs" -name "*${doc}*.md" -type f | grep -q .; then
                echo -e "  ${YELLOW}⚠️  Missing architectural doc: $doc${NC}"
                ((issues++))
            fi
        done
    fi
    
    # Check for improving guide
    if [ ! -f "$project_dir/AI/docs/automated/improving-CONSTRUCT-guide-automated.md" ]; then
        echo -e "  ${YELLOW}⚠️  Missing improving CONSTRUCT guide${NC}"
        ((issues++))
    fi
    
    return $issues
}

# Main validation
main() {
    # Accept PROJECT_DIR as parameter, default to current directory
    local PROJECT_DIR="${1:-.}"
    PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
    
    local total_issues=0
    
    echo "Checking CONSTRUCT documentation in: $PROJECT_DIR"
    
    # Run CONSTRUCT-specific documentation checks
    check_ai_documentation "$PROJECT_DIR" || ((total_issues+=$?))
    check_todo_documentation "$PROJECT_DIR" || ((total_issues+=$?))
    check_dev_logs "$PROJECT_DIR" || ((total_issues+=$?))
    check_pattern_documentation "$PROJECT_DIR" || ((total_issues+=$?))
    check_architectural_docs "$PROJECT_DIR" || ((total_issues+=$?))
    
    # Summary
    echo -e "\n${BLUE}CONSTRUCT Documentation Summary${NC}"
    echo "Total documentation issues: $total_issues"
    
    if [ $total_issues -eq 0 ]; then
        echo -e "${GREEN}✅ All CONSTRUCT documentation standards met${NC}"
    else
        echo -e "${YELLOW}⚠️  Consider improving CONSTRUCT documentation coverage${NC}"
    fi
    
    return $total_issues
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi