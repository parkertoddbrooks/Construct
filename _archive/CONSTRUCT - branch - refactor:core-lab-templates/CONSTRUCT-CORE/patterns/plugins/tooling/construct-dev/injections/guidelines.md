## CONSTRUCT Development Guidelines

### 🚨 Symlink and Promotion Rules

```bash
❌ NEVER: Edit a symlinked file directly
✅ ALWAYS: Create new version in LAB, test, then promote to CORE

❌ NEVER: Replace a symlink with a regular file
✅ ALWAYS: Maintain symlink integrity - they point to CORE

❌ NEVER: Commit changes to symlinked files
✅ ALWAYS: Use the promotion workflow for CORE updates

❌ NEVER: Edit symlinked READMEs directly in LAB
✅ ALWAYS: Update READMEs in CORE, symlinks auto-reflect changes

❌ NEVER: Break symlinks by replacing with regular files  
✅ ALWAYS: Keep AI documentation symlinked for consistency

❌ NEVER: Manually copy files from LAB to CORE
✅ ALWAYS: Use ./tools/promote-to-core.sh for tested changes

❌ NEVER: Create files named *-sym.* that aren't symlinks
✅ ALWAYS: Use -sym.ext naming only for actual symlinks to CORE

❌ NEVER: Copy a *-sym file without preserving the link
✅ ALWAYS: Check pre-commit validates symlink naming integrity
```

### Shell/Python Architecture Rules

```bash
❌ NEVER: Hardcoded paths in scripts
✅ ALWAYS: Use relative paths and configuration

❌ NEVER: Scripts without error handling
✅ ALWAYS: set -e and proper error messages

❌ NEVER: Duplicate logic across scripts
✅ ALWAYS: Shared functions in lib/

❌ NEVER: Configuration scattered in scripts
✅ ALWAYS: Configuration in config/ directory

❌ NEVER: Scripts that assume specific directory structure
✅ ALWAYS: Use get_construct_root() and validation functions
```

### CONSTRUCT-Specific Rules

```bash
❌ NEVER: Modify USER-project-files/ from CONSTRUCT scripts
✅ ALWAYS: Read-only analysis of USER-project-files/

❌ NEVER: Template changes without testing
✅ ALWAYS: Test templates work independently

❌ NEVER: Scripts that only work in development
✅ ALWAYS: Scripts that work for template users

❌ NEVER: Hardcoded USER project names
✅ ALWAYS: Use PROJECT-TEMPLATE placeholders
```

### Modern Shell Scripting Rules

```bash
❌ NEVER: Functions without documentation
✅ ALWAYS: Function headers with purpose and parameters

❌ NEVER: Global variables without UPPER_CASE
✅ ALWAYS: Clear variable scoping and naming

❌ NEVER: Commands without error checking
✅ ALWAYS: Check exit codes and provide feedback

❌ NEVER: Silent failures
✅ ALWAYS: Colored output with status indicators
```

### Quality Gate Rules

```bash
❌ NEVER: Commit without running quality checks
✅ ALWAYS: Use pre-commit hooks for validation

❌ NEVER: Create files without proper documentation
✅ ALWAYS: Auto-generate and update documentation

❌ NEVER: Break existing template functionality
✅ ALWAYS: Validate template integrity before changes
```

### Development Process

1. **Before Writing ANY Code**:
   ```bash
   ./CONSTRUCT/scripts/core/before_coding.sh ComponentName
   ./CONSTRUCT/scripts/core/check-architecture.sh
   ./CONSTRUCT/scripts/construct/update-context.sh
   ```

2. **When Making Commits**:
   - NEVER hide pre-commit hook output from user
   - ALWAYS show the full pre-commit output
   - ALWAYS explain what the hooks validated

3. **Post-Commit Behavior**:
   - New structure files generated during pre-commit
   - Old structure files cleaned up after commit
   - Only current files remain, old ones moved to _old/
   - These deletions are NOT errors

### Validated Development Discoveries

1. **Dual environments required**: CONSTRUCT development separate from USER templates
2. **Template contamination**: USER-project-files must stay clean of CONSTRUCT-specific code
3. **Configuration-driven validation**: Rules in YAML, not hardcoded in scripts
4. **Auto-documentation essential**: Manual docs get out of sync quickly
5. **Before-coding validation essential**: Prevents duplicate work and violations
6. **Quality gates catch issues early**: Pre-commit hooks prevent drift
7. **Session summaries preserve context**: Large changes need documentation
8. **Template testing required**: Changes must work for both CONSTRUCT and users

### When Manual Updates ARE Acceptable

```bash
# ✅ CORRECT: Manual configuration
# Manual strategic decisions, architectural choices
# User-specific goals and priorities

# ❌ WRONG: Manual status tracking
# File counts, git status, structure analysis
# These should auto-update via scripts
```

### 📚 Authoritative Standards Documents

**Shell Standards**: `AI/docs/automated/development-patterns-automated.md`
- Complete script patterns, error handling, library usage
- Configuration-driven validation, quality gates

**Architecture Overview**: `AI/docs/automated/architecture-overview-automated.md`
- Dual-environment design, component relationships

**Script Reference**: `AI/docs/automated/script-reference-automated.md`
- All available scripts and library functions

### 🗄️ Historical Context (Deprecated but Kept for Reference)

- **Previous single-environment approach** (replaced by dual-environment)
- **Hardcoded path patterns** (replaced by relative path resolution)
- **Manual documentation updates** (replaced by auto-generation)
- **Inline validation** (replaced by configuration-driven rules)