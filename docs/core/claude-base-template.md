# CLAUDE-BASE.md: The Foundation Template

This document explains CLAUDE-BASE.md, the foundational template that serves as the starting point for all CONSTRUCT-enhanced CLAUDE.md files.

## Overview

CLAUDE-BASE.md is the universal foundation template containing:
- Core development principles
- AI collaboration guidelines  
- Universal best practices
- Injection markers for patterns
- Structure for dynamic content

## Purpose

The base template provides:
1. **Consistency**: Same foundation across all projects
2. **Universality**: Language-agnostic principles
3. **Extensibility**: Injection points for patterns
4. **Maintainability**: Single source of truth

## Template Structure

### Core Sections

1. **Header**
   ```markdown
   # CLAUDE.md - AI Development Guidelines
   
   This file provides guidance to Claude Code and other AI assistants...
   ```

2. **Universal Principles**
   - Code quality standards
   - Development best practices
   - AI collaboration guidelines
   - General conventions

3. **Injection Markers**
   ```markdown
   <!-- INJECT:languages/[language]/rules -->
   <!-- /INJECT:languages/[language]/rules -->
   ```

4. **Dynamic Sections**
   - Project structure placeholder
   - Development commands placeholder
   - Architecture overview placeholder

### Injection Points

The template includes markers for:
- Language-specific rules
- Framework conventions
- Platform guidelines
- Tool configurations
- Custom patterns

## How It Works

### 1. Template Processing

When `assemble-claude.sh` runs:
1. Loads CLAUDE-BASE.md as foundation
2. Processes injection markers
3. Inserts pattern content
4. Adds project-specific content
5. Generates final CLAUDE.md

### 2. Injection System

Markers follow the format:
```markdown
<!-- INJECT:category/subcategory/section -->
Content gets injected here
<!-- /INJECT:category/subcategory/section -->
```

### 3. Content Priority

1. **Base Content**: Universal principles
2. **Pattern Content**: Language/framework rules
3. **Project Content**: Extracted patterns
4. **Custom Content**: User overrides

## Template Sections

### Header Section
```markdown
# CLAUDE.md - AI Development Guidelines

This file helps AI assistants understand and work with your project...

Generated: [timestamp]
Pattern System: [active patterns]
```

### Core Principles
```markdown
## Universal Development Principles

### Code Quality
- Clear, self-documenting code
- Consistent style and conventions
- Comprehensive error handling
...
```

### Pattern Injection Areas
```markdown
## Language Guidelines
<!-- INJECT:languages/[detected]/guidelines -->
<!-- /INJECT:languages/[detected]/guidelines -->

## Framework Patterns  
<!-- INJECT:frameworks/[detected]/patterns -->
<!-- /INJECT:frameworks/[detected]/patterns -->
```

### Project-Specific Areas
```markdown
## Project Architecture
<!-- PROJECT:architecture -->
[Extracted from existing CLAUDE.md]
<!-- /PROJECT:architecture -->

## Development Workflow
<!-- PROJECT:workflow -->
[Extracted from existing CLAUDE.md]
<!-- /PROJECT:workflow -->
```

## Customization

### Adding Injection Points

1. **In CLAUDE-BASE.md**:
   ```markdown
   ## New Section
   <!-- INJECT:category/pattern/section -->
   <!-- /INJECT:category/pattern/section -->
   ```

2. **In Pattern File**:
   ```markdown
   ## section
   Content to inject...
   ```

### Overriding Base Content

Projects can override base sections:
```yaml
# .construct/patterns.yaml
overrides:
  core_principles:
    code_quality: "custom-rules.md"
```

## Best Practices

### Template Design

1. **Keep It Universal**
   - No language-specific content
   - No framework assumptions
   - No tool dependencies

2. **Clear Injection Points**
   - Descriptive marker names
   - Logical categorization
   - Document injection behavior

3. **Sensible Defaults**
   - Provide fallback content
   - Handle missing patterns
   - Graceful degradation

### Content Organization

1. **Hierarchical Structure**
   - General → Specific
   - Core → Patterns → Project
   - Required → Optional

2. **Clear Sections**
   - Distinct boundaries
   - Logical grouping
   - Navigation aids

## Maintenance

### Updating CLAUDE-BASE.md

1. **Location**: `CONSTRUCT-CORE/CLAUDE-BASE.md`
2. **Process**:
   - Update in CORE
   - Test with projects
   - Verify injections work
   - Document changes

### Version Compatibility

- Base template versioned with CONSTRUCT
- Backward compatible markers
- Graceful handling of new sections
- Migration guides for major changes

## Examples

### Basic Project
```markdown
# CLAUDE.md - AI Development Guidelines

[Base content...]

## Language Guidelines
<!-- INJECT:languages/python/guidelines -->
Python best practices...
<!-- /INJECT:languages/python/guidelines -->

## Project Structure
<!-- PROJECT:structure -->
src/
├── main.py
└── utils/
<!-- /PROJECT:structure -->
```

### Multi-Language Project
```markdown
## Language Guidelines

### Python
<!-- INJECT:languages/python/guidelines -->
...
<!-- /INJECT:languages/python/guidelines -->

### JavaScript  
<!-- INJECT:languages/javascript/guidelines -->
...
<!-- /INJECT:languages/javascript/guidelines -->
```

### Custom Patterns
```markdown
## Custom Domain Rules
<!-- INJECT:custom/finance/compliance -->
Financial compliance requirements...
<!-- /INJECT:custom/finance/compliance -->
```

## Troubleshooting

### Common Issues

1. **Missing Injections**
   - Check pattern exists
   - Verify marker format
   - Check pattern registry

2. **Duplicate Content**
   - Review injection markers
   - Check pattern conflicts
   - Verify assembly order

3. **Formatting Issues**
   - Validate markdown syntax
   - Check indentation
   - Review special characters

### Debug Mode

Enable debug output:
```bash
DEBUG=1 ./assemble-claude.sh project/path patterns
```

Shows:
- Pattern loading
- Injection processing
- Content assembly
- Final validation

## See Also

- [assemble-claude.md](../features/assemble-claude.md) - Assembly process
- [Pattern System](../../CONSTRUCT-CORE/patterns/README.md) - Pattern documentation
- [init-construct.md](../features/init-construct-enhanced.md) - Integration flow