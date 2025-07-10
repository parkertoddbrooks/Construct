#!/bin/bash

# Pre-Coding Guidance - Context-Aware Search
# Shows what exists before creating new functionality in any project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 [PROJECT_DIR] <search-term>"
    echo "       $0 <search-term>"
    echo ""
    echo "Search for existing functionality before creating new code"
    echo ""
    echo "Arguments:"
    echo "  PROJECT_DIR   Directory to search (default: current directory)"
    echo "  search-term   What to search for (component name, function, etc.)"
    echo ""
    echo "This script helps prevent duplication by showing:"
    echo "  - Existing components with similar names"
    echo "  - Related functions and services"
    echo "  - Pattern-specific guidance"
    echo ""
    echo "Examples:"
    echo "  $0 PaymentView          # Search in current directory"
    echo "  $0 ./MyApp UserService  # Search in specific project"
    exit 0
fi

# Accept PROJECT_DIR as first parameter, search term as second
# Or just search term if only one parameter
if [ $# -eq 2 ]; then
    PROJECT_DIR="$1"
    SEARCH_TERM="$2"
elif [ $# -eq 1 ]; then
    PROJECT_DIR="."
    SEARCH_TERM="$1"
else
    PROJECT_DIR="."
    SEARCH_TERM=""
fi

# Convert to absolute path
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

# Get active patterns from patterns.yaml
get_active_patterns() {
    local patterns_file="$PROJECT_DIR/.construct/patterns.yaml"
    
    if [ ! -f "$patterns_file" ]; then
        echo -e "${RED}❌ Error: No .construct/patterns.yaml found${NC}"
        echo -e "${YELLOW}This is required for CONSTRUCT projects${NC}"
        echo -e "${YELLOW}Run 'construct-patterns init' to create one${NC}"
        exit 1
    fi
    
    # Check for yq
    if ! command -v yq >/dev/null 2>&1; then
        echo -e "${RED}❌ Error: yq is required to read patterns.yaml${NC}"
        echo -e "${YELLOW}Install yq: https://github.com/mikefarah/yq${NC}"
        exit 1
    fi
    
    # Get active patterns
    yq eval '.plugins[]' "$patterns_file" 2>/dev/null || echo ""
}

# Detect primary language from patterns
detect_primary_language() {
    local patterns="$1"
    
    # Check for language patterns
    if echo "$patterns" | grep -q "swift-language"; then
        echo "swift"
    elif echo "$patterns" | grep -q "csharp-language"; then
        echo "csharp"
    elif echo "$patterns" | grep -q "typescript-language"; then
        echo "typescript"
    elif echo "$patterns" | grep -q "python-language"; then
        echo "python"
    elif echo "$patterns" | grep -q "shell-scripting"; then
        echo "shell"
    else
        echo "generic"
    fi
}

ACTIVE_PATTERNS=$(get_active_patterns)
PRIMARY_LANGUAGE=$(detect_primary_language "$ACTIVE_PATTERNS")

echo -e "${BLUE}🔍 Pre-Coding Check${NC}"
echo "Project: $PROJECT_DIR"
echo "Primary Language: $PRIMARY_LANGUAGE"
echo "Active Patterns: $(echo "$ACTIVE_PATTERNS" | tr '\n' ', ' | sed 's/, $//')"
echo ""

if [ -z "$SEARCH_TERM" ]; then
    echo -e "${YELLOW}Usage: $0 [PROJECT_DIR] <search_term>${NC}"
    echo ""
    echo "Examples:"
    echo "  $0 validate_file                    # Search in current directory"
    echo "  $0 . UserViewModel                  # Search for UserViewModel in current project"
    echo "  $0 Projects/MyApp/ios AppColors     # Search in specific project"
    echo ""
    echo "Context-aware search based on project type:"
    echo "  - CONSTRUCT projects: searches scripts, lib, config"
    echo "  - Swift projects: searches .swift, .xcodeproj files"
    echo "  - C# projects: searches .cs, .csproj files"
    echo "  - Others: searches all text files"
    echo ""
    exit 1
fi

echo -e "${BLUE}🎯 Searching for: '$SEARCH_TERM'${NC}"
echo ""

check_existing_functions() {
    # Check if this is a CONSTRUCT development project
    local is_construct_dev=false
    if echo "$ACTIVE_PATTERNS" | grep -q "construct-development"; then
        is_construct_dev=true
    fi
    
    case "$PRIMARY_LANGUAGE" in
        shell)
            echo -e "${BLUE}📚 Checking shell scripts and functions...${NC}"
            if [ "$is_construct_dev" = true ]; then
                local lib_dirs=("$PROJECT_DIR/CONSTRUCT/lib" "$PROJECT_DIR/lib")
            else
                local lib_dirs=("$PROJECT_DIR")
            fi
            ;;
        swift)
            echo -e "${BLUE}📚 Checking Swift files...${NC}"
            local lib_dirs=("$PROJECT_DIR")
            ;;
        csharp)
            echo -e "${BLUE}📚 Checking C# files...${NC}"
            local lib_dirs=("$PROJECT_DIR")
            ;;
        *)
            echo -e "${BLUE}📚 Checking source files...${NC}"
            local lib_dirs=("$PROJECT_DIR")
            ;;
    esac
    
    local found_functions=0
    
    for dir in "${lib_dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            continue
        fi
        
        case "$PRIMARY_LANGUAGE" in
            shell)
                local files=$(find "$dir" -name "*.sh" -type f 2>/dev/null || true)
                ;;
            swift)
                local files=$(find "$dir" -name "*.swift" -type f 2>/dev/null || true)
                ;;
            csharp)
                local files=$(find "$dir" -name "*.cs" -type f 2>/dev/null || true)
                ;;
            typescript)
                local files=$(find "$dir" \( -name "*.ts" -o -name "*.tsx" \) -type f 2>/dev/null || true)
                ;;
            python)
                local files=$(find "$dir" -name "*.py" -type f 2>/dev/null || true)
                ;;
            *)
                local files=$(find "$dir" -type f -name "*" 2>/dev/null || true)
                ;;
        esac
        
        for file in $files; do
            local matches=$(grep -n "$SEARCH_TERM" "$file" 2>/dev/null | head -5 || true)
            
            if [ -n "$matches" ]; then
                echo -e "${GREEN}✅ Found in $(basename "$file"):${NC}"
                echo "$matches" | while read -r line; do
                    echo "   $line"
                done
                ((found_functions++))
            fi
        done
    done
    
    if [ $found_functions -eq 0 ]; then
        echo -e "${YELLOW}   No matches found in source files${NC}"
    fi
    echo ""
}

