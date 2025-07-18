# CONSTRUCT Development Pattern Plugin

This plugin provides development patterns specific to working on CONSTRUCT itself.

## What This Plugin Provides

### Guidelines
- Symlink management and integrity rules
- LAB-to-CORE promotion workflow
- Dual-environment development practices
- Shell scripting standards for CONSTRUCT

### Examples
- Shell script templates with proper error handling
- Library function patterns for reusability
- Configuration-driven development examples
- Before-coding validation workflows

### Validators
- Architecture compliance checking
- Symlink integrity validation
- Path resolution validation
- Quality gate enforcement

### Generators
- Context update scripts
- Architecture documentation
- Development session summaries
- Quality reports

## When to Use This Plugin

Use this plugin when:
- Developing CONSTRUCT framework itself
- Creating new CONSTRUCT features
- Working with LAB/CORE architecture
- Building shell-based tools

## Installation

This plugin is automatically activated when working on CONSTRUCT by including in patterns.yaml:

```yaml
plugins:
  - tooling/construct-dev
```

## Key Commands

- `construct-before ComponentName` - Check before creating new components
- `construct-check` - Validate architecture compliance
- `construct-update` - Update project context
- `construct-scan` - Analyze project structure
- `construct-quality` - Check code quality
- `construct-session` - Create session summary

## Development Workflow

1. Always work in CONSTRUCT-LAB for new features
2. Test thoroughly before promoting to CORE
3. Use symlinks to maintain consistency
4. Run quality checks before commits
5. Update documentation as you develop