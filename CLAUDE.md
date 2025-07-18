<!-- CONSTRUCT Enhanced: 2025-07-16 06:24:43 UTC -->
<!-- 
╔══════════════════════════════════════════════════════════════════════════════╗
║                      PATTERN-ENHANCED CONTEXT FILE                           ║
╠══════════════════════════════════════════════════════════════════════════════╣
║ This file is managed by both Claude Code (/init) and CONSTRUCT patterns.    ║
║                                                                              ║
║ ⚠️  WARNING: Manual edits may be lost when:                                  ║
║   • Running /init (replaces entire file)                                     ║
║   • Running construct-init (rebuilds from patterns)                          ║
║   • Inside dynamic sections (updated by construct-update)                    ║
║                                                                              ║
║ 💡 BETTER APPROACH: Instead of editing this file:                            ║
║   • Add project rules → .construct/patterns.yaml                             ║
║   • Create reusable patterns → pattern plugins                               ║
║   • Let CONSTRUCT manage the content                                         ║
║                                                                              ║
║ See: CONSTRUCT-CORE/patterns/PATTERN-GUIDE.md for details                    ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

CONSTRUCT is a dynamic context engineering system for AI-powered development. It automatically loads the right patterns based on what you're working on, creating self-improving development environments where AI assistance gets smarter with every commit.

### Key Architecture
- **Dual Environment System**: CONSTRUCT-CORE (stable) and CONSTRUCT-LAB (experimental)
- **Pattern Plugin System**: Language-specific and tool-specific patterns
- **Context Injection**: CLAUDE.md is dynamically assembled from pattern injections
- **Symlink Architecture**: Maintains consistency between CORE and LAB

## Quick Start

### Essential Commands
```bash
# Before starting work
construct-update          # Update CLAUDE.md context
construct-check          # Check architecture violations

# Development workflow
construct-before Feature  # Before creating new components
construct-scan           # Document current structure
construct-quality        # Check code quality

# When context fills up (~90%)
construct-session-summary # Save session state
```

### Interactive Script Usage
Many CONSTRUCT scripts support interactive mode. In Claude Code's non-interactive environment:
- Scripts auto-detect non-interactive mode
- Default values are used automatically
- Use environment variables to override: `CONSTRUCT_PROJECT_NAME=MyProject ./create-project.sh`

## Core Development Principles

These universal principles apply to ALL development work:

### ✅ DO: Foundation Rules
- **Never break existing tests** - Changes must maintain backward compatibility
- **Document why, not what** - Code should be self-explanatory, comments explain reasoning
- **Error handling is mandatory** - All failure modes must be handled gracefully
- **Security first** - Never expose secrets, validate all inputs, follow security best practices
- **Performance awareness** - Consider impact of changes on system performance
- **Version control discipline** - Clear commits, meaningful messages, atomic changes

### ❌ DON'T: Universal Anti-patterns
- Hardcoded values that should be configurable
- Silent failures without error reporting
- Breaking changes without proper versioning
- Security vulnerabilities (exposed secrets, unvalidated inputs)
- Code without proper testing
- Undocumented complex logic

## Pattern System

### Active Patterns
```yaml
# CONSTRUCT Framework Pattern Configuration
# This configures the patterns used by CONSTRUCT itself

# Languages used in CONSTRUCT development
languages: ["bash", "python"]

# Active pattern plugins
plugins:
  - tooling/construct-dev      # CONSTRUCT-specific development patterns
  - tooling/shell-scripting    # Shell script best practices
  - tooling/shell-quality      # Shell script quality standards
  - tooling/unix-philosophy    # Unix design principles

# Custom rules for CONSTRUCT framework
custom_rules:
  scripts:
    - "All scripts must have help output with --help"
    - "Scripts must support interactive mode detection"
    - "Use absolute paths from CONSTRUCT_CORE root"
    - "Exit codes must be meaningful (0=success, >0=errors)"
  
  structure:
    - "CORE contains stable code"
    - "LAB contains experimental code"
    - "Patterns live in patterns/plugins/"
    - "Scripts organized by category (core/, construct/, workspace/, dev/)"
  
  documentation:
    - "All scripts must have header comments"
    - "Pattern files must include examples"
    - "Validators must document what they check"

# Include configurations
includes:
  - patterns/plugins/registry.yaml    # Plugin registry

# Overrides for specific files/directories
overrides: []
```

