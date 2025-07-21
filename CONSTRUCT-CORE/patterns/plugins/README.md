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
- **web** - Universal web framework patterns (React, Vue, Angular, vanilla JS)

### `languages/` - Language Patterns
- **swift** - Swift 6 language patterns and conventions
- **python** - Python patterns following PEP 8
- **csharp** - C# modern patterns and practices

### `platforms/` - Platform-Specific Patterns
- **ios** - iOS platform conventions and requirements
- **web** - Web platform patterns (PWA, SEO, browser APIs)

### `tooling/` - Development Tool Patterns
- **shell-scripting** - Shell script patterns and structure
- **shell-quality** - Shell script quality standards
- **construct-dev** - CONSTRUCT development patterns
- **error-handling** - Error handling best practices
- **unix-philosophy** - Unix philosophy principles

### `ui/` - UI and Design Patterns
- **design-tokens** - Design system tokens and visual consistency
- **accessibility** - Accessibility patterns and inclusive design
- **visual-quality** - Professional visual standards and quality gates

### `performance/` - Performance Patterns
- **optimization** - General performance optimization patterns
- **rendering** - UI rendering optimization and efficiency patterns
- **memory-management** - Memory usage and lifecycle patterns

### `quality/` - Quality and Standards Patterns
- **standards** - Professional quality standards and requirements
- **practices** - Best practices and empirically validated patterns
- **gates** - Quality gates and validation checkpoints

### `configuration/` - Configuration Patterns
- **ios-config** - iOS platform configuration patterns
- **build-config** - Build system and environment configuration
- **env-setup** - Development environment setup patterns

## Plugin Metadata

Each plugin has a `.yaml` file with:
```yaml
name: plugin-name
version: 1.0.0
description: Clear description of the plugin
author: CONSTRUCT Team
category: languages|frameworks|architectural|platforms|tooling|cross-platform|ui|performance|quality|configuration
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

Plugins can include validators that check code against the pattern rules.

### How Pattern Validators Work

1. **Called by Master Scripts**: Receive PROJECT_DIR as parameter from orchestrator scripts
2. **Pattern-Specific Logic**: Implement checks specific to their domain
3. **Return Exit Codes**: Number of issues found (0 = success)
4. **Focused Validation**: Only check what's relevant to the pattern
5. **Integration**: Results bubble up through exit codes to master scripts

### Validator Types

#### Architecture Validators (`architecture.sh`)
- Structural patterns and organization
- Dependency management
- Module boundaries
- Naming conventions

#### Quality Validators (`quality.sh`)
- Code style and formatting
- Language-specific best practices
- Performance patterns
- Security considerations

#### Documentation Validators (`documentation.sh`)
- Comment standards for the language
- API documentation
- README requirements
- Example usage

#### Usage Validators (`usage.sh`)
- Correct pattern implementation
- Framework compliance
- Library usage patterns

### Validator Requirements

- Accept `PROJECT_DIR` as first parameter
- Return exit code = number of issues (0 = success)
- Provide colored, informative output
- Are called by core orchestrator scripts
- Use consistent error reporting format

### Example Pattern Validator

```bash
#!/bin/bash
# Pattern-Specific Validator
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PROJECT_DIR="${1:-.}"
ISSUES=0

echo -e "${BLUE}🔍 Checking your-pattern compliance...${NC}"

# Pattern-specific checks
if ! check_something "$PROJECT_DIR"; then
    echo -e "${YELLOW}⚠️  Issue found: description${NC}"
    ((ISSUES++))
fi

# Summary
if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}✅ Pattern validation passed${NC}"
else
    echo -e "${YELLOW}⚠️  Found $ISSUES pattern issues${NC}"
fi

exit $ISSUES
```

## Generators

Plugins can also include generators that create documentation or scaffolding based on patterns.

### Generator Types

- **architecture.sh** - Generate architecture documentation
- **scaffolding.sh** - Create boilerplate code following patterns
- **documentation.sh** - Generate pattern-specific docs

### Generator Structure

Generators live in the `generators/` directory:
```
plugins/[category]/[plugin-name]/
└── generators/
    └── architecture.sh
```

Generators follow the same conventions as validators but output content instead of validation results.

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