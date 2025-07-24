# assemble-claude.sh: Pattern Assembly Engine

This document explains the `assemble-claude.sh` script, CONSTRUCT's pattern assembly engine that creates enhanced CLAUDE.md files by combining base templates with pattern plugins.

## Overview

`assemble-claude.sh` is the core engine that assembles CLAUDE.md files from:
- **CLAUDE-BASE.md**: Universal base template with project-agnostic principles
- **Pattern Plugins**: Modular, reusable patterns for languages, frameworks, and tools
- **Project Context**: Information from `/init` and project-specific patterns

## Purpose

The script solves several key problems:
1. **Pattern Reusability**: Share common patterns across projects
2. **Modular Configuration**: Mix and match patterns as needed
3. **Context Preservation**: Maintain project-specific information
4. **Version Control**: Track pattern changes independently

## How It Works

### Input Parameters
```bash
assemble-claude.sh <project_directory> <plugin_list>

# Example:
assemble-claude.sh /path/to/project "languages/swift,frameworks/swiftui,platforms/ios"
```

### Assembly Process

1. **Load Base Template**
   - Reads `CLAUDE-BASE.md` as foundation
   - Contains universal principles and structure

2. **Process Pattern Plugins**
   - Parses comma-separated plugin list
   - Loads each plugin from pattern directories
   - Handles both CORE and LAB plugins

3. **Inject Patterns**
   - Replaces injection markers with pattern content
   - Preserves formatting and structure
   - Handles missing patterns gracefully

4. **Add Metadata**
   - Timestamps generation
   - Lists included patterns
   - Adds source information

### Output
- Generates `CLAUDE.md` in project directory
- Sets read-only permissions (444)
- Creates backup if file exists

## Pattern Plugin System

### Plugin Structure
```
patterns/
├── plugins/
│   ├── languages/
│   │   ├── swift/
│   │   │   ├── swift.md        # Main pattern content
│   │   │   ├── swift.yaml      # Pattern metadata
│   │   │   └── injections/     # Additional sections
│   │   └── python/
│   ├── frameworks/
│   │   ├── swiftui/
│   │   └── django/
│   └── platforms/
│       ├── ios/
│       └── web/
```

### Pattern Types

1. **Built-in Patterns** (CONSTRUCT-CORE)
   - Essential, universal patterns
   - Maintained by CONSTRUCT team
   - Stable and well-tested

2. **Lab Patterns** (CONSTRUCT-LAB)
   - Experimental or specialized patterns
   - Community contributions
   - Project-specific patterns

3. **Extracted Patterns**
   - Generated from existing CLAUDE.md
   - Project-specific knowledge
   - Preserved during migration

### Pattern Loading Order
1. Check for extracted patterns first
2. Look in CONSTRUCT-LAB patterns
3. Fall back to CONSTRUCT-CORE patterns
4. Skip if pattern not found

## Pattern Format

### Main Pattern File (`pattern.md`)
```markdown
# Pattern Name

## Overview
Brief description of the pattern...

## Best Practices
- Practice 1
- Practice 2

## Anti-patterns
- What not to do

## Code Examples
\```language
// Example code
\```
```

### Pattern Metadata (`pattern.yaml`)
```yaml
id: languages/swift
name: Swift Language Patterns
description: Best practices for Swift development
version: 1.0
tags:
  - language
  - ios
  - macos
dependencies:
  - platforms/ios  # Optional dependencies
injections:
  - guidelines     # Additional sections to inject
```

### Injection Sections (`injections/`)
Additional content sections that can be injected:
- `guidelines.md` - Development guidelines
- `commands.md` - Common commands
- `structure.md` - Project structure patterns

## Integration with init-construct.sh

The script integrates seamlessly with `init-construct.sh`:

1. **Pattern Detection**
   - init-construct analyzes project
   - Detects languages, frameworks, platforms
   - Builds recommended pattern list

2. **Pattern Configuration**
   - Saves selections to `.construct/patterns.yaml`
   - Allows manual overrides
   - Supports custom patterns

3. **Assembly Invocation**
   - init-construct calls assemble-claude.sh
   - Passes project path and pattern list
   - Handles errors gracefully

## Advanced Features

### Conditional Injection
Patterns can include conditional sections:
```markdown
<!-- IF:platform=ios -->
iOS-specific content...
<!-- /IF:platform=ios -->
```

