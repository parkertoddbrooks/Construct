# CONSTRUCT-LAB Community Patterns

This directory contains community-contributed patterns for CONSTRUCT. Unlike CORE patterns (which are minimal and universal), these patterns are maintained by individual developers and the community.

## Directory Structure

```
patterns/
├── parker/              # Parker's personal patterns
├── community/           # Community-maintained patterns  
└── {username}/          # Other developers' patterns
```

## Pattern Ownership

- **CORE patterns**: Maintained by CONSTRUCT team, minimal and universal
- **LAB patterns**: Maintained by individual authors, specialized and diverse
- **No promotion needed**: LAB is the permanent home for community patterns

## Creating a Pattern

1. **Create your namespace**: `mkdir patterns/{your-name}/`
2. **Create pattern file**: `vim patterns/{your-name}/{pattern-name}.md`
3. **Follow format**: Use `[NAMESPACE/PATTERN] Title` header
4. **Test locally**: Add to a project's patterns.yaml
5. **Share**: Others can use `{your-name}/{pattern-name}`

## Pattern Format

```markdown
# [PARKER/RUN-UI] Custom UI Patterns for RUN

## When to Use
- When building RUN-style UI components
- When you need consistent visual hierarchy

## Rules
- ✅ DO: Use TokenSystem for all spacing
- ❌ DON'T: Hardcode visual values

## Examples
[Include code examples]

## Integration
This pattern activates when:
- Working on RUN project
- Using RUN-style UI components
```

## Using Community Patterns

In your project's `.construct/patterns.yaml`:

```yaml
plugins:  # This section lists which patterns to include
  - parker/run-ui-patterns    # Use Parker's RUN patterns
  - community/accessibility   # Use community accessibility patterns
  - alice/coordinator-plus    # Use Alice's coordinator patterns
```

## Pattern Evolution

1. **Discovery in projects** → Custom rules in patterns.yaml
2. **Extract to pattern** → Create reusable LAB pattern file
3. **Share and iterate** → Others use and provide feedback
4. **Maintain and evolve** → Pattern author keeps improving

## Benefits

- **No gatekeeping**: Create patterns without CONSTRUCT approval
- **Personal ownership**: Maintain your own patterns your way  
- **Natural sharing**: Others can opt into your patterns
- **Innovation freedom**: Try new ideas without affecting CORE
- **Community growth**: Build ecosystem of specialized patterns