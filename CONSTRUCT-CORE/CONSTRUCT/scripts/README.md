# CONSTRUCT Scripts Directory

## Overview

This directory contains all CONSTRUCT scripts organized by their purpose and scope. Scripts are categorized into subdirectories based on whether they're general-purpose tools or CONSTRUCT-specific utilities.

## Directory Structure

```
scripts/
├── core/                    # General-purpose orchestrators
├── construct/               # CONSTRUCT-specific tools
├── workspace/               # Workspace management
└── dev/                     # Development tools
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

Project-aware tools that were originally CONSTRUCT-specific but now work with any project:

- **`assemble-claude.sh`** - Assembles CLAUDE.md from multiple sources (now with --list-plugins, --list-sets, --refresh-registry)
- **`check-symlinks.sh`** - Validates LAB/CORE symlink integrity
- **`refresh-plugin-registry.sh`** - Refreshes the plugin registry by scanning plugin directories
- **`update-context.sh`** - Updates project context (PROJECT_DIR/CLAUDE.md)
- **`scan_project_structure.sh`** - Analyzes any project's directory structure
- **`update-architecture.sh`** - Updates project architecture documentation based on patterns

### Usage
```bash
# Most CONSTRUCT scripts now accept PROJECT_DIR parameter
./construct/update-context.sh                    # Update current project's CLAUDE.md
./construct/update-context.sh Projects/MyApp     # Update specific project's CLAUDE.md
./construct/scan_project_structure.sh            # Scan current project
./construct/update-architecture.sh ~/myproject   # Update architecture docs for any project

# Plugin registry management
./construct/refresh-plugin-registry.sh           # Update plugin registry
./construct/assemble-claude.sh --list-plugins    # List available plugins
./construct/assemble-claude.sh --list-sets       # List project template sets
./construct/assemble-claude.sh --refresh-registry # Refresh registry

# CONSTRUCT-only script
./construct/check-symlinks.sh                    # Check LAB/CORE symlinks (no PROJECT_DIR)
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

Project-aware helper scripts for development workflow:

- **`commit-with-review.sh`** - Enhanced commit workflow with checks
- **`pre-commit-review.sh`** - Pre-commit validation helper (accepts PROJECT_DIR)
- **`generate-devupdate.sh`** - Generate development update logs (accepts PROJECT_DIR)
- **`session-summary.sh`** - Create session summaries for any project
- **`setup-aliases.sh`** - Setup command shortcuts

### Usage
```bash
# Development workflow helpers (now project-aware)
./dev/session-summary.sh                         # Current project summary
./dev/session-summary.sh Projects/MyApp          # Specific project summary
./dev/generate-devupdate.sh . --auto             # Auto-generate dev update
./dev/pre-commit-review.sh Projects/MyApp        # Run all checks on specific project
./dev/commit-with-review.sh                      # Safe commit process
./dev/setup-aliases.sh                           # Install shortcuts
```

## Pattern Validators

**✅ MIGRATION COMPLETE**: All pattern validators have been moved to the plugin structure.

### Current Location
Pattern validators now live with their pattern plugins:
```
CONSTRUCT-CORE/patterns/plugins/[category]/[plugin-name]/validators/
```

### Migrated Validators
All validators have been successfully migrated:
- `languages/swift/validators/quality.sh`
- `languages/python/validators/quality.sh`
- `languages/csharp/validators/quality.sh`
- `tooling/shell-scripting/validators/` (architecture.sh, documentation.sh)
- `tooling/shell-quality/validators/quality.sh`
- `tooling/construct-dev/validators/` (architecture.sh, documentation.sh)
- `tooling/construct-dev/generators/architecture.sh` (moved from validators)
- `frameworks/ios-ui-library/validators/usage.sh`

### Backward Compatibility
Core orchestrator scripts (check-quality.sh, etc.) support both locations:
1. First checks new plugin location
2. Falls back to legacy location with warning

See `CONSTRUCT-CORE/patterns/plugins/README.md` for complete plugin documentation.

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
Runs validators: patterns/plugins/languages/swift/validators/quality.sh
                patterns/plugins/frameworks/ios-ui-library/validators/usage.sh
                patterns/plugins/architectural/mvvm-ios/validators/architecture.sh
           ↓
Reports: Combined results with total issue count
```

## Project-Aware Updates (New!)

Most scripts now accept a PROJECT_DIR parameter as their first argument:
- Scripts default to current directory if not specified
- Scripts update the project's AI/ directory, not CONSTRUCT-LAB/AI/
- Scripts detect project type from .construct/patterns.yaml
- Scripts adapt behavior based on whether they're in CONSTRUCT or other projects

### Examples
```bash
# Old way (only worked in CONSTRUCT)
./construct/update-context.sh

# New way (works anywhere)
./construct/update-context.sh                    # Current directory
./construct/update-context.sh Projects/MyApp     # Specific project
./construct/update-context.sh ~/external/project # Any project
```

## Best Practices

1. **Use Core Scripts** for general validation - they work anywhere
2. **Most CONSTRUCT Scripts** now work with any project via PROJECT_DIR
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
- Should accept PROJECT_DIR parameter (most now do)
- Should work with any project when possible
- Only assume CONSTRUCT environment if truly CONSTRUCT-specific (like check-symlinks.sh)

## Quick Reference

```bash
# Before coding anything (works in any project)
./core/before_coding.sh ComponentName

# Check everything in current project
./core/check-architecture.sh && ./core/check-quality.sh && ./core/check-documentation.sh

# Check specific project
./core/check-architecture.sh ~/Projects/MyApp

# Update any project's context
./construct/update-context.sh                    # Current project
./construct/update-context.sh Projects/MyApp     # Specific project

# CONSTRUCT-specific maintenance
./construct/check-symlinks.sh                    # Only for CONSTRUCT LAB/CORE

# Development workflow (project-aware)
./dev/session-summary.sh                         # Current project
./dev/session-summary.sh Projects/MyApp          # Specific project
./dev/generate-devupdate.sh . --auto             # Generate dev update
./dev/pre-commit-review.sh                       # Run all checks
```