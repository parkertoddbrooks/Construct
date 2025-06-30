# CONSTRUCT Commands

All commands are run from the `USER-project-files/` directory.

## Daily Development Commands

### Update AI Context
```bash
./AI/scripts/update-context.sh
```
**What it does**: Updates your `CLAUDE.md` file with current project state  
**When to use**: Start of each session, before working with AI  
**Result**: AI knows your current components, violations, and patterns

### Check Architecture
```bash
./AI/scripts/check-architecture.sh
```
**What it does**: Validates your Swift code follows MVVM patterns  
**When to use**: After making changes, before committing  
**Result**: Reports violations and suggests fixes

### Pre-Coding Guidance
```bash
./AI/scripts/before_coding.sh LoginView
```
**What it does**: Shows existing components before you create new ones  
**When to use**: Before creating any new component  
**Result**: Prevents duplicates, suggests reusable patterns

## Session Management

### Session Summary
```bash
./AI/scripts/session-summary.sh
```
**What it does**: Creates context summary when AI context gets full  
**When to use**: When AI warns context is at 90%  
**Result**: Preserves work for next session

### Architecture Documentation
```bash
./AI/scripts/update-architecture.sh
```
**What it does**: Updates detailed architecture documentation  
**When to use**: After major structural changes  
**Result**: Keeps architecture docs current

## Quality Checks

### Quality Gates
```bash
./AI/scripts/check-quality.sh
```
**What it does**: Runs comprehensive quality checks  
**When to use**: Before committing code  
**Result**: Ensures professional quality standards

### MVVM Structure Scan
```bash
./AI/scripts/scan_mvvm_structure.sh
```
**What it does**: Documents current MVVM component organization  
**When to use**: After adding new features  
**Result**: Creates architectural snapshot

### Accessibility Check
```bash
./AI/scripts/check-accessibility.sh
```
**What it does**: Validates accessibility compliance  
**When to use**: After UI changes  
**Result**: Ensures professional accessibility standards

## Setup and Configuration

### Setup Aliases
```bash
./AI/scripts/setup-aliases.sh
```
**What it does**: Installs shell aliases for faster commands  
**When to use**: First time setup, or if aliases break  
**Result**: Can use `construct-update` instead of long paths

## Typical Workflows

### Starting a New Feature
```bash
./AI/scripts/update-context.sh           # Refresh AI context
./AI/scripts/before_coding.sh LoginView  # Check what exists
# Create your feature with AI assistance
./AI/scripts/check-architecture.sh       # Validate patterns
```

### Daily Development Session
```bash
./AI/scripts/update-context.sh      # Start with current state
# Do your development work
./AI/scripts/check-quality.sh       # Validate before committing
```

### When AI Context Gets Full
```bash
./AI/scripts/session-summary.sh     # Preserve context
# Start new AI session
./AI/scripts/update-context.sh      # Load fresh context
```

### Before Major Commits
```bash
./AI/scripts/check-architecture.sh  # Validate patterns
./AI/scripts/check-quality.sh       # Quality gates
./AI/scripts/check-accessibility.sh # Accessibility compliance
```

## Command Aliases

After running `setup-aliases.sh`, you can use these shortcuts:

```bash
construct-update     # ./AI/scripts/update-context.sh
construct-check      # ./AI/scripts/check-architecture.sh
construct-before     # ./AI/scripts/before_coding.sh
construct-quality    # ./AI/scripts/check-quality.sh
construct-scan       # ./AI/scripts/scan_mvvm_structure.sh
construct-session    # ./AI/scripts/session-summary.sh
construct-access     # ./AI/scripts/check-accessibility.sh
```

## Exit Codes

All scripts follow standard exit codes:
- **0**: Success, no issues found
- **1**: Warnings found, review recommended  
- **2**: Errors found, action required

## Getting Help

### Command Help
Most scripts show usage when run without arguments:
```bash
./AI/scripts/before_coding.sh  # Shows usage examples
```

### Troubleshooting
If commands fail:
1. Check you're in `USER-project-files/` directory
2. Ensure scripts are executable: `chmod +x AI/scripts/*.sh`
3. Update context: `./AI/scripts/update-context.sh`

### Script Locations
All development scripts are in: `USER-project-files/AI/scripts/`  
All utility scripts are in: `USER-project-files/scripts/`