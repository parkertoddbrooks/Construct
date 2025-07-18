# Script Interface Consistency Standards

## When to Use
This injection applies to all shell scripts that are part of a larger tooling system.

## 🚨 MANDATORY: Consistent Interface Standards

**All scripts in a tooling system MUST have consistent interfaces**

```bash
❌ NEVER: Inconsistent flag support across scripts
✅ ALWAYS: Standard interface patterns for all scripts
```

## Essential Interface Requirements

### ✅ DO: Standard Flag Support
```bash
# ALL scripts that modify files MUST support:
--help, -h      # Show usage information
--dry-run       # Test functionality without making changes
--quiet         # Suppress non-error output (optional)
--verbose       # Enable detailed output (optional)
```

### ✅ DO: Consistent Exit Codes
```bash
# Standard exit codes across all scripts
0               # Success
1               # General error
2               # Invalid arguments
3               # Missing dependencies
```

### ✅ DO: Predictable Argument Parsing
```bash
#!/bin/bash

# Parse command line arguments consistently
DRY_RUN=false
VERBOSE=false
TARGET_DIR=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        -*)
            echo "Unknown option: $1" >&2
            exit 2
            ;;
        *)
            # Handle positional arguments
            if [ -z "$TARGET_DIR" ]; then
                TARGET_DIR="$1"
            else
                echo "Too many arguments" >&2
                exit 2
            fi
            shift
            ;;
    esac
done
```

## Implementation Patterns

### ✅ DO: Dry-Run Implementation
```bash
# Use DRY_RUN flag throughout script
update_file() {
    local file="$1"
    local content="$2"
    
    if [ "$DRY_RUN" = true ]; then
        echo "Would update: $file"
        echo "New content preview:"
        echo "$content" | head -3
        echo "..."
    else
        echo "$content" > "$file"
        echo "Updated: $file"
    fi
}
```

### ✅ DO: Consistent Help Format
```bash
show_help() {
    echo "Usage: $0 [OPTIONS] [ARGUMENTS]"
    echo ""
    echo "Brief description of what this script does"
    echo ""
    echo "Arguments:"
    echo "  TARGET_DIR    Description of argument (default: current directory)"
    echo ""
    echo "Options:"
    echo "  --dry-run     Show what would be changed without making changes"
    echo "  --verbose     Enable detailed output"
    echo "  --help, -h    Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --dry-run /path/to/project"
    echo "  $0 --verbose ."
}
```

## ❌ DON'T: Inconsistent Anti-patterns

### ❌ Bad: Mixed Validation Approaches
```bash
# DON'T mix different testing strategies
./script1.sh --help     # Tests with help
./script2.sh --dry-run  # Tests with dry-run
./script3.sh --test     # Different flag name
```

### ❌ Bad: Incomplete Interface Support
```bash
# DON'T have some scripts support features others don't
script1.sh --dry-run    # Works
script2.sh --dry-run    # Error: unknown option
```

### ❌ Bad: Inconsistent Output
```bash
# DON'T use different output formats
Script 1: "✅ Success: Updated file"
Script 2: "SUCCESS - file updated"
Script 3: "Updated file successfully"
```

## Validation Integration

### ✅ DO: Testable Scripts
```bash
# Scripts with consistent interfaces can be validated uniformly
for script in ./scripts/*.sh; do
    echo "Testing: $script"
    if "$script" --dry-run >/dev/null 2>&1; then
        echo "✅ $script supports dry-run"
    else
        echo "❌ $script lacks dry-run support"
    fi
done
```

## Discovery Context

**When this pattern was discovered**: During CONSTRUCT construct-init testing
**Problem solved**: Inconsistent validation approaches across scripts
**Architectural impact**: Enables uniform script validation and testing

## Integration

This injection activates automatically for:
- Scripts in tooling systems
- Any script that modifies files or system state
- Scripts intended for automation or CI/CD

The pattern ensures professional, predictable tool interfaces that users can trust.