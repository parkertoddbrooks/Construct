# CONSTRUCT Commands Reference

All commands are run from your CONSTRUCT development directory (`CONSTRUCT-dev/`).

## Core Development Commands

### Update AI Context
```bash
./CONSTRUCT/scripts/update-context.sh
```
**What it does**: Updates your `CLAUDE.md` file with current development state  
**When to use**: Start of each session, before working with AI  
**Result**: AI knows your current components, violations, and patterns  
**Auto-runs**: During git pre-commit hook  
**Creates**: Updates CLAUDE.md with auto-generated sections

### Check Architecture
```bash
./CONSTRUCT/scripts/check-architecture.sh
```
**What it does**: Validates CONSTRUCT development patterns and template integrity  
**When to use**: After making changes, before committing  
**Result**: Reports architecture violations and template validation status  
**Auto-runs**: During git pre-commit hook  
**Validates**: Shell script organization, library usage, template structure

### Pre-Coding Guidance  
```bash
./CONSTRUCT/scripts/before_coding.sh [function_name]
```
**What it does**: Shows existing components before you create new ones  
**When to use**: Before creating any new function or component  
**Result**: Prevents duplicates, suggests reusable patterns  
**Searches**: Existing shell functions, library components, configuration patterns

### Quality Gates
```bash
./CONSTRUCT/scripts/check-quality.sh
```
**What it does**: Runs comprehensive quality checks with automated reporting  
**When to use**: Before committing code  
**Result**: Ensures professional development standards  
**Auto-runs**: During git pre-commit hook  
**Creates**: Timestamped quality reports in `/AI/dev-logs/check-quality/`

### Structure Analysis
```bash
./CONSTRUCT/scripts/scan_construct_structure.sh
```
**What it does**: Documents current CONSTRUCT development structure  
**When to use**: After adding new scripts or changing organization  
**Result**: Creates comprehensive architectural snapshot  
**Auto-runs**: During git pre-commit hook  
**Creates**: Timestamped structure reports in `/AI/structure/`

### Architecture Documentation
```bash
./CONSTRUCT/scripts/update-architecture.sh
```
**What it does**: Updates detailed architecture documentation  
**When to use**: After major structural changes  
**Result**: Keeps architecture docs current with implementation  
**Auto-runs**: During git pre-commit hook  
**Updates**: All documentation in `/AI/docs/automated/` directory

### Documentation Check
```bash
./CONSTRUCT/scripts/check-documentation.sh
```
**What it does**: Validates documentation completeness and accuracy  
**When to use**: Before major releases or when updating docs  
**Result**: Ensures documentation quality and coverage  
**Auto-runs**: During git pre-commit hook  
**Checks**: API documentation, script references, file integrity

## Session Management

### Session Summary
```bash
./CONSTRUCT/scripts/session-summary.sh
```
**What it does**: Creates context summary when AI context gets full  
**When to use**: When AI warns context is at 90%  
**Result**: Preserves work for next session  
**Creates**: Session state files in `/AI/dev-logs/session-states/`

### Setup Aliases
```bash
./CONSTRUCT/scripts/setup-aliases.sh
```
**What it does**: Installs shell aliases for faster CONSTRUCT commands  
**When to use**: First time setup, or if aliases break  
**Result**: Can use `construct-update` instead of long paths  
**Configures**: Shell aliases for all CONSTRUCT development commands

## Automated Workflow Integration

### Pre-Commit Hook (Automatic)
Every `git commit` automatically runs:
```bash
./CONSTRUCT/scripts/update-context.sh          # Updates CLAUDE.md
./CONSTRUCT/scripts/check-architecture.sh      # Validates patterns
./CONSTRUCT/scripts/update-architecture.sh     # Updates docs
./CONSTRUCT/scripts/check-quality.sh           # Quality checks
./CONSTRUCT/scripts/scan_construct_structure.sh # Structure analysis
./CONSTRUCT/scripts/check-documentation.sh     # Documentation validation
```
**Result**: Documentation and quality stay synchronized automatically

## Manual Workflows

