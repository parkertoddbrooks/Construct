# CONSTRUCT Symlink and Promotion Rules

## 🚀 Quick Reference

**Check symlinks:** `./CONSTRUCT/scripts/check-symlinks.sh`  
**View in CLAUDE.md:** Look for `ACTIVE-SYMLINKS` section  
**Promote symlinked file:** Add to `PROMOTE-TO-CORE.yaml` with `type: symlinked-file`  
**Run promotion:** `./tools/promote-to-core.sh`  

## 🚨 CRITICAL RULES - NEVER VIOLATE

### Symlink Immutability
```bash
❌ NEVER: Edit a symlinked file directly
✅ ALWAYS: Create a new version for changes

❌ NEVER: Replace a symlink with a regular file
✅ ALWAYS: Use the promotion system

❌ NEVER: Delete symlinks without updating references
✅ ALWAYS: Maintain symlink integrity
```

### The Golden Rule
**If it's a symlink, it's READ-ONLY in LAB**

## Symlink Architecture

### Direction of Trust
```
CONSTRUCT-CORE (source of truth)
     ↑
     | symlinks point up
     |
CONSTRUCT-LAB (development workspace)
```

### What Gets Symlinked
1. **Shared Documentation**
   - `devupdate-prompt-sym.md` (points to `_devupdate-prompt.md` in CORE)
   - `README-sym.md` files for structure
   - Shared templates

2. **Configuration Files**
   - When testing CORE configs in LAB

3. **Scripts** (via CONSTRUCT symlink)
   - All scripts accessed through CONSTRUCT/

## Promotion Workflow

### Automated Symlink Management

CONSTRUCT uses an automated system to manage symlinks and promotions:

1. **Check current symlinks**
   ```bash
   # View all managed symlinks
   ./CONSTRUCT/scripts/check-symlinks.sh
   
   # Symlinks are also listed in CLAUDE.md (auto-updated)
   cat CONSTRUCT-LAB/CLAUDE.md | grep -A20 "Active Symlinks"
   ```

2. **Create new version in LAB**
   ```bash
   # For existing symlinked file
   cp filename.md filename-new.md
   # Edit filename-new.md (NOT the symlink!)
   ```

3. **Test thoroughly in LAB**
   - Validate changes work
   - Check for regressions
   - Ensure quality standards met

4. **Promote using automated system**
   ```yaml
   # Add to CONSTRUCT-LAB/PROMOTE-TO-CORE.yaml
   - type: symlinked-file
     source: AI/docs/filename-new.md
     dest: CONSTRUCT-CORE/AI/docs/filename.md
     description: "Updated shared documentation"
     bump_version: patch
   ```

5. **Run promotion**
   ```bash
   ./tools/promote-to-core.sh
   # This automatically:
   # - Copies file to CORE
   # - Replaces LAB file with symlink
   # - Updates check-symlinks.sh
   # - Updates CLAUDE.md via update-context.sh
   ```

## Implementation in Scripts

### Check for Symlinks Before Editing
```bash
# Add to edit/write operations
if [ -L "$file_path" ]; then
    echo "❌ ERROR: Cannot edit symlinked file: $file_path"
    echo "   This file is managed by CONSTRUCT-CORE"
    echo "   To make changes:"
    echo "   1. Create a new version in LAB"
    echo "   2. Test your changes"
    echo "   3. Promote to CORE using promotion system"
    exit 1
fi
```

### How the Automated System Works

1. **check-symlinks.sh**
   - Maintains `EXPECTED_SYMLINKS` array as single source of truth
   - Validates all symlinks are intact
   - Provides `--list-markdown` for documentation
   - Called by pre-commit hooks

2. **promote-to-core.sh**
   - Processes `PROMOTE-TO-CORE.yaml` manifest
   - Handles `type: symlinked-file` specially:
     - Copies file to CORE
     - Removes LAB file
     - Creates symlink in its place
     - Updates check-symlinks.sh automatically
   - Handles version bumping and logging

3. **update-context.sh**
   - Calls `check-symlinks.sh --list-markdown`
   - Updates CLAUDE.md with current symlink list
   - Ensures AI always knows which files are symlinked

