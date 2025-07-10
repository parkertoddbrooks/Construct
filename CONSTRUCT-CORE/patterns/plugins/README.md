# Pattern Plugins

Modular, reusable patterns that can be mixed and matched for different project types.

## Categories
- `architectural/` - Architecture patterns (MVVM, etc.)
- `cross-platform/` - Multi-platform development patterns
- `frameworks/` - Framework-specific patterns (SwiftUI, etc.)
- `languages/` - Language-specific patterns and rules
- `platforms/` - Platform-specific patterns (iOS, Android, etc.)
- `tooling/` - Development tool patterns (shell, error handling, etc.)

## Usage
Projects specify which patterns to include via `.construct/patterns.yaml`. Patterns are combined to generate project-specific CLAUDE.md with only relevant context.

## Pattern Format
Each `.md` file contains rules, examples, and anti-patterns in a standardized format that AI assistants can understand and enforce.