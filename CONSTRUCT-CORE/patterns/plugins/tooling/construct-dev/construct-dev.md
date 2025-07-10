# [CONSTRUCT] CONSTRUCT Development Rules

## When to Use
- When working on files in `CONSTRUCT/**/*.sh`
- When modifying CONSTRUCT scripts, libraries, or configurations
- When contributing to the CONSTRUCT development system itself

## Symlink and Promotion Rules

### ✅ DO: Symlink Management
- Create new version in LAB, test, then promote to CORE
- Maintain symlink integrity - they point to CORE
- Use the promotion workflow for CORE updates
- Update READMEs in CORE, symlinks auto-reflect changes
- Keep AI documentation symlinked for consistency
- Use ./tools/promote-to-core.sh for tested changes
- Use -sym.ext naming only for actual symlinks to CORE
- Check pre-commit validates symlink naming integrity

### ❌ DON'T: Symlink Anti-patterns
- Edit a symlinked file directly
- Replace a symlink with a regular file
- Commit changes to symlinked files
- Edit symlinked READMEs directly in LAB
- Break symlinks by replacing with regular files
- Manually copy files from LAB to CORE
- Create files named *-sym.* that aren't symlinks
- Copy a *-sym file without preserving the link

## Shell/Python Architecture Rules

### ✅ DO: Architecture Best Practices
- Use relative paths and configuration
- set -e and proper error messages
- Shared functions in lib/
- Configuration in config/ directory
- Use get_construct_root() and validation functions
- Function headers with purpose and parameters
- Clear variable scoping and naming (UPPER_CASE for globals)
- Check exit codes and provide feedback
- Colored output with status indicators

### ❌ DON'T: Architecture Anti-patterns
- Hardcoded paths in scripts
- Scripts without error handling
- Duplicate logic across scripts
- Configuration scattered in scripts
- Scripts that assume specific directory structure
- Functions without documentation
- Global variables without UPPER_CASE
- Commands without error checking
- Silent failures

## CONSTRUCT-Specific Rules

### ✅ DO: Template Independence
- Read-only analysis of USER-project-files/
- Test templates work independently
- Scripts that work for template users
- Use PROJECT-TEMPLATE placeholders

### ❌ DON'T: Template Contamination
- Modify USER-project-files/ from CONSTRUCT scripts
- Template changes without testing
- Scripts that only work in development
- Hardcoded USER project names

## Quality Gate Rules

### ✅ DO: Quality Assurance
- Use pre-commit hooks for validation
- Auto-generate and update documentation
- Validate template integrity before changes
- Show full pre-commit output in responses
- Explain what the hooks validated

### ❌ DON'T: Quality Shortcuts
- Commit without running quality checks
- Create files without proper documentation
- Break existing template functionality
- Hide pre-commit hook output from user

## Development Workflow

### Before Writing ANY Code:
```bash
./CONSTRUCT/scripts/before_coding.sh ComponentName    # Shows what exists
./CONSTRUCT/scripts/check-architecture.sh             # Validates patterns
./CONSTRUCT/scripts/update-context.sh                 # Updates this context
```

### When Making Commits:
Always show the full pre-commit output and explain what was validated.

Example response format:
```
I'll commit these changes. Here's the pre-commit hook output:
[SHOW FULL OUTPUT]
The commit was successful! The hooks validated...
```

## Post-Commit Behavior
After commits, you may see deletions of structure files - this is normal cleanup:
- New structure files generated during pre-commit
- Old structure files cleaned up after commit
- Only current files remain, old ones moved to _old/
- These deletions are NOT errors and should NOT be "fixed"

## Integration
This pattern activates when:
- Working on files matching `CONSTRUCT/**/*`
- Editing shell scripts in the CONSTRUCT system
- Contributing to CONSTRUCT development infrastructure