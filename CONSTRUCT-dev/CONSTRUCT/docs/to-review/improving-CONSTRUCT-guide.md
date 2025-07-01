# Improving CONSTRUCT Development Guide

## Overview

This guide is for developers who want to improve CONSTRUCT itself - the shell scripts, templates, and infrastructure that make CONSTRUCT work.

## Development Environment Setup

CONSTRUCT has a dual development environment:

**CONSTRUCT-dev/**: For improving CONSTRUCT infrastructure  
**USER-project-files/**: For testing CONSTRUCT as a user would

Both environments use identical AI-assisted workflows but optimized for their domains.

## CONSTRUCT Development Workflow

### 1. Set Up Development Context
```bash
cd CONSTRUCT-dev/
./AI/scripts/update-context.sh      # Updates CONSTRUCT development context
```

This updates `CONSTRUCT-dev/AI/CLAUDE.md` with current CONSTRUCT development state.

### 2. Check CONSTRUCT Architecture
```bash
./AI/scripts/check-architecture.sh  # Validates shell/Python patterns
```

Validates CONSTRUCT's own architecture (shell script organization, lib functions, etc.)

### 3. Search Before Creating
```bash
./AI/scripts/before_coding.sh template  # Search existing before creating
```

Shows existing functions, scripts, and patterns before you create new ones.

### 4. Session Management
```bash
./AI/scripts/session-summary.sh     # Preserve CONSTRUCT development context
```

Creates session summaries for CONSTRUCT development work.

## Directory Structure

### CONSTRUCT Development
```
CONSTRUCT-dev/
├── AI/                          # CONSTRUCT development context
│   ├── CLAUDE.md               # Auto-updating dev context
│   ├── scripts/                # Development workflow scripts
│   ├── dev-logs/               # Development session logs
│   └── todo/                   # Development tasks
├── lib/                        # Reusable shell functions
├── config/                     # Configuration files
├── Templates/                  # Source templates for users
├── tests/                      # Script testing
└── docs/                       # Developer documentation (this file)
```

### User Project Testing
```
USER-project-files/             # Test CONSTRUCT as a user
├── AI/                        # User AI context and scripts
├── PROJECT-name/              # Test Xcode project
└── scripts/                   # User development scripts
```

## Development Patterns

### Shell Script Organization
- **lib/**: Reusable functions across scripts
- **config/**: YAML configuration for validation rules
- **AI/scripts/**: User-facing development scripts
- **tests/**: Validation of script functionality

### Dual-Context Scripts
Many scripts analyze both CONSTRUCT development and user projects:

```bash
# Analyze CONSTRUCT's shell/Python architecture
analyze_construct_architecture() {
    # Validate shell script patterns
    # Check configuration management
    # Test script functionality
}

# Analyze USER-project-files Swift patterns  
analyze_user_project() {
    # Parse Swift files for MVVM compliance
    # Extract patterns for template improvements
    # Generate architecture reports
}
```

### Configuration-Driven Validation
Use YAML files in `config/` for maintainable rule definitions:

```yaml
# config/mvvm-rules.yaml
rules:
  views:
    forbidden_patterns:
      - "@State.*User"
      - "URLSession"
```

## Contributing to CONSTRUCT

### Before Making Changes
1. **Update context**: `./AI/scripts/update-context.sh`
2. **Check architecture**: `./AI/scripts/check-architecture.sh`
3. **Search existing**: `./AI/scripts/before_coding.sh your_feature`

### Development Process
1. **Work in CONSTRUCT-dev/**: Make infrastructure improvements
2. **Test in USER-project-files/**: Verify user experience
3. **Validate changes**: Run architecture checks
4. **Update context**: Keep AI context current

### Quality Standards
- All scripts must have proper error handling (`set -e`)
- Use lib/ functions for shared functionality
- Follow configuration-driven patterns
- Include user-friendly colored output
- Test both CONSTRUCT development and user scenarios

## Testing Changes

### Template Integrity
```bash
# In CONSTRUCT-dev/
./AI/scripts/check-architecture.sh  # Validates template integrity
```

### User Experience Testing
```bash
# Test as a user would
cd USER-project-files/
./AI/scripts/update-context.sh      # Test user workflow
./AI/scripts/check-architecture.sh  # Test Swift validation
```

### Cross-Environment Validation
Scripts should work from both environments and understand their context.

## Key Improvement Areas

### 1. Template Management
- Keep Templates/ clean and generic
- Validate no CONSTRUCT-specific contamination
- Test template independence

### 2. Dual-Context Intelligence
- Scripts that understand both shell and Swift domains
- Cross-environment pattern extraction
- Coordinated but separate development workflows

### 3. AI Integration
- Auto-updating context files
- Configuration-driven rule generation
- Multi-AI platform compatibility

## Philosophy

CONSTRUCT improves itself using its own methodology - this is recursive development. The same principles that make user projects better (AI-assisted workflows, architecture enforcement, context preservation) apply to CONSTRUCT development itself.

When CONSTRUCT developers use CONSTRUCT tools to improve CONSTRUCT, the system becomes self-improving and the methodology proves itself through usage.

**Trust The Process** - even when improving the process itself.
---

# Auto-Generated Architecture Status

**Last Updated**: Mon Jun 30 13:56:35 PDT 2025
**Generated by**: update-architecture.sh

## Current CONSTRUCT Development State

### Component Statistics
- **AI Scripts**: 9/9 implemented
- **Library Functions**: 3 files
- **Configuration Files**: 2 files
- **Documentation Files**: 4 files

### Implementation Progress
- **Phase 1**: CONSTRUCT Development Scripts - 100% complete
- **Phase 2**: USER-project-files cleanup - Pending
- **Phase 3**: Cross-environment integration - Pending
- **Phase 4**: Auto-updating contexts - In progress
- **Phase 5**: Shell aliases and polish - In progress

### Quality Metrics
- **Script Quality**: Run `./AI/scripts/check-quality.sh` for current status
- **Documentation Coverage**: Run `./AI/scripts/check-documentation.sh` for analysis
- **Architecture Compliance**: Run `./AI/scripts/check-architecture.sh` for validation

### Recent Architecture Changes
- Dual development environment implementation complete
- Configuration-driven validation system active
- Auto-updating documentation generation implemented
- Library function architecture established

### Next Development Priorities
1. Complete remaining AI scripts (0 remaining)
2. Clean up USER-project-files scripts (remove RUN-specific hardcoding)
3. Implement cross-environment analysis capabilities
4. Enhance auto-updating context systems
5. Complete shell alias integration

### Development Commands
```bash
# Update all architecture documentation
./AI/scripts/update-architecture.sh

# Check overall CONSTRUCT development health
./AI/scripts/check-quality.sh && ./AI/scripts/check-documentation.sh

# Analyze current structure
./AI/scripts/scan_construct_structure.sh

# Update development context for AI
./AI/scripts/update-context.sh
```

---

*This section auto-updates when you run ./AI/scripts/update-architecture.sh*
