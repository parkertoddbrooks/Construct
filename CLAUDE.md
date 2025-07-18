# CONSTRUCT Development Guide

## 🎯 What is CONSTRUCT?

CONSTRUCT is an intelligent development system that creates living, self-improving development environments. It combines:
- **Pattern System**: Modular, reusable development patterns
- **Context Engineering**: Auto-updating documentation that keeps AI assistants informed
- **Dual-Environment Architecture**: Separate concerns for CONSTRUCT development vs user projects
- **Promotion Workflow**: Safe path from experimentation (LAB) to stable (CORE)

## 🏗️ Architecture Overview

### Three-Layer System
```
CONSTRUCT/
├── CONSTRUCT-CORE/     # Stable, production-ready tools and patterns
├── CONSTRUCT-LAB/      # Development and experimentation environment
└── Projects/           # Managed user projects (git-independent)
```

### Key Concepts

1. **Pattern System**
   - Patterns live in `CONSTRUCT-CORE/patterns/` (built-in) and `CONSTRUCT-LAB/patterns/` (plugins)
   - Projects configure patterns via `.construct/patterns.yaml`
   - `CLAUDE.md` is generated from patterns, never edited manually

2. **Symlink Architecture**
   - LAB symlinks to CORE for shared functionality
   - Enables independent development while maintaining consistency
   - Promotion workflow updates CORE, symlinks auto-reflect changes

3. **Context Engineering**
   - Dynamic sections auto-update with project state
   - Scripts analyze and report on architecture/quality
   - Pre-commit hooks ensure context stays fresh

4. **Git Independence**
   - CONSTRUCT has its own git repository
   - Each project in `Projects/` maintains independent git
   - Pattern configuration (`.construct/patterns.yaml`) tracked by project

## 🚀 Quick Start

### For CONSTRUCT Development (Working on CONSTRUCT itself)

```bash
# Always work in CONSTRUCT-LAB
cd CONSTRUCT-LAB

# Update context before starting
./CONSTRUCT/scripts/update-context.sh

# Check architecture compliance
./CONSTRUCT/scripts/check-architecture.sh

# Before creating new components
./CONSTRUCT/scripts/before_coding.sh ComponentName

# Promote tested changes to CORE
./CONSTRUCT-LAB/tools/promote-to-core.sh
```

### For User Projects (Using CONSTRUCT)

```bash
# Create new project
./CONSTRUCT-CORE/CONSTRUCT/scripts/create-project.sh MyProject

# Import existing project
./CONSTRUCT-CORE/CONSTRUCT/scripts/import-project.sh ../ExistingProject

# Work with patterns
cd Projects/MyProject
construct-patterns show      # View current patterns
construct-patterns list      # See available patterns
construct-patterns regenerate # Update CLAUDE.md from patterns
```

## 📋 Pattern System

