# CONSTRUCT-LAB Patterns Directory

This directory is for **project-specific pattern development**. When working on your project in CONSTRUCT-LAB, you can develop and test custom patterns here before optionally sharing them.

## Directory Structure

```
patterns/
├── plugins/             # Your project's local pattern plugins
├── experiments/         # Experimental patterns being tested
├── community/           # (Legacy - will be removed)
├── parker/              # (Legacy - will be removed)
└── README.md           # This file
```

## Purpose

This is NOT a community patterns directory. Instead, it's where you:
1. **Develop** patterns specific to your project
2. **Test** patterns before they're ready for distribution
3. **Override** or extend CORE patterns for your needs
4. **Package** patterns for sharing as separate repositories

## Creating Local Patterns

To create a pattern for your project:

```bash
# Create plugin structure
mkdir -p patterns/plugins/[category]/[plugin-name]/validators

# Create pattern file
vim patterns/plugins/[category]/[plugin-name]/[plugin-name].md

# Create metadata
vim patterns/plugins/[category]/[plugin-name]/[plugin-name].yaml

# Optionally add validators
vim patterns/plugins/[category]/[plugin-name]/validators/quality.sh
```

## Using Local Patterns

In your project's `.construct/patterns.yaml`:

```yaml
plugins:
  # CORE patterns
  - languages/swift
  - frameworks/swiftui
  
  # Your local patterns (from LAB)
  - custom/my-ui-library
  - experimental/new-architecture
```

## Pattern Development Workflow

1. **Start Local** - Develop pattern in your LAB patterns/plugins/
2. **Test Thoroughly** - Use in your project, refine rules
3. **Package** - Create complete plugin with docs and validators
4. **Share** (Optional) - Publish as separate repository

## Sharing Patterns

When your pattern is ready to share:

1. **Create Repository** - New repo for your pattern plugin
2. **Copy Plugin** - Copy complete plugin folder to new repo
3. **Add Installation** - Document how others can use it
4. **Version** - Use semantic versioning for releases

Example shared pattern repository:
```
my-awesome-pattern/
├── README.md
├── my-awesome-pattern.md
├── my-awesome-pattern.yaml
├── validators/
│   ├── quality.sh
│   └── architecture.sh
├── examples/
│   ├── good/
│   └── bad/
└── tests/
```

## Relationship to CORE

- **CORE patterns** - Universal, stable patterns shipped with CONSTRUCT
- **LAB patterns** - Your project-specific patterns in development
- **External patterns** - Published pattern repositories others can use

LAB patterns can:
- Override CORE patterns (LAB takes precedence)
- Extend CORE patterns (via dependencies)
- Be completely independent

## Testing Your Patterns

Once you've created a pattern plugin, test it:

```bash
# Run quality checks (if you have a quality validator)
./CONSTRUCT/scripts/core/check-quality.sh

# Run architecture checks (if you have an architecture validator)  
./CONSTRUCT/scripts/core/check-architecture.sh

# Run documentation checks (if you have a documentation validator)
./CONSTRUCT/scripts/core/check-documentation.sh
```

The core scripts will automatically find and run your validators based on your `.construct/patterns.yaml` configuration.

## Best Practices

1. **Start Simple** - Basic pattern file first, add validators later
2. **Test Locally** - Ensure pattern works in your project
3. **Document Well** - Clear examples of good/bad patterns
4. **Version Carefully** - Don't break compatibility unnecessarily
5. **Share Thoughtfully** - Only share truly reusable patterns

## Migration from Old Structure

The old community/parker structure is being phased out in favor of:
- Local development in `plugins/` directory
- Publishing patterns as separate repositories
- No more username-based directories in CONSTRUCT-LAB

This allows for better separation between:
- CONSTRUCT development (happens here in LAB)
- Pattern sharing (happens in external repos)