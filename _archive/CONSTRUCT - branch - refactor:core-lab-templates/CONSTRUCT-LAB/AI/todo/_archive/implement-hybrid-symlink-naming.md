# Implement Hybrid Symlink Naming Convention

## Overview
Implement a hybrid approach for symlink clarity that works in both terminal and GUI environments, combining standard symlink arrows with self-documenting filename conventions.

## Problem Statement
Current symlinks are unclear in GUI environments (VS Code, Finder, etc.) where symlink arrows don't show. Users can't easily distinguish between symlinked files (shared with CORE) and independent files (LAB-only).

## Solution: Hybrid Approach

### Naming Convention
- **Symlinked files**: Use `-sym.ext` pattern (e.g., `README-sym.md`)
- **Independent files**: Use normal naming (e.g., `README.md`)
- **Maintain standard symlinks**: `README-sym.md -> ../../CORE/README.md`

### Benefits
- **Terminal clarity**: Arrows show symlink status (`ls -la`)
- **GUI clarity**: Filenames indicate symlink status
- **Universal understanding**: Works in any interface
- **Tool compatibility**: Can detect by pattern OR `find -type l`

## Implementation Tasks

### 1. Update Existing Symlinks
```bash
# Rename current symlinks to use -sym pattern
mv AI/dev-logs/check-quality/README.md AI/dev-logs/check-quality/README-sym.md
mv AI/dev-logs/dev-updates/README.md AI/dev-logs/dev-updates/README-sym.md  
mv AI/dev-logs/dev-updates/_devupdate-prompt.md AI/dev-logs/dev-updates/devupdate-prompt-sym.md
mv AI/docs/README.md AI/docs/README-sym.md

# Update symlink targets if needed
ln -sf ../../../../CONSTRUCT-CORE/AI/dev-logs/check-quality/README.md AI/dev-logs/check-quality/README-sym.md
# etc.
```

### 2. Update check-symlinks.sh
- Modify expected symlink paths to use `-sym.ext` pattern
- Update validation logic to expect new naming convention
- Update documentation generation to reflect new pattern

### 3. Add Pre-commit Validation
Create new validation function in pre-commit hook:

```bash
validate_symlink_naming() {
    local violations=0
    
    # Check: All *-sym.* files must be actual symlinks
    while IFS= read -r -d '' file; do
        if [ ! -L "$file" ]; then
            echo "❌ ORPHAN: $file claims to be symlink but isn't!"
            ((violations++))
        fi
    done < <(find . -name "*-sym.*" -print0 2>/dev/null)
    
    # Check: All symlinks should use -sym naming (except CONSTRUCT dir)
    while IFS= read -r -d '' file; do
        if [[ "$file" != "./CONSTRUCT" && "$file" != *"-sym."* ]]; then
            echo "⚠️  UNNAMED SYMLINK: $file is symlink but name doesn't indicate it"
            ((violations++))
        fi
    done < <(find . -type l -print0 2>/dev/null)
    
    return $violations
}
```

### 4. Update Documentation
- Update CLAUDE.md to explain new naming convention
- Update README files to document the pattern
- Add examples showing GUI vs terminal visibility

### 5. Add Helper Commands
```bash
# New commands for discoverability
construct-symlinks     # Show all symlinked files  
construct-independent  # Show all LAB-only files
construct-orphans      # Check for naming violations
```

## Validation Rules

### Strict Enforcement
1. **Files named `*-sym.*` MUST be symlinks** (no exceptions)
2. **Symlinks SHOULD use `-sym.ext` naming** (except whole directories)
3. **Pre-commit hook MUST block orphan `-sym` files**
4. **Symlink targets MUST exist in CORE**

### Exception Handling
- `CONSTRUCT/` directory symlink doesn't need `-sym` naming (whole directory)
- Generated files in `automated/` don't need special naming
- Temporary files can be excluded from validation

## Benefits Summary
- **GUI users**: Immediately see what's symlinked vs independent
- **Terminal users**: Still get standard symlink arrows
- **Developers**: Can script against naming patterns
- **Quality gates**: Prevent orphan files that lie about their nature
- **Cross-platform**: Works regardless of symlink support quirks

## Success Criteria
- [ ] All existing symlinks renamed to `-sym.ext` pattern
- [ ] Pre-commit hook validates naming integrity
- [ ] Documentation updated to explain convention
- [ ] Helper commands available for users
- [ ] No orphan `-sym` files possible
- [ ] System self-documents its symlink architecture