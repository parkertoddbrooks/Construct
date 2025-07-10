# [SHELL] Modern Shell Scripting Standards

## When to Use
- When writing or modifying shell scripts (*.sh files)
- When creating bash automation or tooling
- For any shell-based scripting tasks

## Essential Patterns

### ✅ DO: Script Structure
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
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
```

### ✅ DO: Error Handling
- Always use `set -e` for automatic error handling
- Check exit codes and provide feedback
- Provide meaningful error messages with context
- Use colored output for status indicators

### ✅ DO: Function Documentation
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

### ✅ DO: Variable Naming
- Use UPPER_CASE for global variables and environment variables
- Use local variables in functions
- Provide clear, descriptive variable names
- Quote variables to handle spaces: `"$variable"`

### ✅ DO: Path Handling
- Use relative paths and configuration
- Resolve paths dynamically, never hardcode
- Use `$(cd ... && pwd)` for absolute path resolution

### ❌ DON'T: Anti-patterns
- Hardcoded paths (breaks portability)
- Scripts without `set -e` (silent failures)
- Functions without documentation
- Global variables without UPPER_CASE naming
- Commands without error checking
- Silent operations (no user feedback)
- Unquoted variables that might contain spaces

### ❌ DON'T: Bad Examples
```bash
# BAD: Hardcoded paths
SCRIPT_DIR="/Users/username/project/scripts"

# BAD: No error handling
#!/bin/bash
# Missing: set -e
command_that_might_fail
next_command  # Runs even if previous failed

# BAD: No validation
cp "$1" "$2"  # No check if parameters exist

# BAD: Silent operations
find . -name "*.tmp" -delete  # No feedback to user

# BAD: Global variables without clear naming
result="some value"  # Should be RESULT or local

# BAD: Functions without documentation
process_files() {
    # What does this do? What parameters? What returns?
}
```

## Configuration-Driven Patterns

### ✅ DO: External Configuration
```bash
# Load configuration from external files
load_config() {
    local config_file="$PROJECT_ROOT/config/settings.yaml"
    
    if [ ! -f "$config_file" ]; then
        echo -e "${RED}❌ Config file not found: $config_file${NC}" >&2
        return 1
    fi
    
    # Parse and apply configuration
}
```

### ✅ DO: Help and Usage
```bash
# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 [options]"
    echo "Description of script and options"
    echo ""
    echo "Options:"
    echo "  --help, -h    Show this help"
    exit 0
fi
```

## Library Integration

### ✅ DO: Source Library Functions
```bash
# Source library functions (with validation)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source common libraries
if [ -f "$PROJECT_ROOT/lib/common.sh" ]; then
    source "$PROJECT_ROOT/lib/common.sh"
else
    echo "❌ Error: Required library not found: lib/common.sh" >&2
    exit 1
fi
```

### ✅ DO: Reusable Functions
- Extract common patterns into lib/ functions
- Share validation logic across scripts
- Create utilities for file analysis and processing

## Output Standards

### ✅ DO: Consistent Output Format
```bash
echo -e "${BLUE}🔍 Starting process...${NC}"
echo -e "${YELLOW}⚠️ Warning message${NC}"
echo -e "${RED}❌ Error message${NC}"
echo -e "${GREEN}✅ Success message${NC}"
```

### ✅ DO: Status Indicators
- Use emoji and colors for clear status
- Provide progress feedback for long operations
- Show summary results at completion

## Integration
This pattern activates when:
- Working on files with `.sh` extension
- Creating bash scripts or automation
- Writing shell-based tooling