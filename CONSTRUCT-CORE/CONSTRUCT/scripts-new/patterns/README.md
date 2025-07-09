# CONSTRUCT Pattern Validators

## Purpose

Pattern-specific validation scripts that implement targeted checks for different languages, frameworks, and development patterns.

## Directory Structure

```
patterns/
├── construct-development/    # CONSTRUCT development patterns
│   └── validate-architecture.sh
├── shell-scripting/         # Shell script patterns
│   └── validate-architecture.sh
├── shell-quality/           # Shell script quality
│   └── validate-quality.sh
├── swift-language/          # Swift development
│   └── validate-quality.sh
├── csharp-language/         # C# development
│   └── validate-quality.sh
└── ios-ui-library/          # iOS UI patterns
    └── validate-usage.sh
```

## How Pattern Validators Work

1. **Called by Master Scripts**: Receive PROJECT_DIR as parameter
2. **Pattern-Specific Logic**: Implement checks specific to their domain
3. **Return Exit Codes**: Number of issues found (0 = success)
4. **Focused Validation**: Only check what's relevant to the pattern

## Validator Types

### Architecture Validators (`validate-architecture.sh`)
- Structural patterns and organization
- Dependency management
- Module boundaries
- Naming conventions

### Quality Validators (`validate-quality.sh`)
- Code style and formatting
- Language-specific best practices
- Performance patterns
- Security considerations

### Documentation Validators (`validate-documentation.sh`)
- Comment standards for the language
- API documentation
- README requirements
- Example usage

### Usage Validators (`validate-usage.sh`)
- Correct pattern implementation
- Framework compliance
- Library usage patterns

## Creating New Pattern Validators

1. Create pattern directory: `patterns/your-pattern/`
2. Add validators following naming convention
3. Accept PROJECT_DIR as first parameter
4. Return issue count as exit code
5. Use consistent output formatting

## Example Pattern Validator

```bash
#!/bin/bash
# Pattern-Specific Validator
set -e

PROJECT_DIR="${1:-.}"
ISSUES=0

echo "🔍 Checking your-pattern compliance..."

# Pattern-specific checks
if ! check_something "$PROJECT_DIR"; then
    ((ISSUES++))
fi

exit $ISSUES
```

## Integration

Pattern validators are called by master scripts in `/scripts/`:
- Master scripts handle orchestration
- Pattern validators handle specific checks
- Results bubble up through exit codes