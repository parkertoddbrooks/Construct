# Interactive Scripts Feature

## Overview

CONSTRUCT's interactive script support enables scripts with user prompts to work seamlessly in non-interactive environments like Claude Code, CI/CD pipelines, and automated workflows. This is achieved through a standardized "show prompts" pattern that displays required inputs before execution.

### The Two-UI Philosophy

This feature is designed specifically for the Claude Code + GitHub Desktop workflow:
- **Claude Code**: Command execution and interaction - see what inputs are needed, provide values
- **GitHub Desktop**: Verification layer - review actual changes before committing

### Core Design Principles

1. **Pre-flight Pattern**: Show what will be asked before running
2. **No Custom Slash Commands**: Work within Claude Code's constraints
3. **Consistent Experience**: Every script follows the same pattern
4. **Self-Documenting**: Scripts explain their own requirements
5. **Interactive Rails**: Natural conversation flow with minimal prompts

## How It Works

### The Show Prompts Pattern

Scripts that have user prompts support three modes:

1. **Interactive Mode** (default when run in terminal)
   - Shows prompts and waits for user input
   - Provides helpful options and defaults
   - Traditional CLI experience

2. **Show Prompts Mode** (triggered by `--show-prompts` or `--claude-prompts`)
   - Displays all required inputs
   - Shows available options and defaults
   - Provides example commands
   - Exits without executing
   - `--claude-prompts` provides simplified output for Claude Code

3. **Non-Interactive Mode** (auto-detected or piped input)
   - Accepts pre-filled inputs via stdin
   - Uses defaults for missing values
   - Runs without prompting

### Usage Examples

#### Show What Inputs Are Needed

```bash
# See what create-project.sh will ask for
$ ./create-project.sh TestProject ios --show-prompts

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Script: create-project.sh
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
This script needs the following inputs:

1. Additional plugins (comma-separated)
   Available: languages/swift, mvvm-architecture, cross-platform/model-sync
   Default: tooling/shell-scripting
   
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
To run with defaults:
  echo '' | ./create-project.sh TestProject ios

To run with specific values:
  echo 'languages/swift,mvvm-architecture' | ./create-project.sh TestProject ios
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

#### Run With Pre-filled Answers

```bash
# Run with defaults (empty input)
echo '' | ./create-project.sh TestProject ios

# Run with specific plugins
echo 'languages/swift,mvvm-architecture' | ./create-project.sh TestProject ios

# Multiple inputs (newline separated)
echo -e "y\nn" | ./pre-commit-review.sh
```

## Why This Approach?

### The Challenge

Claude Code's bash tool doesn't support interactive prompts - scripts that use `read` or similar commands will hang waiting for input that never comes. While Claude Code has nice interactive UI for its own commands (like `/config`), there's no way to create custom slash commands.

### The Solution

Instead of fighting these constraints, we embrace them:
1. **Show First**: Display what inputs are needed
2. **User Decides**: User tells Claude what values to use  
3. **Run with Values**: Claude runs script with pre-filled answers
4. **Review Changes**: User verifies in GitHub Desktop

This creates a smooth workflow that respects both tools' strengths.

## Interactive Rails Mode

The Interactive Rails pattern enables natural conversation flow while keeping scripts on predefined paths. Scripts marked with `# INTERACTIVE_MODE: enabled` support this pattern.

### How Rails Mode Works

1. **Follow script structure** - Scripts define the conversation flow
2. **Natural prompts** - Present script prompts conversationally
3. **Smart responses**:
   - Direct answers (ios, yes, default) → Continue script flow
   - Questions (what? how? list options?) → Provide help, then return to flow
4. **Minimal context** - Stay on rails unless user needs help

### Example Rails Flow
```
User: Run pre-commit checks
Claude: All checks passed! Ready to commit. Proceed? [y/n]
User: What does this commit?
Claude: [HELP MODE] This will commit 5 files with your changes to feature X.
Would you like to proceed with the commit? [y/n]
User: y
[Execute: echo 'y' | ./pre-commit-review.sh]
```