check_existing_scripts() {
    # Skip if not a shell/CONSTRUCT project
    if [ "$PRIMARY_LANGUAGE" != "shell" ]; then
        return
    fi
    
    echo -e "${BLUE}🔧 Checking existing scripts...${NC}"
    
    local script_files=$(find "$PROJECT_DIR" -name "*.sh" -type f -not -path "*/lib/*" 2>/dev/null || true)
    local found_scripts=0
    
    for script_file in $script_files; do
        if grep -l "$SEARCH_TERM" "$script_file" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Found in $(basename "$script_file"):${NC}"
            local matches=$(grep -n "$SEARCH_TERM" "$script_file" | head -3)
            echo "$matches" | while read -r line; do
                echo "   $line"
            done
            ((found_scripts++))
        fi
    done
    
    if [ $found_scripts -eq 0 ]; then
        echo -e "${YELLOW}   No existing scripts found matching '$SEARCH_TERM'${NC}"
    fi
    echo ""
}

check_configuration() {
    echo -e "${BLUE}⚙️ Checking configuration files...${NC}"
    
    local config_patterns
    case "$PRIMARY_LANGUAGE" in
        shell)
            config_patterns="-name *.yaml -o -name *.yml"
            ;;
        swift)
            config_patterns="-name *.plist -o -name *.xcconfig -o -name *.yaml"
            ;;
        csharp)
            config_patterns="-name *.json -o -name *.config -o -name *.yaml"
            ;;
        typescript)
            config_patterns="-name *.json -o -name *.yaml -o -name *.yml"
            ;;
        *)
            config_patterns="-name *.yaml -o -name *.yml -o -name *.json -o -name *.config"
            ;;
    esac
    
    local config_files=$(find "$PROJECT_DIR" \( $config_patterns \) -type f 2>/dev/null || true)
    local found_configs=0
    
    for config_file in $config_files; do
        # Skip node_modules and similar
        if [[ "$config_file" == *"node_modules"* ]] || [[ "$config_file" == *".git"* ]]; then
            continue
        fi
        
        if grep -l "$SEARCH_TERM" "$config_file" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Found in $(basename "$config_file"):${NC}"
            local matches=$(grep -n "$SEARCH_TERM" "$config_file" | head -3)
            echo "$matches" | while read -r line; do
                echo "   $line"
            done
            ((found_configs++))
        fi
    done
    
    if [ $found_configs -eq 0 ]; then
        echo -e "${YELLOW}   No configuration found matching '$SEARCH_TERM'${NC}"
    fi
    echo ""
}

