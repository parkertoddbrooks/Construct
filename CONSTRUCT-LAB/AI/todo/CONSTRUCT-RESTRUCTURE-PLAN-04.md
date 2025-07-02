# CONSTRUCT Restructure Plan v4: Template-First Architecture

## Overview
Building on v3's promotion system, v4 refines the approach with clearer understanding of user personas and simplified template architecture. The key insight: LAB is delivered as-is (no build needed), and `template-structure/` serves as both symlink source and template foundation.

## Current State (What's Working)
```
CONSTRUCT/
├── CONSTRUCT-CORE/         # Universal orchestration engine ✅
│   ├── CONSTRUCT/          # Core tools (scripts, lib, config) ✅
│   ├── TEMPLATES/          # Production templates ✅
│   ├── docs/               # Core documentation ✅
│   └── AI/                 # Partially implemented
├── CONSTRUCT-LAB/          # Development environment ✅
│   ├── AI/                 # Working AI context ✅
│   ├── PROMOTE-TO-CORE.yaml # Promotion manifest ✅
│   ├── tools/promote-to-core.sh # Enhanced with symlink support ✅
│   └── CONSTRUCT -> ../CONSTRUCT-CORE/CONSTRUCT ✅
└── Automated symlink tracking system ✅
```

## Target State v4: Simplified Template System
```
CONSTRUCT/
├── CONSTRUCT-LAB/                      # As-is for power users
│   └── (unchanged, delivered as-is when forked)
│
└── CONSTRUCT-CORE/                     
    ├── CONSTRUCT/                     
    │   ├── scripts/                  
    │   │   ├── create-project.sh    # NEW: Local project generator
    │   │   └── create-template.sh   # NEW: Template creator
    │   └── adapters/                 # NEW: Language adapters
    │       ├── swift/
    │       ├── python/
    │       └── .../
    │
    ├── AI/                           
    │   ├── template-structure/       # NEW: Template + symlink source
    │   │   └── AI/                  # Full AI directory template
    │   │       ├── README.md        # Real file (symlinked to LAB)
    │   │       ├── docs/
    │   │       │   └── README.md    # Real file
    │   │       ├── dev-logs/
    │   │       │   ├── dev-updates/
    │   │       │   │   └── _devupdate-prompt.md  # Real file
    │   │       │   └── check-quality/
    │   │       │       └── README.md  # Real file
    │   │       └── ...              # Mix of real files and empty dirs
    │   │
    │   ├── manifest.yaml            # NEW: Template application rules
    │   └── structure/               # EXISTING: Automated scans
    │
    └── TEMPLATES/                     
        ├── swift-ios/
        ├── python-fastapi/          # Future
        └── .../
```

## Key Refinements from v3

### 1. User Personas Clarified
- **Template Users**: Use GitHub templates, get clean project
- **Power Users**: Fork CONSTRUCT, use LAB, create projects locally

### 2. Simplified AI Structure
- No separate `shared-files/` directory
- Files live directly in `template-structure/` where they belong
- These files are the symlink sources for LAB
- Same files get copied to new templates/projects

### 3. Local Project Generation
```bash
# Power users can create projects without GitHub
./CONSTRUCT/scripts/create-project.sh MyApp swift-ios
```

### 4. Extensible Architecture
- Community can add adapters, templates, configs
- Everything promotable through LAB → CORE workflow

## Implementation Steps

### Phase 1: Complete AI Template Structure 
1. Create `CONSTRUCT-CORE/AI/template-structure/` directory
2. Move existing symlinked files to proper locations:
   - `_devupdate-prompt.md` → `template-structure/AI/dev-logs/dev-updates/`
   - Quality check README → `template-structure/AI/dev-logs/check-quality/`
3. Update symlinks in LAB to point to new locations
4. Update `check-symlinks.sh` EXPECTED_SYMLINKS array
5. Update documentation (symlink-promotion-rules.md)

### Phase 2: Create Template System
1. Build `manifest.yaml` defining:
   - Which files to copy vs reference
   - Placeholder replacements
   - Directory creation rules
2. Create `create-project.sh` script:
   - Copy template files
   - Apply AI structure
   - Replace placeholders
   - Initialize git repo
3. Create `create-template.sh` script:
   - Scaffold new template
   - Apply AI structure
   - Set up adapter references

### Phase 3: Build Adapter System
1. Define adapter interface:
   - `detect.sh` - Language detection
   - `rules.yaml` - Language-specific rules
   - `context.md` - AI context for language
2. Create initial adapters:
   - Move Swift rules to `adapters/swift/`
   - Create Python adapter as example
3. Update orchestrator to use adapters

### Phase 4: Testing & Documentation
1. Test complete workflow:
   - Fork → LAB development → Promotion → Project creation
2. Document power user workflow
3. Create template author guide
4. Update README with both user personas

## What's Already Done ✅
- Basic CORE/LAB/TEMPLATES structure
- Promotion system with symlink support
- Automated symlink tracking in CLAUDE.md
- Pre-commit hooks and quality gates
- Documentation auto-generation

## What's Still TODO 🔲

### High Priority
1. **Relocate symlinked files** to `template-structure/`
2. **Create manifest.yaml** for template application
3. **Build create-project.sh** for local project generation
4. **Update all symlink references** after relocation

### Medium Priority
1. **Create adapter system** structure
2. **Build create-template.sh** for new templates
3. **Document power user workflow**

### Future Enhancements
1. **Add more language adapters**
2. **Create more templates**
3. **Build template marketplace/registry**
4. **Add template testing framework**

## Success Criteria v4

- ✅ Clean separation of concerns (CORE/LAB/TEMPLATES)
- ✅ Automated promotion and symlink management
- 🔲 Power users can create projects locally
- 🔲 Template files organized in single location
- 🔲 Extensible adapter system
- 🔲 Community-friendly contribution model

## The Philosophy (Refined)

**CONSTRUCT is a framework for building frameworks**

- **For Template Users**: Clean, ready-to-use project templates
- **For Power Users**: Complete development environment with tools to create, improve, and share templates
- **For Contributors**: Clear patterns for extending the system with new languages and templates

The `template-structure/` is the bridge - it defines what every project gets while serving as the source for LAB's symlinks.

---

**Branch**: refactor/core-lab-templates  
**Version**: CONSTRUCT-RESTRUCTURE-PLAN-04  
**Focus**: Template-first architecture with power user tools  
**Date**: 2025-07-02