#!/bin/bash

# CONSTRUCT Development Pattern - API Reference Generator
# Generates API reference for library functions

set -e

PROJECT_DIR="${1:-.}"

# Detect CONSTRUCT lib location
if [ -d "$PROJECT_DIR/CONSTRUCT-CORE/CONSTRUCT/lib" ]; then
    # This is the CONSTRUCT repository itself
    CONSTRUCT_DIR="$PROJECT_DIR/CONSTRUCT-CORE/CONSTRUCT"
elif [ -d "$PROJECT_DIR/CONSTRUCT/lib" ]; then
    # This is a project using CONSTRUCT
    CONSTRUCT_DIR="$PROJECT_DIR/CONSTRUCT"
else
    echo "Not a CONSTRUCT project (no CONSTRUCT/lib directory found)"
    exit 1
fi

cat << 'EOF'
## API Reference

This reference documents all library functions available in CONSTRUCT.

EOF

# Document each library file and its functions
find "$CONSTRUCT_DIR/lib" -name "*.sh" -type f 2>/dev/null | sort | while read -r lib_file; do
    lib_name=$(basename "$lib_file" .sh)
    echo "### $lib_name"
    echo ""
    
    # Extract file description
    file_description=$(head -10 "$lib_file" | grep "^# .*[A-Za-z]" | grep -v "^#!/" | head -1 | sed 's/^# //')
    if [ -n "$file_description" ]; then
        echo "$file_description"
        echo ""
    fi
    
    # Document each function with its documentation
    # Look for functions and their preceding comments
    awk '
    /^# Purpose:/ { 
        purpose = substr($0, 11)
        getline
        if (/^# Parameters:/) {
            params = substr($0, 14)
            getline
            if (/^# Returns:/) {
                returns = substr($0, 11)
                getline
                if (/^[a-zA-Z_][a-zA-Z0-9_]*\(\)/) {
                    func_name = substr($0, 1, index($0, "(") - 1)
                    print "#### `" func_name "()`"
                    print ""
                    print "**Purpose**: " purpose
                    print ""
                    print "**Parameters**: " params
                    print ""
                    print "**Returns**: " returns
                    print ""
                }
            }
        }
        purpose = ""
        params = ""
        returns = ""
    }
    /^[a-zA-Z_][a-zA-Z0-9_]*\(\)/ && purpose == "" {
        func_name = substr($0, 1, index($0, "(") - 1)
        print "#### `" func_name "()`"
        print ""
        print "*No documentation available*"
        print ""
    }
    ' "$lib_file"
    
    echo "---"
    echo ""
done

cat << 'EOF'
### Common Usage Patterns

#### Sourcing Libraries

```bash
# Source from script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common-patterns.sh"
source "$SCRIPT_DIR/../lib/validation.sh"
```

#### Error Handling

```bash
# Use validation functions
if ! validate_directory "$dir"; then
    echo "Invalid directory"
    exit 1
fi

# Check file types
if is_shell_script "$file"; then
    validate_shell_script "$file"
fi
```

#### File Analysis

```bash
# Count files by type
script_count=$(count_shell_scripts "$PROJECT_DIR")
yaml_count=$(count_yaml_files "$CONFIG_DIR")

# Find specific files
find_shell_scripts "$PROJECT_DIR" | while read -r script; do
    process_script "$script"
done
```

#### Template Operations

```bash
# Validate template integrity
if validate_template_integrity; then
    echo "Template is valid"
fi

# Get template information
template_name=$(get_template_name)
template_version=$(get_template_version)
```

### Function Categories

#### Path and Directory Functions
- `get_construct_root()`: Get CONSTRUCT root directory
- `get_project_root()`: Get current project root
- `validate_directory()`: Validate directory exists and is readable
- `ensure_directory()`: Create directory if it doesn't exist

#### File Analysis Functions
- `is_shell_script()`: Check if file is a shell script
- `count_shell_scripts()`: Count shell scripts in directory
- `find_shell_scripts()`: Find all shell scripts
- `analyze_script_quality()`: Analyze script for quality issues

#### Validation Functions
- `validate_shell_script()`: Validate shell script syntax
- `validate_yaml_file()`: Validate YAML file format
- `validate_template_integrity()`: Check template structure
- `check_required_files()`: Verify required files exist

#### Configuration Functions
- `load_config()`: Load YAML configuration
- `get_config_value()`: Get specific config value
- `validate_config()`: Validate configuration structure
- `merge_configs()`: Merge multiple configurations

#### Output Functions
- `print_success()`: Print success message with color
- `print_error()`: Print error message with color
- `print_warning()`: Print warning message with color
- `print_info()`: Print info message with color

### Best Practices

1. **Always Check Return Values**
   ```bash
   if ! function_name "$param"; then
       handle_error
   fi
   ```

2. **Use Local Variables**
   ```bash
   function_name() {
       local var1="$1"
       local var2="$2"
       # Use variables
   }
   ```

3. **Provide Meaningful Error Messages**
   ```bash
   if [ ! -f "$file" ]; then
       print_error "File not found: $file"
       return 1
   fi
   ```

4. **Document All Functions**
   ```bash
   # Purpose: Clear description
   # Parameters: $1 - param description
   # Returns: 0 on success, 1 on failure
   ```

---

*Generated by CONSTRUCT pattern system*
EOF