## Automatic Detection

Scripts automatically enter "show prompts" mode when:

1. **Claude Code Environment**
   ```bash
   # CLAUDE_CODE environment variable is set
   CLAUDE_CODE=1 ./script.sh
   ```

2. **No TTY Available**
   ```bash
   # Running in CI/CD or piped
   ./script.sh < /dev/null
   ```

3. **Explicit Flag**
   ```bash
   # User requests prompt information
   ./script.sh --show-prompts
   ./script.sh --claude-prompts  # Simplified output
   ./script.sh --dry-run
   ```

## Script Implementation

### For Script Authors

To make your script interactive-friendly:

```bash
#!/bin/bash
# INTERACTIVE_MODE: enabled

# 1. Calculate paths first
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSTRUCT_CORE="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# 2. Source the interactive support library
source "$CONSTRUCT_CORE/CONSTRUCT/lib/interactive-support.sh"

# 3. Define your prompts function
show_my_prompts() {
    # Simplified output for Claude
    if is_claude_prompts_mode "$@"; then
        echo "1. Project type [ios|web|api|fullstack]"
        echo "2. Enable git init? [y/n]"
        return
    fi
    
    echo "1. Project type"
    echo "   Options: [ios|web|api|fullstack]"
    echo "   Default: ios"
    echo ""
    echo "2. Enable git init"
    echo "   Options: [y|n]"
    echo "   Default: y"
}

# 4. Check if should show prompts
if should_show_prompts "$@"; then
    show_script_prompts "$(basename "$0")" show_my_prompts "$@"
    exit 0
fi

# 5. Use get_input_with_default for inputs
PROJECT_TYPE=$(get_input_with_default "Project type [ios|web|api|fullstack]" "ios")
ENABLE_GIT=$(yes_no_prompt "Initialize git repository?" "y")

# Rest of script implementation...
```

### Library Functions

The `interactive-support.sh` library provides:

| Function | Purpose | Usage |
|----------|---------|-------|
| `should_show_prompts` | Detect if prompts should be shown | `if should_show_prompts "$@"; then` |
| `show_script_prompts` | Display standardized prompt format | `show_script_prompts "script.sh" show_my_prompts "$@"` |
| `get_input_with_default` | Get input with fallback | `VAR=$(get_input_with_default "Prompt" "default")` |
| `yes_no_prompt` | Get yes/no answer with default | `ANS=$(yes_no_prompt "Continue?" "y")` |
| `is_interactive` | Check if running interactively | `if is_interactive; then` |
| `is_claude_prompts_mode` | Check for simplified Claude output | `if is_claude_prompts_mode "$@"; then` |

## Supported Scripts

The following scripts have interactive prompts and support the show prompts pattern:

### Workspace Management
- `create-project.sh` - Create new projects with type and plugin selection

### Core Tools
- `construct-patterns.sh` - Regenerate CLAUDE.md with confirmation prompt

### Development Tools  
- `setup-aliases.sh` - Update shell aliases with confirmation
- `pre-commit-review.sh` - Run pre-commit checks with commit confirmation

Note: Most other scripts work with command-line arguments only and don't require interactive support. Scripts like `import-project.sh`, `generate-devupdate.sh`, and `session-summary.sh` run without prompts.

### Repository Context

All log-generating scripts (both interactive and non-interactive) now include repository context at the top of their output, showing:
- Repository name
- Remote URL (if available)
- Current branch

This helps identify which project the logs belong to when working with multiple repositories. See [Repository Context](repository-context.md) for details.

## Practical Workflow Example

Here's how it works in practice with Claude Code:

