# CONSTRUCT Library Documentation

This directory contains shared libraries and modules used by CONSTRUCT scripts. These libraries provide common functionality, promote code reuse, and ensure consistency across the framework.

## Overview

The CONSTRUCT library system provides:
- **Shared Functions**: Common operations used across multiple scripts
- **Modular Design**: Organized by functionality
- **Easy Integration**: Simple sourcing mechanism
- **Comprehensive Testing**: Full unit test coverage

## Library Structure

```
lib/
├── construct-init/          # Modules for init-construct.sh
│   ├── common.sh           # Core utilities and helpers
│   ├── config.sh           # Configuration management
│   └── pattern-extractor.sh # Pattern extraction logic
├── common-patterns.sh       # Shared validation patterns
├── file-analysis.sh         # File and directory analysis
├── interactive-support.sh   # Interactive mode detection
├── template-location.sh     # Template path resolution
├── template-utils.sh        # Template processing utilities
└── validation.sh           # Input validation functions
```

## Module Documentation

### construct-init/ Directory

Specialized modules for the AI-Native init-construct system:

#### common.sh
Core utilities for init-construct operations:

**Functions**:
- `log_error()`, `log_warning()`, `log_info()`, `log_success()`, `log_debug()` - Structured logging
- `validate_directory()` - Directory validation with security checks
- `check_required_tools()` - Tool availability verification
- `setup_cleanup()`, `add_temp_file()`, `cleanup_on_exit()` - Temp file management
- `consume_api_token()` - Token bucket rate limiting
- `call_claude_with_retry()` - Claude SDK calls with retry logic
- `call_claude_with_cache()` - Cached API calls
- `setup_logging()`, `rotate_log_if_needed()` - Log management with rotation

**Features**:
- Token bucket rate limiting (prevents API violations)
- Response caching with TTL support
- Automatic log rotation with compression
- Cross-platform compatibility

**Usage**:
```bash
source "$CONSTRUCT_ROOT/CONSTRUCT-CORE/CONSTRUCT/lib/construct-init/common.sh"

# Use logging functions
log_info "Starting process..."
log_success "Operation completed"

# Rate-limited API call
consume_api_token
call_claude_with_retry 30 "$prompt_file" "$output_file" "json"
```

#### config.sh
Configuration management for CONSTRUCT:

**Functions**:
- `load_config()` - Load configuration from multiple sources
- `get_config()` - Retrieve configuration values
- `parse_yaml_config()` - Parse YAML files (with/without yq)
- `apply_env_overrides()` - Apply environment variable overrides
- `create_default_config()` - Generate default configuration

**Configuration Sources** (in order):
1. Specified config file
2. `.construct/config.yaml`
3. `~/.construct/config.yaml`
4. Default configuration
5. Environment variable overrides

**Usage**:
```bash
source "$CONSTRUCT_ROOT/CONSTRUCT-CORE/CONSTRUCT/lib/construct-init/config.sh"

# Load configuration
load_config

# Get values
local timeout=$(get_config "api.timeout" 30)
local cache_dir=$(get_config "cache.directory")
```

#### pattern-extractor.sh
Concurrent pattern extraction system:

**Functions**:
- `extract_patterns_concurrent()` - Main extraction orchestrator
- `extract_single_category()` - Single category extraction
- `setup_extraction_environment()` - Environment preparation
- `wait_for_extractions()` - Concurrent job management
- `should_extract_category()` - Intelligent category selection

**Features**:
- Concurrent extraction with configurable parallelism
- Intelligent category selection based on project
- Progress tracking and timeout handling
- Automatic cleanup on failure

**Usage**:
```bash
source "$CONSTRUCT_ROOT/CONSTRUCT-CORE/CONSTRUCT/lib/construct-init/pattern-extractor.sh"

# Extract patterns
local categories=("languages" "frameworks" "tooling")
extract_patterns_concurrent "$project_name" "$content_file" "${categories[@]}"
```

### Core Libraries

#### common-patterns.sh
Shared validation and pattern detection:

**Functions**:
- `validate_project_name()` - Project name validation
- `is_swift_project()` - Swift project detection
- `is_web_project()` - Web project detection
- `detect_project_type()` - Automatic project type detection
- `validate_environment()` - Environment validation

**Usage**:
```bash
source "$CONSTRUCT_ROOT/CONSTRUCT-CORE/CONSTRUCT/lib/common-patterns.sh"

if validate_project_name "$name"; then
    local project_type=$(detect_project_type "$project_dir")
    echo "Detected: $project_type project"
fi
```

#### file-analysis.sh
File and directory analysis utilities:

**Functions**:
- `count_files_by_type()` - Count files by extension
- `analyze_directory_structure()` - Directory structure analysis
- `find_large_files()` - Large file detection
- `calculate_code_metrics()` - Basic code metrics

**Usage**:
```bash
source "$CONSTRUCT_ROOT/CONSTRUCT-CORE/CONSTRUCT/lib/file-analysis.sh"

local swift_files=$(count_files_by_type "$project_dir" "swift")
analyze_directory_structure "$project_dir" > structure.txt
```

#### interactive-support.sh
Interactive mode detection and handling:

**Functions**:
- `is_interactive()` - Detect interactive mode
- `prompt_user()` - User prompting with validation
- `select_from_list()` - Menu selection
- `confirm_action()` - Yes/no confirmation

