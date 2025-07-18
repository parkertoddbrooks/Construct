# Add PyYAML to Setup Requirements

## Overview
Add PyYAML as an optional dependency to CONSTRUCT's setup process to enable enhanced YAML validation in quality checks.

## Current Status
- Quality check script has graceful fallback when PyYAML is missing
- Basic shell-native YAML validation works without PyYAML
- Enhanced validation requires PyYAML installation

## Implementation Tasks

### 1. Update construct-setup Script
- [ ] Add PyYAML installation check
- [ ] Provide installation instructions if missing
- [ ] Make PyYAML installation optional but recommended

### 2. Add to Documentation
- [ ] Update installation instructions in README
- [ ] Document enhanced vs basic YAML validation
- [ ] Add troubleshooting for PyYAML issues

### 3. Setup Options
- [ ] **Option A**: Auto-install PyYAML during setup
- [ ] **Option B**: Prompt user to install PyYAML
- [ ] **Option C**: Document as optional requirement

### 4. Installation Methods
```bash
# Via pip
pip3 install PyYAML

# Via conda
conda install pyyaml

# Via package manager (macOS)
brew install python-yq

# Via package manager (Ubuntu/Debian)
apt-get install python3-yaml
```

## Benefits

### With PyYAML
- Full YAML syntax validation
- Detailed error messages for malformed YAML
- Industry-standard parsing validation
- Catches complex YAML structure issues

### Without PyYAML (Current Fallback)
- Basic key-value structure validation
- Tab vs spaces checking
- Quote balance validation
- Empty list item detection

## Implementation Priority
**Medium** - Non-blocking enhancement that improves quality validation when available.

## Success Criteria
- [ ] construct-setup script handles PyYAML installation
- [ ] Documentation clearly explains benefits
- [ ] Quality checks work with or without PyYAML
- [ ] User experience is smooth regardless of choice

## Technical Notes

### Current Quality Check Logic
```bash
if command -v python3 &> /dev/null; then
    if python3 -c "import sys; sys.exit(0 if 'yaml' in sys.modules or __import__('yaml') else 1)" 2>/dev/null; then
        # Enhanced PyYAML validation
    else
        # Shell-native fallback validation
    fi
fi
```

### Integration Points
- `construct-setup` script
- `CONSTRUCT-docs/` installation instructions
- Quality check reporting
- CI/CD validation workflows

## Related Files
- `/construct-setup` (main setup script)
- `/CONSTRUCT-dev/AI/scripts/check-quality.sh` (quality validation)
- `/README.md` (installation instructions)
- `/CONSTRUCT-docs/` (user documentation)

---

**Created**: 2025-06-30  
**Priority**: Medium  
**Status**: Pending  
**Estimated Effort**: 2-3 hours