# PRD: CONSTRUCT Workspace & Project Import System

## 🆕 NEW THINKING: Integration with construct-init Orchestrator

**CRITICAL UPDATE**: This workspace import system now integrates with the enhanced `construct-init` as intelligent orchestrator approach discovered in Step00 recovery analysis.

**Key Integration Points**:
- **Import Process Enhancement**: `import-project.sh` now calls `construct-init` to ensure complete infrastructure installation
- **Infrastructure Guarantees**: Every imported project gets full CONSTRUCT infrastructure (AI/, .construct/, hooks, CONSTRUCT/)
- **Claude SDK Pattern Extraction**: Import process uses Claude SDK to intelligently extract existing patterns before applying CONSTRUCT enhancement
- **Validation Integration**: Import process validates all infrastructure works before completion

**Enhanced Import Flow**:
1. Clone/import project (preserving git history)
2. Run `construct-init` for complete infrastructure setup
3. Pattern extraction and enhancement (if existing CLAUDE.md)
4. Validation that all CONSTRUCT tools work in imported project

**This enhances the workspace import design** by ensuring every imported project has complete, working CONSTRUCT integration.

## Overview

This PRD defines how CONSTRUCT manages multiple independent projects within a workspace while preserving each project's git history and identity. It builds on the pattern system (unified-pattern-system-plan.md) and the construct-init orchestrator to handle real-world scenarios of importing existing projects.

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
├── .gitignore                     # Ignores Projects/ directory
├── CONSTRUCT-CORE/                # Built-in patterns & tools
│   └── patterns/                  # Minimal universal patterns
├── CONSTRUCT-LAB/                 # Plugin ecosystem
│   └── patterns/                  # Community & personal plugins
├── .construct-workspace/          # Workspace metadata
│   ├── registry.yaml             # Project registry with branches
│   └── import-history/           # Preserved old CONSTRUCT files
└── Projects/                      # All managed projects
    ├── MyApp/                     # Logical project grouping
    │   ├── ios/                   # iOS repository
    │   │   ├── .git/             # iOS repo's git
    │   │   └── .construct/       # iOS-specific patterns
    │   ├── backend/              # Backend repository  
    │   │   ├── .git/             # Backend repo's git
    │   │   └── .construct/       # Backend-specific patterns
    │   ├── web/                  # Web repository
    │   │   ├── .git/             # Web repo's git
    │   │   └── .construct/       # Web-specific patterns
    │   └── .construct/           # Project-level coordination
    └── SingleRepoProject/         # Some projects use monorepo
        ├── .git/                  # Single repository
        └── .construct/            # Project patterns
```

### Multi-Repository Projects

Many real-world projects consist of multiple repositories:
- iOS app with its own release cycle
- Backend API deployed independently
- Web frontend with different team
- Shared libraries in separate repos

CONSTRUCT supports both approaches:

#### Multi-Repository Structure
- Logical project folder groups related repos
- Each component has its own .git and .construct
- Project-level .construct coordinates shared patterns

#### Monorepo Structure  
- Single .git at project root
- One .construct for entire project
- Simpler but less flexible

### Pattern Resolution for Multi-Repo

```
Projects/MyApp/.construct/patterns.yaml          # Shared patterns
    +
Projects/MyApp/ios/.construct/patterns.yaml      # iOS-specific
    +
CONSTRUCT-CORE/patterns/                         # Built-in
    +
CONSTRUCT-LAB/patterns/                          # Plugins
    ↓
    Generated CLAUDE.md in each repo
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

### Workspace Registry for Multi-Repo

```yaml
# .construct-workspace/registry.yaml
construct:
  branch: develop
  version: 2.0.0

projects:
  MyApp:
    type: multi-repo
    components:
      ios:
        path: ./Projects/MyApp/ios
        repo: https://github.com/team/myapp-ios
        branch: develop
        patterns:
          - swift
          - mvvm
          - parker/run-ui-patterns
      backend:
        path: ./Projects/MyApp/backend
        repo: https://github.com/team/myapp-api
        branch: main
        patterns:
          - csharp
          - clean-architecture
      web:
        path: ./Projects/MyApp/web
        repo: https://github.com/team/myapp-web
        branch: feature/new-ui
        patterns:
          - typescript
          - react-patterns
    shared_patterns:  # Applied to all components
      - cross-platform/model-sync
      
  SingleProject:
    type: monorepo
    path: ./Projects/SingleProject
    repo: https://github.com/user/single-project
    branch: main
    patterns:
      - swift
      - mvvm
```

