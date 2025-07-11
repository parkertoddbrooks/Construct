## Script Reference

This reference documents all available scripts in the CONSTRUCT system.

### Core Development Scripts

#### assemble-claude.sh

**Path**: `CONSTRUCT-CORE/CONSTRUCT/scripts/construct/assemble-claude.sh`

**Purpose**: Assembles CLAUDE.md from base + selected plugins
**Usage**: Run with `--help` for detailed usage information

#### check-symlinks.sh

**Path**: `CONSTRUCT-CORE/CONSTRUCT/scripts/construct/check-symlinks.sh`

**Purpose**: CONSTRUCT Symlink Integrity Checker
**Usage**: Run with `--help` for detailed usage information

#### refresh-plugin-registry.sh

**Path**: `CONSTRUCT-CORE/CONSTRUCT/scripts/construct/refresh-plugin-registry.sh`

**Purpose**: Refresh Plugin Registry
**Usage**: Run with `--help` for detailed usage information

#### scan_project_structure.sh

**Path**: `CONSTRUCT-CORE/CONSTRUCT/scripts/construct/scan_project_structure.sh`

**Purpose**: Project Structure Scan Script
**Usage**: Run with `--help` for detailed usage information

#### update-architecture.sh

**Path**: `CONSTRUCT-CORE/CONSTRUCT/scripts/construct/update-architecture.sh`

**Purpose**: Project Architecture Documentation Update Script
**Usage**: Run with `--help` for detailed usage information

#### update-context.sh

**Path**: `CONSTRUCT-CORE/CONSTRUCT/scripts/construct/update-context.sh`

**Purpose**: Project Context Updater
**Usage**: Run with `--help` for detailed usage information

#### before_coding.sh

**Path**: `CONSTRUCT-CORE/CONSTRUCT/scripts/core/before_coding.sh`

**Purpose**: Pre-Coding Guidance - Context-Aware Search
**Usage**: Run with `--help` for detailed usage information

#### check-architecture.sh

**Path**: `CONSTRUCT-CORE/CONSTRUCT/scripts/core/check-architecture.sh`

**Purpose**: CONSTRUCT Architecture Checker - Master Script
**Usage**: Run with `--help` for detailed usage information

#### check-documentation.sh

**Path**: `CONSTRUCT-CORE/CONSTRUCT/scripts/core/check-documentation.sh`

**Purpose**: CONSTRUCT Documentation Checker - Master Script
**Usage**: Run with `--help` for detailed usage information

#### check-quality.sh

**Path**: `CONSTRUCT-CORE/CONSTRUCT/scripts/core/check-quality.sh`

**Purpose**: CONSTRUCT Quality Checker - Master Script
**Usage**: Run with `--help` for detailed usage information

#### construct-patterns.sh

**Path**: `CONSTRUCT-CORE/CONSTRUCT/scripts/core/construct-patterns.sh`

**Purpose**: Interactive pattern management
**Usage**: Run with `--help` for detailed usage information

#### commit-with-review.sh

**Path**: `CONSTRUCT-CORE/CONSTRUCT/scripts/dev/commit-with-review.sh`

**Purpose**: CONSTRUCT Commit with Review
**Usage**: Run with `--help` for detailed usage information

#### generate-devupdate.sh

**Path**: `CONSTRUCT-CORE/CONSTRUCT/scripts/dev/generate-devupdate.sh`

**Purpose**: Project Development Update Generator
**Usage**: Run with `--help` for detailed usage information

#### pre-commit-review.sh

**Path**: `CONSTRUCT-CORE/CONSTRUCT/scripts/dev/pre-commit-review.sh`

**Purpose**: Project Pre-Commit Review Script
**Usage**: Run with `--help` for detailed usage information

#### session-summary.sh

**Path**: `CONSTRUCT-CORE/CONSTRUCT/scripts/dev/session-summary.sh`

**Purpose**: CONSTRUCT Development Session Summary Generator
**Usage**: Run with `--help` for detailed usage information

#### setup-aliases.sh

**Path**: `CONSTRUCT-CORE/CONSTRUCT/scripts/dev/setup-aliases.sh`

**Purpose**: CONSTRUCT Development Aliases Setup Script
**Usage**: Run with `--help` for detailed usage information

#### create-project.sh

**Path**: `CONSTRUCT-CORE/CONSTRUCT/scripts/workspace/create-project.sh`