## Development Guidelines

## CONSTRUCT Development Guidelines

### 🚨 Symlink and Promotion Rules

```bash
❌ NEVER: Edit a symlinked file directly
✅ ALWAYS: Create new version in LAB, test, then promote to CORE

❌ NEVER: Replace a symlink with a regular file
✅ ALWAYS: Maintain symlink integrity - they point to CORE

❌ NEVER: Commit changes to symlinked files
✅ ALWAYS: Use the promotion workflow for CORE updates

❌ NEVER: Edit symlinked READMEs directly in LAB
✅ ALWAYS: Update READMEs in CORE, symlinks auto-reflect changes

❌ NEVER: Break symlinks by replacing with regular files  
✅ ALWAYS: Keep AI documentation symlinked for consistency

❌ NEVER: Manually copy files from LAB to CORE
✅ ALWAYS: Use ./tools/promote-to-core.sh for tested changes

❌ NEVER: Create files named *-sym.* that aren't symlinks
✅ ALWAYS: Use -sym.ext naming only for actual symlinks to CORE

❌ NEVER: Copy a *-sym file without preserving the link
✅ ALWAYS: Check pre-commit validates symlink naming integrity
```

### Shell/Python Architecture Rules

```bash
❌ NEVER: Hardcoded paths in scripts
✅ ALWAYS: Use relative paths and configuration

❌ NEVER: Scripts without error handling
✅ ALWAYS: set -e and proper error messages

❌ NEVER: Duplicate logic across scripts
✅ ALWAYS: Shared functions in lib/

❌ NEVER: Configuration scattered in scripts
✅ ALWAYS: Configuration in config/ directory

❌ NEVER: Scripts that assume specific directory structure
✅ ALWAYS: Use get_construct_root() and validation functions
```

### CONSTRUCT-Specific Rules

```bash
❌ NEVER: Modify USER-project-files/ from CONSTRUCT scripts
✅ ALWAYS: Read-only analysis of USER-project-files/

❌ NEVER: Template changes without testing
✅ ALWAYS: Test templates work independently

❌ NEVER: Scripts that only work in development
✅ ALWAYS: Scripts that work for template users

❌ NEVER: Hardcoded USER project names
✅ ALWAYS: Use PROJECT-TEMPLATE placeholders
```

### Modern Shell Scripting Rules

```bash
❌ NEVER: Functions without documentation
✅ ALWAYS: Function headers with purpose and parameters

❌ NEVER: Global variables without UPPER_CASE
✅ ALWAYS: Clear variable scoping and naming

❌ NEVER: Commands without error checking
✅ ALWAYS: Check exit codes and provide feedback

❌ NEVER: Silent failures
✅ ALWAYS: Colored output with status indicators
```

### Quality Gate Rules

```bash
❌ NEVER: Commit without running quality checks
✅ ALWAYS: Use pre-commit hooks for validation

❌ NEVER: Create files without proper documentation
✅ ALWAYS: Auto-generate and update documentation

❌ NEVER: Break existing template functionality
✅ ALWAYS: Validate template integrity before changes
```

### Development Process

1. **Before Writing ANY Code**:
   ```bash
   ./CONSTRUCT/scripts/core/before_coding.sh ComponentName
   ./CONSTRUCT/scripts/core/check-architecture.sh
   ./CONSTRUCT/scripts/construct/update-context.sh
   ```

2. **When Making Commits**:
   - NEVER hide pre-commit hook output from user
   - ALWAYS show the full pre-commit output
   - ALWAYS explain what the hooks validated

3. **Post-Commit Behavior**:
   - New structure files generated during pre-commit
   - Old structure files cleaned up after commit
   - Only current files remain, old ones moved to _old/
   - These deletions are NOT errors

### Validated Development Discoveries

1. **Dual environments required**: CONSTRUCT development separate from USER templates
2. **Template contamination**: USER-project-files must stay clean of CONSTRUCT-specific code
3. **Configuration-driven validation**: Rules in YAML, not hardcoded in scripts
4. **Auto-documentation essential**: Manual docs get out of sync quickly
5. **Before-coding validation essential**: Prevents duplicate work and violations
6. **Quality gates catch issues early**: Pre-commit hooks prevent drift
7. **Session summaries preserve context**: Large changes need documentation
8. **Template testing required**: Changes must work for both CONSTRUCT and users

