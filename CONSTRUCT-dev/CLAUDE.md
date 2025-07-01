# CONSTRUCT Development Context

## 🚨 ENFORCE THESE RULES (CONSTRUCT Development)

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
```

### CONSTRUCT-Specific Rules
```bash
❌ NEVER: Modify USER-project-files/ from CONSTRUCT scripts
✅ ALWAYS: Read-only analysis of USER-project-files/

❌ NEVER: Template changes without testing
✅ ALWAYS: Test templates work independently

❌ NEVER: Scripts that only work in development
✅ ALWAYS: Scripts that work for template users
```

## 📊 Current CONSTRUCT Development State

### Active CONSTRUCT Components
- Scripts: [To be analyzed]
- Templates: iOS-App, Watch-App, AI tools
- Documentation: Complete structure
- Tests: [To be implemented]

### CONSTRUCT Architecture
```
CONSTRUCT-dev/
├── AI/                    # CONSTRUCT development context
├── lib/                   # Reusable shell functions
├── config/               # Configuration files
├── Templates/            # Source templates for users
└── tests/               # Script testing
```

## 🎯 Current CONSTRUCT Development Goals

### Phase 1: Core Setup (In Progress)
- [ ] Create missing ConstructTemplate.xcodeproj
- [ ] Fix construct-setup script for template users
- [ ] Implement dual-context scripts (CONSTRUCT + USER analysis)
- [ ] Set up GitHub template repository

### Phase 2: Script Development
- [ ] Implement update-context.sh for USER-project-files
- [ ] Create check-architecture.sh for Swift MVVM validation
- [ ] Build analyze-user-project.sh for pattern extraction
- [ ] Develop sync-templates.sh for template updates

## 🔧 CONSTRUCT Development Scripts

### Dual-Context Scripts (Analyze Both)
- `AI/scripts/update-context.sh` - Updates both CONSTRUCT and USER contexts
- `AI/scripts/check-architecture.sh` - Validates CONSTRUCT shell + USER Swift
- `AI/scripts/analyze-user-project.sh` - Extract patterns from USER-project-files

### CONSTRUCT-Only Scripts
- `AI/scripts/sync-templates.sh` - Update Templates/ from discoveries
- `lib/template-utils.sh` - Template management utilities
- `lib/file-analysis.sh` - Parse Swift files for MVVM patterns

## 📋 Active CONSTRUCT PRDs

### Current Development
- construct-template-repository-prd.md - Main development direction
- github-template-setup.md - Repository configuration plan
- setup-requirements.md - Missing components tracking

## ⚠️ CONSTRUCT Development Violations

### Missing Components
- ConstructTemplate.xcodeproj in Templates/
- Multiple AI scripts referenced by aliases
- Template validation system
- Script testing infrastructure

## 🧪 CONSTRUCT Development Discoveries

### Template Repository Approach
- Repository IS the product users get
- USER-project-files/ gets personalized in-place
- Clean separation via GitHub template repository
- No template extraction needed

### Dual-Context Challenge
- CONSTRUCT development uses shell/Python patterns
- USER-project-files uses Swift MVVM patterns
- Scripts must understand both domains
- Architecture validation across different paradigms

## 📚 CONSTRUCT Development Patterns

### Script Structure
```bash
#!/bin/bash
set -e  # Exit on error

# Source shared functions
source "$(dirname "$0")/../lib/validation.sh"
source "$(dirname "$0")/../lib/file-analysis.sh"

# Load configuration
CONFIG_FILE="$(dirname "$0")/../config/mvvm-rules.yaml"

# Main logic with error handling
main() {
    # Implementation
}

main "$@"
```

### Dual Analysis Pattern
```bash
# Analyze CONSTRUCT's own architecture (shell/Python)
analyze_construct_architecture() {
    # Check script organization
    # Validate configuration management
    # Test script functionality
}

# Analyze USER-project-files (Swift MVVM)
analyze_user_project() {
    # Parse Swift files for MVVM compliance
    # Extract patterns for template improvements
    # Generate architecture reports
}
```

## 🤖 CONSTRUCT Development Instructions

### When Working on CONSTRUCT:
1. Work in CONSTRUCT-dev/ directory
2. Use CONSTRUCT development context (this file)
3. Test changes against USER-project-files/
4. Ensure template users aren't affected

### When Testing Template Changes:
1. Modify Templates/ in CONSTRUCT-dev/
2. Test construct-setup script
3. Verify USER-project-files/ personalization works
4. Check template repository workflow

### Dual-Context Development:
- CONSTRUCT development follows shell/Python best practices
- USER analysis follows Swift MVVM validation
- Scripts bridge both worlds effectively

---

**Remember**: CONSTRUCT improves itself while serving template users. Both contexts must work seamlessly.

---


---


---


---

# 🤖 AUTO-GENERATED CONSTRUCT DEVELOPMENT STATUS
**Last Updated**: Mon Jun 30 22:06:16 PDT 2025
**Generated by**: update-context.sh

## 📊 Current State

### Component Counts
- **Shell Scripts**:       14
- **Library Functions**:        4 
- **Configuration Files**:        2
- **Test Files**:        0

### Git Status
- **Branch**: main
- **Last Commit**: 521721d fix: Prevent CLAUDE.md duplication by improving auto-generated section replacement
- **Uncommitted Files**:        3

### Template Health
- **Status**: ✅ Valid
- **Location**: PROJECT-TEMPLATE/
- **Integrity**: Run check-architecture.sh for details

## 🔧 Available Development Tools

### Library Functions (lib/)
- **file-analysis.sh** - Swift MVVM pattern analysis
- **template-utils.sh** - Template management and validation  
- **validation.sh** - Common validation functions

### Configuration (config/)
- **mvvm-rules.yaml** - MVVM validation rules
- **quality-gates.yaml** - Quality thresholds and gates

### Scripts (CONSTRUCT/scripts/)
- **update-context.sh** - This script (updates development context)
- **check-architecture.sh** - Validates CONSTRUCT development patterns
- **before_coding.sh** - Pre-coding guidance and search

## 🚀 Quick Commands

```bash
# CONSTRUCT Development Workflow
./CONSTRUCT/scripts/update-context.sh      # Update this context
./CONSTRUCT/scripts/check-architecture.sh  # Validate CONSTRUCT patterns  
./CONSTRUCT/scripts/before_coding.sh func  # Search before creating

# Cross-Environment Analysis (when implemented)
./CONSTRUCT/scripts/analyze-user-project.sh # Analyze USER-project-files
```

## 💡 Development Patterns

### Shell Script Organization
- Use lib/ for reusable functions
- Follow config/ YAML for validation rules
- Include proper error handling (set -e)
- Add user-friendly colored output

### Dual-Context Approach
- CONSTRUCT development (shell/Python patterns)
- USER project analysis (Swift MVVM patterns)
- Cross-environment insights for improvements

---
*This section auto-updates when you run ./CONSTRUCT/scripts/update-context.sh*

