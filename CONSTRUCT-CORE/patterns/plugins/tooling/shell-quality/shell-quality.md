# Shell Script Quality Standards

## Overview
This pattern enforces quality standards for shell scripts to ensure maintainability, reliability, and consistency.

## Rules

### Error Handling
```bash
❌ NEVER: Scripts without set -e
✅ ALWAYS: set -e at the beginning of every script

❌ NEVER: Silent failures
✅ ALWAYS: Provide clear error messages on failure

❌ NEVER: Commands without error checking
✅ ALWAYS: Check exit codes for critical operations
```

### Code Organization
```bash
❌ NEVER: Functions without documentation
✅ ALWAYS: Document function purpose and parameters

❌ NEVER: Global variables without UPPER_CASE naming
✅ ALWAYS: Use UPPER_CASE for globals, lowercase for locals

❌ NEVER: Magic numbers or hardcoded values
✅ ALWAYS: Use named constants or configuration
```

### Output Standards
```bash
❌ NEVER: No feedback during long operations
✅ ALWAYS: Provide progress indicators

❌ NEVER: Inconsistent output formatting
✅ ALWAYS: Use color coding for status (✅ success, ❌ error, ⚠️ warning)

❌ NEVER: Errors to stdout
✅ ALWAYS: Send errors to stderr with >&2
```

### Script Structure
```bash
❌ NEVER: Missing shebang line
✅ ALWAYS: #!/bin/bash as first line

❌ NEVER: No help text
✅ ALWAYS: Provide --help option with usage information

❌ NEVER: Absolute paths
✅ ALWAYS: Use relative paths and path resolution
```

## Examples

### ✅ Good: Proper Error Handling
```bash
#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Function with documentation
# Check if file exists and is readable
# Parameters:
#   $1 - File path to check
# Returns:
#   0 on success, 1 on failure
check_file() {
    local file="$1"
    
    if [ -z "$file" ]; then
        echo -e "${RED}❌ Error: No file specified${NC}" >&2
        return 1
    fi
    
    if [ ! -f "$file" ]; then
        echo -e "${RED}❌ Error: File not found: $file${NC}" >&2
        return 1
    fi
    
    if [ ! -r "$file" ]; then
        echo -e "${RED}❌ Error: File not readable: $file${NC}" >&2
        return 1
    fi
    
    echo -e "${GREEN}✅ File check passed${NC}"
    return 0
}
```

### ❌ Bad: Poor Quality Practices
```bash
# Missing shebang
# No set -e

check_file() {
    # No documentation
    if [ -f $1 ]  # Unquoted variable
    then
        echo "ok"  # No color, unclear message
    fi
    # No error handling
}

# Hardcoded path
cd /Users/john/project  # Will fail for other users
```

## Integration
This pattern validates:
- Proper script structure and organization
- Error handling implementation
- Output formatting standards
- Documentation completeness