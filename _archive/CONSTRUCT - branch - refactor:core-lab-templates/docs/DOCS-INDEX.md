# CONSTRUCT Documentation Index

Complete index of all CONSTRUCT documentation, organized by topic.

## 📚 Documentation Overview

- [README-INDEX.md](README-INDEX.md) - Index of all README files
- [STRUCTURE.md](STRUCTURE.md) - Current directory structure
- **This file** - Complete documentation index

## 🚀 Getting Started

### Setup & Installation
- [Main README](../README.md) - Project overview and setup
- [CONSTRUCT Scripts README](../CONSTRUCT-CORE/CONSTRUCT/scripts/README.md) - Script usage guide

### Quick References
- [Architecture Cheatsheet](ARCHITECTURE-CHEATSHEET/CONSTRUCT-ARCHITECTURE-CHEATSHEET--grok-see-feedback.md) - Quick architecture reference
- [Interactive Mode Support](../CONSTRUCT-CORE/CONSTRUCT/scripts/INTERACTIVE-SUPPORT-STATUS.md) - Script interactivity status

## 🏗️ Core Concepts

### Workspace & Project Management
- [Workspace Management](core/workspace-management.md) - Understanding `.construct/` vs `.construct-workspace/` ⭐ NEW
- [Project Creation Guide](../CONSTRUCT-CORE/CONSTRUCT/scripts/workspace/create-project.sh) - Creating new projects
- [Import Projects Guide](../CONSTRUCT-CORE/CONSTRUCT/scripts/workspace/import-project.sh) - Importing existing projects

### Pattern System
- [Pattern System Overview](../CONSTRUCT-CORE/patterns/README.md) - How patterns work
- [Plugin Architecture](../CONSTRUCT-CORE/patterns/plugins/README.md) - Pattern plugin system
- [Pattern Templates](../CONSTRUCT-CORE/patterns/templates/README.md) - Configuration templates
- [Pattern Guide](../CONSTRUCT-CORE/patterns/PATTERN-GUIDE.md) - Creating custom patterns

### Quality & Philosophy
- [Distributed Quality Philosophy](core/distributed-quality-philosophy.md) - CONSTRUCT's quality approach
- [Distributed Quality Examples](core/distributed-quality-examples.md) - Practical examples
- [Unix Philosophy Patterns](../CONSTRUCT-CORE/patterns/plugins/tooling/unix-philosophy/unix-philosophy.md) - Unix design principles

## 🔧 Features

### Script System
- [Interactive Scripts](features/interactive-scripts.md) - Script interactivity features
- [Repository Context](features/repository-context.md) - Context management in scripts
- [Session Management](../CONSTRUCT-LAB/AI/dev-logs/session-states/README.md) - Development session tracking

### Development Workflow
- [LAB to CORE Promotion](core/promotion-system-guide.md) - How code moves from experimental to stable
- [Symlink Promotion Rules](core/symlink-promotion-rules.md) - Detailed promotion process
- [Development Updates](../CONSTRUCT-LAB/AI/dev-logs/dev-updates/README.md) - Tracking development progress

## 📦 Pattern Plugins

