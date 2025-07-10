# CONSTRUCT Promotion System Guide

## Overview

The CONSTRUCT promotion system ensures that only tested, validated code enters CONSTRUCT-CORE. It provides an explicit, auditable path for moving innovations from experimentation (LAB) to production (CORE).

## Core Philosophy

### Nothing Enters CORE by Accident
Every file, script, or configuration in CONSTRUCT-CORE has been:
1. Developed and tested in CONSTRUCT-LAB
2. Explicitly declared in a promotion manifest
3. Reviewed and promoted through the formal process
4. Logged with version tracking

### LAB is for Experimentation
- Break things freely in LAB
- Try new approaches without fear
- Test against real projects
- Iterate until stable

### CORE is Sacred
- Only stable, proven code
- Maintains backward compatibility
- Serves as the single source of truth
- Powers both LAB and TEMPLATES

## The Promotion Workflow

### 1. Develop in LAB
```bash
cd CONSTRUCT-LAB/experiments/
# Create new feature, improvement, or fix
vim my-new-feature.sh
```

### 2. Test Thoroughly
```bash
# Test in LAB environment
./experiments/my-new-feature.sh

# Test against templates
# Verify no breaking changes
```

### 3. Declare Promotion
Edit `CONSTRUCT-LAB/PROMOTE-TO-CORE.yaml`:
```yaml
promotions:
  - type: file
    source: experiments/my-new-feature.sh
    dest: CONSTRUCT-CORE/CONSTRUCT/scripts/my-new-feature.sh
    description: "New feature that does X"
    bump_version: minor
```

### 4. Execute Promotion
```bash
cd CONSTRUCT-LAB
./tools/promote-to-core.sh
```

### 5. Review and Commit
```bash
# Review changes in CORE
cd CONSTRUCT-CORE
git diff

# Commit with clear message
git add .
git commit -m "feat: Promote my-new-feature from LAB

- Developed and tested in LAB
- Provides X functionality
- Version: 1.1.0"
```

## Promotion Manifest Schema

### File Promotion
```yaml
- type: file
  source: relative/path/in/lab/file.sh
  dest: CONSTRUCT-CORE/path/to/destination.sh
  description: "Clear description of what and why"
  bump_version: major|minor|patch
```

### Directory Promotion (Future)
```yaml
- type: directory
  source: experiments/new-module/
  dest: CONSTRUCT-CORE/CONSTRUCT/modules/new-module/
  description: "New module for X"
  include_files: 
    - "*.sh"
    - "README.md"
  exclude_files:
    - "*.test.sh"
  bump_version: minor
```

## Version Bumping Rules

### Patch (0.0.X)
- Bug fixes
- Documentation updates
- Minor improvements
- No API changes

### Minor (0.X.0)
- New features
- New scripts or functions
- Backward-compatible changes
- Enhanced functionality

### Major (X.0.0)
- Breaking changes
- Major architectural shifts
- Incompatible API changes
- Significant refactoring

## Promotion Log

Every promotion is logged in `CONSTRUCT-CORE/PROMOTION-LOG.md`:
- Timestamp of promotion
- Version after promotion
- List of promoted items
- Descriptions of changes

## Best Practices

### Before Promoting

1. **Test Exhaustively**
   - Run all quality checks
   - Test with real projects
   - Verify template compatibility

2. **Document Clearly**
   - Update relevant documentation
   - Include clear descriptions
   - Explain the "why"

3. **Consider Impact**
   - Will this break existing users?
   - Is it backward compatible?
   - Should this be a major version bump?

### During Promotion

1. **Review the Manifest**
   - Double-check source paths
   - Verify destination paths
   - Ensure descriptions are clear

2. **Use Preview Mode**
   - Run promotion in dry-run first
   - Review what will change
   - Confirm before executing

3. **Backup Important Files**
   - The script creates backups
   - But manual backups never hurt
   - Especially for major changes

### After Promotion

1. **Test in CORE**
   - Run promoted scripts
   - Verify functionality
   - Check template integration

2. **Update Documentation**
   - If behavior changed
   - If new features added
   - If examples needed

3. **Commit Thoughtfully**
   - Clear commit messages
   - Reference the promotion
   - Include version bump

## Rollback Process

If a promotion causes issues:

1. **Immediate Rollback**
   ```bash
   cd CONSTRUCT-CORE
   git checkout HEAD~1 -- .
   ```

2. **Restore Specific Files**
   ```bash
   # Backups are created as .bak files
   mv script.sh.bak script.sh
   ```

3. **Fix in LAB**
   - Return to LAB
   - Fix the issues
   - Test more thoroughly
   - Re-promote when ready

## Integration with CI/CD

Future enhancements could include:
- Automated testing before promotion
- CI validation of promotions
- Automated version bumping
- Release note generation

## FAQs

### Q: Can I edit files directly in CORE?
A: During the bootstrap phase (pre-v1.0.0), yes. After v1.0.0, all changes must go through LAB and promotion.

### Q: What if I need to hotfix CORE?
A: Create the fix in LAB, test quickly, and use an expedited promotion with clear documentation.

### Q: How often should I promote?
A: Promote when features are stable and tested. Batch related changes together for cleaner history.

### Q: Can I promote multiple files at once?
A: Yes, add multiple entries to the promotion manifest. They'll be promoted together with a single version bump.

## Summary

The promotion system ensures CONSTRUCT-CORE remains stable while enabling rapid experimentation in LAB. It provides:
- **Quality Control**: Only tested code reaches CORE
- **Audit Trail**: Every change is tracked
- **Version Management**: Semantic versioning for all changes
- **Safe Experimentation**: LAB remains free for innovation

Remember: CORE is the foundation that both LAB and TEMPLATES depend on. Treat promotions with the respect they deserve.