### Adding New Symlinked Files

To add a file that should be shared between CORE and LAB:

```yaml
# In PROMOTE-TO-CORE.yaml
- type: symlinked-file
  source: path/to/new-file.md
  dest: CONSTRUCT-CORE/path/to/new-file.md
  description: "New shared file that LAB will reference"
  bump_version: minor
```

The promotion script will:
1. Copy the file to CORE
2. Replace the LAB file with a symlink
3. Add the symlink to check-symlinks.sh
4. Update documentation automatically

## Visual Indicators

### In File Listings
- Symlinks should be visually distinct
- Use `ls -la` to always show symlink targets
- Consider color coding in scripts

### In Documentation
Mark symlinked content clearly:
```markdown
<!-- SYMLINKED FROM CONSTRUCT-CORE - DO NOT EDIT -->
<!-- To modify: create new version in LAB and promote -->
```

## Current Symlinks

The following files are currently symlinked from LAB to CORE:
- `CONSTRUCT/` - Main tools directory  
- `AI/dev-logs/dev-updates/devupdate-prompt-sym.md` - Dev update template
- `AI/dev-logs/check-quality/README-sym.md` - Quality check documentation
- `AI/dev-logs/dev-updates/README-sym.md` - Dev updates documentation
- `AI/docs/README-sym.md` - AI documentation overview

**Note**: Files use `-sym.ext` naming convention for GUI clarity while maintaining actual symlinks for terminal visibility.

### Hybrid Symlink Naming Convention

CONSTRUCT uses a hybrid approach that provides clarity in both terminal and GUI environments:

**Terminal Environment**: Symlinks show arrows (`->`) in `ls -la` output
**GUI Environment**: Symlinks appear identical to regular files in VS Code, Finder, etc.

**Solution**: Use `-sym.ext` naming pattern for symlinked files:
- `README-sym.md` → actual symlink pointing to `CORE/README.md`  
- `devupdate-prompt-sym.md` → actual symlink pointing to `CORE/_devupdate-prompt.md`

**Benefits**:
- **Self-documenting**: Filename clearly indicates symlink status
- **Cross-platform clarity**: Works in both terminal and GUI
- **Orphan protection**: Pre-commit validation prevents fake `-sym` files
- **Alan Cox compliant**: "If you don't know, it isn't right" - the name tells you

To see the current list:
```bash
./CONSTRUCT/scripts/check-symlinks.sh
# OR check CLAUDE.md's ACTIVE-SYMLINKS section
```

## Enforcement Strategies

### 1. Automated Enforcement
- **check-symlinks.sh** validates integrity on every commit
- **update-context.sh** keeps CLAUDE.md current
- **promote-to-core.sh** handles all symlink creation

### 2. Pre-commit Hooks
- Run `check-symlinks.sh` automatically
- Detect if symlinks were replaced with files
- Update documentation before every commit

### 3. Script Protection
- All CONSTRUCT scripts check for symlinks before editing
- Clear error messages with workflow guidance
- Symlink status visible in CLAUDE.md

### 4. Self-Maintaining Documentation
- CLAUDE.md auto-updates with symlink list
- Promotion examples in PROMOTE-TO-CORE.yaml
- This guide explains the complete system

## Common Mistakes to Avoid

### ❌ Opening symlink in editor and saving
This edits the CORE file directly!

### ❌ Using `mv` to replace a symlink
This breaks the link structure!

### ❌ Copying over a symlink with `cp`
Use `cp -H` to copy the content, not create a regular file!

### ❌ Creating files named *-sym.* that aren't symlinks
The `-sym` naming convention is reserved for actual symlinks only!

### ❌ Copying a *-sym file without preserving the link
This creates orphan files that lie about being symlinks!

### ❌ Forgetting symlinks after git clone
Symlinks must be recreated or verified after cloning!

## The Philosophy

**CORE is sacred** - It contains only stable, tested, promoted code.

**LAB is experimental** - It's where we try things, break things, and learn.

**Symlinks are bridges** - They let LAB use CORE's stability while maintaining separation.

**Promotion is deliberate** - Nothing enters CORE by accident.

---

Remember: If you wouldn't put it in production, don't put it in CORE!