### When Manual Updates ARE Acceptable

```bash
# ✅ CORRECT: Manual configuration
# Manual strategic decisions, architectural choices
# User-specific goals and priorities

# ❌ WRONG: Manual status tracking
# File counts, git status, structure analysis
# These should auto-update via scripts
```

### 📚 Authoritative Standards Documents

**Shell Standards**: `AI/docs/automated/development-patterns-automated.md`
- Complete script patterns, error handling, library usage
- Configuration-driven validation, quality gates

**Architecture Overview**: `AI/docs/automated/architecture-overview-automated.md`
- Dual-environment design, component relationships

**Script Reference**: `AI/docs/automated/script-reference-automated.md`
- All available scripts and library functions

### 🗄️ Historical Context (Deprecated but Kept for Reference)

- **Previous single-environment approach** (replaced by dual-environment)
- **Hardcoded path patterns** (replaced by relative path resolution)
- **Manual documentation updates** (replaced by auto-generation)
- **Inline validation** (replaced by configuration-driven rules)

## Validated Development Discoveries

These are empirically proven truths about CONSTRUCT development:

### 🏗️ CONSTRUCT Architecture Truths

1. **Dual environments required**: CONSTRUCT development separate from USER templates
2. **Template contamination**: USER-project-files must stay clean of CONSTRUCT-specific code  
3. **Configuration-driven validation**: Rules in YAML, not hardcoded in scripts
4. **Auto-documentation essential**: Manual docs get out of sync quickly
5. **Before-coding validation essential**: Prevents duplicate work and violations
6. **Quality gates catch issues early**: Pre-commit hooks prevent drift
7. **Session summaries preserve context**: Large changes need documentation
8. **Template testing required**: Changes must work for both CONSTRUCT and users

### 🔗 Symlink Architecture Truths

1. **Symlinks maintain consistency**: Changes in CORE automatically reflect in LAB
2. **Never edit symlinked files**: Always edit source in CORE
3. **Symlink naming convention**: *-sym.ext files are always symlinks
4. **Pre-commit validates integrity**: Broken symlinks fail commits
5. **Promotion workflow required**: LAB changes promote to CORE via tools

### 🚀 LAB-to-CORE Promotion Truths

1. **LAB is experimental**: All new features start in LAB
2. **CORE is stable**: Only tested, proven code goes to CORE
3. **Promotion requires validation**: Tools ensure quality before promotion
4. **Manifest controls promotion**: PROMOTE-TO-CORE.yaml defines what moves
5. **Symlinks auto-update**: After promotion, LAB reflects new CORE state

### 📜 Shell Scripting Truths

1. **Exit codes matter**: 0 = success, >0 = number of issues found
2. **Colors improve UX**: Red for errors, green for success, yellow for warnings
3. **Help is mandatory**: All scripts must support --help
4. **Library functions reduce duplication**: Common patterns belong in lib/
5. **Absolute paths from CONSTRUCT_ROOT**: Scripts work from any directory

### 🔄 Development Process Discoveries

1. **Context degrades quickly**: Regular updates keep AI effective
2. **Patterns emerge from use**: Don't over-design, let patterns develop
3. **Documentation generates trust**: Clear docs reduce cognitive load
4. **Automation prevents drift**: Manual processes always decay
5. **Examples teach better than rules**: Show correct patterns in action

### 🎯 Git Workflow Patterns

1. **Pre-commit hooks prevent bad commits**: Quality gates stop issues early
2. **Auto-staging generated files**: Structure files update automatically
3. **Branch protection via quality**: Bad code can't merge
4. **Clear commit messages required**: Future you needs context
5. **Atomic commits preferred**: One logical change per commit

## Project Structure

### Repository Structure
```
CONSTRUCT/
├── CONSTRUCT-CORE/        # Stable framework components
│   ├── CONSTRUCT/         # Main framework code
│   │   ├── scripts/       # Executable scripts (by category)
│   │   ├── lib/           # Shared functions
│   │   └── config/        # Configuration
│   ├── patterns/plugins/  # Pattern plugin system
│   └── TEMPLATES/         # Project templates
├── CONSTRUCT-LAB/         # Experimental development
└── Projects/              # Git-independent managed projects
```

