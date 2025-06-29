# Construct Command Reference

## Overview

Construct provides a comprehensive set of commands to manage your Swift project architecture. All commands follow the pattern `construct-[action]`.

## Core Commands

### `construct-update`
Updates CLAUDE.md with the current project state.

```bash
construct-update
```

**What it does:**
- Scans project for components, services, and tokens
- Detects architecture violations
- Updates PRD tracking
- Extracts patterns from code
- Records recent decisions

**When to use:**
- Start of each coding session
- After significant changes
- Before AI assistance
- After merging branches

### `construct-check`
Validates architecture compliance.

```bash
construct-check
construct-check --component LoginView  # Check specific component
```

**What it checks:**
- Hardcoded values
- MVVM compliance
- Navigation patterns
- State management
- Swift 6 patterns
- Design token usage
- iOS configuration placement
- Accessibility compliance
- PRD alignment

**Exit codes:**
- 0: All checks passed
- 1: Violations found

### `construct-before`
Pre-coding discovery tool.

```bash
construct-before ComponentName
construct-before LoginView
construct-before UserService
```

**What it shows:**
- Existing similar components
- Available shared components
- Design tokens
- PRD alignment
- Suggested structure
- Code patterns to follow

**Always run before creating new components!**

## Development Commands

### `construct-new`
Creates new components from templates.

```bash
construct-new FeatureName
construct-new LoginView
construct-new PaymentService
```

**What it creates:**
- Feature directory structure
- View with MVVM pattern
- ViewModel with @MainActor
- Design tokens file
- Test file templates

### `construct-scan`
Documents current MVVM structure.

```bash
construct-scan
```

**What it generates:**
- Complete component inventory
- Relationship mapping
- Orphaned files detection
- Structure visualization
- Timestamped snapshots

## Quality Commands

### `construct-protect`
Runs comprehensive quality checks.

```bash
construct-protect
```

**What it validates:**
- SwiftUI best practices
- Background flash prevention
- Accessibility compliance
- Performance patterns
- Memory management
- Thread safety

### `construct-learn`
Analyzes patterns and violations.

```bash
construct-learn
```

**What it tracks:**
- Common patterns
- Violation trends
- Code evolution
- Architecture drift
- Team practices

## PRD Commands

### `construct-vision`
Manages product requirements.

```bash
construct-vision new feature-name    # Create new PRD
construct-vision list               # List all PRDs
construct-vision current            # Show current sprint
```

**PRD workflow:**
1. Create sprint PRD
2. Define requirements
3. Track implementation
4. Verify completion

## Session Commands

### `construct-session`
Generates session summary (auto-triggered at 90% context).

```bash
construct-session
```

**What it captures:**
- Current work state
- Recent changes
- Active files
- Uncommitted work
- Session metrics
- Next steps

**Critical**: Run this when Claude warns about context!

## AI Integration Commands

### `construct-export`
Exports rules for AI tools.

```bash
construct-export                    # Interactive mode
construct-export --cursor          # Export for Cursor
construct-export --copilot         # Export for GitHub Copilot
construct-export --format yaml     # Universal format
```

**Exported rules include:**
- Current patterns
- Project conventions
- Recent decisions
- Active violations
- Custom standards

## Navigation Shortcuts

### `construct-cd`
Navigate to project root.

```bash
construct-cd
```

### `construct-ios`
Navigate to iOS app directory.

```bash
construct-ios
```

### `construct-watch`
Navigate to Watch app directory.

```bash
construct-watch
```

## Advanced Usage

### Chaining Commands

Commands can be chained for workflows:

```bash
# Full update workflow
construct-update && construct-check && construct-scan

# Pre-commit workflow
construct-check && construct-protect

# New feature workflow
construct-before LoginView && construct-new LoginView
```

### Command Flags

Many commands support flags:

```bash
# Check specific component
construct-check --component LoginView

# Skip certain checks
construct-protect --skip-accessibility

# Verbose output
construct-update --verbose

# Fix mode
construct-check --fix
```

### Integration with Git

Construct commands integrate with git:

```bash
# Pre-commit hook runs
construct-check && construct-protect

# Post-merge hook runs
construct-update

# Pre-push hook runs
construct-check --strict
```

## Troubleshooting Commands

### Debug Mode

Enable debug output:

```bash
CONSTRUCT_DEBUG=1 construct-update
```

### Dry Run

Preview changes without applying:

```bash
construct-update --dry-run
construct-check --dry-run
```

### Reset

Reset Construct state:

```bash
construct-reset           # Reset to defaults
construct-reset --hard    # Full reset
```

## Best Practices

### Daily Workflow

1. **Start of day:**
   ```bash
   construct-update
   construct-check
   ```

2. **Before new feature:**
   ```bash
   construct-before FeatureName
   construct-new FeatureName
   ```

3. **Before commit:**
   ```bash
   construct-check
   construct-protect
   ```

4. **End of session (or at 90% context):**
   ```bash
   construct-session
   ```

### Team Workflow

1. **After pulling changes:**
   ```bash
   construct-update
   construct-scan
   ```

2. **Before PR:**
   ```bash
   construct-check --strict
   construct-protect
   construct-export
   ```

3. **Code review:**
   ```bash
   construct-learn
   construct-check --component ReviewedComponent
   ```

## Environment Variables

Construct respects these environment variables:

- `CONSTRUCT_ROOT`: Override project root detection
- `CONSTRUCT_DEBUG`: Enable debug output
- `CONSTRUCT_SKIP_HOOKS`: Disable git hooks temporarily
- `CONSTRUCT_AI_PLATFORM`: Default AI platform for export

## Getting Help

### Built-in Help

```bash
construct-help              # General help
construct-check --help      # Command-specific help
```

### Documentation

- Run `construct-docs` to open documentation
- Check `docs/` directory in project
- Visit [construct.dev](https://construct.dev)

### Common Issues

**"Command not found"**
- Run `source ~/.zshrc` or restart terminal

**"Permission denied"**
- Check script permissions: `chmod +x Template/AI/scripts/*.sh`

**"No such file or directory"**
- Run from project root or use `construct-cd`

## Command Aliases

For even shorter commands, add to your shell:

```bash
alias cu='construct-update'
alias cc='construct-check'
alias cb='construct-before'
alias cn='construct-new'
alias cs='construct-session'
```

**Trust The Process.**