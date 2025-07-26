# CONSTRUCT-LAB Tools

This directory contains tools for managing the CONSTRUCT-LAB development environment, particularly the promotion system for moving validated code from LAB to CORE.

## Recent Updates

### AI-Native Orchestrator Complete (July 2025)
The major init-construct.sh refactoring is complete with Claude SDK integration:
- Fixed streaming JSON issues by switching to standard JSON format
- Added `--extract` flag for optional full three-level pattern extraction
- Improved error handling and debug logging
- Quick mode (default) completes in ~30 seconds
- Full extraction mode available for deeper analysis

## Available Tools

### 🚀 promote-to-core.sh
Processes the promotion manifest and moves validated code from LAB to CORE.

**Usage:**
```bash
./promote-to-core.sh
```

**What it does:**
1. Reads PROMOTE-TO-CORE.yaml
2. Validates promotion entries
3. Copies files to CONSTRUCT-CORE
4. Bumps version according to change type
5. Creates promotion log entry
6. Optionally clears the manifest

### 🔍 validate-promotion.sh
Pre-flight check before running promotions. Catches common issues early.

**Usage:**
```bash
./validate-promotion.sh
```

**What it checks:**
- Source files exist
- Scripts are executable
- Scripts have proper shebang and error handling
- Valid version bump types
- CONSTRUCT-CORE accessibility
- Uncommitted changes warning

## Promotion Workflow

### 1. Develop and Test in LAB
```bash
# Create new feature in appropriate directory
cd CONSTRUCT-LAB/
# For example, a new script:
vim CONSTRUCT/scripts/dev/my-awesome-feature.sh
chmod +x CONSTRUCT/scripts/dev/my-awesome-feature.sh

# Test thoroughly
./CONSTRUCT/scripts/dev/my-awesome-feature.sh
```

### 2. Add to Promotion Manifest
```bash
# Edit PROMOTE-TO-CORE.yaml
cd CONSTRUCT-LAB
vim PROMOTE-TO-CORE.yaml

# Add your promotion entry:
promotions:
  - type: file
    source: CONSTRUCT/scripts/dev/my-awesome-feature.sh
    dest: CONSTRUCT-CORE/CONSTRUCT/scripts/dev/my-awesome-feature.sh
    description: "Awesome feature that does X"
    bump_version: minor
```

### 3. Validate Before Promotion
```bash
./tools/validate-promotion.sh
```

### 4. Execute Promotion
```bash
./tools/promote-to-core.sh
```

### 5. Commit Changes
```bash
cd ..
git add CONSTRUCT-CORE/
git commit -m "feat: Promote my-awesome-feature from LAB to CORE v1.1.0"
```

## Best Practices

### Before Promoting
- ✅ Test in LAB environment
- ✅ Test against templates
- ✅ Run quality checks
- ✅ Update documentation
- ✅ Run validate-promotion.sh

### Writing Good Descriptions
```yaml
# ❌ Bad
description: "Updated script"

# ✅ Good
description: "Added validation for empty directories to prevent script failures"
```

### Version Bump Guidelines
- **patch**: Bug fixes, typo corrections, small improvements
- **minor**: New features, new scripts, backward-compatible changes
- **major**: Breaking changes, architectural shifts, API changes

### After Promoting
- Test in CORE context
- Verify templates still work
- Update any affected documentation
- Clear promotion manifest

## Future Tools

Planned additions to this directory:
- `rollback-promotion.sh` - Revert a problematic promotion
- `dry-run-promotion.sh` - Preview promotion without executing
- `promotion-history.sh` - View promotion history and stats
- `sync-lab-from-core.sh` - Update LAB after external CORE changes

## Notes

- These tools are for CONSTRUCT-LAB use only
- They modify CONSTRUCT-CORE, so use with care
- Always validate before promoting
- Commit changes promptly after promotion
- Keep the promotion manifest clean