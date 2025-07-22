# CONSTRUCT Requirements

## System Requirements

### Operating System
- **macOS**: 12.0+ (tested)

### Core Dependencies

#### Required
- **Bash**: 4.0+ (shell scripting)
- **Git**: 2.0+ (version control and project management)
- **yq**: 4.0+ (YAML processing for pattern system)
- **jq**: 1.6+ (JSON processing for configuration and data handling)

#### Optional but Recommended

## Installation Commands

### macOS (Homebrew)
```bash
# Install required dependencies
brew install yq jq
```

### Verification
```bash
# Check installations
yq --version    # Should show v4.x.x
jq --version    # Should show jq-1.x
git --version   # Should show git version 2.x
bash --version  # Should show GNU bash 4.x or 5.x
```

## Development Environment

### For CONSTRUCT Development
- **Shell Knowledge**: Advanced bash scripting
- **YAML**: Understanding of YAML syntax and structure
- **Git Workflows**: Branching, merging, independent repositories

### For Using CONSTRUCT (Projects)
- **Xcode**: 14.0+ (for Swift/iOS projects)
- **Swift**: 5.7+ (for iOS development)
- **macOS Development**: iOS 15.0+ target

## Pattern System Dependencies

### Critical for Pattern System
- **yq**: Required for all pattern operations
  - Pattern assembly from YAML configurations
  - Multi-repository pattern inheritance
  - Custom rules processing
  - Workspace registry management
  - Pattern validation

### Impact Without yq
- ❌ Cannot read `.construct/patterns.yaml` files
- ❌ Cannot validate pattern configurations
- ❌ Cannot use custom rules or pattern overrides
- ❌ Workspace commands will fail
- ❌ Multi-repo pattern inheritance won't work

## Workspace System Dependencies

### Multi-Repository Support
- **yq**: Required for workspace registry manipulation
- **Git**: Each component maintains independent repository
- **Directory Structure**: Projects/ must be in .gitignore

### Workspace Commands
All workspace commands require yq:
- `workspace-status.sh`
- `workspace-update.sh`
- `import-project.sh`
- `import-component.sh`

## Feature Dependencies Matrix

| Feature | yq | jq | git | bash |
|---------|----|----|-----|------|
| Basic project creation | ✅ | ✅ | ✅ | ✅ |
| Pattern system | ✅ | ✅ | ✅ | ✅ |
| Multi-repo projects | ✅ | ✅ | ✅ | ✅ |
| Workspace management | ✅ | ✅ | ✅ | ✅ |
| Pattern validation | ✅ | ✅ | ❌ | ✅ |
| Legacy migration | ✅ | ✅ | ✅ | ✅ |
| Advanced analytics | ✅ | ✅ | ✅ | ✅ |

## Troubleshooting

### yq Not Found
```bash
# Error: yq: command not found
# Solution: Install yq using instructions above
brew install yq
```

### Permission Denied
```bash
# Error: Permission denied executing scripts
# Solution: Make scripts executable
chmod +x CONSTRUCT-CORE/CONSTRUCT/scripts/*.sh
```

### YAML Syntax Errors
```bash
# Error: Invalid patterns.yaml format
# Solution: Validate YAML syntax
yq eval '.' .construct/patterns.yaml
```

## Future Dependencies

### Planned Features
- **Python**: 3.8+ (for advanced analytics)
- **Node.js**: 16+ (for template distribution)
- **Docker**: Latest (for containerized development)

### Under Consideration
- **ripgrep**: Faster text searching
- **fd**: Faster file finding
- **bat**: Enhanced file viewing

## Compatibility Notes

### Known Issues
- Some shell scripts may need adjustment for zsh vs bash
- File permissions handling may vary

### Version Compatibility
- **yq v3 vs v4**: CONSTRUCT requires v4+ syntax
- **Bash 3 vs 4**: Some array operations require Bash 4+
- **Git 1.x**: Some commands require Git 2.0+ features

---

**Last Updated**: 2025-07-08
**Status**: Active development
**Priority**: High (affects core functionality)