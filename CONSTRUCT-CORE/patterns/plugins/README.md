# Pattern Plugins Directory

This directory contains complete, self-contained pattern plugins that provide rules, validators, and examples for different aspects of software development.

## Plugin Structure

Each plugin follows this structure:
```
plugins/
└── [category]/
    └── [plugin-name]/
        ├── [plugin-name].md        # Pattern rules and guidelines (required)
        ├── [plugin-name].yaml      # Plugin metadata (required)
        └── validators/             # Validation scripts (optional)
            ├── quality.sh          # Code quality checks
            ├── architecture.sh     # Architecture validation
            ├── documentation.sh    # Documentation checks
            └── usage.sh           # Pattern usage validation
```

## Categories

### `architectural/` - Architecture Patterns
- **mvvm** - Generic Model-View-ViewModel pattern
- **mvvm-ios** - iOS-specific MVVM with SwiftUI (extends mvvm)

### `cross-platform/` - Multi-Platform Patterns
- **model-sync** - Cross-platform model synchronization

### `frameworks/` - Framework-Specific Patterns
- **swiftui** - SwiftUI best practices and patterns
- **ios-ui-library** - Reusable iOS UI component patterns

### `languages/` - Language Patterns
- **swift** - Swift 6 language patterns and conventions
- **python** - Python patterns following PEP 8
- **csharp** - C# modern patterns and practices

### `platforms/` - Platform-Specific Patterns
- **ios** - iOS platform conventions and requirements

### `tooling/` - Development Tool Patterns
- **shell-scripting** - Shell script patterns and structure
- **shell-quality** - Shell script quality standards
- **construct-dev** - CONSTRUCT development patterns
- **error-handling** - Error handling best practices
- **unix-philosophy** - Unix philosophy principles

## Plugin Metadata

Each plugin has a `.yaml` file with:
```yaml
name: plugin-name
version: 1.0.0
description: Clear description of the plugin
author: CONSTRUCT Team
category: languages|frameworks|architectural|platforms|tooling|cross-platform
validators:           # Optional - which validators are included
  - quality
  - architecture
  - documentation
dependencies:         # Optional - other required plugins
  - category/other-plugin
tags:                # For discovery and filtering
  - relevant
  - keywords
min_construct_version: 2.0.0
```

## Using Plugins

In your project's `.construct/patterns.yaml`:
```yaml
plugins:
  # Language and platform
  - languages/swift
  - platforms/ios
  
  # Architecture
  - architectural/mvvm-ios
  
  # Frameworks
  - frameworks/swiftui
  
  # Development tools
  - tooling/shell-scripting
  - tooling/error-handling
```

## Validators

Plugins can include validators that check code against the pattern rules:

- **quality.sh** - Code quality and style checks
- **architecture.sh** - Structural and architectural validation
- **documentation.sh** - Documentation completeness and format
- **usage.sh** - Proper pattern implementation

Validators:
- Accept `PROJECT_DIR` as first parameter
- Return exit code = number of issues (0 = success)
- Provide colored, informative output
- Are called by core orchestrator scripts

## Creating New Plugins

1. Create directory: `plugins/[category]/[plugin-name]/`
2. Add `[plugin-name].md` with pattern rules
3. Add `[plugin-name].yaml` with metadata
4. Optionally add `validators/` with validation scripts
5. Test with a sample project

## Plugin Dependencies

Plugins can depend on other plugins. For example:
- `mvvm-ios` depends on `architectural/mvvm`
- `swift` patterns work with `frameworks/swiftui`
- `shell-quality` extends `tooling/shell-scripting`

Dependencies are automatically included when a plugin is selected.

## Best Practices

1. **Keep plugins focused** - One concept per plugin
2. **Use clear examples** - Show both good and bad patterns
3. **Make validators specific** - Check for actual pattern violations
4. **Document dependencies** - Be explicit about requirements
5. **Version carefully** - Follow semantic versioning