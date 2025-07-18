### 🚨 MANDATORY: Orchestration Pattern

When writing shell scripts, you MUST separate orchestration from logic:

```bash
❌ NEVER: Monolithic scripts >50 lines
✅ ALWAYS: Orchestration script + lib functions

❌ NEVER: Business logic mixed with argument parsing
✅ ALWAYS: main.sh (flow) + lib/logic.sh (functions)

❌ NEVER: Duplicate logic across scripts
✅ ALWAYS: Shared functions in lib/ directory
```

### Orchestration Script Template

```bash
#!/bin/bash
# main-script.sh - Orchestration only

set -e

# Setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/business-logic.sh"

# Parse arguments
parse_args "$@"

# Orchestrate workflow
validate_input "$INPUT"
result=$(process_data "$INPUT")
generate_output "$result"
```

### Library Functions Template

```bash
#!/bin/bash
# lib/business-logic.sh - Pure functions

# Process data - no user interaction
process_data() {
    local input="$1"
    # Complex logic here
    echo "processed: $input"
}

# Validate input - returns exit code
validate_input() {
    local input="$1"
    [[ -n "$input" ]] || return 1
}
```

### When to Apply This Pattern

- **Any script >50 lines** → Split immediately
- **Any duplicate logic** → Extract to lib/
- **Any complex processing** → Separate from orchestration
- **Any script with >3 functions** → Move functions to lib/

This pattern prevents monolithic scripts and enables code reuse across your project.