## Code Examples

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

### ❌ Anti-Pattern Examples (Never Do This)

```bash
# ❌ BAD: Hardcoded paths
SCRIPT_DIR="/Users/username/project/scripts"  # Breaks for other users

# ❌ BAD: No error handling
#!/bin/bash
# Missing: set -e
command_that_might_fail
next_command  # Runs even if previous failed

# ❌ BAD: No validation
cp "$1" "$2"  # No check if parameters exist

# ❌ BAD: Silent operations
find . -name "*.tmp" -delete  # No feedback to user

# ❌ BAD: Global variables without clear naming
result="some value"  # Should be RESULT or local

# ❌ BAD: Functions without documentation
process_files() {
    # What does this do? What parameters? What returns?
}
```

### Template Structure Validation Pattern

```bash
# Always check template health before modifications
validate_template_structure() {
    local template_dir="$CONSTRUCT_ROOT/PROJECT-TEMPLATE"
    
    if [ ! -d "$template_dir" ]; then
        echo -e "${RED}❌ Template directory not found${NC}"
        return 1
    fi
    
    # Check for required template files
    local required_files=(
        "USER-CHOSEN-NAME/AI/CLAUDE.md"
        "USER-CHOSEN-NAME/AI/scripts/construct/update-context.sh"
    )
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$template_dir/$file" ]; then
            echo -e "${RED}❌ Missing template file: $file${NC}"
            return 1
        fi
    done
    
    echo -e "${GREEN}✅ Template structure valid${NC}"
    return 0
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

## Quick Commands

## CONSTRUCT Development Commands

### 🛠️ Core Development Workflow

1. **`construct-update`** (or `./CONSTRUCT/scripts/construct/update-context.sh`)
   - Updates CLAUDE.md with current project state
   - Run before starting a Claude session
   - Shows what components exist, violations, recent work

2. **`construct-check`** (or `./CONSTRUCT/scripts/core/check-architecture.sh`)
   - Checks for architecture violations
   - Verifies development patterns automatically
   - Shows hardcoded paths, duplication, template issues
   - **Use this to check development progress!**

3. **`construct-before ComponentName`** (or `./CONSTRUCT/scripts/core/before_coding.sh`)
   - Run before creating any new component
   - Shows what already exists
   - Prevents duplicates
   - Checks architectural alignment

4. **`construct-scan`** (or `./CONSTRUCT/scripts/construct/scan_project_structure.sh`)
   - Documents current CONSTRUCT structure
   - Creates timestamped snapshots
   - Archives old scans to `_old/`

5. **`construct-arch`** (or `./CONSTRUCT/scripts/construct/update-architecture.sh`)
   - Updates architecture documentation
   - Refreshes file trees and metrics

6. **`construct-quality`** (or `./CONSTRUCT/scripts/core/check-quality.sh`)
   - Checks shell script quality standards
   - Looks for common issues and anti-patterns
   - Validates configuration files

7. **`construct-docs`** (or `./CONSTRUCT/scripts/core/check-documentation.sh`)
   - Validates documentation coverage
   - Checks for missing function docs
   - Ensures README files exist

8. **`construct-session-summary`** (or `./CONSTRUCT/scripts/dev/session-summary.sh`)
   - Creates session summary when context is ~90%
   - Preserves work for next session

### 📍 Quick Reference Commands

```bash
construct-update        # Update CLAUDE.md before starting
construct-check         # Check violations & architecture compliance
construct-before        # Before creating new components
construct-scan          # Document CONSTRUCT structure
construct-arch          # Update architecture docs
construct-quality       # Check script quality standards
construct-docs          # Validate documentation
construct-full          # Run all updates

# Navigation
construct-cd            # Go to CONSTRUCT root
construct-dev           # Go to CONSTRUCT-dev
construct-template      # Go to PROJECT-TEMPLATE
```

### 🔍 Discovery Commands

```bash
# What scripts exist?
find CONSTRUCT/scripts -name "*.sh" | sort

