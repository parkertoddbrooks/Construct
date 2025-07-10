# CONSTRUCT README Index

This file lists all README files in the CONSTRUCT project. For complete documentation, see [DOCS-INDEX.md](DOCS-INDEX.md).

## Table of Contents
1. [Quick Links](#quick-links)
2. [Directory Structure](#directory-structure)
3. [README Files Index](#readme-files-index)

## Quick Links
- [📚 All Documentation](DOCS-INDEX.md) - Complete documentation index
- [🏗️ Directory Structure](STRUCTURE.md) - Current project structure
- [🆕 What's New](DOCS-INDEX.md#-whats-new-2025-07-10) - Recent updates

---

## Directory Structure

```
CONSTRUCT/
├── .claude/
├── .construct-workspace/
│   └── import-history/
├── CONSTRUCT-CORE/
│   ├── CONSTRUCT/
│   │   ├── adapters/
│   │   ├── config/
│   │   ├── lib/
│   │   ├── orchestrator/
│   │   └── scripts/                    # All CONSTRUCT scripts (organized)
│   │       ├── construct/              # CONSTRUCT-specific tools
│   │       ├── core/                   # Core validation scripts
│   │       ├── dev/                    # Development workflow
│   │       └── workspace/              # Project management
│   ├── patterns/
│   │   ├── lib/
│   │   ├── plugins/                    # Complete pattern plugins with validators
│   │   │   ├── registry.yaml          # Auto-generated plugin catalog
│   │   │   ├── architectural/
│   │   │   │   ├── mvvm/              # Generic MVVM pattern
│   │   │   │   └── mvvm-ios/          # iOS-specific MVVM
│   │   │   ├── cross-platform/
│   │   │   │   └── model-sync/
│   │   │   ├── frameworks/
│   │   │   │   ├── ios-ui-library/
│   │   │   │   └── swiftui/
│   │   │   ├── languages/
│   │   │   │   ├── csharp/
│   │   │   │   ├── python/
│   │   │   │   └── swift/
│   │   │   ├── platforms/
│   │   │   │   └── ios/
│   │   │   └── tooling/
│   │   │       ├── construct-dev/
│   │   │       ├── error-handling/
│   │   │       ├── shell-quality/
│   │   │       ├── shell-scripting/
│   │   │       └── unix-philosophy/
│   │   └── templates/
│   │       ├── patterns.yaml          # Template for project configs
│   │       └── project-sets.yaml      # Pre-configured project types
│   └── TEMPLATES/
│       ├── component-templates/
│       │   ├── ai-structure/
│       │   │   └── AI/
│       │   │       ├── ai-misc-conversations/
│       │   │       ├── ai-raw-cli/
│       │   │       ├── dev-logs/
│       │   │       │   ├── check-quality/
│       │   │       │   ├── dev-updates/
│       │   │       │   └── session-states/
│       │   │       ├── docs/
│       │   │       ├── examples/
│       │   │       ├── PRDs/
│       │   │       ├── structure/
│       │   │       └── todo/
│       │   ├── ci-cd/
│       │   └── construct-integration/
│       └── project-templates/
│           └── swift-ios+watch/
│               ├── iOS-App/
│               │   ├── App/
│               │   ├── Core/
│               │   ├── Features/
│               │   ├── Shared/
│               │   └── Tests/
│               ├── project-name.xcodeproj/
│               └── Watch-App/
│                   ├── App/
│                   ├── Core/
│                   ├── Features/
│                   ├── Shared/
│                   └── Tests/
├── CONSTRUCT-LAB/
│   ├── .construct/                    # LAB's pattern configuration
│   ├── AI/
│   │   ├── ai-misc-conversations/
│   │   ├── ai-raw-cli/
│   │   ├── dev-logs/
│   │   │   ├── check-quality/
│   │   │   │   └── README-sym.md -> ../../../../CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/dev-logs/check-quality/README.md
│   │   │   ├── dev-updates/
│   │   │   │   ├── devupdate-prompt-sym.md -> ../../../../CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/dev-logs/dev-updates/_devupdate-prompt.md
│   │   │   │   └── README-sym.md -> ../../../../CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/dev-logs/dev-updates/README.md
│   │   │   └── session-states/
│   │   ├── docs/
│   │   │   └── README-sym.md -> ../../../CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/docs/README.md
│   │   ├── PRDs/
│   │   ├── quality-reports/
│   │   ├── structure/
│   │   └── todo/
│   │       └── README-sym.md -> ../../../CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/todo/README.md
│   ├── CONSTRUCT -> ../CONSTRUCT-CORE/CONSTRUCT
│   ├── docs/
│   ├── experiments/
│   ├── patterns/                       # Local pattern development
│   │   ├── community/                  # (Legacy - being removed)
│   │   ├── experiments/                # Experimental patterns
│   │   ├── parker/                     # (Legacy - being removed)
│   │   └── plugins/                    # Project-specific pattern plugins
│   └── tools/
└── docs/
    ├── ARCHITECTURE-CHEATSHEET/
    ├── core/
    └── features/
```

### Key Symlinks

**Active symlinks:**
- `CONSTRUCT-LAB/CONSTRUCT` -> `../CONSTRUCT-CORE/CONSTRUCT` (Scripts and tools)
- Various README-sym.md files in LAB link to templates in CORE/TEMPLATES/component-templates/ai-structure/

---

## README Files Index

### Root
1. `./README.md` - Main CONSTRUCT repository documentation

### CONSTRUCT-CORE
2. `./CONSTRUCT-CORE/CONSTRUCT/README.md` - CONSTRUCT core system documentation
3. `./CONSTRUCT-CORE/CONSTRUCT/orchestrator/README.md` - Orchestrator component
4. `./CONSTRUCT-CORE/CONSTRUCT/scripts/README.md` - Script usage guide and organization

### Patterns System
5. `./CONSTRUCT-CORE/patterns/README.md` - Pattern system root
6. `./CONSTRUCT-CORE/patterns/lib/README.md` - Pattern utilities library
7. `./CONSTRUCT-CORE/patterns/plugins/README.md` - Pattern plugins directory
8. `./CONSTRUCT-CORE/patterns/templates/README.md` - Pattern configuration templates

### Templates
9. `./CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/dev-logs/check-quality/README.md`
10. `./CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/dev-logs/dev-updates/README.md`
11. `./CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/docs/README.md`
12. `./CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/todo/README.md`

### Swift iOS+Watch Template
15. `./CONSTRUCT-CORE/TEMPLATES/project-templates/swift-ios+watch/iOS-App/Features/README.md`
16. `./CONSTRUCT-CORE/TEMPLATES/project-templates/swift-ios+watch/iOS-App/Shared/Components/README.md`
17. `./CONSTRUCT-CORE/TEMPLATES/project-templates/swift-ios+watch/iOS-App/Shared/Models/README.md`
18. `./CONSTRUCT-CORE/TEMPLATES/project-templates/swift-ios+watch/iOS-App/Shared/Services/README.md`
19. `./CONSTRUCT-CORE/TEMPLATES/project-templates/swift-ios+watch/iOS-App/Tests/README.md`
20. `./CONSTRUCT-CORE/TEMPLATES/project-templates/swift-ios+watch/Watch-App/Features/README.md`
21. `./CONSTRUCT-CORE/TEMPLATES/project-templates/swift-ios+watch/Watch-App/Shared/Components/README.md`
22. `./CONSTRUCT-CORE/TEMPLATES/project-templates/swift-ios+watch/Watch-App/Shared/Models/README.md`
23. `./CONSTRUCT-CORE/TEMPLATES/project-templates/swift-ios+watch/Watch-App/Shared/Services/README.md`
24. `./CONSTRUCT-CORE/TEMPLATES/project-templates/swift-ios+watch/Watch-App/Tests/README.md`

### CONSTRUCT-LAB
25. `./CONSTRUCT-LAB/patterns/README.md` - LAB patterns directory (local development)
26. `./CONSTRUCT-LAB/patterns/plugins/README.md` - LAB pattern plugins guide
27. `./CONSTRUCT-LAB/tools/README.md` - LAB tools directory

---

## Directory Tree with README Locations

```
CONSTRUCT/
├── README.md ◄─────────────────────────────────────── Main repository documentation
├── .claude/
├── .construct-workspace/
│   └── import-history/
├── CONSTRUCT-CORE/
│   ├── CONSTRUCT/
│   │   ├── README.md ◄──────────────────────────────── Core system documentation
│   │   ├── adapters/
│   │   ├── config/
│   │   ├── lib/
│   │   ├── orchestrator/
│   │   │   └── README.md ◄──────────────────────────── Orchestrator component
│   │   ├── scripts/ (shown as scripts, actually scripts-new)
│   │   │   ├── README.md ◄──────────────────────────── Active scripts directory
│   │   │   ├── construct/
│   │   │   ├── core/
│   │   │   ├── dev/
│   │   │   ├── patterns/
│   │   │   │   ├── README.md ◄──────────────────────── Pattern scripts
│   │   │   │   ├── code-quality/
│   │   │   │   ├── construct-development/
│   │   │   │   ├── csharp-language/
│   │   │   │   ├── ios-ui-library/
│   │   │   │   ├── mvvm-architecture/
│   │   │   │   ├── python-development/
│   │   │   │   ├── shell-quality/
│   │   │   │   ├── shell-scripting/
│   │   │   │   └── swift-language/
│   │   │   └── workspace/
│   │   └── scripts/ (legacy)
│   │       └── README.md ◄──────────────────────────── Legacy scripts directory
│   ├── patterns/
│   │   ├── README.md ◄──────────────────────────────── Pattern system root
│   │   ├── lib/
│   │   │   └── README.md ◄──────────────────────────── Pattern utilities library
│   │   ├── plugins/
│   │   │   ├── README.md ◄──────────────────────────── Pattern plugins directory
│   │   │   ├── architectural/
│   │   │   ├── cross-platform/
│   │   │   ├── frameworks/
│   │   │   ├── languages/
│   │   │   ├── platforms/
│   │   │   └── tooling/
│   │   └── templates/
│   │       └── README.md ◄──────────────────────────── Pattern configuration templates
│   └── TEMPLATES/
│       ├── component-templates/
│       │   ├── ai-structure/
│       │   │   └── AI/
│       │   │       ├── ai-misc-conversations/
│       │   │       ├── ai-raw-cli/
│       │   │       ├── dev-logs/
│       │   │       │   ├── check-quality/
│       │   │       │   │   └── README.md ◄────────────── Quality check logs template
│       │   │       │   ├── dev-updates/
│       │   │       │   │   └── README.md ◄────────────── Dev updates template
│       │   │       │   └── session-states/
│       │   │       ├── docs/
│       │   │       │   └── README.md ◄────────────────── Documentation template
│       │   │       ├── examples/
│       │   │       ├── PRDs/
│       │   │       ├── structure/
│       │   │       └── todo/
│       │   │           └── README.md ◄────────────────── Todo tracking template
│       │   ├── ci-cd/
│       │   └── construct-integration/
│       └── project-templates/
│           └── swift-ios+watch/
│               ├── iOS-App/
│               │   ├── App/
│               │   ├── Core/
│               │   ├── Features/
│               │   │   └── README.md ◄────────────────── iOS features guide
│               │   ├── Shared/
│               │   │   ├── Components/
│               │   │   │   └── README.md ◄────────────── iOS components guide
│               │   │   ├── Models/
│               │   │   │   └── README.md ◄────────────── iOS models guide
│               │   │   └── Services/
│               │   │       └── README.md ◄────────────── iOS services guide
│               │   └── Tests/
│               │       └── README.md ◄────────────────── iOS tests guide
│               ├── project-name.xcodeproj/
│               └── Watch-App/
│                   ├── App/
│                   ├── Core/
│                   ├── Features/
│                   │   └── README.md ◄────────────────── Watch features guide
│                   ├── Shared/
│                   │   ├── Components/
│                   │   │   └── README.md ◄────────────── Watch components guide
│                   │   ├── Models/
│                   │   │   └── README.md ◄────────────── Watch models guide
│                   │   └── Services/
│                   │       └── README.md ◄────────────── Watch services guide
│                   └── Tests/
│                       └── README.md ◄────────────────── Watch tests guide
├── CONSTRUCT-LAB/
│   ├── .construct/
│   ├── AI/
│   │   ├── ai-misc-conversations/
│   │   ├── ai-raw-cli/
│   │   ├── dev-logs/
│   │   │   ├── check-quality/
│   │   │   │   └── README-sym.md -> ../../../../CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/dev-logs/check-quality/README.md
│   │   │   ├── dev-updates/
│   │   │   │   ├── devupdate-prompt-sym.md -> ../../../../CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/dev-logs/dev-updates/_devupdate-prompt.md
│   │   │   │   └── README-sym.md -> ../../../../CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/dev-logs/dev-updates/README.md
│   │   │   └── session-states/
│   │   ├── docs/
│   │   │   └── README-sym.md -> ../../../CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/docs/README.md
│   │   ├── PRDs/
│   │   ├── quality-reports/
│   │   ├── structure/
│   │   └── todo/
│   │       └── README-sym.md -> ../../../CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/todo/README.md
│   ├── CONSTRUCT -> ../CONSTRUCT-CORE/CONSTRUCT
│   ├── docs/
│   ├── experiments/
│   ├── patterns/
│   │   ├── README.md ◄──────────────────────────────── LAB patterns directory
│   │   ├── community/
│   │   ├── experiments/
│   │   ├── parker/
│   │   └── plugins/
│   └── tools/
│       └── README.md ◄──────────────────────────────── LAB tools directory
└── docs/
    ├── ARCHITECTURE-CHEATSHEET/
    ├── core/
    └── features/
```

## README Files in Order (Top to Bottom)

1. `./README.md`
2. `./CONSTRUCT-CORE/CONSTRUCT/README.md`
3. `./CONSTRUCT-CORE/CONSTRUCT/orchestrator/README.md`
4. `./CONSTRUCT-CORE/CONSTRUCT/scripts-new/README.md`
5. `./CONSTRUCT-CORE/CONSTRUCT/scripts-new/patterns/README.md`
6. `./CONSTRUCT-CORE/CONSTRUCT/scripts/README.md`
7. `./CONSTRUCT-CORE/patterns/README.md`
8. `./CONSTRUCT-CORE/patterns/lib/README.md`
9. `./CONSTRUCT-CORE/patterns/plugins/README.md`
10. `./CONSTRUCT-CORE/patterns/templates/README.md`
11. `./CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/dev-logs/check-quality/README.md`
12. `./CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/dev-logs/dev-updates/README.md`
13. `./CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/docs/README.md`
14. `./CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/todo/README.md`
15. `./CONSTRUCT-CORE/TEMPLATES/project-templates/swift-ios+watch/iOS-App/Features/README.md`
16. `./CONSTRUCT-CORE/TEMPLATES/project-templates/swift-ios+watch/iOS-App/Shared/Components/README.md`
17. `./CONSTRUCT-CORE/TEMPLATES/project-templates/swift-ios+watch/iOS-App/Shared/Models/README.md`
18. `./CONSTRUCT-CORE/TEMPLATES/project-templates/swift-ios+watch/iOS-App/Shared/Services/README.md`
19. `./CONSTRUCT-CORE/TEMPLATES/project-templates/swift-ios+watch/iOS-App/Tests/README.md`
20. `./CONSTRUCT-CORE/TEMPLATES/project-templates/swift-ios+watch/Watch-App/Features/README.md`
21. `./CONSTRUCT-CORE/TEMPLATES/project-templates/swift-ios+watch/Watch-App/Shared/Components/README.md`
22. `./CONSTRUCT-CORE/TEMPLATES/project-templates/swift-ios+watch/Watch-App/Shared/Models/README.md`
23. `./CONSTRUCT-CORE/TEMPLATES/project-templates/swift-ios+watch/Watch-App/Shared/Services/README.md`
24. `./CONSTRUCT-CORE/TEMPLATES/project-templates/swift-ios+watch/Watch-App/Tests/README.md`
25. `./CONSTRUCT-LAB/patterns/README.md`
26. `./CONSTRUCT-LAB/patterns/plugins/README.md`
27. `./CONSTRUCT-LAB/tools/README.md`

### Documentation
28. `./docs/core/README.md` - Core documentation index ⭐ NEW