### Language Patterns
- [Swift Patterns](../CONSTRUCT-CORE/patterns/plugins/languages/swift/swift.md) - Swift 6 best practices
- [C# Patterns](../CONSTRUCT-CORE/patterns/plugins/languages/csharp/csharp.md) - Modern C#/.NET patterns
- [Python Patterns](../CONSTRUCT-CORE/patterns/plugins/languages/python/python.md) - Python PEP 8 patterns

### Architectural Patterns
- [MVVM Pattern](../CONSTRUCT-CORE/patterns/plugins/architectural/mvvm/mvvm.md) - Model-View-ViewModel
- [MVVM iOS](../CONSTRUCT-CORE/patterns/plugins/architectural/mvvm-ios/mvvm-ios.md) - iOS-specific MVVM

### Framework Patterns
- [SwiftUI Patterns](../CONSTRUCT-CORE/patterns/plugins/frameworks/swiftui/swiftui.md) - SwiftUI best practices
- [iOS UI Library](../CONSTRUCT-CORE/patterns/plugins/frameworks/ios-ui-library/ios-ui-library.md) - Reusable components

### Tooling Patterns
- [Shell Scripting](../CONSTRUCT-CORE/patterns/plugins/tooling/shell-scripting/shell-scripting.md) - Shell script patterns
- [Shell Quality](../CONSTRUCT-CORE/patterns/plugins/tooling/shell-quality/shell-quality.md) - Script quality standards
- [Error Handling](../CONSTRUCT-CORE/patterns/plugins/tooling/error-handling/error-handling.md) - Error patterns
- [CONSTRUCT Development](../CONSTRUCT-CORE/patterns/plugins/tooling/construct-dev/construct-dev.md) - CONSTRUCT-specific patterns

## 🛠️ Development Tools

### Validation Scripts
- [Architecture Check](../CONSTRUCT-CORE/CONSTRUCT/scripts/core/check-architecture.sh) - Validate architecture
- [Quality Check](../CONSTRUCT-CORE/CONSTRUCT/scripts/core/check-quality.sh) - Check code quality
- [Documentation Check](../CONSTRUCT-CORE/CONSTRUCT/scripts/core/check-documentation.sh) - Verify docs

### Context Management
- [Assemble CLAUDE.md](../CONSTRUCT-CORE/CONSTRUCT/scripts/construct/assemble-claude.sh) - Generate context files
- [Update Context](../CONSTRUCT-CORE/CONSTRUCT/scripts/construct/update-context.sh) - Refresh project context
- [Update Architecture](../CONSTRUCT-CORE/CONSTRUCT/scripts/construct/update-architecture.sh) - Update architecture docs

### Development Workflow
- [Session Summary](../CONSTRUCT-CORE/CONSTRUCT/scripts/dev/session-summary.sh) - Create session summaries
- [Commit with Review](../CONSTRUCT-CORE/CONSTRUCT/scripts/dev/commit-with-review.sh) - Structured commits
- [Generate Dev Update](../CONSTRUCT-CORE/CONSTRUCT/scripts/dev/generate-devupdate.sh) - Development logs

## 📋 Templates

### Project Templates
- [iOS + Watch Template](../CONSTRUCT-CORE/TEMPLATES/project-templates/swift-ios+watch/) - Full iOS app template
- [AI Structure Template](../CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/) - AI folder structure

### Configuration Templates
- [Patterns Template](../CONSTRUCT-CORE/patterns/templates/patterns.yaml) - Project pattern configuration
- [Project Sets](../CONSTRUCT-CORE/patterns/templates/project-sets.yaml) - Pre-configured project types ⭐ NEW

## 🆕 What's New (2025-07-10)

### Major Updates
1. **Scripts Reorganization** 
   - Migrated `scripts-new/` → `scripts/`
   - New structure: `construct/`, `core/`, `dev/`, `workspace/`
   - All 21 scripts tested and working

2. **Plugin Registry System**
   - Auto-generated `registry.yaml` catalogs all plugins
   - New commands: `--list-plugins`, `--list-sets`, `--refresh-registry`
   - `project-sets.yaml` for quick project setup

3. **Documentation Improvements**
   - Added [Workspace Management](core/workspace-management.md) guide
   - Created this comprehensive documentation index
   - Updated directory structure documentation

4. **Bug Fixes**
   - Fixed `--help` handling in all scripts
   - Corrected plugin path resolution
   - Updated all script references

## 📝 Documentation Notes

### Understanding AI Folders
- `/docs/` - System documentation for CONSTRUCT framework (you are here)
- `/CONSTRUCT-LAB/AI/docs/` - Project development documentation
  - Confusing for CONSTRUCT itself since CONSTRUCT *is* the project
  - Makes sense for imported projects where AI/ contains their development context
  - May be renamed in future for clarity

### Contributing
- System docs go in `/docs/`
- Development logs go in `/CONSTRUCT-LAB/AI/`
- Pattern documentation goes with the pattern in `patterns/plugins/`
- README files should explain their immediate directory