# What library functions exist?
find CONSTRUCT/lib -name "*.sh" | sort

# Check for hardcoded values
grep -r "/Users\|/home" CONSTRUCT/ --include="*.sh"

# Update this file
./CONSTRUCT/scripts/update-context.sh
```

### 🏗️ Architecture Commands

```bash
# Before creating anything
./CONSTRUCT/scripts/before_coding.sh ComponentName

# Check compliance
./CONSTRUCT/scripts/check-architecture.sh

# See current structure
./CONSTRUCT/scripts/scan_construct_structure.sh

# Generate all documentation
./CONSTRUCT/scripts/update-architecture.sh
```

### 🔄 LAB/CORE Workflow Commands

```bash
# Check symlink integrity
./CONSTRUCT/scripts/construct/check-symlinks.sh

# Validate changes for promotion
./tools/validate-promotion.sh

# Promote tested changes to CORE
./tools/promote-to-core.sh

# Update promotion manifest
vim PROMOTE-TO-CORE.yaml
```

### 🧪 Testing Commands

```bash
# Run all quality checks
construct-quality

# Test specific pattern
construct-check --pattern shell-scripting

# Validate before commit
construct-check && construct-quality && construct-docs
```

### 📊 Reporting Commands

```bash
# Generate development update
./CONSTRUCT/scripts/dev/generate-devupdate.sh

# Create session summary
construct-session-summary

# View current violations
construct-check --report

# Architecture overview
construct-arch --overview
```

## Current Context

<!-- START:CURRENT-STRUCTURE -->
## 📊 Current Project State (Auto-Updated)
Last updated: 2025-07-16 08:37:07

### Active Components
- Shell Scripts: 191
- Library Functions: 0
- Pattern Plugins: 1
- Templates: 7
- Documentation Files: 5
- Configuration Files: 0

### Available Resources

#### 🧩 Library Functions

#### ⚙️ Configuration Files

<!-- END:CURRENT-STRUCTURE -->

<!-- Dynamic sections updated by construct-update -->

<!-- START:ACTIVE-SYMLINKS -->
### 🔗 Active Symlinks (Auto-Updated)

These files in LAB are symlinks to CORE - NEVER edit them directly:
```bash
# CONSTRUCT -> ../CONSTRUCT-CORE/CONSTRUCT
# AI/dev-logs/dev-updates/devupdate-prompt-sym.md -> ../../../../CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/dev-logs/dev-updates/_devupdate-prompt.md
# AI/dev-logs/check-quality/README-sym.md -> ../../../../CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/dev-logs/check-quality/README.md
# AI/dev-logs/dev-updates/README-sym.md -> ../../../../CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/dev-logs/dev-updates/README.md
# AI/docs/README-sym.md -> ../../../CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/docs/README.md
# AI/todo/README-sym.md -> ../../../CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/todo/README.md

# To check symlink integrity:
./CONSTRUCT/scripts/check-symlinks.sh

