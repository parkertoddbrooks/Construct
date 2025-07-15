## CONSTRUCT Development Examples

### New Shell Script Template

```bash
#!/bin/bash

# Script Name - Brief Description
# Detailed explanation of what this script does

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
CONSTRUCT_CORE="$CONSTRUCT_ROOT/CONSTRUCT-CORE"

# Source library functions
source "$CONSTRUCT_CORE/CONSTRUCT/lib/validation.sh"
source "$CONSTRUCT_CORE/CONSTRUCT/lib/common-patterns.sh"

echo -e "${BLUE}🔍 Script description...${NC}"

# Main function with proper error handling
main() {
    # Validate environment
    validate_environment
    
    # Implementation here
    echo -e "${GREEN}✅ Success message${NC}"
}

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 [options]"
    echo "Description of script and options"
    exit 0
fi

# Run main function
main "$@"
```

### Library Function Template

```bash
# Function description
# Parameters:
#   $1 - Description of first parameter
#   $2 - Description of second parameter  
# Returns:
#   0 on success, 1 on failure
function_name() {
    local param1="$1"
    local param2="$2"
    
    # Validation
    if [ -z "$param1" ]; then
        echo -e "${RED}❌ Error: param1 required${NC}" >&2
        return 1
    fi
    
    # Implementation
    echo -e "${GREEN}✅ Success${NC}"
    return 0
}
```

### Configuration-Driven Validation Pattern

```bash
# Load validation rules from YAML config
load_validation_rules() {
    local config_file="$CONSTRUCT_CORE/CONSTRUCT/config/quality-gates.yaml"
    
    if [ ! -f "$config_file" ]; then
        echo -e "${RED}❌ Config file not found: $config_file${NC}" >&2
        return 1
    fi
    
    # Parse and apply rules
    # (Implementation depends on requirements)
}
```

### File Analysis Script Example

```bash
#!/bin/bash

# Example: File Analysis Script
# Analyzes shell scripts for quality and patterns

set -e

# Colors and setup (standard pattern)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Path resolution (always relative)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSTRUCT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
CONSTRUCT_CORE="$CONSTRUCT_ROOT/CONSTRUCT-CORE"

# Library sourcing (always validate)
source "$CONSTRUCT_CORE/CONSTRUCT/lib/validation.sh"
source "$CONSTRUCT_CORE/CONSTRUCT/lib/file-analysis.sh"

# Documented function with clear purpose
analyze_script_quality() {
    local script_path="$1"
    local issues_found=0
    
    echo -e "${BLUE}🔍 Analyzing: $(basename "$script_path")${NC}"
    
    # Check for error handling
    if ! grep -q "set -e" "$script_path"; then
        echo -e "${YELLOW}⚠️ Missing 'set -e' error handling${NC}"
        issues_found=$((issues_found + 1))
    fi
    
    # Check for proper output formatting
    if ! grep -q "GREEN.*NC" "$script_path"; then
        echo -e "${YELLOW}⚠️ Consider adding colored output${NC}"
        issues_found=$((issues_found + 1))
    fi
    
    # Return result
    if [ $issues_found -eq 0 ]; then
        echo -e "${GREEN}✅ Script quality check passed${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️ Found $issues_found quality issues${NC}"
        return 1
    fi
}

main() {
    echo -e "${BLUE}🚀 Starting script quality analysis...${NC}"
    
    # Validate environment first
    validate_environment
    
    # Process scripts
    local scripts_processed=0
    local scripts_passed=0
    
    while IFS= read -r -d '' script; do
        if analyze_script_quality "$script"; then
            scripts_passed=$((scripts_passed + 1))
        fi
        scripts_processed=$((scripts_processed + 1))
    done < <(find "$CONSTRUCT_CORE/CONSTRUCT/scripts" -name "*.sh" -print0)
    
    # Summary
    echo -e "${BLUE}📋 Analysis Summary${NC}"
    echo "Scripts processed: $scripts_processed"
    echo "Scripts passed: $scripts_passed"
    
    if [ $scripts_passed -eq $scripts_processed ]; then
        echo -e "${GREEN}✅ All scripts meet quality standards${NC}"
    else
        echo -e "${YELLOW}⚠️ Some scripts need improvement${NC}"
    fi
}

# Help text
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0"
    echo "Analyzes shell scripts for quality and coding standards"
    echo ""
    echo "This script checks for:"
    echo "  - Proper error handling (set -e)"
    echo "  - Colored output formatting"
    echo "  - Documentation standards"
    exit 0
fi

main "$@"
```

### Symlink Management Pattern

```bash
# Check symlink integrity
./CONSTRUCT/scripts/construct/check-symlinks.sh

# What's symlinked (from LAB to CORE):
# - CONSTRUCT/ (entire directory)
# - AI/docs/README.md  
# - AI/dev-logs/*/README.md
# - AI/dev-logs/dev-updates/_devupdate-prompt.md

# What's independent:
# - User-created files in LAB
# - tools/ directory (LAB-specific)
# - Development work files

# Generate symlink documentation for CLAUDE.md:
./CONSTRUCT/scripts/construct/check-symlinks.sh --list-markdown
```

