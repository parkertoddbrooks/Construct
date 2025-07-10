# CONSTRUCT

**Supercharge Claude Code with intelligent context engineering**

## The Missing Piece for Claude Code

Claude Code is incredible - developers are [building entire apps](https://www.indragie.com/blog/i-shipped-a-macos-app-built-entirely-by-claude-code) with it, writing less than 5% of the code by hand. But there's a hidden friction: **context switching**.

Real projects aren't monoliths. You're writing SwiftUI one moment, fixing bash scripts the next, then diving into backend APIs. Claude Code is brilliant at each task individually, but it doesn't know when to switch contexts. You ask for help with a pre-commit hook and get Swift patterns. Sound familiar?

## Enter CONSTRUCT: Context Engineering for Claude Code

CONSTRUCT solves this elegantly through what Andrej Karpathy calls ["context engineering"](https://x.com/karpathy/status/1937902205765607626) - the art of filling the context window with exactly the right information for the task at hand.

### How It Works

```yaml
# .construct/patterns.yaml
plugins:
  - languages/swift
  - tooling/shell-scripting
  - architectural/mvvm
  - custom/team-conventions
```

CONSTRUCT dynamically assembles the perfect context for Claude Code based on:
- What file you're editing
- What patterns your project uses
- What task you're performing

No more wrong-language suggestions. No more context bloat. Just the right patterns at the right time.

## Pattern System

Think of patterns as LEGO blocks for AI context:

```
📦 Pattern Plugin
├── 📄 pattern.md        # The rules and examples
├── 🔧 validators/       # Scripts to check compliance
├── 🏗️ generators/       # Scripts to generate docs/code
└── 📋 metadata.yaml     # Pattern description
```

### Core Features

**🎯 Smart Context Assembly**
- Detects what you're working on
- Loads only relevant patterns
- Keeps context window efficient

**🔌 Plugin Ecosystem**
- Discover patterns: `construct registry search swift`
- Install patterns: `construct registry add languages/swift`
- Share your patterns with the community

**🚀 Interactive Scripts**
- Scripts that work seamlessly with Claude Code
- Natural conversation flow ("Rails mode")
- No more copy-pasting commands

**📁 Multi-Repo Support**
- Manage complex projects with ease
- Preserve git history on import
- Works with any project structure

## Quick Start

```bash
# Create a new project
construct create MyApp ios

# Or enhance an existing project
cd my-project
construct init

# Add patterns for your stack
construct registry add languages/typescript
construct registry add frameworks/react
```

## Real-World Example

Working on a full-stack app? CONSTRUCT adapts as you switch contexts:

```
Morning: Working on iOS views
✓ swift-patterns
✓ swiftui-patterns
✓ mvvm-architecture
✗ backend-patterns

Afternoon: Fixing API endpoints
✗ swift-patterns
✓ typescript-patterns
✓ express-patterns
✓ rest-api-patterns
```

Claude Code automatically gets the right context for each task.

## Why Developers Love CONSTRUCT

**"It's like having a senior dev configure Claude Code for each file I touch"**
- No manual context switching
- Consistent patterns across your team
- AI suggestions that actually match your architecture

**"Finally, my bash scripts get bash help, not Swift code"**
- Language-aware context
- Framework-specific patterns
- Tool-specific guidance

## Beyond Cursor Rules

Inspired by tools like [SwiftCatalyst](https://github.com/danielraffel/SwiftCatalyst) but evolved beyond static rules:

| Approach | Setup | Maintenance | Multi-Language | Context Switching |
|----------|-------|-------------|----------------|-------------------|
| `.cursorrules` | Simple | Manual edits | Single context | None |
| SwiftCatalyst | Template | Fork & modify | Swift only | None |
| **CONSTRUCT** | Dynamic | Self-updating | Any language | Automatic |

## Community-Driven

CONSTRUCT patterns grow organically:
1. **Discover** patterns while building
2. **Extract** them as plugins
3. **Share** with the community
4. **Benefit** from others' discoveries

No committees. No "official" patterns. Just what works.

## Philosophy

- **Don't edit the binary**: Generated contexts are read-only
- **Patterns over prompts**: Reusable, testable, shareable
- **Progressive enhancement**: Start simple, add patterns as needed
- **Community first**: Best patterns come from real developers

## Get Started

```bash
# Install CONSTRUCT
curl -fsSL https://construct.dev/install.sh | bash

# Initialize in your project
construct init

# Browse available patterns
construct registry browse
```

## Documentation

- [Pattern Creation Guide](docs/patterns/creating-patterns.md)
- [Interactive Scripts](docs/features/interactive-scripts.md)
- [Multi-Repo Projects](docs/workspace-management.md)
- [Plugin Development](docs/plugins/README.md)

## Requirements

- macOS 12.0+ or Linux
- Git
- Claude Code (or any AI coding assistant)

## The Future of AI-Assisted Development

CONSTRUCT isn't just about making Claude Code better - it's about establishing context engineering as a discipline. As AI models get smarter, the teams that master context engineering will ship faster, with higher quality, and better consistency.

Join us in building the context engineering platform for the AI-first era.

---

**Ready to supercharge your Claude Code experience?** Star this repo and join our [Discord](https://discord.gg/construct) to share patterns and shape the future of AI-assisted development.