# If you need to modify these files:
# 1. Create new version in LAB
# 2. Test thoroughly
# 3. Use promote-to-core.sh to update CORE
```
<!-- END:ACTIVE-SYMLINKS -->

<!-- START:SPRINT-CONTEXT -->
## 🎯 Current Development Context (Auto-Updated)
**Date**: 2025-07-16
**Focus**: Dual-environment development system
**Branch**: refactor/core-lab-templates
**Last Commit**: e22ed4b feat: Add web framework and platform patterns

### Current Focus
- Active patterns and development priorities
- Code quality and architecture compliance
- Documentation coverage and completeness
- Development workflow optimization

### Development Workflow
1. Work in project directory
2. Use project context (this file)
3. Run pattern-specific validators
4. Commit changes with confidence
<!-- END:SPRINT-CONTEXT -->

<!-- START:VIOLATIONS -->
## ⚠️ Active Violations (Auto-Updated)

### Hardcoded Paths
Run ./CONSTRUCT/scripts/core/check-quality.sh to see current violations

### Missing Documentation
✅ All scripts have documentation headers

### Code Duplication
Run ./CONSTRUCT/scripts/core/check-architecture.sh for duplication analysis

### Template Issues
✅ Template integrity verified
<!-- END:VIOLATIONS -->

<!-- START:WORKING-LOCATION -->
## 📍 Current Working Location (Auto-Updated)

### Recently Modified Files
- CLAUDE.md
- CONSTRUCT-CORE/patterns/plugins/frameworks/web/validators/performance-check.sh
- CONSTRUCT-CORE/patterns/plugins/frameworks/web/validators/security-check.sh
- CONSTRUCT-CORE/patterns/plugins/frameworks/web/web.md
- CONSTRUCT-CORE/patterns/plugins/frameworks/web/web.yaml
- CONSTRUCT-CORE/patterns/plugins/platforms/web/validators/accessibility-check.sh
- CONSTRUCT-CORE/patterns/plugins/platforms/web/web.md
- CONSTRUCT-CORE/patterns/plugins/platforms/web/web.yaml
- CONSTRUCT-CORE/patterns/plugins/README.md
- CONSTRUCT-CORE/patterns/plugins/registry.yaml


### Git Status
```
M  CLAUDE.md
D  CONSTRUCT-CORE/CLAUDE.md
M  CONSTRUCT-CORE/CONSTRUCT/scripts/construct/init-construct.sh
M  CONSTRUCT-CORE/patterns/plugins/frameworks/web/web.yaml
M  CONSTRUCT-CORE/patterns/plugins/platforms/web/web.yaml
M  CONSTRUCT-LAB/AI/PRDs/current-sprint/step01/status-01.md
 M CONSTRUCT-LAB/AI/docs/automated/architecture-overview-automated.md
A  CONSTRUCT-LAB/AI/quality-reports/quality-report-2025-07-16--07-59-00.md
D  CONSTRUCT-LAB/AI/structure/project-structure-2025-07-15--23-34-04.md
 D CONSTRUCT-LAB/AI/structure/project-structure-2025-07-16--07-59-00.md