### Pattern Locations
- **CONSTRUCT-CORE/patterns/**: Minimal, universal patterns
- **CONSTRUCT-LAB/patterns/**: Plugin ecosystem (community/personal)
- **Project/.construct/patterns.yaml**: Project configuration

### Working with Patterns

1. **View Available Patterns**
   ```bash
   construct-patterns list
   ```

2. **Configure Project Patterns**
   ```yaml
   # .construct/patterns.yaml
   languages: ["swift", "typescript"]
   plugins: ["tooling/shell-scripting", "cross-platform/model-sync"]
   custom_rules:
     swift:
       - "Always use dependency injection"
   ```

3. **Regenerate CLAUDE.md**
   ```bash
   construct-patterns regenerate
   ```

### Creating Pattern Plugins

1. Create plugin in `CONSTRUCT-LAB/patterns/`
2. Follow structure: `category/plugin-name.md`
3. Test with projects
4. Share without promoting to CORE (LAB is permanent home)

## 🔄 Symlink & Promotion Workflow

### Understanding Symlinks
```bash
# Check symlink integrity
./CONSTRUCT/scripts/check-symlinks.sh

# Active symlinks in LAB point to CORE:
CONSTRUCT -> ../CONSTRUCT-CORE/CONSTRUCT
AI/docs/README-sym.md -> ../../../CONSTRUCT-CORE/AI/docs/README.md
```

### Promotion Process
1. Develop and test in LAB
2. Add to `PROMOTE-TO-CORE.yaml`
3. Run `./CONSTRUCT-LAB/tools/promote-to-core.sh`
4. Validate changes in CORE
5. Commit and clear manifest

### Rules
- ❌ NEVER edit symlinked files directly
- ❌ NEVER manually copy LAB to CORE
- ✅ ALWAYS use promotion workflow
- ✅ ALWAYS test in LAB first

## 🛠️ Key Scripts

### Context Management
- `update-context.sh` - Refreshes CLAUDE.md auto-sections
- `update-architecture.sh` - Updates architecture documentation
- `session-summary.sh` - Creates summary when context fills

### Quality & Validation
- `check-architecture.sh` - Validates patterns and structure
- `check-quality.sh` - Script quality standards
- `check-documentation.sh` - Documentation coverage
- `check-symlinks.sh` - Symlink integrity

### Development Workflow
- `before_coding.sh` - Pre-coding guidance
- `construct-patterns.sh` - Pattern management
- `assemble-claude.sh` - Pattern assembly engine

### Project Management
- `create-project.sh` - Create new CONSTRUCT project
- `import-project.sh` - Import existing project
- `import-component.sh` - Add component to multi-repo project
- `workspace-status.sh` - View all managed projects
- `workspace-update.sh` - Update all project contexts

## 📁 Directory Structure

### CONSTRUCT-CORE (Stable)
```
CONSTRUCT-CORE/
├── CLAUDE.md           # User project template context
├── CLAUDE-BASE.md      # Universal principles
├── CONSTRUCT/          # Core scripts and tools
│   ├── scripts/       # Workflow automation
│   ├── lib/          # Shared functions
│   └── config/       # Configuration files
├── patterns/          # Built-in patterns
│   ├── plugins/      # Pattern categories
│   └── templates/    # Pattern config template
└── TEMPLATES/         # Project templates
```

### CONSTRUCT-LAB (Development)
```
CONSTRUCT-LAB/
├── CLAUDE.md          # CONSTRUCT development context
├── CONSTRUCT@         # Symlink to CORE
├── AI/               # Development artifacts
│   ├── PRDs/        # Product requirements
│   ├── todo/        # Development planning
│   ├── dev-logs/    # Session documentation
│   └── structure/   # Architecture snapshots
├── patterns/         # Plugin ecosystem
└── tools/           # LAB-specific tools
    ├── promote-to-core.sh
    └── validate-promotion.sh
```

## 🔧 Development Patterns

### Shell Script Standards
```bash
#!/bin/bash
set -e  # Always use error handling

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get paths (always relative)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSTRUCT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# Source libraries
source "$CONSTRUCT_ROOT/CONSTRUCT-CORE/CONSTRUCT/lib/common-patterns.sh"

# Document functions
# Purpose: Clear description
# Parameters: $1 - description
# Returns: 0 on success, 1 on failure
function_name() {
    local param="$1"
    # Implementation
}
```

### Configuration-Driven Design
- Rules in YAML files, not hardcoded
- `config/` directory for all configuration
- Scripts read config, don't embed values

### Error Handling
- Check exit codes
- Provide colored feedback
- Validate inputs before processing
- Show helpful error messages

## 🎯 Common Tasks

### Adding a New Pattern Plugin
1. Create in `CONSTRUCT-LAB/patterns/category/name.md`
2. Follow existing pattern structure
3. Test with sample project
4. Document in plugin header

### Importing Multiple Projects
```bash
# Import main project
./import-project.sh https://github.com/user/main MainProject

# Add components
./import-component.sh https://github.com/user/ios MainProject ios
./import-component.sh https://github.com/user/backend MainProject backend
```

### Migrating from Old CONSTRUCT
```bash
# Import handles migration automatically
./import-project.sh ../OldConstructProject

# Check migration notes in output
# Old files backed up to .construct-workspace/import-history/
```

### Creating Custom Patterns
1. Start with project-specific rules in `.construct/patterns.yaml`
2. When patterns prove useful, extract to LAB plugin
3. Share plugin without CORE promotion
4. Community can adopt via pattern configuration

## ⚠️ Important Rules

### Never Break These
1. **Symlink Integrity**: Don't edit symlinked files
2. **Git Independence**: Projects maintain own repositories  
3. **Pattern Generation**: CLAUDE.md is generated, not edited
4. **Relative Paths**: No hardcoded absolute paths
5. **Promotion Process**: Always test in LAB first

### Always Remember
1. **Context Engineering**: Keep AI assistants informed
2. **Documentation**: Auto-generate when possible
3. **Validation**: Run checks before commits
4. **Template Independence**: Don't contaminate user templates
5. **Error Handling**: Every script needs proper errors

## 🚦 Getting Help

### Documentation
- Architecture: `AI/docs/automated/architecture-overview-automated.md`
- Script Reference: `AI/docs/automated/script-reference-automated.md`
- Development Patterns: `AI/docs/automated/development-patterns-automated.md`
- Pattern Guide: `CONSTRUCT-CORE/patterns/PATTERN-GUIDE.md`

### Commands
```bash
# See all available commands
ls CONSTRUCT-CORE/CONSTRUCT/scripts/

# Get help for any script
./script-name.sh --help

# Check current state
construct-update  # Updates context
construct-check   # Validates architecture
```

### Development Flow
1. Start with `update-context.sh`
2. Check violations with `check-architecture.sh`
3. Use `before_coding.sh` before creating
4. Test thoroughly in LAB
5. Promote stable changes to CORE
6. Document decisions in dev-logs

## 🤖 AI Assistant Notes

When working with CONSTRUCT:
1. **Read the room**: Check auto-sections in CLAUDE.md files
2. **Respect symlinks**: Never edit -sym files directly
3. **Use the tools**: Scripts exist for common tasks
4. **Pattern first**: Check if pattern exists before creating
5. **Context matters**: Update context before major work
6. **Test in LAB**: All experiments happen in LAB first

The goal is to create self-improving development environments where AI assistance gets smarter with every commit.
