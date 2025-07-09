# CONSTRUCT Scripts - Pattern-Based Architecture

## Overview

This is the new pattern-based script organization for CONSTRUCT. Scripts are now organized into:

1. **Core Scripts** (root level) - Infrastructure and orchestration
2. **Pattern Scripts** (patterns/) - Pattern-specific validation and checks

## Directory Structure

```
scripts-new/
├── # Core Infrastructure Scripts (stay at root)
├── assemble-claude.sh          # Assembles CLAUDE.md from patterns
├── check-symlinks.sh           # Symlink integrity checking
├── construct-patterns.sh       # Pattern management interface
├── create-project.sh           # Project creation with patterns
├── import-project.sh           # Import projects into workspace
├── workspace-status.sh         # Multi-project status
├── update-context.sh           # Context updates
├── ...
│
├── # Master Orchestration Scripts
├── check-architecture.sh       # Orchestrates pattern architecture checks
├── check-quality.sh            # Orchestrates pattern quality checks
│
└── patterns/                   # Pattern-specific implementations
    ├── shell-scripting/
    │   └── validate-architecture.sh
    ├── construct-development/
    │   └── validate-architecture.sh
    ├── shell-quality/
    │   └── validate-quality.sh
    ├── swift-language/
    │   └── validate-quality.sh
    ├── csharp-language/
    │   └── validate-quality.sh
    └── ios-ui-library/
        └── validate-usage.sh
```

## How It Works

### Master Scripts

The master scripts (`check-architecture.sh`, `check-quality.sh`) now:
1. Run base checks that apply to all projects
2. Detect active patterns from `.construct/patterns.yaml`
3. Delegate to pattern-specific validators
4. Aggregate results and generate reports

### Pattern Scripts

Each pattern can have:
- `validate-architecture.sh` - Architecture/structure validation
- `validate-quality.sh` - Code quality checks
- `validate-usage.sh` - Pattern usage validation
- Other pattern-specific scripts

### Example Flow

When you run `check-quality.sh`:

```
check-quality.sh
  ├── Runs base quality checks
  ├── Reads .construct/patterns.yaml
  ├── Finds active patterns: [swift-language, ios-ui-library]
  ├── Calls patterns/swift-language/validate-quality.sh
  ├── Calls patterns/ios-ui-library/validate-usage.sh
  └── Generates quality report
```

## Benefits

1. **Modular** - Each pattern is self-contained
2. **Extensible** - Easy to add new patterns
3. **Configurable** - Projects choose which patterns to use
4. **Maintainable** - Pattern logic is isolated

## Migration Notes

To migrate from the old structure:
1. Core scripts were copied as-is
2. Architecture and quality checks were split into base + pattern-specific
3. Pattern validators were created for common patterns
4. Master scripts orchestrate pattern execution

## Next Steps

1. Test the new scripts with a sample project
2. Create corresponding lib/ and config/ structures for patterns
3. Update pre-commit hooks to use new scripts
4. Migrate remaining validation logic to patterns