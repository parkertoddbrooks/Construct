# CONSTRUCT README Index

This file provides a comprehensive map of the CONSTRUCT project structure, including all directories, symlinks, and README documentation.

## Table of Contents
1. [Directory Structure](#directory-structure)
2. [README Files Index](#readme-files-index)
3. [Complete README Contents](#complete-readme-contents)

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
│   │   ├── scripts/                    # (shown as scripts, actually scripts-new)
│   │   │   ├── construct/
│   │   │   ├── core/
│   │   │   ├── dev/
│   │   │   ├── patterns/
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
│   ├── patterns/
│   │   ├── lib/
│   │   ├── plugins/
│   │   │   ├── architectural/
│   │   │   ├── cross-platform/
│   │   │   ├── frameworks/
│   │   │   ├── languages/
│   │   │   ├── platforms/
│   │   │   └── tooling/
│   │   └── templates/
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
│   │   ├── community/
│   │   ├── experiments/
│   │   ├── parker/
│   │   └── plugins/
│   └── tools/
└── docs/
    ├── ARCHITECTURE-CHEATSHEET/
    ├── core/
    └── features/
```

### Key Symlinks
**⚠️ WARNING: The symlinks below are currently broken - they point to:**
- `CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/...` (doesn't exist)
**But should point to:**
- `CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/...`

**Current symlinks:**
- `CONSTRUCT-LAB/CONSTRUCT` -> `../CONSTRUCT-CORE/CONSTRUCT`
- `CONSTRUCT-LAB/AI/dev-logs/check-quality/README-sym.md` -> Should point to CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/...
- `CONSTRUCT-LAB/AI/dev-logs/dev-updates/devupdate-prompt-sym.md` -> Should point to CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/...
- `CONSTRUCT-LAB/AI/dev-logs/dev-updates/README-sym.md` -> Should point to CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/...
- `CONSTRUCT-LAB/AI/docs/README-sym.md` -> Should point to CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/...
- `CONSTRUCT-LAB/AI/todo/README-sym.md` -> Should point to CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/...

---

## README Files Index

### Root
1. `./README.md` - Main CONSTRUCT repository documentation

### CONSTRUCT-CORE
2. `./CONSTRUCT-CORE/CONSTRUCT/README.md` - CONSTRUCT core system documentation
3. `./CONSTRUCT-CORE/CONSTRUCT/orchestrator/README.md` - Orchestrator component
4. `./CONSTRUCT-CORE/CONSTRUCT/scripts/README.md` - Legacy scripts directory
5. `./CONSTRUCT-CORE/CONSTRUCT/scripts-new/README.md` - Active scripts directory
6. `./CONSTRUCT-CORE/CONSTRUCT/scripts-new/patterns/README.md` - Pattern scripts

### Patterns System
7. `./CONSTRUCT-CORE/patterns/README.md` - Pattern system root
8. `./CONSTRUCT-CORE/patterns/lib/README.md` - Pattern utilities library
9. `./CONSTRUCT-CORE/patterns/plugins/README.md` - Pattern plugins directory
10. `./CONSTRUCT-CORE/patterns/templates/README.md` - Pattern configuration templates

### Templates
11. `./CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/dev-logs/check-quality/README.md`
12. `./CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/dev-logs/dev-updates/README.md`
13. `./CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/docs/README.md`
14. `./CONSTRUCT-CORE/TEMPLATES/component-templates/ai-structure/AI/todo/README.md`

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
25. `./CONSTRUCT-LAB/patterns/README.md` - LAB patterns directory
26. `./CONSTRUCT-LAB/tools/README.md` - LAB tools directory

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
26. `./CONSTRUCT-LAB/tools/README.md`