### LAB-to-CORE Promotion Pattern

```bash
# Promotion workflow for tested changes
./tools/validate-promotion.sh   # Check if changes are ready
./tools/promote-to-core.sh      # Promote validated changes

# Configuration file: PROMOTE-TO-CORE.yaml
# - Defines promotion rules
# - Specifies validation requirements
# - Controls which files get promoted

# Workflow:
# 1. Develop and test in LAB
# 2. Validate promotion readiness
# 3. Promote to CORE via tools
# 4. Symlinks automatically reflect changes
```

### Cross-Environment Analysis Pattern

```bash
# Analyze both CONSTRUCT and USER environments
analyze_dual_environment() {
    echo -e "${BLUE}🔍 Analyzing dual environment...${NC}"
    
    # Analyze CONSTRUCT development patterns
    echo -e "${YELLOW}Analyzing CONSTRUCT patterns...${NC}"
    analyze_construct_architecture
    
    # Analyze USER project patterns (read-only)
    echo -e "${YELLOW}Analyzing USER project patterns...${NC}"
    analyze_user_project_readonly
    
    # Extract insights for improvements
    echo -e "${YELLOW}Extracting cross-environment insights...${NC}"
    extract_improvement_patterns
}
```

### Template Management Patterns

```bash
# Template Integrity Validation
validate_template_integrity() {
    local template_dir="$CONSTRUCT_CORE/TEMPLATES"
    local issues=0
    
    echo -e "${BLUE}🔍 Validating template integrity...${NC}"
    
    # Check for CONSTRUCT-specific code in templates
    if grep -r "CONSTRUCT-LAB\|CONSTRUCT-CORE" "$template_dir" --include="*.sh" > /dev/null; then
        echo -e "${RED}❌ Found CONSTRUCT-specific paths in templates${NC}"
        issues=$((issues + 1))
    fi
    
    # Verify template independence
    for template in $(find "$template_dir" -name "*.sh" -type f); do
        if ! bash -n "$template" 2>/dev/null; then
            echo -e "${RED}❌ Syntax error in template: $(basename "$template")${NC}"
            issues=$((issues + 1))
        fi
    done
    
    if [ $issues -eq 0 ]; then
        echo -e "${GREEN}✅ All templates valid${NC}"
    else
        echo -e "${YELLOW}⚠️ Found $issues template issues${NC}"
    fi
    
    return $issues
}

# Template Variable Replacement
apply_template_variables() {
    local template_file="$1"
    local project_name="$2"
    local output_file="$3"
    
    # Replace template variables
    sed -e "s/PROJECT-TEMPLATE/$project_name/g" \
        -e "s/\${PROJECT_NAME}/$project_name/g" \
        -e "s/\${TIMESTAMP}/$(date +%Y-%m-%d)/g" \
        "$template_file" > "$output_file"
}

# Cross-Template Consistency Check
check_template_consistency() {
    echo -e "${BLUE}🔍 Checking template consistency...${NC}"
    
    # Ensure all templates use same variable format
    local var_formats=$(grep -h '\${[^}]*}' "$CONSTRUCT_CORE/TEMPLATES"/**/*.* 2>/dev/null | \
                       sort -u | wc -l)
    
    if [ "$var_formats" -gt 5 ]; then
        echo -e "${YELLOW}⚠️ Too many variable formats ($var_formats)${NC}"
        echo "Consider standardizing template variables"
    else
        echo -e "${GREEN}✅ Template variables consistent${NC}"
    fi
}
```

### Pattern Validation Examples

```bash
# Validate Pattern Structure
validate_pattern_structure() {
    local pattern_dir="$1"
    local required_files=("pattern.yaml" "pattern.md")
    local missing=0
    
    echo -e "${BLUE}🔍 Validating pattern: $(basename "$pattern_dir")${NC}"
    
    # Check required files
    for file in "${required_files[@]}"; do
        if [ ! -f "$pattern_dir/$file" ]; then
            echo -e "${RED}❌ Missing required file: $file${NC}"
            missing=$((missing + 1))
        fi
    done
    
    # Validate pattern.yaml
    if [ -f "$pattern_dir/pattern.yaml" ]; then
        if ! python -c "import yaml; yaml.safe_load(open('$pattern_dir/pattern.yaml'))" 2>/dev/null; then
            echo -e "${RED}❌ Invalid YAML in pattern.yaml${NC}"
            missing=$((missing + 1))
        fi
    fi
    
    return $missing
}

# Pattern Dependency Check
check_pattern_dependencies() {
    local pattern_yaml="$1"
    local registry="$CONSTRUCT_CORE/patterns/plugins/registry.yaml"
    
    # Extract dependencies
    local deps=$(python -c "
import yaml
with open('$pattern_yaml') as f:
    data = yaml.safe_load(f)
    print(' '.join(data.get('dependencies', [])))
" 2>/dev/null)
    
    # Verify each dependency exists
    for dep in $deps; do
        if ! grep -q "id: $dep" "$registry"; then
            echo -e "${YELLOW}⚠️ Missing dependency: $dep${NC}"
        fi
    done
}
```