# CONSTRUCT Restructure Plan v2: Swift-First, Multi-Tech Ready

## Overview
Building on v1's CORE/LAB/TEMPLATES structure, v2 focuses on Swift/Apple development first while preparing for multi-technology expansion. The key insight: CONSTRUCT-CORE becomes a universal orchestrator that adapts to whatever technologies it finds.

## Current State (Completed from v1)
```
CONSTRUCT/
├── CONSTRUCT-CORE/         # Universal orchestration engine ✅
├── CONSTRUCT-LAB/          # Development environment ✅
├── TEMPLATES/              # Production-ready templates ✅
│   └── swift-ios/         # Swift template (from PROJECT-TEMPLATE) ✅
└── _old/                  # Original structure preserved ✅
```

## Target State v2: Swift-First Evolution
```
CONSTRUCT/
├── CONSTRUCT-CORE/         # Universal orchestration engine
│   ├── orchestrator/      # Auto-detects project type
│   │   ├── detect.sh     # Finds Swift, Python, Node.js, etc.
│   │   ├── route.sh      # Routes to appropriate adapter
│   │   └── merge.sh      # Merges multi-tech contexts
│   ├── adapters/         # Technology-specific rules
│   │   ├── swift/        # Swift/iOS rules (BUILD FIRST)
│   │   ├── python/       # Future
│   │   └── nodejs/       # Future
│   ├── scripts/          # Universal scripts (existing)
│   ├── lib/             # Shared functions (existing)
│   └── config/          # Core configuration (existing)
├── CONSTRUCT-LAB/         # Your development workspace
└── TEMPLATES/
    └── swift-ios/        # Clean Swift template
        └── swift/        # Technology-specific subdirectory
            ├── MyApp.xcodeproj/
            ├── iOS-App/
            └── Watch-App/
```

## Phase 1: Update Swift Template Structure ✅ COMPLETED
The template now uses technology-specific subdirectories to support future multi-tech projects.

## Phase 2: Build Swift Adapter (CURRENT FOCUS)

### 2.1 Create Swift Detection
```bash
CONSTRUCT-CORE/adapters/swift/detect.sh
# Detects: *.xcodeproj, Package.swift, Info.plist
# Returns: true if Swift project found
```

### 2.2 Swift-Specific Rules
```yaml
CONSTRUCT-CORE/adapters/swift/rules.yaml
mvvm:
  - no-business-logic-in-views
  - use-published-for-state
  - coordinator-navigation
design-tokens:
  - no-hardcoded-dimensions
  - use-semantic-colors
```

### 2.3 Swift AI Context Template
```markdown
CONSTRUCT-CORE/adapters/swift/context-template.md
<!-- SWIFT-SPECIFIC RULES -->
✅ ALWAYS: .frame(width: tokens.width)
❌ NEVER: .frame(width: 200)
```

## Phase 3: Update Core Scripts for Detection

### 3.1 Make update-context.sh Multi-Tech Aware
```bash
# Detects technologies present
# Applies appropriate rules
# Generates unified CLAUDE.md with all contexts
```

### 3.2 Make check-architecture.sh Adaptive
```bash
# If swift/ directory exists → Run Swift checks
# If python/ directory exists → Run Python checks
# Report unified results
```

## Phase 4: Test Swift-First Workflow

### 4.1 Single-Tech Project (Swift Only)
```
MyApp/
├── AI/
├── CONSTRUCT/
└── swift/              # Only Swift = Swift rules only
    └── MyApp.xcodeproj/
```

### 4.2 Future Multi-Tech Project
```
MyApp/
├── AI/
├── CONSTRUCT/
├── swift/              # Swift rules apply here
│   └── MyApp.xcodeproj/
└── python/             # Python rules apply here
    └── api/
```

## Key Insights from Our Discussion

1. **Templates Use Tech Subdirectories**
   - Not everything at root
   - `swift/`, `python/`, `nodejs/` subdirectories
   - Allows multi-tech projects later

2. **CONSTRUCT-CORE Adapts**
   - Detects what's present
   - Applies appropriate rules
   - No hardcoding, pure detection

3. **One CLAUDE.md at Root**
   - Merges all technology contexts
   - Shows integration points
   - Unified view of project

4. **Start with Swift, Expand Later**
   - Perfect Swift support first
   - Add languages as needed
   - Each addition is just new adapter

## Implementation Priority

### Immediate (Swift Focus)
1. ✅ Update template structure (swift/ subdirectory)
2. Create Swift adapter in CONSTRUCT-CORE
3. Update detection logic in core scripts
4. Test with Swift-only projects

### Future (Multi-Tech)
1. Add Python adapter when needed
2. Add Node.js adapter when needed
3. Test multi-technology projects
4. Enhance cross-tech integration detection

## Success Criteria v2

- ✅ Swift projects get Swift rules automatically
- ✅ Future Python projects will get Python rules
- ✅ Multi-tech projects get ALL applicable rules
- ✅ No manual configuration needed
- ✅ CLAUDE.md shows unified context
- ✅ Adding new languages doesn't break existing ones

## What Changed from v1

1. **Technology Subdirectories**: Templates organize by technology
2. **Adapter System**: Each language has detection + rules + context
3. **Auto-Detection**: No manual config, pure detection
4. **Swift-First**: Build complete Swift support before expanding
5. **Future-Proof**: Structure ready for any language

## Next Actions

1. Create `CONSTRUCT-CORE/adapters/swift/` structure
2. Move Swift-specific rules from scripts to adapter
3. Implement detection logic
4. Update core scripts to use adapters
5. Test with existing Swift template

---

**Branch**: refactor/core-lab-templates  
**Version**: CONSTRUCT-RESTRUCTURE-PLAN-02  
**Focus**: Swift-first, multi-tech ready  
**Date**: 2025-07-01