**Rails Mode Support**:
- Automatic detection of Claude Code environment
- Seamless mode switching
- Consistent user experience

**Usage**:
```bash
source "$CONSTRUCT_ROOT/CONSTRUCT-CORE/CONSTRUCT/lib/interactive-support.sh"

if is_interactive; then
    local choice=$(select_from_list "Select option:" "${options[@]}")
    if confirm_action "Proceed with $choice?"; then
        process_choice "$choice"
    fi
fi
```

#### template-location.sh
Template path resolution:

**Functions**:
- `get_construct_root()` - Find CONSTRUCT root directory
- `get_template_path()` - Resolve template paths
- `validate_template()` - Template validation

**Usage**:
```bash
source "$CONSTRUCT_ROOT/CONSTRUCT-CORE/CONSTRUCT/lib/template-location.sh"

local construct_root=$(get_construct_root)
local template=$(get_template_path "swift-ios")
```

#### template-utils.sh
Template processing utilities:

**Functions**:
- `copy_template()` - Template copying with substitution
- `process_template_variables()` - Variable substitution
- `validate_template_structure()` - Structure validation
- `create_from_template()` - Complete template instantiation

**Usage**:
```bash
source "$CONSTRUCT_ROOT/CONSTRUCT-CORE/CONSTRUCT/lib/template-utils.sh"

local vars=(
    "PROJECT_NAME=$name"
    "AUTHOR=$author"
)
create_from_template "$template_path" "$target_dir" "${vars[@]}"
```

#### validation.sh
Input validation functions:

**Functions**:
- `validate_email()` - Email validation
- `validate_url()` - URL validation
- `validate_path()` - Path validation
- `validate_version()` - Version string validation
- `sanitize_input()` - Input sanitization

**Usage**:
```bash
source "$CONSTRUCT_ROOT/CONSTRUCT-CORE/CONSTRUCT/lib/validation.sh"

if validate_email "$user_email"; then
    save_config "user.email" "$user_email"
fi

local safe_path=$(sanitize_input "$user_path")
```

## Best Practices

### Using Libraries

1. **Source at Script Start**:
   ```bash
   #!/bin/bash
   SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
   source "$SCRIPT_DIR/../../lib/common-patterns.sh"
   ```

2. **Check Availability**:
   ```bash
   if [ -f "$lib_path" ]; then
       source "$lib_path"
   else
       echo "Warning: Library not found" >&2
   fi
   ```

3. **Export Functions**:
   ```bash
   # In library
   export -f my_function
   
   # Available in subshells
   (my_function)
   ```

### Creating New Libraries

1. **Consistent Structure**:
   - Clear function documentation
   - Parameter validation
   - Error handling
   - Return codes

2. **Naming Conventions**:
   - Libraries: `category-purpose.sh`
   - Functions: `verb_noun()` or `is_condition()`
   - Variables: `local` scope by default

3. **Dependencies**:
   - Minimize inter-library dependencies
   - Document required libraries
   - Check dependencies at runtime

## Testing

All libraries have comprehensive unit tests:

```bash
# Run all library tests
./CONSTRUCT-CORE/CONSTRUCT/tests/run-unit-tests.sh

# Test specific library
./CONSTRUCT-CORE/CONSTRUCT/tests/unit/test-common.sh
```

### Writing Tests

1. **Test Structure**:
   ```bash
   test_function_name() {
       # Arrange
       local input="test"
       
       # Act
       local result=$(function_name "$input")
       
       # Assert
       assert_equals "expected" "$result"
   }
   ```

2. **Coverage**:
   - Happy path
   - Error cases
   - Edge cases
   - Integration points

## Configuration

Libraries can be configured via:

1. **Environment Variables**:
   ```bash
   export CONSTRUCT_LOG_LEVEL="debug"
   export CONSTRUCT_CACHE_DIR="/tmp/construct"
   ```

2. **Configuration Files**:
   ```yaml
   # .construct/config.yaml
   logging:
     level: debug
     directory: logs/
   cache:
     enabled: true
     ttl: 3600
   ```

3. **Runtime Parameters**:
   ```bash
   # Pass configuration to functions
   setup_logging --level debug --rotate 10MB
   ```

## Troubleshooting

### Common Issues

1. **Library Not Found**:
   - Check path resolution
   - Verify CONSTRUCT_ROOT
   - Check file permissions

2. **Function Not Available**:
   - Ensure library is sourced
   - Check export statements
   - Verify no syntax errors

3. **Subshell Issues**:
   - Export functions and variables
   - Pass environment explicitly
   - Check PATH in subshells

### Debug Mode

Enable debug output:
```bash
export DEBUG=1
./script.sh

# Or inline
DEBUG=1 ./script.sh
```

## Contributing

When contributing to libraries:

1. **Follow Standards**:
   - Match existing style
   - Add documentation
   - Include tests
   - Update this README

2. **Backward Compatibility**:
   - Don't break existing APIs
   - Deprecate gracefully
   - Version major changes

3. **Review Process**:
   - Test with multiple scripts
   - Verify cross-platform compatibility
   - Update dependent scripts

## Version History

- **v2.0** - AI-Native enhancements (July 2025)
  - Added construct-init modules
  - Token bucket rate limiting
  - Response caching system
  - Concurrent extraction

- **v1.0** - Initial library system
  - Core validation functions
  - Template utilities
  - Interactive support