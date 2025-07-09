# CONSTRUCT Scripts Directory

## Overview

This directory contains all CONSTRUCT scripts organized by their purpose and scope. Scripts are categorized into subdirectories based on whether they're general-purpose tools or CONSTRUCT-specific utilities.

## Directory Structure

```
scripts-new/
├── core/                    # General-purpose orchestrators
├── construct/               # CONSTRUCT-specific tools
├── workspace/               # Workspace management
├── dev/                     # Development tools
└── patterns/                # Pattern validators
```

## Core Scripts (`core/`)

General-purpose orchestrators that work with any project using patterns.yaml:

- **`check-quality.sh`** - Orchestrates code quality validation across active patterns
- **`check-architecture.sh`** - Orchestrates architecture validation based on patterns
- **`check-documentation.sh`** - Orchestrates documentation validation
- **`before_coding.sh`** - Pattern-aware code search and discovery tool
- **`construct-patterns.sh`** - Pattern management interface

### Usage
```bash
# All core scripts accept PROJECT_DIR parameter
./core/check-quality.sh                    # Current directory
./core/check-architecture.sh Projects/MyApp # Specific project
./core/before_coding.sh UserViewModel       # Search for code
```

## CONSTRUCT Scripts (`construct/`)

CONSTRUCT-specific tools for managing the CONSTRUCT development environment:

- **`assemble-claude.sh`** - Assembles CLAUDE.md from multiple sources
- **`check-symlinks.sh`** - Validates LAB/CORE symlink integrity
- **`update-context.sh`** - Updates CONSTRUCT development context (CLAUDE.md)
- **`scan_construct_structure.sh`** - Analyzes CONSTRUCT directory structure
- **`update-architecture.sh`** - Updates architecture documentation

### Usage
```bash
# CONSTRUCT scripts work within CONSTRUCT environment
./construct/check-symlinks.sh              # Check symlink integrity
./construct/update-context.sh              # Update CLAUDE.md
```

## Workspace Scripts (`workspace/`)

Tools for managing multi-project workspaces:

- **`create-project.sh`** - Create new projects with patterns
- **`import-project.sh`** - Import existing projects into workspace
- **`import-component.sh`** - Import components between projects
- **`workspace-status.sh`** - Multi-project status overview
- **`workspace-update.sh`** - Update all projects in workspace

### Usage
```bash
# Workspace management
./workspace/create-project.sh MyNewApp ios          # Create iOS project
./workspace/import-project.sh ~/external/MyProject  # Import project
./workspace/workspace-status.sh                     # Check all projects
```

## Development Tools (`dev/`)

Helper scripts for development workflow:

- **`commit-with-review.sh`** - Enhanced commit workflow with checks
- **`pre-commit-review.sh`** - Pre-commit validation helper
- **`generate-devupdate.sh`** - Generate development update logs
- **`session-summary.sh`** - Create session summaries for context preservation
- **`setup-aliases.sh`** - Setup command shortcuts

### Usage
```bash
# Development workflow helpers
./dev/session-summary.sh                   # Before context limit
./dev/commit-with-review.sh                # Safe commit process
./dev/setup-aliases.sh                     # Install shortcuts
```

## Pattern Validators (`patterns/`)

Language and framework-specific validators called by core orchestrators:

### Available Patterns
- `shell-scripting/` - Shell script validation
- `shell-quality/` - Shell script quality checks
- `construct-development/` - CONSTRUCT-specific validation
- `python-development/` - Python code validation
- `swift-language/` - Swift code validation
- `csharp-language/` - C# code validation
- `mvvm-architecture/` - MVVM pattern validation
- `ios-ui-library/` - iOS UI component validation

Each pattern contains:
- `validate-architecture.sh` - Architecture checks
- `validate-quality.sh` - Quality checks
- `validate-documentation.sh` - Documentation checks

## How It All Works Together

1. **Core scripts** are called with a PROJECT_DIR
2. They read `.construct/patterns.yaml` to find active patterns
3. They run base checks applicable to all projects
4. They delegate to **pattern validators** for specific checks
5. Results are aggregated and reported

### Example Flow
```
User runs: ./core/check-quality.sh Projects/MyApp/ios
           ↓
Script reads: Projects/MyApp/ios/.construct/patterns.yaml
           ↓
Finds patterns: [swift-language, ios-ui-library, mvvm-architecture]
           ↓
Runs validators: patterns/swift-language/validate-quality.sh
                patterns/ios-ui-library/validate-quality.sh
                patterns/mvvm-architecture/validate-quality.sh
           ↓
Reports: Combined results with total issue count
```

## Best Practices

1. **Use Core Scripts** for general validation - they work anywhere
2. **Use CONSTRUCT Scripts** only in CONSTRUCT development environment
3. **Add Pattern Validators** for new languages/frameworks
4. **Check Exit Codes** - 0 = success, >0 = issue count
5. **Run Before Commits** - Catch issues early

## Adding New Scripts

### For Core Scripts
- Must accept PROJECT_DIR parameter
- Must read patterns.yaml
- Must delegate to pattern validators
- Should work in any project

### For Pattern Validators
- Must accept PROJECT_DIR parameter
- Must return issue count as exit code
- Should focus on specific language/framework
- Should be called by core orchestrators

### For CONSTRUCT Scripts
- Can assume CONSTRUCT environment
- Can use hardcoded CONSTRUCT paths
- Should maintain CONSTRUCT infrastructure

## Quick Reference

```bash
# Before coding anything
./core/before_coding.sh ComponentName

# Check everything
./core/check-architecture.sh && ./core/check-quality.sh && ./core/check-documentation.sh

# CONSTRUCT maintenance
./construct/update-context.sh
./construct/check-symlinks.sh

# Development workflow
./dev/session-summary.sh    # When context is ~90%
./dev/commit-with-review.sh # Safe commits
```