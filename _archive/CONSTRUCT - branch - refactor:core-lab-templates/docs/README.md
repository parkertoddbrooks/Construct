# CONSTRUCT Documentation

Welcome to the CONSTRUCT documentation. This directory contains comprehensive documentation for the CONSTRUCT pattern framework.

## 🆕 What's New (2025-07-10)

### Major Updates
- **Scripts Reorganization Complete** - Migrated from `scripts-new/` to organized `scripts/` structure
- **Plugin Registry System** - Auto-generated catalog of all available plugins
- **New Documentation** - Added workspace management guide and comprehensive indices
- **Bug Fixes** - Fixed --help handling and plugin path resolution

[See full changelog →](DOCS-INDEX.md#-whats-new-2025-07-10)

## 📚 Documentation Guides

### Quick Start
- [**DOCS-INDEX.md**](DOCS-INDEX.md) - Complete documentation index (start here!)
- [**STRUCTURE.md**](STRUCTURE.md) - Current directory structure
- [**README-INDEX.md**](README-INDEX.md) - Index of all README files

### Key Topics
- [Workspace Management](core/workspace-management.md) - Understanding `.construct/` vs `.construct-workspace/`
- [Interactive Scripts](features/interactive-scripts.md) - Script capabilities and Rails mode
- [Architecture Cheatsheet](ARCHITECTURE-CHEATSHEET/) - Quick reference guide

## 📁 Documentation Structure

```
docs/
├── README.md                    # This file
├── DOCS-INDEX.md               # Complete documentation index
├── STRUCTURE.md                # Directory structure reference
├── README-INDEX.md             # Index of all README files
│
├── core/                       # Core system documentation
│   ├── README.md              # Core docs index
│   ├── workspace-management.md # Project vs workspace config
│   ├── distributed-quality-*.md # Quality philosophy
│   └── promotion-system-*.md   # LAB to CORE promotion
│
├── features/                   # Feature documentation
│   ├── interactive-scripts.md  # Script interactivity
│   └── repository-context.md   # Context management
│
└── ARCHITECTURE-CHEATSHEET/    # Quick architecture reference
```

## 🔍 Finding Documentation

### By Topic
- **Getting Started** → [Main README](../README.md)
- **Pattern System** → [Patterns README](../CONSTRUCT-CORE/patterns/README.md)
- **Script Usage** → [Scripts README](../CONSTRUCT-CORE/CONSTRUCT/scripts/README.md)
- **Creating Projects** → [Workspace Management](core/workspace-management.md)

### By Component
- **Patterns** → `../CONSTRUCT-CORE/patterns/plugins/*/`
- **Scripts** → `../CONSTRUCT-CORE/CONSTRUCT/scripts/*/`
- **Templates** → `../CONSTRUCT-CORE/TEMPLATES/*/`

## 📝 Documentation Standards

1. **Location**
   - System docs go in `/docs/`
   - Pattern docs go with the pattern
   - Script help via `--help` flag

2. **Format**
   - Markdown for all documentation
   - Clear headings and structure
   - Examples where helpful

3. **Maintenance**
   - Update docs with code changes
   - Mark deprecated features
   - Date significant updates

## 🤝 Contributing

When adding new features:
1. Update relevant documentation
2. Add to appropriate index
3. Update STRUCTURE.md if adding directories
4. Note changes in What's New section

---

For questions or improvements, see the [main project README](../README.md).