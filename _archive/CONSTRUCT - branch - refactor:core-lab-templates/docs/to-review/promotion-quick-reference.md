# Promotion System Quick Reference

## The Golden Rule
**Nothing enters CORE without explicit promotion from LAB**

## Quick Commands
```bash
# 1. Add promotion to manifest
vim PROMOTE-TO-CORE.yaml

# 2. Validate promotion
./tools/validate-promotion.sh

# 3. Execute promotion
./tools/promote-to-core.sh

# 4. Commit to git
git add CONSTRUCT-CORE/
git commit -m "feat: Promote X from LAB to CORE"
```

## Manifest Template
```yaml
promotions:
  - type: file
    source: experiments/my-feature.sh
    dest: CONSTRUCT-CORE/CONSTRUCT/scripts/my-feature.sh
    description: "Clear description of what and why"
    bump_version: minor  # major|minor|patch
```

## Version Bumping
- **patch** (1.0.X): Bug fixes, docs, minor improvements
- **minor** (1.X.0): New features, backward-compatible
- **major** (X.0.0): Breaking changes, major shifts

## File Locations
- **Manifest**: `CONSTRUCT-LAB/PROMOTE-TO-CORE.yaml`
- **Tools**: `CONSTRUCT-LAB/tools/`
- **Log**: `CONSTRUCT-CORE/PROMOTION-LOG.md`
- **Version**: `CONSTRUCT-CORE/VERSION`

## Workflow Diagram
```
LAB (develop) → Manifest (declare) → Validate (check) → Promote (copy) → CORE (stable)
     ↓               ↓                    ↓                ↓              ↓
experiments/    PROMOTE-TO-     validate-promotion   promote-to-    CONSTRUCT-CORE/
my-feature.sh   CORE.yaml            .sh              core.sh          VERSION++
```

## Common Patterns

### Promoting a New Script
```yaml
- type: file
  source: experiments/analyze-deps.sh
  dest: CONSTRUCT-CORE/CONSTRUCT/scripts/analyze-deps.sh
  description: "New dependency analysis tool"
  bump_version: minor
```

### Promoting a Bug Fix
```yaml
- type: file
  source: fixes/validation-fix.sh
  dest: CONSTRUCT-CORE/CONSTRUCT/lib/validation.sh
  description: "Fix validation error with empty strings"
  bump_version: patch
```

### Promoting Documentation
```yaml
- type: file
  source: docs/new-pattern-guide.md
  dest: CONSTRUCT-CORE/docs/patterns/new-pattern-guide.md
  description: "Document new error handling patterns"
  bump_version: patch
```

## Pre-Flight Checklist
- [ ] Source file exists and works
- [ ] Tested in LAB environment
- [ ] Tested against templates
- [ ] No breaking changes (or bump major)
- [ ] Clear description in manifest
- [ ] Run validate-promotion.sh
- [ ] Ready to commit after promotion

## Emergency Rollback
```bash
# Quick rollback of last promotion
cd CONSTRUCT-CORE
git checkout HEAD~1 -- .

# Or restore specific file from backup
mv script.sh.bak script.sh
```

Remember: **LAB is for breaking things, CORE is for stable things**