**Purpose**: Create Project - Sets up new projects with pattern configuration
**Usage**: Run with `--help` for detailed usage information

#### import-component.sh

**Path**: `CONSTRUCT-CORE/CONSTRUCT/scripts/workspace/import-component.sh`

**Purpose**: Import Component - Adds a repository component to existing multi-repo project
**Usage**: Run with `--help` for detailed usage information

#### import-project.sh

**Path**: `CONSTRUCT-CORE/CONSTRUCT/scripts/workspace/import-project.sh`

**Purpose**: Import Project - Imports existing projects into CONSTRUCT workspace
**Usage**: Run with `--help` for detailed usage information

#### workspace-status.sh

**Path**: `CONSTRUCT-CORE/CONSTRUCT/scripts/workspace/workspace-status.sh`

**Purpose**: Workspace Status - Shows status of all projects in CONSTRUCT workspace
**Usage**: Run with `--help` for detailed usage information

#### workspace-update.sh

**Path**: `CONSTRUCT-CORE/CONSTRUCT/scripts/workspace/workspace-update.sh`

**Purpose**: Workspace Update - Regenerates CLAUDE.md for all projects in workspace
**Usage**: Run with `--help` for detailed usage information


### Library Functions

#### common-patterns.sh

**Purpose**: Common Script Patterns Library for CONSTRUCT
**Functions**:
- `get_script_dir()`
- `get_construct_root()`
- `get_construct_dev()`
- `get_script_paths()`
- `find_shell_scripts()`
- `safe_grep_count()`
- `find_shell_scripts_in()`
- `count_shell_scripts()`
- `find_yaml_files_in()`
- `count_yaml_files()`
- `create_temp_dir()`
- `cleanup_temp_dir()`
- `create_structure_dirs()`
- `archive_existing_files()`
- `get_repo_info()`

#### file-analysis.sh

**Purpose**: File Analysis Library for CONSTRUCT
**Functions**:
- `find_swift_files()`
- `find_viewmodels()`
- `find_views()`
- `find_services()`
- `find_hardcoded_values()`
- `check_mvvm_violations()`
- `count_components()`
- `find_design_tokens()`
- `generate_architecture_summary()`
- `validate_mvvm_structure()`

#### interactive-support.sh

**Purpose**: Interactive Support Library
**Functions**:
- `should_show_prompts()`
- `is_claude_prompts_mode()`
- `is_interactive()`
- `show_script_prompts()`
- `get_input_with_default()`
- `select_with_default()`
- `yes_no_prompt()`
- `multi_select()`
- `show_info()`
- `show_success()`
- `show_error()`
- `show_warning()`
- `list_directory_options()`

#### template-location.sh

**Purpose**: Template Location Library
**Functions**:
- `get_ai_template_dir()`
- `get_project_templates_dir()`
- `get_component_templates_dir()`
- `get_pattern_templates_dir()`
- `ai_template_exists()`
- `get_project_template_path()`

#### template-utils.sh

**Purpose**: Template Utilities Library for CONSTRUCT
**Functions**:
- `get_construct_root()`
- `get_template_dir()`
- `get_template_project_dir()`
- `detect_context()`
- `get_project_context()`
- `validate_template_structure()`
- `validate_user_project_structure()`
- `validate_template_integrity()`
- `check_template_contamination()`
- `test_template_independence()`
- `get_template_scripts()`
- `get_template_script_count()`
- `validate_template_scripts()`

#### validation.sh

**Purpose**: Validation Library for CONSTRUCT
**Functions**:
- `check_dependencies()`
- `validate_directory()`
- `validate_file()`
- `validate_script_syntax()`
- `validate_config_file()`
- `validate_environment()`
- `validate_project_structure()`
- `generate_validation_report()`
- `cleanup_on_exit()`


### Configuration Files

#### mvvm-rules.yaml

**Purpose**: MVVM Architecture Rules for CONSTRUCT
**Sections**:
- `rules`
- `architecture`
- `swift6`
- `accessibility`
- `quality_gates`

#### quality-gates.yaml

**Purpose**: Quality Gates Configuration for CONSTRUCT
**Sections**:
- `construct_development`
- `user_projects`
- `checks`
- `thresholds`
- `reporting`
- `enforcement`
- `auto_fix`

---

*Generated by CONSTRUCT pattern system*
