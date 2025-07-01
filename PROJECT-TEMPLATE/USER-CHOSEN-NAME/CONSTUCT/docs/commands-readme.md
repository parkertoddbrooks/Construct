# CONSTRUCT Commands

All commands are run from your project directory (e.g., `MyRunningApp/`).

## Daily Development Commands

### Update AI Context
```bash
./AI/scripts/update-context.sh
```
**What it does**: Updates your `CLAUDE.md` file with current project state using dynamic detection  
**When to use**: Start of each session, before working with AI  
**Result**: AI knows your current components, violations, and patterns
**New**: Now automatically detects your project name and Xcode structure

### Check Architecture
```bash
./AI/scripts/check-architecture.sh
```
**What it does**: Validates your Swift code follows MVVM patterns  
**When to use**: After making changes, before committing  
**Result**: Reports violations and suggests fixes
**New**: Uses dynamic project detection - works with any project name

### Pre-Coding Guidance
```bash
./AI/scripts/before_coding.sh LoginView
```
**What it does**: Shows existing components before you create new ones  
**When to use**: Before creating any new component  
**Result**: Prevents duplicates, suggests reusable patterns
**New**: Automatically finds components using dynamic project detection

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
**What it does**: Runs comprehensive quality checks with automated reporting  
**When to use**: Before committing code  
**Result**: Ensures professional quality standards
**New**: Generates timestamped quality reports automatically

### MVVM Structure Scan
```bash
./AI/scripts/scan_mvvm_structure.sh
```
**What it does**: Documents current MVVM component organization  
**When to use**: After adding new features  
**Result**: Creates architectural snapshot
**New**: Uses dynamic detection to analyze your specific project structure

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
**New**: Aliases now use dynamic detection for project navigation

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
1. Check you're in your project root directory (e.g., `MyRunningApp/`)
2. Ensure scripts are executable: `chmod +x AI/scripts/*.sh`
3. Verify project structure: `ls -la` should show `CLAUDE.md`, `AI/`, and `{YourProjectName}-Project/`
4. Update context: `./AI/scripts/update-context.sh`
5. Test detection: `source AI/lib/project-detection.sh && verify_project_structure`

### Script Locations
All development scripts are in: `AI/scripts/`  
Project detection library: `AI/lib/project-detection.sh`

## New Features (Dynamic Detection)

### Automatic Project Detection
All scripts now automatically detect:
- **Your project name**: From your directory structure
- **Xcode project location**: `{YourProjectName}-Project/`
- **iOS app source**: `{YourProjectName}-Project/iOS-App/`
- **Watch app source**: `{YourProjectName}-Project/Watch-App/`

### No More Hardcoded Paths
- Scripts work with **any project name** you choose
- No more editing configuration files
- Works immediately after `construct-setup`

### Example Project Structure
```
MyRunningApp/                           # Your chosen name
├── CLAUDE.md                          # AI context
├── AI/
│   ├── scripts/                       # All commands
│   └── lib/project-detection.sh       # Detection library
└── MyRunningApp-Project/              # Auto-detected
    ├── MyRunningApp.xcodeproj         # Auto-detected
    ├── iOS-App/                       # Auto-detected
    └── Watch-App/                     # Auto-detected
```

### Benefits
- **Just works**: No configuration needed
- **Any project name**: WeatherApp, TaskManager, MyGreatApp
- **Reliable**: Robust detection with error handling
- **Clean**: No hardcoded paths in any scripts