```bash
# 1. Claude runs with --show-prompts
$ ./create-project.sh MyApp ios --show-prompts

# Output shows:
# 1. Additional plugins (comma-separated)
#    Available: languages/swift, mvvm-architecture
#    Default: tooling/shell-scripting

# 2. User tells Claude: "Use languages/swift and mvvm-architecture"

# 3. Claude runs:
$ echo 'languages/swift,mvvm-architecture' | ./create-project.sh MyApp ios

# 4. User switches to GitHub Desktop:
# - Sees new MyApp/ directory created
# - Reviews .construct/patterns.yaml content
# - Checks AI/ structure was copied correctly
# - Commits if everything looks good
```

## Best Practices

### For Claude Code Users

1. **Always run with `--show-prompts` first**
   ```bash
   ./any-script.sh --show-prompts
   ```

2. **Review in GitHub Desktop before committing**
   - See what files were created/modified
   - Verify changes match expectations
   - Commit when satisfied

3. **Use meaningful inputs**
   ```bash
   # Good: Specific plugins for your project
   echo 'languages/swift,mvvm-architecture' | ./create-project.sh MyApp ios
   
   # Avoid: Empty inputs without understanding defaults
   echo '' | ./create-project.sh MyApp ios
   ```

### For Script Authors

1. **Keep prompts simple and clear**
   - One input per line
   - Show available options
   - Always provide defaults

2. **Validate inputs properly**
   ```bash
   PROJECT_TYPE=$(get_input_with_default "Type [ios|web|api]" "ios")
   if [[ ! "$PROJECT_TYPE" =~ ^(ios|web|api)$ ]]; then
       echo "Invalid project type: $PROJECT_TYPE"
       exit 1
   fi
   ```

3. **Provide helpful examples**
   ```bash
   show_my_prompts() {
       echo "1. Plugins to enable"
       echo "   Format: comma-separated list"
       echo "   Example: languages/swift,mvvm-architecture"
       echo "   Available: $(list_available_plugins)"
       echo "   Default: tooling/shell-scripting"
   }
   ```

## Troubleshooting

### Script Hangs in Claude Code

**Problem**: Script waits for input that never comes

**Solution**: Run with `--show-prompts` first:
```bash
./script.sh --show-prompts
# Then run with piped input
echo 'answer' | ./script.sh
```

### Can't See Available Options

**Problem**: Don't know what values are valid

**Solution**: The `--show-prompts` output lists all options:
```bash
$ ./create-project.sh --show-prompts
# Shows: Options: [ios|web|api|fullstack]
```

### Want to Use All Defaults

**Problem**: Just want to accept all defaults

**Solution**: Pipe empty input:
```bash
echo '' | ./script.sh
# Or for multiple prompts
yes '' | ./script.sh
```

## Environment Variables

Scripts respect these environment variables:

| Variable | Purpose | Example |
|----------|---------|---------|
| `CLAUDE_CODE` | Force non-interactive mode | `CLAUDE_CODE=1 ./script.sh` |
| `CONSTRUCT_INTERACTIVE` | Force interactive mode | `CONSTRUCT_INTERACTIVE=1 ./script.sh` |
| `CONSTRUCT_PROMPTS_FORMAT` | Output format (future) | `CONSTRUCT_PROMPTS_FORMAT=json` |

## Future Enhancements

### Planned Features

1. **JSON Output Format**
   ```bash
   ./script.sh --show-prompts --json
   # {"prompts": [{"name": "type", "options": ["ios", "web"], "default": "ios"}]}
   ```

2. **Config File Support**
   ```bash
   ./script.sh --config project.yaml
   # Reads all inputs from config file
   ```

3. **Batch Operations**
   ```bash
   ./create-projects.sh --batch projects.txt
   # Creates multiple projects from file
   ```

4. **Smart Defaults**
   ```bash
   # Detects you're in a Swift project
   # Automatically suggests Swift-related patterns
   ```

## Related Documentation

- [Repository Context](repository-context.md) - How scripts include repository information in logs
- [Script Reference](../../CONSTRUCT-LAB/AI/docs/automated/script-reference-automated.md) - Auto-generated script documentation
- [Development Patterns](../../CONSTRUCT-LAB/AI/docs/automated/development-patterns-automated.md) - CONSTRUCT development standards