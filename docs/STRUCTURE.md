# CONSTRUCT Directory Structure

Last updated: 2025-07-21

## Overview

This document shows the current directory structure of CONSTRUCT. For detailed documentation, see [DOCS-INDEX.md](DOCS-INDEX.md).

## Directory Tree

```
CONSTRUCT/
├── .construct/                         # CONSTRUCT's own project configuration
│   └── patterns.yaml                  # Active patterns for CONSTRUCT development
│
├── .construct-workspace/              # Workspace management (for imported projects)
│   ├── registry.yaml                 # Tracks all imported projects
│   └── import-history/               # Backups from project migrations
│
├── CONSTRUCT-CORE/                    # Stable, production-ready code
│   ├── CLAUDE-BASE.md                # Universal base patterns (language-agnostic)
│   ├── CLAUDE.md                     # iOS-specific patterns (being refactored)
│   │
│   ├── CONSTRUCT/                    # Core CONSTRUCT system
│   │   ├── adapters/                 # Init system adapters
│   │   ├── config/                   # Configuration files
│   │   ├── lib/                      # Shared shell libraries
│   │   ├── orchestrator/             # Pattern orchestration system
│   │   └── scripts/                  # All CONSTRUCT scripts
│   │       ├── construct/            # CONSTRUCT-specific tools
│   │       ├── core/                 # Core validation scripts
│   │       ├── dev/                  # Development workflow scripts
│   │       └── workspace/            # Workspace management scripts
│   │
│   ├── patterns/                     # Pattern system
│   │   ├── lib/                      # Pattern utilities (future)
│   │   ├── plugins/                  # All pattern plugins
│   │   │   ├── registry.yaml         # Auto-generated plugin registry
│   │   │   ├── architectural/        # Architecture patterns
│   │   │   ├── cross-platform/       # Cross-platform patterns
│   │   │   ├── frameworks/           # Framework-specific patterns
│   │   │   ├── languages/            # Language-specific patterns
│   │   │   ├── platforms/            # Platform-specific patterns
│   │   │   ├── tooling/              # Development tooling patterns
│   │   │   ├── ui/                   # UI and design patterns
│   │   │   ├── performance/          # Performance optimization patterns
│   │   │   ├── quality/              # Quality and standards patterns
│   │   │   └── configuration/        # Configuration patterns
│   │   └── templates/                # Configuration templates
│   │       ├── patterns.yaml         # Template for project patterns
│   │       └── project-sets.yaml     # Pre-configured project types
│   │
│   └── TEMPLATES/                    # Project and component templates
│       ├── component-templates/      # Reusable component structures
│       │   ├── ai-structure/         # AI folder template
│       │   ├── ci-cd/               # CI/CD templates
│       │   └── construct-integration/ # CONSTRUCT integration files
│       └── project-templates/        # Full project templates
│           └── swift-ios+watch/      # iOS + Watch app template
│
├── CONSTRUCT-LAB/                    # Experimental features and development
│   ├── .construct/                   # LAB's own patterns configuration
│   ├── AI/                          # Development context (for CONSTRUCT itself)
│   │   ├── dev-logs/                # Development logs
│   │   ├── docs/                    # Project development docs
│   │   ├── PRDs/                    # Product requirement documents
│   │   ├── structure/               # Structure snapshots
│   │   └── todo/                    # Task management
│   ├── CONSTRUCT -> ../CONSTRUCT-CORE/CONSTRUCT  # Symlink to scripts
│   ├── experiments/                  # Experimental features
│   └── patterns/                     # LAB pattern development
│       └── plugins/                  # Project-specific plugins
│
├── Projects/                         # Imported projects (via import-project.sh)
│   └── [imported projects will appear here]
│
├── docs/                            # CONSTRUCT system documentation
│   ├── ARCHITECTURE-CHEATSHEET/     # Quick architecture reference
│   ├── core/                        # Core system documentation
│   │   ├── workspace-management.md  # .construct vs .construct-workspace
│   │   ├── distributed-quality-*.md # Quality philosophy
│   │   └── promotion-system-*.md    # LAB to CORE promotion
│   └── features/                    # Feature documentation
│       ├── interactive-scripts.md   # Script interactivity
│       └── repository-context.md    # Context management
│
└── tools/                           # Development tools
    └── [various development utilities]
```

## Key Directories Explained

### CONSTRUCT-CORE
- **Purpose**: Stable, tested, production-ready code
- **Promotion**: Code promoted from LAB after validation
- **Stability**: Changes require careful review

### CONSTRUCT-LAB
- **Purpose**: Experimental features and active development
- **Testing**: Where new ideas are tried
- **Promotion**: Successful experiments move to CORE

### patterns/plugins/
- **Structure**: category/plugin-name/
- **Contents**: Each plugin contains:
  - `{name}.md` - Pattern documentation
  - `{name}.yaml` - Plugin metadata
  - `validators/` - Pattern validation scripts
  - `generators/` - Documentation generators

### scripts/
- **construct/**: CONSTRUCT-specific tools (assemble-claude, update-context)
- **core/**: Core validation (check-quality, check-architecture)
- **dev/**: Development workflow (session-summary, commit-with-review)
- **workspace/**: Multi-project management (import-project, create-project)

## Configuration Files

### Project Level
- `.construct/patterns.yaml` - Defines active patterns for a project

### Workspace Level
- `.construct-workspace/registry.yaml` - Tracks imported projects
- `patterns/plugins/registry.yaml` - Available plugins catalog
- `patterns/templates/project-sets.yaml` - Project type templates

## Recent Changes (2025-07-21)

1. **Enhanced Pattern Categories**: Expanded from 6 to 10 categories for comprehensive project support
2. **Claude SDK Integration**: AI-native intelligent pattern extraction using Claude SDK
3. **Pattern Enhancement**: Added ui/, performance/, quality/, and configuration/ categories
4. **Project Recovery**: Completed Phase 2A of CONSTRUCT recovery plan with enhanced categorization
5. **Cross-Platform Support**: Bash 3+ compatibility for macOS, Linux, and Windows WSL