### Variable Substitution
Support for project variables:
```markdown
Project: {{PROJECT_NAME}}
Author: {{AUTHOR}}
```

### Pattern Composition
Patterns can include other patterns:
```markdown
<!-- INCLUDE:patterns/shared/logging -->
```

### Custom Injections
Projects can define custom injection points:
```markdown
<!-- INJECT:custom/security-rules -->
<!-- /INJECT:custom/security-rules -->
```

## Usage Examples

### Basic Usage
```bash
# Single pattern
./assemble-claude.sh /path/to/project "languages/python"

# Multiple patterns
./assemble-claude.sh /path/to/project "languages/swift,frameworks/swiftui,platforms/ios"
```

### With Extracted Patterns
```bash
# Uses extracted patterns if available
./assemble-claude.sh /path/to/project "extracted-myproject,languages/python"
```

### Custom Pattern Path
```bash
# Set custom pattern directory
PATTERN_DIR=/custom/patterns ./assemble-claude.sh /path/to/project "custom/pattern"
```

## Error Handling

The script handles various error conditions:

1. **Missing Patterns**
   - Logs warning
   - Continues with available patterns
   - Lists missing patterns in output

2. **Invalid YAML**
   - Falls back to pattern directory name
   - Continues processing
   - Logs parsing errors

3. **File Permissions**
   - Checks write permissions
   - Creates directories if needed
   - Sets appropriate permissions

4. **Circular Dependencies**
   - Detects circular includes
   - Prevents infinite loops
   - Logs dependency issues

## Configuration

### Environment Variables
- `CONSTRUCT_ROOT`: Override CONSTRUCT location
- `PATTERN_DIR`: Custom pattern directory
- `DEBUG`: Enable debug output
- `NO_BACKUP`: Skip backup creation

### Configuration File
`.construct/config.yaml`:
```yaml
assembly:
  backup: true
  read_only: true
  metadata: true
  inject_all: false
```

## Best Practices

### Creating Patterns

1. **Keep Patterns Focused**
   - Single responsibility
   - Clear scope
   - Minimal dependencies

2. **Use Clear Structure**
   - Consistent headings
   - Logical organization
   - Good examples

3. **Document Thoroughly**
   - Purpose and usage
   - Prerequisites
   - Common pitfalls

### Pattern Organization

1. **Categorize Properly**
   - languages/ for language-specific
   - frameworks/ for framework patterns
   - platforms/ for platform-specific
   - tooling/ for development tools

2. **Version Patterns**
   - Include version in metadata
   - Document breaking changes
   - Maintain compatibility

3. **Test Patterns**
   - Verify with real projects
   - Check edge cases
   - Validate assembly output

## Troubleshooting

### Common Issues

1. **Pattern Not Found**
   ```
   Warning: Pattern 'languages/unknown' not found
   ```
   - Check pattern exists
   - Verify path spelling
   - Check CONSTRUCT_ROOT

2. **Invalid Injection Marker**
   ```
   Error: Unclosed injection marker
   ```
   - Verify marker syntax
   - Check for typos
   - Ensure proper closing

3. **Permission Denied**
   ```
   Error: Cannot write CLAUDE.md
   ```
   - Check directory permissions
   - Remove existing read-only file
   - Run with appropriate user

### Debug Mode

Enable detailed output:
```bash
DEBUG=1 ./assemble-claude.sh /project "patterns"
```

Shows:
- Pattern loading process
- Injection operations
- File operations
- Variable substitutions

## Extending the System

### Adding New Pattern Types

1. Create new category directory
2. Follow naming conventions
3. Include README.md
4. Update pattern registry

### Custom Assembly Logic

Override assembly behavior:
```bash
# Custom assembly script
./custom-assemble.sh --base my-base.md --output custom.md
```

### Integration with CI/CD

```yaml
# GitHub Actions example
- name: Assemble CLAUDE.md
  run: |
    ./assemble-claude.sh . "${{ env.PATTERNS }}"
    git add CLAUDE.md
    git commit -m "Update CLAUDE.md with patterns"
```

## See Also

- [Pattern Guide](../../CONSTRUCT-CORE/patterns/README.md) - Creating patterns
- [init-construct.md](init-construct-enhanced.md) - Full integration
- [claude-base-template.md](../core/claude-base-template.md) - Base template docs