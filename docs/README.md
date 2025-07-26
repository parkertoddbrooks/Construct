# CONSTRUCT Documentation

Welcome to the CONSTRUCT documentation. This directory contains comprehensive documentation for the CONSTRUCT pattern framework.

## 🆕 What's New (2025-07-26)

### Latest Updates
- **init-construct.sh Fixed** - Claude SDK integration now working properly with JSON output
- **Streaming Issues Resolved** - Switched from broken streaming to reliable JSON format  
- **Two-Mode Operation** - Quick extraction (default, ~30s) or full extraction (--extract flag)
- **Improved Error Handling** - Better debug logging and error messages
- **No More Truncation** - Content extraction now preserves all project knowledge

### Previous Updates (2025-07-21)
- **Phase 2A Complete** - Enhanced pattern categorization system with 10 categories
- **Claude SDK Integration** - AI-native intelligent pattern extraction and analysis
- **Comprehensive Project Support** - Now handles projects with design tokens, quality gates
- **Cross-Platform Compatibility** - Bash 3+ support for macOS, Linux, Windows WSL
- **Enhanced Categories** - Added ui/, performance/, quality/, configuration/ pattern categories

[See full changelog →](DOCS-INDEX.md#-whats-new-2025-07-26)

## 📚 Documentation Guides

### Quick Start
- [**DOCS-INDEX.md**](DOCS-INDEX.md) - Complete documentation index (start here!)
- [**STRUCTURE.md**](STRUCTURE.md) - Current directory structure
- [**README-INDEX.md**](README-INDEX.md) - Index of all README files

### Key Topics
- [Workspace Management](core/workspace-management.md) - Understanding `.construct/` vs `.construct-workspace/`
- [Pattern System](../CONSTRUCT-CORE/patterns/README.md) - AI-native categorization and Claude SDK integration
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