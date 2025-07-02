# CONSTRUCT Restructure Plan v3: CORE as Container, Explicit Promotion System

## Overview
Building on v2's multi-tech architecture, v3 refines the structure with CONSTRUCT-CORE as the container for ALL shareable assets, and introduces an explicit promotion system from LAB to CORE. Nothing enters CORE without deliberate promotion.

## Current State (Completed from v2)
```
CONSTRUCT/
├── CONSTRUCT-CORE/         # Universal orchestration engine ✅
├── CONSTRUCT-LAB/          # Development environment ✅
├── TEMPLATES/              # Production-ready templates ✅
│   └── swift-ios/         # Swift template ✅
└── _old/                  # Original structure preserved ✅
```

## Target State v3: CORE as Universal Container
```
CONSTRUCT/
├── CONSTRUCT-LAB/                      # Development workspace
│   ├── AI/                            # Working AI context
│   ├── experiments/                   # New features testing
│   ├── PROMOTE-TO-CORE.yaml          # Explicit promotion manifest
│   └── CONSTRUCT -> ../CONSTRUCT-CORE/CONSTRUCT  # Symlink
│
└── CONSTRUCT-CORE/                     # ALL stable, shareable assets
    ├── CONSTRUCT/                     # Universal tools (was root of CORE)
    │   ├── scripts/                  # Core scripts
    │   ├── lib/                      # Shared libraries
    │   ├── config/                   # Core configs
    │   └── orchestrator/             # Language detection
    │
    ├── AI/                           # AI template system
    │   ├── structure/                # Directory structure template
    │   │   ├── AI/
    │   │   ├── AI/docs/
    │   │   ├── AI/docs/automated/
    │   │   ├── AI/dev-logs/
    │   │   └── ... (empty dirs)
    │   ├── shared-files/             # Files to share
    │   │   ├── README.md
    │   │   ├── docs-README.md
    │   │   └── devupdate-prompt.md
    │   └── manifest.yaml             # What gets copied/linked where
    │
    └── TEMPLATES/                     # All production templates
        └── swift-ios/
            ├── AI/                   # From CORE/AI template
            ├── CONSTRUCT -> ../../CONSTRUCT  # Uses CORE tools
            └── swift/                # Swift project files
```

## The Promotion System

### Core Principle
- **Nothing enters CORE without explicit promotion**
- **LAB is the only place for experimentation**
- **CORE only contains stable, tested assets**

### Promotion Manifest
```yaml
# CONSTRUCT-LAB/PROMOTE-TO-CORE.yaml
promotions:
  # Promote new directory structure
  - type: directory
    source: AI/ai-misc-conversations/claude/
    dest: CONSTRUCT-CORE/AI/structure/ai-misc-conversations/claude/
    include_files: []  # Empty dir only
    
  # Promote directory WITH specific files
  - type: directory
    source: AI/todo/capture-as-a-doc/
    dest: CONSTRUCT-CORE/AI/structure/todo/capture-as-a-doc/
    include_files:
      - README.md  # Only this file
      
  # Promote a script improvement
  - type: file
    source: experiments/better-validation.sh
    dest: CONSTRUCT-CORE/CONSTRUCT/scripts/validation.sh
    bump_version: minor
    
  # Promote shared AI file
  - type: file
    source: AI/shared-files/new-devupdate-prompt.md
    dest: CONSTRUCT-CORE/AI/shared-files/devupdate-prompt.md
```

### Promotion Workflow
1. **Develop in LAB** - All changes start here
2. **Test thoroughly** - Ensure stability
3. **Add to PROMOTE-TO-CORE.yaml** - Explicit declaration
4. **Run promotion** - `./tools/promote-to-core.sh`
5. **CORE updated** - Version bumped, changelog updated

## AI Template System

### Directory Structure Automation
```bash
# LAB creates new directory
mkdir -p CONSTRUCT-LAB/AI/new-tool/automated/

# Add to promotion manifest
# Run promotion
# CORE gets the structure

# Templates sync from CORE/AI/structure/
```

### Shared Files Management
```yaml
# CONSTRUCT-CORE/AI/manifest.yaml
shared_files:
  - source: shared-files/AI-README.md
    destinations:
      - lab: AI/README.md
        method: symlink
      - template: AI/README.md
        method: copy
```

### Automated vs Manual Separation
```
AI/
├── docs/
│   ├── automated/         # Generated content (ignored)
│   └── guides/           # Manual content (tracked)
├── dev-logs/
│   ├── session-states/
│   │   ├── automated/    # Script output (ignored)
│   │   └── archive/      # Old files (tracked)
```

## Key Changes from v2

1. **CONSTRUCT-CORE Reorganization**
   - CONSTRUCT/ subdirectory for tools (was root)
   - AI/ subdirectory for AI templates
   - TEMPLATES/ subdirectory for all templates

2. **Explicit Promotion System**
   - Nothing auto-syncs to CORE
   - PROMOTE-TO-CORE.yaml declares all promotions
   - Clear audit trail of what entered CORE when

3. **AI Template Architecture**
   - Shared structure definition
   - Shared files with manifest
   - Automated/ directories for generated content

4. **Reversed Flow**
   - LAB develops and tests
   - Explicit promotion to CORE
   - Templates consume from CORE

## Implementation Steps

### Phase 1: Reorganize CONSTRUCT-CORE
1. Move current CORE contents to CONSTRUCT/ subdirectory
2. Create AI/ template structure
3. Move TEMPLATES/ into CORE

### Phase 2: Build Promotion System
1. Create promotion manifest schema
2. Build promote-to-core.sh script
3. Add version tracking to promotions
4. Create rollback capabilities

### Phase 3: Implement AI Templates
1. Extract common AI structure
2. Identify shared files
3. Create manifest system
4. Build sync scripts

### Phase 4: Testing
1. Test promotion workflow
2. Verify template generation
3. Ensure symlinks work correctly
4. Validate automated/ ignore patterns

## Success Criteria v3

- ✅ CORE contains only stable, promoted code
- ✅ Clear promotion path from LAB to CORE
- ✅ AI structure shared without duplication
- ✅ Automated content separated from manual
- ✅ Templates get clean structure from CORE
- ✅ Version tracking for all promotions

## Benefits

1. **Quality Control** - Nothing accidental in CORE
2. **Clear History** - Promotion manifest shows what/when/why
3. **No Duplication** - Single source for shared files
4. **Clean Templates** - Users get exactly what they need
5. **Safe Experimentation** - LAB can be messy without affecting CORE

---

**Branch**: refactor/core-lab-templates  
**Version**: CONSTRUCT-RESTRUCTURE-PLAN-03  
**Focus**: CORE as container, explicit promotion  
**Date**: 2025-07-01