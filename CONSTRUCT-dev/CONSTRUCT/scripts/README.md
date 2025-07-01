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

### Testing
- **`test-runner.sh`** - Basic test execution framework (in ../tests/)

## Usage

All scripts are designed to be run from the CONSTRUCT-dev/ directory:

```bash
# From CONSTRUCT-dev/ directory
./CONSTRUCT/scripts/update-context.sh
./CONSTRUCT/scripts/check-architecture.sh
# etc.
```

## Automation

These scripts are automatically executed during git pre-commit hooks to ensure:
- Documentation stays current
- Architecture compliance is maintained
- Quality standards are met
- Development context is preserved

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