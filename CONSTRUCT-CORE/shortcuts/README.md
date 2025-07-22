# CONSTRUCT Claude Shortcuts

This directory contains Claude Code shortcuts that enhance your CONSTRUCT workflow. These shortcuts provide quick access to common CONSTRUCT operations directly from Claude.

## 🚀 Quick Start

Install all CONSTRUCT shortcuts:

```bash
./install-shortcuts.sh
```

This will create symlinks in `~/.config/claude/shortcuts/` pointing to the shortcuts in this directory.

## 📦 Available Shortcuts

### `/init-construct`
Transforms any project into a fully CONSTRUCT-enabled environment. This shortcut:
- Verifies Claude SDK installation
- Analyzes your project structure
- Installs CONSTRUCT infrastructure
- Extracts patterns from existing CLAUDE.md
- Detects technologies and recommends patterns
- Enhances your CLAUDE.md with the pattern system

**Usage**: Run from any project directory containing a CLAUDE.md file.

## 🛠️ How Shortcuts Work

Claude Code shortcuts are markdown files stored in `~/.config/claude/shortcuts/`. When you type a command starting with `/`, Claude looks for a matching `.md` file in that directory.

Each shortcut file contains:
1. A description of what the shortcut does
2. A "Task" section that Claude executes

## 📝 Creating New Shortcuts

To add a new CONSTRUCT shortcut:

1. Create a new `.md` file in the `claude/` subdirectory
2. Follow this template:

```markdown
# Shortcut Name

Brief description of what this shortcut does.

## What This Does

- Bullet points explaining the shortcut's functionality
- Be specific about what happens
- Include any prerequisites

## Usage

Explain when and how to use this shortcut.

## Task

[Instructions for Claude to execute]
```

3. Run `./install-shortcuts.sh` to install your new shortcut

## 🔧 Manual Installation

If you prefer to install shortcuts manually:

```bash
# Create Claude shortcuts directory
mkdir -p ~/.config/claude/shortcuts

# Symlink individual shortcuts
ln -s /path/to/CONSTRUCT/CONSTRUCT-CORE/shortcuts/claude/init-construct.md ~/.config/claude/shortcuts/

# Or copy them
cp /path/to/CONSTRUCT/CONSTRUCT-CORE/shortcuts/claude/*.md ~/.config/claude/shortcuts/
```

## 🤝 Contributing

When adding new shortcuts:
1. Ensure they follow CONSTRUCT principles
2. Test thoroughly before committing
3. Update this README with the new shortcut description
4. Consider if the shortcut should be in CORE (stable) or LAB (experimental)

## 📋 Shortcut Guidelines

- **Naming**: Use clear, action-oriented names (e.g., `/init-construct`, `/update-patterns`)
- **Scope**: Shortcuts should focus on CONSTRUCT-specific operations
- **Safety**: Always validate inputs and provide clear error messages
- **Documentation**: Each shortcut must have clear documentation in its file

## 🔗 Integration with CONSTRUCT

These shortcuts are designed to work seamlessly with CONSTRUCT's:
- Pattern system
- Context engineering
- Project management tools
- Development workflows

They respect CONSTRUCT's core principles:
- Git independence
- Pattern-driven development
- Symlink architecture
- LAB/CORE separation