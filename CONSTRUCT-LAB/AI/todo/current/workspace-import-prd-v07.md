# PRD: CONSTRUCT Workspace & Project Import System

## Overview

This PRD defines how CONSTRUCT manages multiple independent projects within a workspace while preserving each project's git history and identity. It builds on the pattern system (unified-pattern-system-plan.md) to handle real-world scenarios of importing existing projects.

## Core Concepts

### Pattern Locations & Ownership

1. **CONSTRUCT-CORE/patterns/** - Built-in patterns (like iOS frameworks)
   - Minimal, universal patterns maintained by CONSTRUCT
   - Examples: basic Swift, MVVM, error handling

2. **CONSTRUCT-LAB/patterns/** - Plugin ecosystem (like npm packages)
   - Community and personal pattern plugins
   - Never promoted to CORE - permanent home for specialized patterns
   - Examples: parker/run-ui-patterns, alice/coordinator-plus

3. **Project/.construct/patterns.yaml** - Configuration only
   - Specifies which patterns to use
   - Contains project-specific custom_rules
   - Tracked by project's git

### Git Independence

- **CONSTRUCT git** tracks: patterns in CORE and LAB
- **Project git** tracks: .construct/patterns.yaml only
- **CLAUDE.md** is generated, never tracked by either git

## Problem Statement

Developers need to:
1. Manage multiple related projects from one location
2. Import existing projects without losing git history
3. Upgrade projects using old CONSTRUCT versions
4. Share patterns through plugins without forcing adoption
5. Keep projects independent and deployable
6. Maintain their own pattern plugins

Current pattern system plan addresses pattern management but not workspace organization and project imports.

## Goals

### Primary Goals
- Enable CONSTRUCT to manage multiple independent git repositories
- Preserve complete git history when importing projects
- Seamlessly migrate projects from old CONSTRUCT versions
- Enable pattern sharing through optional plugins (not forced adoption)
- Support independent pattern plugin development

### Non-Goals
- Force projects to use monorepo structure
- Require projects to change their git workflow
- Combine project histories into CONSTRUCT's git
- Promote all patterns to CORE (LAB is permanent home for plugins)
- Require projects to use specific patterns

## User Stories

### As a Developer
1. I want to import my existing Swift project into CONSTRUCT without losing any git history
2. I want each project to maintain its own repository so I can deploy independently
3. I want to upgrade old CONSTRUCT implementations to the pattern system
4. I want to create my own pattern plugins that others can optionally use
5. I want to extract patterns from my project to reusable plugins

### As a Team Lead
1. I want to standardize CONSTRUCT usage across our project portfolio
2. I want to preserve custom modifications teams have made
3. I want visibility into which patterns each project uses
4. I want teams to maintain their own specialized patterns

### As a Pattern Author
1. I want to maintain my own pattern plugins in LAB
2. I want others to use my patterns without CONSTRUCT approval
3. I want to evolve my patterns based on user feedback

## Technical Architecture

### Workspace Structure
```
CONSTRUCT/                          # Main workspace
├── .git/                          # CONSTRUCT's repository
├── .gitignore                     # Ignores Project-* directories
├── CONSTRUCT-CORE/                # Built-in patterns & tools
│   └── patterns/                  # Minimal universal patterns
│       ├── languages/            
│       └── architectural/        
├── CONSTRUCT-LAB/                 # Plugin ecosystem
│   └── patterns/                  # Community & personal plugins
│       ├── parker/               # Your patterns
│       │   ├── run-ui-patterns/
│       │   └── coordinator-flow/
│       ├── alice/                # Alice's patterns
│       └── community/            # Third-party patterns
├── .construct-workspace/          # Workspace metadata
│   ├── registry.yaml             # Project registry with branches
│   └── import-history/           # Preserved old CONSTRUCT files
├── Project-A-iOS/                # Independent project
│   ├── .git/                     # Project's own repository
│   ├── .construct/               # CONSTRUCT configuration
│   │   └── patterns.yaml         # Specifies which patterns to use
│   └── CLAUDE.md                 # Generated (gitignored)
└── Project-B-Backend/            # Another independent project
    └── .git/                     # Its own repository
```

### Pattern Flow

```
CONSTRUCT-CORE/patterns/          # Built-in (CONSTRUCT team maintains)
    +
CONSTRUCT-LAB/patterns/           # Plugins (Community maintains)
    +
Project/.construct/patterns.yaml  # Configuration (Project specifies)
    ↓
    CLAUDE.md (Generated)         # Combined result
```

### Key Design Decisions

#### 1. Git Independence
- Each project maintains its own .git directory
- CONSTRUCT's .gitignore excludes Project-* directories
- Only .construct/ metadata is visible to both gits
- CONSTRUCT tracks patterns, projects track configuration

#### 2. Pattern Plugin System
- CORE contains only essential patterns
- LAB is permanent home for specialized patterns
- No promotion from LAB to CORE needed
- Projects choose which plugins to use
- Pattern authors maintain their own plugins

#### 3. Branch Awareness
- Workspace registry tracks current branches
- Pattern updates come from CONSTRUCT's checked-out branch
- Projects control when to update their patterns.yaml
- Generated CLAUDE.md reflects current CONSTRUCT branch

#### 4. Import Intelligence
- Detect old CONSTRUCT versions automatically
- Preserve customizations in import-history
- Extract patterns from old CLAUDE.md files
- Generate patterns.yaml with discovered configuration

## Implementation Plan

### Phase 1: Workspace Foundation
1. Create workspace structure
2. Implement project registry system
3. Update .gitignore patterns
4. Create workspace-level commands

### Phase 2: Basic Import
1. Build import-project.sh script
2. Add language detection
3. Generate initial patterns.yaml
4. Create project-specific CLAUDE.md

### Phase 3: Legacy CONSTRUCT Support
1. Detect old CONSTRUCT versions
2. Extract patterns from old CLAUDE.md
3. Preserve customizations
4. Generate migration report

### Phase 4: Workspace Intelligence
1. Cross-project pattern analysis
2. Workspace-wide updates
3. Pattern consistency checking
4. Shared component detection

## Detailed Requirements

### Pattern Evolution Workflow

#### 1. Project Discovery → Custom Rules
```yaml
# Project discovers need for specific rule
# Project-A/.construct/patterns.yaml
custom_rules:
  swift:
    - "Use Coordinator pattern with Flow suffix"
```

#### 2. Custom Rules → LAB Plugin
```bash
# Pattern proves valuable, extract to plugin
cd CONSTRUCT-LAB/patterns
mkdir -p parker
vim parker/coordinator-flow.md
# Document pattern with examples
```

#### 3. Project Uses Plugin
```yaml
# Update project to use plugin instead of custom rule
# Project-A/.construct/patterns.yaml
plugins:
  - parker/coordinator-flow  # Now reusable!
# Remove from custom_rules
```

### Workspace Registry

```yaml
# .construct-workspace/registry.yaml
construct:
  branch: develop  # or main
  version: 2.0.0

projects:
  Project-A-iOS:
    path: ./Project-A-iOS
    repo: https://github.com/user/Project-A-iOS
    branch: feature/new-ui      # Current branch
    default_branch: main
    patterns:
      - swift
      - mvvm
      - parker/run-ui-patterns  # Using LAB plugin
    
  Project-B-Backend:
    path: ./Project-B-Backend
    repo: https://github.com/user/Project-B-Backend  
    branch: main
    default_branch: main
    patterns:
      - csharp
      - clean-architecture
```

### Import Process Flow

#### For New Projects (No CONSTRUCT)
1. Clone project into workspace
2. Detect languages and frameworks
3. Suggest appropriate patterns (CORE + relevant LAB plugins)
4. Generate .construct/patterns.yaml
5. Create initial CLAUDE.md
6. Update project's .gitignore

#### For Projects with Old CONSTRUCT
1. Clone project into workspace
2. Detect CONSTRUCT version
3. Preserve old files in import-history
4. Extract patterns and identify potential plugins
5. Generate patterns.yaml with:
   - Detected pattern usage → plugin references
   - Custom modifications → custom_rules
6. Create new pattern-based CLAUDE.md
7. Commit migration to project's git

#### For Projects with Current CONSTRUCT
1. Clone project into workspace
2. Verify pattern system compatibility
3. Register in workspace
4. Suggest LAB plugins based on custom_rules

### Workspace Commands

#### `workspace-status`
Shows all projects, their branches, patterns, and git status
```
CONSTRUCT Workspace Status
========================
CONSTRUCT: develop (v2.0.0)

Projects:
- Project-A-iOS:     feature/new-ui → main [modified]
  Patterns: swift, mvvm, parker/run-ui-patterns
  
- Project-B-Backend: main [clean]
  Patterns: csharp, clean-architecture
```

#### `workspace-update`
Regenerates all CLAUDE.md files with patterns from current CONSTRUCT branch

#### `workspace-analyze`
Finds common custom_rules that could become LAB plugins

#### `extract-to-plugin`
Helps extract custom_rules to a new LAB plugin
```bash
construct-workspace extract-to-plugin Project-A "coordinator pattern"
# Creates: LAB/patterns/{user}/coordinator-pattern.md
# Updates: Project-A/.construct/patterns.yaml
```

## Migration Strategy

### From unified-pattern-system-plan.md
The pattern system provides the foundation. This PRD adds:
- Workspace organization for multiple projects
- Git independence and branch tracking
- Import workflows for existing projects
- LAB as permanent plugin ecosystem
- Pattern extraction workflow

### Integration Points
1. Uses assemble-claude.sh for CLAUDE.md generation
2. Uses patterns.yaml structure with custom_rules
3. Extends migration scripts for workspace context
4. Leverages LAB for plugin development (no promotion needed)
5. Pattern resolution checks both CORE and LAB

## Success Metrics

1. **Import Success Rate**: 95% of projects import without manual intervention
2. **Git History Preservation**: 100% of project history maintained
3. **Pattern Migration**: 90% of old CONSTRUCT patterns successfully extracted
4. **Plugin Adoption**: 50% of custom_rules evolve into LAB plugins
5. **Developer Satisfaction**: Teams successfully maintain independent plugins

## Risks & Mitigations

### Risk: Git Complexity
**Mitigation**: Keep simple directory structure, no submodules initially

### Risk: Pattern Conflicts  
**Mitigation**: Plugin namespacing (parker/, alice/) prevents conflicts

### Risk: LAB Plugin Quality
**Mitigation**: Community ratings/feedback, plugin documentation standards

### Risk: CONSTRUCT Branch Confusion
**Mitigation**: Clear workspace-status command shows which patterns are active

## Future Enhancements

1. **Plugin Discovery**: Browse/search LAB plugins
2. **Plugin Versioning**: Pin to specific plugin versions
3. **Automated Pattern Extraction**: AI-assisted custom_rules → plugin conversion
4. **Plugin Marketplace**: Share patterns beyond single CONSTRUCT instance

## Key Differences from Original Vision

1. **LAB is permanent home for plugins** - No promotion to CORE needed
2. **Pattern authors maintain their plugins** - Like npm package authors
3. **CORE stays minimal** - Only truly universal patterns
4. **Projects evolve patterns** - Discovery happens in projects first
5. **Git branches matter** - CONSTRUCT branch determines available patterns

## Dependencies

- Pattern system (unified-pattern-system-plan.md)
- Basic CONSTRUCT structure (CONSTRUCT-RESTRUCTURE-PLAN-04.md)
- Migration tools (construct-integration-system.md)

## Timeline

- Week 1: Workspace foundation and registry
- Week 2: Basic import functionality  
- Week 3: Legacy CONSTRUCT support
- Week 4: Pattern extraction tools
- Week 5: Testing with real projects

---

**Status**: Ready for Review
**Priority**: High (enables real-world adoption)
**Complexity**: Medium (builds on pattern system)
**Key Innovation**: LAB as permanent plugin ecosystem, not waiting room for CORE