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
        └── validators/             # 🚨 MANDATORY validators
```

## 🚨 CRITICAL: Validator Requirement

**Every plugin and injection MUST have validators**. This is not optional:

- **No pattern without enforcement** - If you can't validate it, don't document it
- **Validators must be executable** and follow exit code standards (0=success, >0=issues)
- **Injections need validators** in their own `validators/` directory
- **Clear feedback required** - Validators must explain what violations they found

## Categories

You can use any category that makes sense for your project:
- `custom/` - Project-specific patterns
- `experimental/` - Patterns being tested
- `overrides/` - Patterns that override CORE patterns
- `injections/` - Small focused improvements to existing patterns
- Or create your own categories

## Injections

**Injections** are small, focused pattern additions that extend existing CORE patterns without replacing them. They're perfect for:
- Adding newly discovered best practices
- Extending patterns with project-specific requirements
- Documenting architectural decisions learned through development

**🚨 MANDATORY**: Every injection must include a `validators/` directory with enforcement scripts.

Example: `tooling/shell-scripting/injections/consistency-standards` adds interface consistency requirements to shell scripting patterns and includes `validators/interface-consistency.sh` to enforce them.

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
./CONSTRUCT/scripts/core/check-quality.sh .
```