check_documentation() {
    echo -e "${BLUE}📖 Checking documentation...${NC}"
    
    local doc_files=$(find "$PROJECT_DIR" -name "*.md" -type f 2>/dev/null || true)
    local found_docs=0
    
    for doc_file in $doc_files; do
        # Skip node_modules and similar
        if [[ "$doc_file" == *"node_modules"* ]] || [[ "$doc_file" == *".git"* ]]; then
            continue
        fi
        
        if grep -l "$SEARCH_TERM" "$doc_file" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Found in $(basename "$doc_file"):${NC}"
            local matches=$(grep -n "$SEARCH_TERM" "$doc_file" | head -2)
            echo "$matches" | while read -r line; do
                echo "   $line"
            done
            ((found_docs++))
        fi
    done
    
    if [ $found_docs -eq 0 ]; then
        echo -e "${YELLOW}   No documentation found matching '$SEARCH_TERM'${NC}"
    fi
    echo ""
}

check_project_specific() {
    # Check if this is a CONSTRUCT development project
    local is_construct_dev=false
    if echo "$ACTIVE_PATTERNS" | grep -q "construct-development"; then
        is_construct_dev=true
    fi
    
    case "$PRIMARY_LANGUAGE" in
        swift)
            echo -e "${BLUE}🎯 Checking Swift-specific files...${NC}"
            # Check storyboards, xibs
            local ui_files=$(find "$PROJECT_DIR" \( -name "*.storyboard" -o -name "*.xib" \) -type f 2>/dev/null || true)
            local found=0
            
            for file in $ui_files; do
                if grep -l "$SEARCH_TERM" "$file" > /dev/null 2>&1; then
                    echo -e "${GREEN}✅ Found in UI file: $(basename "$file")${NC}"
                    ((found++))
                fi
            done
            
            if [ $found -eq 0 ]; then
                echo -e "${YELLOW}   No UI files found matching '$SEARCH_TERM'${NC}"
            fi
            ;;
            
        shell)
            if [ "$is_construct_dev" = true ]; then
                echo -e "${BLUE}🎯 Checking templates...${NC}"
                local template_files=$(find "$PROJECT_DIR" -path "*/Templates/*" -type f 2>/dev/null || true)
                local found_templates=0
                
                for template_file in $template_files; do
                    if grep -l "$SEARCH_TERM" "$template_file" > /dev/null 2>&1; then
                        echo -e "${GREEN}✅ Found in template: $(basename "$template_file")${NC}"
                        local matches=$(grep -n "$SEARCH_TERM" "$template_file" | head -2)
                        echo "$matches" | while read -r line; do
                            echo "   $line"
                        done
                        ((found_templates++))
                    fi
                done
                
                if [ $found_templates -eq 0 ]; then
                    echo -e "${YELLOW}   No templates found matching '$SEARCH_TERM'${NC}"
                fi
            fi
            ;;
    esac
    echo ""
}

