# CONSTRUCT

An intelligent development system for Apple platforms that transforms how teams build Swift applications with AI assistance.

## What is CONSTRUCT?

CONSTRUCT provides a living development environment that grows smarter with every line of code you write. Unlike static templates or rule files, CONSTRUCT actively learns from your project's evolution and ensures your AI coding assistant always has perfect context.

### The Problem with Current AI Development

When using AI tools like Claude Code or Cursor for Swift development:
- **Static rules get stale** - Your `.cursorrules` or templates don't evolve with your project
- **AI lacks context** - Each session starts fresh, missing your project's specific patterns
- **Team knowledge silos** - AI interactions are per-user and invisible to the team
- **Architecture drift** - No enforcement of patterns across AI-assisted development

### How CONSTRUCT Solves This

CONSTRUCT creates a **living development system** that:
- Automatically updates AI context as your codebase evolves
- Enforces Swift best practices and MVVM architecture in real-time
- Captures team discoveries and makes them permanent
- Provides transparency for all AI-assisted development

## Quick Start

[Installation instructions coming soon]

## Core Features

### 1. Living AI Context
Your `CLAUDE.md` file auto-updates with:
- Current component inventory (prevents duplicates)
- Architecture violations to avoid
- Team-discovered patterns and solutions
- Project-specific conventions

### 2. Architecture Enforcement
Real-time validation of:
- MVVM pattern compliance
- SwiftUI best practices
- Design token usage
- Dependency management

### 3. Team Transparency
- All architectural decisions are visible
- AI discoveries become team knowledge
- Quality standards travel with the code
- Every fork maintains the same standards

## How It Works

### With Static Templates (Traditional)
```
Template → Copy → Diverge → Drift → Inconsistency
```
Your AI assistant only knows generic Swift patterns.

### With CONSTRUCT (Living System)
```
Template → Initialize → Develop → Learn → Improve
```
Your AI assistant learns your specific patterns and enforces them.

## Integration with Claude Code

CONSTRUCT complements Claude Code's features:

| Claude Code Feature | CONSTRUCT Enhancement |
|-------------------|---------------------|
| `/init` command | Pre-configured with your project patterns |
| Custom hooks | Architecture validation hooks included |
| Context management | Auto-updating context files |
| Team settings | Shared architectural decisions |

## For Development Teams

CONSTRUCT ensures that whether developers use Claude Code, Cursor, or GitHub Copilot:
- Everyone follows the same architectural patterns
- AI suggestions align with team standards
- Knowledge discovered by one developer benefits all
- Code quality remains consistent

## Technical Architecture

### Three-Layer System
- **CONSTRUCT-CORE**: Stable tools and templates
- **CONSTRUCT-LAB**: Experimentation and improvement space
- **TEMPLATES**: Production-ready Swift project templates

### Quality Control
Every change goes through:
1. Local development and testing
2. Automated validation
3. Explicit promotion to stable
4. Team-wide propagation

## Comparison with Alternatives

| Approach | Initial Setup | Ongoing Maintenance | Team Sync | AI Context |
|----------|--------------|-------------------|-----------|------------|
| Static templates (SwiftCatalyst) | Quick | Manual updates | Copy/paste | Generic |
| `.cursorrules` | Simple | Edit per project | Git conflicts | Static |
| **CONSTRUCT** | Guided | Self-updating | Automatic | Evolving |

## Documentation

- [Getting Started Guide](docs/getting-started.md)
- [Architecture Patterns](docs/architecture.md)
- [Team Workflow](docs/team-workflow.md)
- [AI Integration](docs/ai-integration.md)

## Requirements

- macOS 12.0+
- Xcode 14.0+
- Swift 5.7+
- Git

## Support

- **Issues**: [GitHub Issues](https://github.com/parkertoddbrooks/CONSTRUCT/issues)
- **Discussions**: [GitHub Discussions](https://github.com/parkertoddbrooks/CONSTRUCT/discussions)
- **Documentation**: [Full Docs](docs/README.md)

---

CONSTRUCT is not just another template—it's a development philosophy that makes AI-assisted coding more intelligent, consistent, and team-friendly.