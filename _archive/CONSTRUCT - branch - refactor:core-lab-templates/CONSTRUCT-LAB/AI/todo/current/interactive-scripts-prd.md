# PRD: Interactive Script Support for Claude Code

## Overview

CONSTRUCT scripts need to work seamlessly in Claude Code, which doesn't support interactive prompts. This PRD defines a standard pattern for all CONSTRUCT scripts to show their required inputs upfront, allowing users to review prompts in Claude Code and then run with pre-filled answers.

## Problem Statement

Current issues:
1. Interactive scripts hang in Claude Code waiting for input
2. Users can't see what inputs are required before running
3. No consistent pattern across scripts for handling non-interactive environments
4. GitHub Desktop workflow requires knowing what will change before execution

## Goals

### Primary Goals
- Enable all CONSTRUCT scripts to work in Claude Code
- Provide consistent UX across all interactive scripts
- Show required inputs before execution
- Support the Claude Code + GitHub Desktop workflow

### Non-Goals
- Creating custom slash commands (not supported by Claude Code)
- Building GUI interfaces
- Changing existing script functionality

## Solution

### The "Show Prompts" Pattern

Every interactive script will support a `--show-prompts` flag that:
1. Shows what inputs the script requires
2. Displays available options and defaults
3. Provides example commands for running with pre-filled answers
4. Exits without executing any changes

### Shared Library System

Create `lib/interactive-support.sh` that provides:
- Environment detection (Claude Code, TTY, etc.)
- Standardized prompt display formatting
- Common input handling functions
- Consistent help text generation

## User Experience

### Workflow in Claude Code

```bash
# User runs script with --show-prompts
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

# User tells Claude what values to use
# Claude runs with those values
$ echo 'languages/swift,mvvm-architecture' | ./create-project.sh TestProject ios

# User reviews changes in GitHub Desktop
```

### Automatic Detection

Scripts automatically show prompts when:
- `CLAUDE_CODE` environment variable is set
- No TTY is detected
- `--show-prompts` or `--dry-run` is passed

## Technical Implementation

### Phase 1: Core Library (Day 1)
1. Create `lib/interactive-support.sh`
2. Implement detection functions
3. Create display formatting functions
4. Add input validation helpers

### Phase 2: Update Priority Scripts (Day 2)
1. `create-project.sh` - Project creation
2. `import-project.sh` - Project importing
3. `workspace-update.sh` - Workspace operations
4. `construct-patterns.sh` - Pattern management

### Phase 3: Update All Scripts (Day 3-4)
1. Update remaining scripts
2. Add tests for interactive support
3. Update documentation
4. Create migration guide

## Success Metrics

1. **All scripts work in Claude Code** - 100% compatibility
2. **Consistent UX** - Same pattern across all scripts
3. **Clear documentation** - Every script self-documents
4. **No breaking changes** - Existing usage still works

## API Design

### Library Functions

```bash
# Check if should show prompts instead of running
should_show_prompts() -> boolean

# Display standardized prompt format
show_script_prompts(script_name, prompt_function)

# Get input with fallback for non-interactive
get_input_with_default(prompt, default) -> string

# Select from options with fallback
select_with_default(prompt, options[], default) -> string
```

### Script Pattern

```bash
#!/bin/bash
source "$CONSTRUCT_CORE/CONSTRUCT/lib/interactive-support.sh"

# Define what prompts this script needs
show_my_prompts() {
    echo "1. Input description"
    echo "   Options: [...]" 
    echo "   Default: ..."
}

# Check if should show prompts
if should_show_prompts "$@"; then
    show_script_prompts "$(basename "$0")" show_my_prompts
    exit 0
fi

# Regular script execution
```

## Rollout Plan

1. **Week 1**: Implement core library and update critical scripts
2. **Week 2**: Update all remaining scripts
3. **Week 3**: Testing and documentation
4. **Week 4**: Release and communication

## Dependencies

- No external dependencies
- Uses only POSIX shell features
- Compatible with bash 3.2+ (macOS default)

## Risks and Mitigations

### Risk: Scripts become more complex
**Mitigation**: Shared library hides complexity, scripts just declare prompts

### Risk: Inconsistent implementation
**Mitigation**: Clear specification, code reviews, shared library enforces patterns

### Risk: Breaking existing workflows
**Mitigation**: All changes are additive, existing usage unchanged

## Future Enhancements

1. **JSON output mode** for programmatic parsing
2. **Config file support** to skip prompts entirely
3. **Batch mode** for running multiple operations
4. **Integration with CONSTRUCT patterns** for smart defaults

## Conclusion

This interactive script support system will make CONSTRUCT fully compatible with Claude Code while maintaining a superior developer experience. The standardized approach ensures consistency and reduces maintenance burden.