suggest_patterns() {
    echo -e "${BLUE}💡 Suggestions based on search term and active patterns...${NC}"
    
    # Check if this is a CONSTRUCT development project
    local is_construct_dev=false
    if echo "$ACTIVE_PATTERNS" | grep -q "construct-development"; then
        is_construct_dev=true
    fi
    
    case "$PRIMARY_LANGUAGE" in
        shell)
            case "$SEARCH_TERM" in
                *validate*|*check*)
                    echo -e "${GREEN}✨ For validation functions:${NC}"
                    echo "   - Add to lib/validation.sh"
                    echo "   - Follow pattern: validate_something()"
                    echo "   - Include error messages with colors"
                    echo "   - Return 0 for success, 1 for failure"
                    ;;
                *template*)
                    echo -e "${GREEN}✨ For template functions:${NC}"
                    echo "   - Add to lib/template-utils.sh"
                    echo "   - Check template integrity first"
                    echo "   - Use existing template validation patterns"
                    ;;
                *)
                    echo -e "${GREEN}✨ CONSTRUCT development suggestions:${NC}"
                    echo "   - Check existing lib/ functions first"
                    echo "   - Follow shell script best practices"
                    echo "   - Add proper error handling (set -e)"
                    echo "   - Update relevant YAML configs"
                    ;;
            esac
            ;;
            
        swift)
            case "$SEARCH_TERM" in
                *View*|*Controller*)
                    echo -e "${GREEN}✨ For Swift UI components:${NC}"
                    echo "   - Follow MVVM pattern"
                    echo "   - Check existing ViewModels"
                    echo "   - Use design tokens for styling"
                    echo "   - Consider reusable components"
                    ;;
                *Service*|*Manager*)
                    echo -e "${GREEN}✨ For Swift services:${NC}"
                    echo "   - Create protocol first"
                    echo "   - Use dependency injection"
                    echo "   - Handle errors with Result type"
                    echo "   - Add async/await support"
                    ;;
                *)
                    echo -e "${GREEN}✨ Swift development suggestions:${NC}"
                    echo "   - Follow Swift naming conventions"
                    echo "   - Check for existing extensions"
                    echo "   - Consider protocol-oriented design"
                    echo "   - Use @MainActor for UI updates"
                    ;;
            esac
            ;;
            
        csharp)
            echo -e "${GREEN}✨ C# development suggestions:${NC}"
            echo "   - Follow .NET naming conventions"
            echo "   - Check for existing services"
            echo "   - Use dependency injection"
            echo "   - Consider async/await patterns"
            ;;
            
        *)
            echo -e "${GREEN}✨ General suggestions:${NC}"
            echo "   - Check existing implementations"
            echo "   - Follow project conventions"
            echo "   - Consider reusability"
            echo "   - Document your code"
            ;;
    esac
    echo ""
}

show_next_steps() {
    echo -e "${BLUE}🚀 Next Steps${NC}"
    echo "=============="
    echo ""
    echo "Before creating new functionality:"
    echo "  1. Review existing implementations above"
    echo "  2. Check if enhancement is better than new creation"
    echo "  3. Consider which file/directory is appropriate"
    echo "  4. Follow established patterns and conventions"
    echo ""
    
    # Check if this is a CONSTRUCT development project
    local is_construct_dev=false
    if echo "$ACTIVE_PATTERNS" | grep -q "construct-development"; then
        is_construct_dev=true
    fi
    
    case "$PRIMARY_LANGUAGE" in
        shell)
            echo "CONSTRUCT workflow:"
            echo "  ./CONSTRUCT/scripts/core/check-architecture.sh    # Verify current state"
            echo "  # ... make your changes ..."
            echo "  ./CONSTRUCT/scripts/construct/update-context.sh   # Update development context"
            echo "  ./CONSTRUCT/scripts/core/check-quality.sh         # Check quality"
            echo ""
            echo "Available resources:"
            echo "  - lib/ functions for reusable code"
            echo "  - config/ YAML for configuration"
            echo "  - patterns/ for pattern plugins"
            ;;
            
        swift)
            echo "Swift workflow:"
            echo "  - Check existing ViewModels and Services"
            echo "  - Follow MVVM architecture"
            echo "  - Run construct-check for violations"
            echo "  - Update CLAUDE.md if needed"
            ;;
            
        csharp)
            echo "C# workflow:"
            echo "  - Check existing services and models"
            echo "  - Follow project architecture"
            echo "  - Consider API versioning"
            echo "  - Update documentation"
            ;;
            
        *)
            echo "General workflow:"
            echo "  - Review project conventions"
            echo "  - Check for similar implementations"
            echo "  - Follow existing patterns"
            echo "  - Document your changes"
            ;;
    esac
}

# Main execution
main() {
    echo -e "${GREEN}🚀 Starting pre-coding check for '$SEARCH_TERM'...${NC}"
    echo ""
    
    # Run all checks
    check_existing_functions
    check_existing_scripts
    check_configuration
    check_documentation
    check_project_specific
    suggest_patterns
    show_next_steps
    
    echo -e "${GREEN}✅ Pre-coding check complete!${NC}"
}

# Run main function
main "$@"