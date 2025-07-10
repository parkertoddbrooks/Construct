# CONSTRUCT Plugin System PRD

## Overview
Transform CONSTRUCT's pattern system from standalone markdown files into complete, self-contained plugins that include validation, examples, and tests.

## Problem Statement
Currently, CONSTRUCT patterns are:
- Just markdown files with rules
- Validators scattered in different directories
- No standardized structure
- No metadata or dependency management
- Difficult to test or validate
- Hard for community to contribute complete solutions

## Goals
1. **Standardize Plugin Structure** - Define what makes a complete plugin
2. **Enable Self-Contained Plugins** - Everything needed in one directory
3. **Support Community Contributions** - Easy to create and share
4. **Automated Validation** - Plugins can validate code against their rules
5. **Testable Patterns** - Include tests to verify validators work

## Plugin Structure

### Required Components
```
patterns/
└── plugins/
    └── [category]/
        └── [plugin-name]/
            ├── [plugin-name].md      # Pattern rules (required)
            ├── [plugin-name].yaml    # Metadata (required)
            ├── validators/           # Validation scripts (optional)
            │   ├── quality.sh
            │   ├── architecture.sh
            │   ├── documentation.sh
            │   └── usage.sh
            ├── examples/             # Example code (recommended)
            │   ├── good/
            │   └── bad/
            └── tests/               # Validator tests (recommended)
                ├── should-pass/
                └── should-fail/
```

### Metadata Schema ([plugin-name].yaml)
```yaml
# Required fields
name: swift-language
version: 1.0.0
description: Swift language patterns and best practices
author: CONSTRUCT Team
category: languages

# Optional fields
validators:
  - quality
  - architecture
  - usage
dependencies:
  - architectural/mvvm-ios    # Required plugins
  - frameworks/swiftui
conflicts:
  - languages/objective-c     # Incompatible plugins
tags:
  - swift
  - ios
  - mobile
min_construct_version: 2.0.0
documentation_url: https://...
```

## Plugin Categories

### Core Categories (in CONSTRUCT-CORE)
- `languages/` - Programming language patterns
- `frameworks/` - Framework-specific patterns
- `architectural/` - Architecture patterns
- `platforms/` - Platform-specific patterns
- `tooling/` - Development tool patterns
- `cross-platform/` - Multi-platform patterns

### Community Categories (in CONSTRUCT-LAB)
- `community/` - General community patterns
- `[username]/` - Personal pattern collections

## Validator Standards

### Validator Interface
All validators must:
1. Accept `PROJECT_DIR` as first parameter
2. Return exit code = number of issues found (0 = success)
3. Source CONSTRUCT libraries:
   ```bash
   source "$CONSTRUCT_ROOT/lib/validation.sh"
   source "$CONSTRUCT_ROOT/lib/file-analysis.sh"
   ```
4. Output colored, informative messages
5. Be idempotent (safe to run multiple times)

### Standard Validators
- `validate-quality.sh` - Code quality checks
- `validate-architecture.sh` - Structural checks
- `validate-documentation.sh` - Documentation checks
- `validate-usage.sh` - Pattern implementation checks

## Implementation Plan

### Phase 1: Core Infrastructure (Week 1)
1. Create plugin loader that reads metadata
2. Update construct-patterns.sh to handle new structure
3. Create plugin validation command
4. Document plugin creation process

### Phase 2: Migrate Existing Patterns (Week 2)
1. Convert existing patterns to plugin structure
2. Extract validators from scripts-new/patterns/
3. Create metadata files for each
4. Add basic examples

### Phase 3: Testing Framework (Week 3)
1. Create test runner for validators
2. Add tests for core plugins
3. Set up CI for plugin testing
4. Create plugin scaffold generator

### Phase 4: Community Features (Week 4)
1. Plugin discovery mechanism
2. Plugin dependency resolution
3. Plugin versioning support
4. Plugin sharing documentation

## Success Metrics
1. **Adoption**: 10+ community plugins created in first month
2. **Quality**: All core plugins have 90%+ test coverage
3. **Validation**: 80% reduction in pattern violations
4. **Developer Experience**: Plugin creation time < 30 minutes

## Example: Swift Language Plugin

### Directory Structure
```
patterns/plugins/languages/swift/
├── swift.md                 # Swift patterns and rules
├── swift.yaml              # Metadata
├── validators/
│   ├── validate-quality.sh     # Swift code quality
│   ├── validate-architecture.sh # Swift/iOS architecture
│   └── validate-usage.sh       # Pattern compliance
├── examples/
│   ├── good/
│   │   ├── async-await.swift
│   │   ├── mvvm-viewmodel.swift
│   │   └── swiftui-view.swift
│   └── bad/
│       ├── dispatch-queue.swift
│       ├── massive-view.swift
│       └── force-unwrap.swift
└── tests/
    ├── should-pass/
    │   └── proper-patterns.swift
    └── should-fail/
        └── violations.swift
```

### Metadata (swift.yaml)
```yaml
name: swift-language
version: 1.0.0
description: Swift 6 language patterns and best practices
author: CONSTRUCT Team
category: languages
validators:
  - quality
  - architecture
  - usage
dependencies:
  - architectural/mvvm-ios
  - frameworks/swiftui
tags:
  - swift
  - ios
  - swift-6
  - concurrency
min_construct_version: 2.0.0
```

### Usage in patterns.yaml
```yaml
# Project's .construct/patterns.yaml
plugins:
  - languages/swift
  - frameworks/swiftui
  - architectural/mvvm-ios
  - community/accessibility
  - parker/run-ui-patterns
```

## Migration Guide

### For Pattern Authors
1. Create plugin directory structure
2. Move pattern .md file
3. Create metadata .yaml
4. Extract/create validators
5. Add examples
6. Create tests
7. Submit PR or share

### For CONSTRUCT Users
1. Update to new construct-patterns.sh
2. Run migration command
3. Update patterns.yaml to use new paths
4. Test validation works

## Future Enhancements
1. **Plugin Marketplace** - Central repository for community plugins
2. **Auto-installation** - `construct plugin install swift-language`
3. **Plugin Signing** - Verify plugin authenticity
4. **Performance Metrics** - Track validator execution time
5. **IDE Integration** - Real-time validation in editors

## Questions to Resolve
1. Should validators be required or optional?
2. How to handle plugin versioning and updates?
3. Should we support binary validators (compiled tools)?
4. How to handle cross-plugin dependencies?
5. Should plugins be able to modify CONSTRUCT behavior?

## Timeline
- Week 1-2: Core implementation
- Week 3-4: Migration and testing
- Month 2: Community launch
- Month 3: Marketplace planning

---

This PRD transforms patterns from simple documentation into complete, validated, testable plugins that enhance CONSTRUCT's capabilities while enabling community contributions.