```

### Active Development Areas
- CONSTRUCT-LAB/CONSTRUCT/scripts/ - Core development scripts
- CONSTRUCT-LAB/CONSTRUCT/lib/ - Shared library functions  
- CONSTRUCT-LAB/AI/docs/automated/ - Auto-generated documentation
- PROJECT-TEMPLATE/ - Template files for users
<!-- END:WORKING-LOCATION -->

<!-- START:DOCUMENTATION-LINKS -->
## 📚 Documentation Resources (Auto-Updated)

### Architecture Documentation
- Architecture Overview - Run ./CONSTRUCT/scripts/construct/update-architecture.sh to generate
- Script Reference - Run ./CONSTRUCT/scripts/construct/update-architecture.sh to generate
- Development Patterns - Run ./CONSTRUCT/scripts/construct/update-architecture.sh to generate
- API Reference - Run ./CONSTRUCT/scripts/construct/update-architecture.sh to generate

### Structure Analysis
- Current Structure - Run ./CONSTRUCT/scripts/construct/scan_construct_structure.sh to generate
- [Latest Structure Scan](AI/structure/) - Timestamped structure analysis files
- [Structure Archive](AI/structure/_old/) - Previous structure snapshots

### Quality Reports
- Latest Quality Report - Run ./CONSTRUCT/scripts/core/check-quality.sh to generate
- Session Summaries - Run ./CONSTRUCT/scripts/dev/session-summary.sh to generate

### Development Process
- Improving CONSTRUCT Guide - Run ./CONSTRUCT/scripts/construct/update-architecture.sh to generate
<!-- END:DOCUMENTATION-LINKS -->

<!-- START:ACTIVE-PRDS -->
### 📋 Active Product Requirements (Auto-Updated)

#### Current Sprint PRDs
- [CONSTRUCT-Abstraction-Roadmap-v02.md](CONSTRUCT-LAB/AI/PRDs/current-sprint/CONSTRUCT-Abstraction-Roadmap-v02.md)
- [init-construct-enhancement-spec.md](CONSTRUCT-LAB/AI/PRDs/current-sprint/init-construct-enhancement-spec.md)
- [injection-protocol-spec.md](CONSTRUCT-LAB/AI/PRDs/current-sprint/injection-protocol-spec.md)
- [status-01.md](CONSTRUCT-LAB/AI/PRDs/current-sprint/status-01.md)
- [unified-pattern-system-plan-v32.md](CONSTRUCT-LAB/AI/PRDs/current-sprint/unified-pattern-system-plan-v32.md)
- [dynamic-context-orchestration-prd.md](CONSTRUCT-LAB/AI/PRDs/current-sprint/dynamic-context-orchestration-prd.md)
- [workspace-import-prd-v11.md](CONSTRUCT-LAB/AI/PRDs/current-sprint/workspace-import-prd-v11.md)
- [context-aware-context-engineering-prd.md](CONSTRUCT-LAB/AI/PRDs/current-sprint/context-aware-context-engineering-prd.md)

#### Active Todos
- [CONSTRUCT-ABSTRACTION-ROADMAP-v01.markdown](CONSTRUCT-LAB/AI/todo/current/CONSTRUCT-ABSTRACTION-ROADMAP-v01.markdown)
- [CONSTRUCT-ABSTRACTION-ROADMAP-v02.markdown](CONSTRUCT-LAB/AI/todo/current/CONSTRUCT-ABSTRACTION-ROADMAP-v02.markdown)
- [context-engineering-integration-prd-v01.md](CONSTRUCT-LAB/AI/todo/current/context-engineering-integration-prd-v01.md)
- [dynamic-context-orchestration-prd.md](CONSTRUCT-LAB/AI/todo/current/dynamic-context-orchestration-prd.md)
- [howto.md](CONSTRUCT-LAB/AI/todo/current/howto.md)
- [integrate-init.txt](CONSTRUCT-LAB/AI/todo/current/integrate-init.txt)
- [interactive-scripts-prd.md](CONSTRUCT-LAB/AI/todo/current/interactive-scripts-prd.md)
- [preserve.md](CONSTRUCT-LAB/AI/todo/current/preserve.md)
- [unified-pattern-system-plan-v32.md](CONSTRUCT-LAB/AI/todo/current/unified-pattern-system-plan-v32.md)
- [workspace-import-prd-v11.md](CONSTRUCT-LAB/AI/todo/current/workspace-import-prd-v11.md)

<!-- END:ACTIVE-PRDS -->

## AI Assistance

## AI Guidance for CONSTRUCT Development

### 🤖 Working with CONSTRUCT

When working on CONSTRUCT framework:
1. **Read the room**: Check auto-sections in CLAUDE.md files
2. **Respect symlinks**: Never edit -sym files directly
3. **Use the tools**: Scripts exist for common tasks
4. **Pattern first**: Check if pattern exists before creating
5. **Context matters**: Update context before major work
6. **Test in LAB**: All experiments happen in LAB first

### Where Code Belongs - Quick Reference

**Scripts** (CONSTRUCT/scripts/):
- `core/` - Core functionality (check-quality, check-architecture, etc.)
- `construct/` - CONSTRUCT-specific tools (update-context, check-symlinks, etc.)
- `dev/` - Development workflows (session-summary, setup-aliases, etc.)
- `workspace/` - Workspace management (create-project, import-project, etc.)

**Library Functions** (CONSTRUCT/lib/):
- Reusable functions across scripts
- Common validation patterns
- Template management utilities
- File analysis and pattern detection

**Configuration** (CONSTRUCT/config/):
- Validation rules and thresholds
- Quality gates and standards
- YAML-based rule definitions
- No hardcoded values in scripts

**Documentation** (AI/docs/):
- Auto-generated architecture overviews
- Script references and usage guides
- Development patterns and standards
- Session summaries and decision logs

### Common AI Mistakes to Avoid

1. **Hardcoding paths in scripts**
   - ❌ AI suggestion: "Use /Users/username/project"
   - ✅ Correct: Use get_construct_root() and relative paths

2. **Missing error handling**
   - ❌ AI suggestion: "Just run the command"
   - ✅ Correct: Check exit codes and provide feedback

3. **Not using library functions**
   - ❌ AI suggestion: "Duplicate the validation code"
   - ✅ Correct: Source and use existing library functions

4. **Breaking template independence**
   - ❌ AI suggestion: "Modify USER-project-files directly"
   - ✅ Correct: Read-only analysis, modifications via templates

5. **Editing symlinked files**
   - ❌ AI suggestion: "Edit the README in LAB"
   - ✅ Correct: Edit in CORE, symlinks auto-update

### When Manual Updates ARE Acceptable

```bash
# ✅ CORRECT: Manual configuration
# Manual strategic decisions, architectural choices
# User-specific goals and priorities

