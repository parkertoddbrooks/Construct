# CONSTRUCT Restructure Plan: CORE/LAB/TEMPLATES Architecture

## Overview
Refactoring CONSTRUCT from its current dual-environment structure to a cleaner three-layer architecture that separates the universal orchestration engine (CORE) from development (LAB) and production templates (TEMPLATES).

## Current State
```
CONSTRUCT/
├── CONSTRUCT-dev/          # Development environment for CONSTRUCT
├── PROJECT-TEMPLATE/       # Swift/iOS template for users
├── README.md
└── construct-setup
```

## Target State
```
CONSTRUCT/
├── CONSTRUCT-CORE/         # Universal orchestration engine
├── CONSTRUCT-LAB/          # Development environment
├── TEMPLATES/              # Production-ready templates
│   ├── swift-ios/
│   ├── nodejs-api/         # Future
│   └── react-web/          # Future
├── README.md
└── construct-setup         # Updated for new structure
```

## Migration Steps

### Phase 1: Safe Copy (CURRENT STEP)
- [x] Create new branch: `refactor/core-lab-templates`
- [x] Copy all project files to `_old/` for reference
- [ ] Keep `.git/`, `.gitignore`, `.claude/` in place

### Phase 2: Extract CONSTRUCT-CORE
- [ ] Create `CONSTRUCT-CORE/` directory
- [ ] Copy universal components from `_old/CONSTRUCT-dev/CONSTRUCT/`
- [ ] Remove any development-specific code
- [ ] Add VERSION file (start at 1.0.0)
- [ ] Structure:
  ```
  CONSTRUCT-CORE/
  ├── orchestrator/       # Language detection and routing
  ├── adapters/          # Language-specific implementations
  ├── scripts/           # Universal scripts
  ├── lib/              # Shared functions
  ├── config/           # Core configuration
  └── VERSION
  ```

### Phase 3: Create CONSTRUCT-LAB
- [ ] Copy `_old/CONSTRUCT-dev/` to `CONSTRUCT-LAB/`
- [ ] Remove the embedded CONSTRUCT/ directory
- [ ] Create symlink: `CONSTRUCT-LAB/CONSTRUCT -> ../CONSTRUCT-CORE`
- [ ] Keep all AI/, experiments/, and development content

### Phase 4: Create TEMPLATES Structure
- [ ] Create `TEMPLATES/` directory
- [ ] Move `_old/PROJECT-TEMPLATE/` to `TEMPLATES/swift-ios/`
- [ ] Create symlink: `TEMPLATES/swift-ios/CONSTRUCT -> ../../CONSTRUCT-CORE`
- [ ] Prepare structure for future templates

### Phase 5: Update Scripts and Paths
- [ ] Update all relative paths in scripts
- [ ] Test each script in new structure
- [ ] Update construct-setup for new template location
- [ ] Ensure all AI context generation works

### Phase 6: Verification
- [ ] Run all scripts from CONSTRUCT-LAB
- [ ] Test template creation flow
- [ ] Verify AI context updates work
- [ ] Check that no functionality is lost

### Phase 7: Documentation Updates
- [ ] Update main README.md
- [ ] Update CONSTRUCT-LAB/AI/CLAUDE.md
- [ ] Create CONSTRUCT-CORE/README.md
- [ ] Update template documentation

## Key Principles

1. **No Deletion from _old/** - Everything is copied, nothing deleted
2. **Gradual Build** - Build new structure piece by piece
3. **Continuous Verification** - Test after each step
4. **Symlink Strategy** - CORE is shared via symlinks, not copies
5. **Git Safety** - All work on branch, main stays pristine

## Success Criteria

- [ ] CONSTRUCT-LAB can develop and test new features
- [ ] CONSTRUCT-CORE contains only universal, stable code
- [ ] Templates are clean and ready for users
- [ ] No functionality is lost in migration
- [ ] Clear separation of concerns achieved
- [ ] Multi-language support is possible (future)

## Rollback Plan

If issues arise:
1. `git checkout main` - Return to original
2. `git branch -D refactor/core-lab-templates` - Remove branch
3. Learn from attempt and revise plan

## Visual Reference

### What Goes Where:

**From CONSTRUCT-dev/ →**
- `CONSTRUCT/` → `CONSTRUCT-CORE/` (universal parts only)
- Everything else → `CONSTRUCT-LAB/`

**From PROJECT-TEMPLATE/ →**
- Entire directory → `TEMPLATES/swift-ios/`

**New Additions:**
- VERSION file in CONSTRUCT-CORE
- Symlinks in LAB and TEMPLATES pointing to CORE
- Future template directories in TEMPLATES/

## Next Steps

1. Confirm `_old/` directory is created with full copy
2. Begin Phase 2: Extract CONSTRUCT-CORE
3. Test each component as we build
4. Document any issues or learnings

---

**Branch**: refactor/core-lab-templates  
**Original preserved in**: _old/  
**Git safety**: Can always return to main branch