### Import Process Flow

#### For Multi-Repository Projects
1. Create logical project folder in Projects/
2. Import each repository as a component:
   ```bash
   import-project.sh https://github.com/team/myapp-ios MyApp/ios
   import-project.sh https://github.com/team/myapp-api MyApp/backend
   import-project.sh https://github.com/team/myapp-web MyApp/web
   ```
3. Create project-level .construct/patterns.yaml for shared patterns
4. Each component gets its own .construct/ for specific patterns
5. Update workspace registry with multi-repo structure

#### For Monorepo Projects
1. Import entire repository to Projects/{name}
2. Detect multi-language structure within monorepo
3. Generate comprehensive patterns.yaml
4. Single CLAUDE.md serves entire project

#### For Legacy Multi-Repo Projects
1. Import each component separately
2. Detect if components share old CONSTRUCT patterns
3. Extract common patterns to project-level .construct/
4. Component-specific patterns stay in component .construct/
5. Preserve import history for each component

### Workspace Commands (Updated)

#### `workspace-status`
```
CONSTRUCT Workspace Status
========================
CONSTRUCT: develop (v2.0.0)

Projects:
- MyApp (multi-repo):
  - ios:     develop → main [modified]
    Patterns: swift, mvvm, parker/run-ui-patterns
  - backend: main [clean]
    Patterns: csharp, clean-architecture
  - web:     feature/new-ui → main [ahead 3]
    Patterns: typescript, react-patterns
  Shared: cross-platform/model-sync
  
- SingleProject (monorepo): main [clean]
  Patterns: swift, mvvm
```

#### `workspace-update`
Regenerates CLAUDE.md files:
- For multi-repo: Updates each component's CLAUDE.md
- For monorepo: Updates single CLAUDE.md
- Includes both component and project-level patterns

#### `import-component`
Adds a new repository to existing multi-repo project:
```bash
workspace import-component MyApp frontend-v2 https://github.com/team/myapp-v2
```

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

## Implementation Considerations

### Multi-Repo Coordination

When working across components of a multi-repo project:

1. **Shared Patterns**: Project-level .construct/ defines patterns all components use
2. **Component Patterns**: Each repo's .construct/ adds specific needs
3. **Cross-Component Work**: "Update User model" affects ios/, backend/, and web/
4. **Branch Coordination**: Components may be on different branches

### Pattern Inheritance

For multi-repo projects:
```
Projects/MyApp/.construct/patterns.yaml          # Level 1: Project shared
    ↓
Projects/MyApp/ios/.construct/patterns.yaml      # Level 2: Component specific
    ↓
Generated CLAUDE.md includes both levels
```

### Git Workflow Examples

#### Updating Patterns Across Components
```bash
# In project-level
cd Projects/MyApp
vim .construct/patterns.yaml  # Add cross-platform/model-sync
cd ios && construct-patterns regenerate
cd ../backend && construct-patterns regenerate
cd ../web && construct-patterns regenerate
```

#### Component-Specific Pattern Work
```bash
cd Projects/MyApp/ios
vim .construct/patterns.yaml  # Add parker/swift-ui-animations
construct-patterns regenerate  # Only affects iOS
```

## Updated Success Metrics

1. **Multi-Repo Support**: 80% of projects use multiple repositories
2. **Component Independence**: Each repo maintains full autonomy
3. **Pattern Sharing**: 60% of multi-repo projects use shared patterns
4. **Branch Flexibility**: Components on different branches work smoothly

---

**Status**: Updated for Multi-Repository Reality
**Priority**: High (matches real-world architecture)
**Complexity**: Medium (additional coordination layer)
**Key Innovation**: Supports both multi-repo and monorepo projects