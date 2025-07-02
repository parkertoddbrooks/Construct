# CONSTRUCT Symlink and Promotion Rules

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
   - `_devupdate-prompt.md`
   - `README.md` files for structure
   - Shared templates

2. **Configuration Files**
   - When testing CORE configs in LAB

3. **Scripts** (via CONSTRUCT symlink)
   - All scripts accessed through CONSTRUCT/

## Promotion Workflow

### Making Changes to Symlinked Files

1. **Identify the symlink**
   ```bash
   ls -la filename.md
   # Shows: filename.md -> ../../../../CONSTRUCT-CORE/path/to/file
   ```

2. **Create a new version in LAB**
   ```bash
   # DON'T edit the symlink!
   cp CONSTRUCT-CORE/path/to/file.md new-version.md
   # Edit new-version.md
   ```

3. **Test thoroughly in LAB**
   - Validate changes work
   - Check for regressions
   - Get it perfect

4. **Promote to CORE**
   ```bash
   # Replace the CORE version
   cp new-version.md CONSTRUCT-CORE/path/to/file.md
   # Remove your test version
   rm new-version.md
   # Symlink automatically points to updated file
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

### Promotion Script Pattern
```bash
# promote-to-core.sh should:
1. Verify source file exists and is tested
2. Create backup of current CORE version
3. Copy new version to CORE
4. Update VERSION file
5. Log the promotion
```

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

## Enforcement Strategies

### 1. Pre-commit Hooks
- Detect if symlinks were replaced with files
- Prevent commits that break symlink structure

### 2. Script Protection
- All CONSTRUCT scripts check for symlinks
- Refuse to edit symlinked files
- Provide clear guidance on proper workflow

### 3. Documentation
- Clear warnings in all relevant docs
- Promotion workflow guides
- Examples of correct patterns

## Common Mistakes to Avoid

### ❌ Opening symlink in editor and saving
This edits the CORE file directly!

### ❌ Using `mv` to replace a symlink
This breaks the link structure!

### ❌ Copying over a symlink with `cp`
Use `cp -H` to copy the content, not create a regular file!

### ❌ Forgetting symlinks after git clone
Symlinks must be recreated or verified after cloning!

## The Philosophy

**CORE is sacred** - It contains only stable, tested, promoted code.

**LAB is experimental** - It's where we try things, break things, and learn.

**Symlinks are bridges** - They let LAB use CORE's stability while maintaining separation.

**Promotion is deliberate** - Nothing enters CORE by accident.

---

Remember: If you wouldn't put it in production, don't put it in CORE!