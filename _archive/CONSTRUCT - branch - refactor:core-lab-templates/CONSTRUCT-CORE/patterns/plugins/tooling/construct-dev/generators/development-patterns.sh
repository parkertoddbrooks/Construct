#!/bin/bash

# CONSTRUCT Development Pattern - Development Patterns Generator
# Generates comprehensive development patterns documentation

set -e

PROJECT_DIR="${1:-.}"

cat << 'EOF'
## Development Patterns

This guide documents the standard patterns used in CONSTRUCT development.

### Script Development Patterns

#### Standard Script Structure

All CONSTRUCT development scripts follow this pattern:

```bash
#!/bin/bash

# Script Description
# Brief explanation of what this script does

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Source library functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common-patterns.sh"

# Get project directories using library functions
CONSTRUCT_ROOT=$(get_construct_root)
CONSTRUCT_DEV=$(get_construct_dev)

echo -e "${BLUE}🔍 Script Description...${NC}"
echo ""

# Main logic with proper error handling
main() {
    # Implementation
}

main "$@"
```

#### Error Handling Patterns

##### Required Error Handling
- Always use `set -e` for fail-fast behavior
- Source library functions with proper path resolution
- Use colored output for status reporting
- Implement proper exit codes

##### Validation Pattern
```bash
validate_input() {
    local input=$1
    
    if [ -z "$input" ]; then
        echo -e "${RED}❌ Error: Input required${NC}"
        exit 1
    fi
    
    if [ ! -f "$input" ]; then
        echo -e "${RED}❌ Error: File not found: $input${NC}"
        exit 1
    fi
}
```

### Output Formatting Patterns

#### Status Indicators
- ✅ Success/Pass
- ❌ Error/Fail  
- ⚠️ Warning/Attention needed
- 🔍 Analysis/Investigation
- 📊 Statistics/Metrics
- 💡 Insights/Tips
- 🔄 Process/Update
- 📚 Documentation
- 🏗️ Architecture
- 🚀 Performance

#### Color Coding
- `GREEN`: Success, pass, good status
- `RED`: Errors, failures, critical issues
- `YELLOW`: Warnings, attention needed, suggestions
- `BLUE`: Information, headers, process status

### Library Function Patterns

#### Function Documentation
```bash
# Purpose: Validates directory exists and is readable
# Parameters: $1 - Directory path to validate
# Returns: 0 on success, 1 on failure
validate_directory() {
    local dir=$1
    # Implementation
}
```

#### Configuration-Driven Validation
```bash
# Load validation rules from YAML config
load_validation_rules() {
    local config_file="$CONSTRUCT_DIR/config/quality-gates.yaml"
    # Parse and apply rules
}
```

### Development Workflow Patterns

#### Context Update Pattern
1. Analyze current state
2. Generate structured data
3. Update AI context file
4. Provide next step suggestions

#### Quality Check Pattern
1. Run multiple validation categories
2. Count violations by severity
3. Provide actionable feedback
4. Exit with appropriate code

#### Structure Analysis Pattern
1. Scan directory structure
2. Categorize and count components
3. Generate both detailed and summary reports
4. Identify architectural patterns and gaps

### Configuration Patterns

#### YAML Configuration Structure
```yaml
# Configuration file description
# Purpose and usage notes

rules:
  category1:
    forbidden_patterns:
      - "pattern1"
      - "pattern2"
    required_patterns:
      - "pattern3"
      
  category2:
    thresholds:
      warning: 5
      error: 10
```

#### Configuration Loading Pattern
```bash
load_config() {
    local config_file="$1"
    
    if [ ! -f "$config_file" ]; then
        echo -e "${RED}❌ Config file not found: $config_file${NC}"
        exit 1
    fi
    
    # Parse YAML and extract values
}
```

### Testing Patterns

#### Script Testing Structure
```bash
# Test script template
test_script_functionality() {
    local script_path="$1"
    
    # Test 1: Script exists and is executable
    if [ ! -x "$script_path" ]; then
        echo "❌ Script not executable: $script_path"
        return 1
    fi
    
    # Test 2: Script runs without errors
    if ! "$script_path" --help &>/dev/null; then
        echo "❌ Script help failed: $script_path"
        return 1
    fi
    
    echo "✅ Script tests passed: $script_path"
    return 0
}
```

### Documentation Patterns

#### Auto-Generated Documentation
- Use consistent headers with generation timestamp
- Include script/command that generated the documentation
- Provide context about purpose and usage
- Update documentation as part of development workflow

#### Session Documentation
- Record development decisions and rationale
- Track architectural changes and their impact
- Document discovered patterns and anti-patterns
- Maintain development timeline and milestones

### Promotion Patterns

#### LAB to CORE Promotion
1. Develop and test in CONSTRUCT-LAB
2. Validate with multiple projects
3. Add to promotion manifest
4. Run promotion workflow
5. Update documentation

#### Version Control Patterns
- Feature branches for new development
- Pull requests for code review
- Semantic versioning for releases
- Changelog maintenance

---

*Generated by CONSTRUCT pattern system*
EOF