# CONSTRUCT Development Scripts

This directory contains all the core scripts for CONSTRUCT development and maintenance.

## Available Scripts

### Core Development Workflow
- **`update-context.sh`** - Updates CLAUDE.md with current development state
- **`check-architecture.sh`** - Validates CONSTRUCT development patterns  
- **`check-quality.sh`** - Runs comprehensive quality checks
- **`scan_construct_structure.sh`** - Analyzes and documents project structure
- **`update-architecture.sh`** - Generates comprehensive architecture documentation

### Development Utilities
- **`before_coding.sh`** - Search existing components before creating new ones
- **`session-summary.sh`** - Creates session summaries when context gets full
- **`check-documentation.sh`** - Validates documentation coverage and quality
- **`setup-aliases.sh`** - Installs shell aliases for faster development

### Git Integration
- **`pre-commit-review.sh`** - Interactive pre-commit validation with full visibility
- **`commit-with-review.sh`** - Guided commit process with quality gates
- **`generate-devupdate.sh`** - Automated development update generation

### Symlink Management  
- **`check-symlinks.sh`** - Validates symlink integrity between LAB and CORE
- **`promote-to-core.sh`** - Promotes tested changes from LAB to CORE
- **`validate-promotion.sh`** - Validates promotion workflow compliance

## Usage

All scripts are designed to be run from the CONSTRUCT-LAB/ directory:

```bash
# From CONSTRUCT-LAB/ directory
./CONSTRUCT/scripts/update-context.sh
./CONSTRUCT/scripts/check-architecture.sh
# etc.
```

## Automation & Git Integration

### Pre-Commit Hooks
These scripts are automatically executed during git pre-commit hooks to ensure:
- **Documentation stays current** - All generated docs auto-staged in same commit
- **Architecture compliance** - Patterns and standards validated before commit
- **Quality standards** - Code quality gates enforced automatically  
- **Development context preserved** - AI context files always up-to-date
- **Template integrity** - Changes don't break template users

### Auto-Staging Behavior
The pre-commit hook automatically stages generated files including:
- Documentation updates in `AI/docs/automated/`
- Quality reports in `AI/dev-logs/check-quality/automated/`
- Structure scans in `AI/structure/`
- Session summaries in `AI/dev-logs/session-states/automated/`
- Development updates in `AI/dev-logs/dev-updates/automated/`
- Updated context in `CLAUDE.md`

This ensures **single-commit workflow** where your changes and all generated documentation are committed together.

## Script Dependencies

Scripts source shared functions from:
- `../lib/validation.sh` - Common validation patterns
- `../lib/template-utils.sh` - Template management
- `../lib/file-analysis.sh` - Code analysis utilities
- `../lib/common-patterns.sh` - Shared script patterns

## Configuration

Scripts use configuration files from:
- `../config/mvvm-rules.yaml` - Architecture validation rules
- `../config/quality-gates.yaml` - Quality thresholds and standards