### Starting Development Session
```bash
./CONSTRUCT/scripts/update-context.sh      # Refresh AI context
./CONSTRUCT/scripts/before_coding.sh func  # Check existing functions
# Do your development work
git commit                                 # Automatic quality checks
```

### Adding New Features
```bash
./CONSTRUCT/scripts/before_coding.sh feature_name  # Check what exists
# Create your feature/script/function
./CONSTRUCT/scripts/check-architecture.sh          # Manual validation (optional)
git commit                                         # Automatic validation
```

### When AI Context Gets Full
```bash
./CONSTRUCT/scripts/session-summary.sh     # Preserve context
# Start new AI session with fresh context
./CONSTRUCT/scripts/update-context.sh      # Load fresh context
```

### Manual Quality Check (Optional)
```bash
./CONSTRUCT/scripts/check-architecture.sh  # Architecture validation
./CONSTRUCT/scripts/check-quality.sh       # Quality analysis
./CONSTRUCT/scripts/check-documentation.sh # Documentation check
```
**Note**: These run automatically on commit, manual execution is optional

## Command Aliases

After running `setup-aliases.sh`, you can use these shortcuts:

```bash
construct-update     # ./CONSTRUCT/scripts/update-context.sh
construct-check      # ./CONSTRUCT/scripts/check-architecture.sh
construct-before     # ./CONSTRUCT/scripts/before_coding.sh
construct-quality    # ./CONSTRUCT/scripts/check-quality.sh
construct-scan       # ./CONSTRUCT/scripts/scan_construct_structure.sh
construct-session    # ./CONSTRUCT/scripts/session-summary.sh
construct-docs       # ./CONSTRUCT/scripts/update-architecture.sh
construct-doc-check  # ./CONSTRUCT/scripts/check-documentation.sh
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
./CONSTRUCT/scripts/before_coding.sh  # Shows usage examples
```

### Troubleshooting
If commands fail:
1. Check you're in CONSTRUCT development directory (`CONSTRUCT-dev/`)
2. Ensure scripts are executable: `chmod +x CONSTRUCT/scripts/*.sh`
3. Verify structure: `ls -la` should show `CLAUDE.md`, `CONSTRUCT/`, and `PROJECT-TEMPLATE/`
4. Update context: `./CONSTRUCT/scripts/update-context.sh`
5. Check library functions: `ls CONSTRUCT/lib/`

### Script Locations
All development scripts are in: `CONSTRUCT/scripts/`  
Library functions are in: `CONSTRUCT/lib/`  
Configuration files are in: `CONSTRUCT/config/`

## File Management and Automation

### Auto-Generated Files
CONSTRUCT automatically creates and manages:
- **Quality Reports**: Timestamped in `/AI/dev-logs/check-quality/`
- **Structure Analysis**: Timestamped in `/AI/structure/`
- **Session States**: Saved in `/AI/dev-logs/session-states/`
- **Architecture Documentation**: Updated in `/AI/docs/automated/` directory
- **Backups**: Created before any file updates

### File Naming Conventions
- **Date Format**: `YYYY-MM-DD`
- **Time Format**: `HH-MM-SS`
- **Example**: `quality-report-2025-06-30--15-35-12.md`
- **Backups**: `original-file.backup-YYYYMMDD-HHMMSS`

### CONSTRUCT Development Structure
```
CONSTRUCT-dev/                          # Development environment
├── CLAUDE.md                          # AI context (auto-updated)
├── CONSTRUCT/
│   ├── scripts/                       # All commands
│   ├── lib/                          # Reusable functions
│   ├── config/                       # Configuration files
│   └── docs/                         # Human documentation
├── AI/
│   ├── docs/
│   │   └── automated/               # Auto-generated architecture docs
│   ├── dev-logs/                     # Auto-generated reports
│   └── structure/                    # Structure analysis
└── PROJECT-TEMPLATE/                 # Clean template for users
    └── {Project}Template.xcodeproj   # Template Xcode project
```

### Benefits of Current System
- **Fully Automated**: Pre-commit hooks run all quality checks
- **Always Current**: Documentation updates automatically
- **Quality Assured**: Continuous validation and reporting
- **Version Tracked**: Historical analysis with timestamped files
- **Error Prevention**: Architecture violations caught before commit