# ❌ WRONG: Manual status tracking
# File counts, git status, structure analysis
# These should auto-update via scripts
```

### AI Session Best Practices

1. **On Session Start**:
   - Run `construct-update` to refresh auto-sections
   - Check "Current Development Context" for immediate goals
   - Review "Active Violations" for issues to avoid
   - Check documentation links for detailed architecture info

2. **When Context Remaining Falls to 10% or Below**:
   - **Alert user at EVERY response when ≤10% remains**: 
     - At 10%: "⚠️ Context at 90% used (10% remaining) - prepare to wrap up"
     - At 8%: "⚠️ Context at 92% used (8% remaining) - time to generate session summary"
     - At 5%: "🚨 URGENT: Only 5% context remaining - run session summary NOW"
     - At 3%: "🚨 CRITICAL: 3% context left - this may be the last full response"
   - **Tell user to run**: `construct-session-summary`
   - **After summary generates**: Remind user to start fresh Claude session
   - **Key message**: "Session summary saved. Please start a new Claude session to continue with full context."
   - **Also remind**: "Consider creating a dev-log if you've completed significant work:
     - Template: `AI/dev-logs/_devupdate-prompt.md`
     - Create as: `AI/dev-logs/devupdate-XX.md`"

3. **When Creating Code**:
   - Check "Available Resources" section first
   - Use "Pattern Library" templates
   - Never violate "ENFORCE THESE RULES" section
   - Run architecture check before finalizing
   - Ensure template independence is maintained

4. **When Discovering New Truths**:
   - Add to "Validated Discoveries" if universally true
   - Update "Current Development Context" if project-specific
   - Move old truths to "Historical Context" if deprecated
   - Update auto-sections via update-context.sh

### CONSTRUCT-Specific AI Guidance

When AI is asked about CONSTRUCT development:

1. **Architecture Questions**:
   - LAB is for experimentation, CORE is for stable code
   - Symlinks maintain consistency between environments
   - Templates must work independently of CONSTRUCT

2. **Script Development**:
   - Always use relative paths from CONSTRUCT_ROOT
   - Include proper error handling (set -e)
   - Add colored output for user feedback
   - Document functions with purpose and parameters

3. **Pattern System**:
   - Patterns live in patterns/plugins/
   - Each pattern has its own validators and generators
   - Pattern configuration via patterns.yaml
   - CLAUDE.md is generated, never edited manually

4. **Quality Standards**:
   - All scripts need --help output
   - Functions need documentation headers
   - Configuration belongs in config/ not scripts
   - Pre-commit hooks enforce standards

### 🔧 Interactive Rails Mode

When working with CONSTRUCT scripts that source `interactive-support.sh`:

#### Rails Pattern
1. **Follow script structure** - Scripts define the conversation flow
2. **Natural prompts** - Present script prompts conversationally 
3. **Smart responses**:
   - Direct answers (ios, default, yes) → Continue script flow
   - Questions (what? how? list options?) → Provide help, then return to flow
4. **Minimal context** - Stay on rails unless user needs help

#### Example Flow
```
User: Create a new project
Claude: What's the project name and type? (ios, web, api, or fullstack)
User: MyApp ios
Claude: Use default plugins or would you like to customize?
User: What plugins are available?
Claude: [HELP MODE] Available plugins include:
- languages/swift - Swift language patterns
- tooling/shell-scripting - Shell automation
- cross-platform/model-sync - Multi-platform support
Would you like default or custom?
User: default
[Execute: echo '' | ./create-project.sh MyApp ios]
```

#### When AI Encounters Rails Scripts:
- Let the script guide the conversation
- Provide natural responses to prompts
- Present help when user asks questions
- Return to script flow after help
- Don't try to bypass the interactive flow
- Trust the script's decision logic

### Remember

The goal is to create self-improving development environments where AI assistance gets smarter with every commit. CONSTRUCT development should follow its own patterns and standards, serving as the exemplar for projects using CONSTRUCT.

---

*This context is dynamically generated based on active patterns. To update, run the appropriate context refresh command for your project.*
