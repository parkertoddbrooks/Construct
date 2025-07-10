# LAB Pattern Plugins

This directory contains pattern plugins being developed for your project. These plugins can override or extend CORE patterns.

## Structure

Each plugin follows the same structure as CORE plugins:
```
plugins/
└── [category]/
    └── [plugin-name]/
        ├── [plugin-name].md        # Pattern rules
        ├── [plugin-name].yaml      # Metadata
        └── validators/             # Optional validators
```

## Categories

You can use any category that makes sense for your project:
- `custom/` - Project-specific patterns
- `experimental/` - Patterns being tested
- `overrides/` - Patterns that override CORE patterns
- Or create your own categories

## Development Tips

1. **Copy from CORE** - Start by copying a similar CORE pattern as a template
2. **Test incrementally** - Add rules gradually and test each one
3. **Use validators** - Write validators to enforce your patterns
4. **Document examples** - Show both good and bad code examples

## Override CORE Patterns

To override a CORE pattern, create a plugin with the same path:
```
# To override CORE's languages/swift:
patterns/plugins/languages/swift/swift.md
patterns/plugins/languages/swift/swift.yaml
```

LAB patterns take precedence over CORE patterns with the same path.

## Local Testing

Test your patterns by adding them to `.construct/patterns.yaml`:
```yaml
plugins:
  # Your local pattern
  - custom/my-pattern
```

Then run validators:
```bash
./scripts-new/core/check-quality.sh
```