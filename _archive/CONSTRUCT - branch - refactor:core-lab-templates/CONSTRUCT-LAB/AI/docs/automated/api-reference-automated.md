## API Reference

This reference documents all library functions available in CONSTRUCT.

### common-patterns

Common Script Patterns Library for CONSTRUCT

#### `get_script_dir()`

*No documentation available*

#### `get_construct_root()`

*No documentation available*

#### `get_construct_dev()`

*No documentation available*

#### `get_script_paths()`

*No documentation available*

#### `find_shell_scripts()`

*No documentation available*

#### `safe_grep_count()`

*No documentation available*

#### `find_shell_scripts_in()`

*No documentation available*

#### `count_shell_scripts()`

*No documentation available*

#### `find_yaml_files_in()`

*No documentation available*

#### `count_yaml_files()`

*No documentation available*

#### `create_temp_dir()`

*No documentation available*

#### `cleanup_temp_dir()`

*No documentation available*

#### `create_structure_dirs()`

*No documentation available*

#### `archive_existing_files()`

*No documentation available*

#### `get_repo_info()`

*No documentation available*

---

### file-analysis

File Analysis Library for CONSTRUCT

#### `find_swift_files()`

*No documentation available*

#### `find_viewmodels()`

*No documentation available*

#### `find_views()`

*No documentation available*

#### `find_services()`

*No documentation available*

#### `find_hardcoded_values()`

*No documentation available*

#### `check_mvvm_violations()`

*No documentation available*

#### `count_components()`

*No documentation available*

#### `find_design_tokens()`

*No documentation available*

#### `generate_architecture_summary()`

*No documentation available*

#### `validate_mvvm_structure()`

*No documentation available*

---

### interactive-support

Interactive Support Library

#### `should_show_prompts()`

*No documentation available*

#### `is_claude_prompts_mode()`

*No documentation available*

#### `is_interactive()`

*No documentation available*

#### `show_script_prompts()`

*No documentation available*

#### `get_input_with_default()`

*No documentation available*

#### `select_with_default()`

*No documentation available*

#### `yes_no_prompt()`

*No documentation available*

#### `multi_select()`

*No documentation available*

#### `show_info()`

*No documentation available*

#### `show_success()`

*No documentation available*

#### `show_error()`

*No documentation available*

#### `show_warning()`

*No documentation available*

#### `list_directory_options()`

*No documentation available*

---

### template-location

Template Location Library

#### `get_ai_template_dir()`

*No documentation available*

#### `get_project_templates_dir()`

*No documentation available*

#### `get_component_templates_dir()`

*No documentation available*

#### `get_pattern_templates_dir()`

*No documentation available*

#### `ai_template_exists()`

*No documentation available*

#### `get_project_template_path()`

*No documentation available*

---

### template-utils

Template Utilities Library for CONSTRUCT

#### `get_construct_root()`

*No documentation available*

#### `get_template_dir()`

*No documentation available*

#### `get_template_project_dir()`

*No documentation available*

#### `detect_context()`

*No documentation available*

#### `get_project_context()`

*No documentation available*

#### `validate_template_structure()`

*No documentation available*

#### `validate_user_project_structure()`

*No documentation available*

#### `validate_template_integrity()`

*No documentation available*

#### `check_template_contamination()`

*No documentation available*

#### `test_template_independence()`

*No documentation available*

#### `get_template_scripts()`

*No documentation available*

#### `get_template_script_count()`

*No documentation available*

#### `validate_template_scripts()`

*No documentation available*

---

### validation

Validation Library for CONSTRUCT

#### `check_dependencies()`

*No documentation available*

#### `validate_directory()`

*No documentation available*

#### `validate_file()`

*No documentation available*

#### `validate_script_syntax()`

*No documentation available*

#### `validate_config_file()`

*No documentation available*

#### `validate_environment()`

*No documentation available*

#### `validate_project_structure()`

*No documentation available*

#### `generate_validation_report()`

*No documentation available*

#### `cleanup_on_exit()`

*No documentation available*

---

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
