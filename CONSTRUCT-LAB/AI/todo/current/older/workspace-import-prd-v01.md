# PRD: CONSTRUCT Workspace & Project Import System

## Overview

This PRD defines how CONSTRUCT manages multiple independent projects within a workspace while preserving each project's git history and identity. It builds on the pattern system (unified-pattern-system-plan.md) to handle real-world scenarios of importing existing projects.

## Problem Statement

Developers need to:
1. Manage multiple related projects from one location
2. Import existing projects without losing git history
3. Upgrade projects using old CONSTRUCT versions
4. Share patterns and improvements across projects
5. Keep projects independent and deployable

Current pattern system plan addresses pattern management but not workspace organization and project imports.

## Goals

### Primary Goals
- Enable CONSTRUCT to manage multiple independent git repositories
- Preserve complete git history when importing projects
- Seamlessly migrate projects from old CONSTRUCT versions
- Share pattern discoveries across all workspace projects

### Non-Goals
- Force projects to use monorepo structure
- Require projects to change their git workflow
- Combine project histories into CONSTRUCT's git

## User Stories

### As a Developer
1. I want to import my existing Swift project into CONSTRUCT without losing any git history
2. I want each project to maintain its own repository so I can deploy independently
3. I want to upgrade old CONSTRUCT implementations to the pattern system
4. I want pattern improvements to be available across all my projects

### As a Team Lead
1. I want to standardize CONSTRUCT usage across our project portfolio
2. I want to preserve custom modifications teams have made
3. I want visibility into which patterns each project uses

## Technical Architecture

### Workspace Structure
```
CONSTRUCT/                          # Main workspace
├── .git/                          # CONSTRUCT's repository
├── .gitignore                     # Ignores Project-* directories
├── CONSTRUCT-CORE/                # Pattern library & tools
├── CONSTRUCT-LAB/                 # Pattern development
├── .construct-workspace/          # Workspace metadata
│   ├── registry.yaml             # Project registry
│   └── import-history/           # Preserved old CONSTRUCT files
├── Project-A-iOS/                # Independent project
│   ├── .git/                     # Project's own repository
│   ├── .construct/               # CONSTRUCT configuration
│   │   └── patterns.yaml         # Project's patterns
│   └── CLAUDE.md                 # Generated (gitignored)
└── Project-B-Backend/            # Another independent project
    └── .git/                     # Its own repository
```

### Key Design Decisions

#### 1. Git Independence
- Each project maintains its own .git directory
- CONSTRUCT's .gitignore excludes Project-* directories
- Only .construct/ metadata is visible to CONSTRUCT's git

#### 2. Pattern Integration
- Each project has .construct/patterns.yaml
- CLAUDE.md is generated, not tracked in git
- Projects can have custom rules in their patterns.yaml

#### 3. Import Intelligence
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

### Import Process Flow

#### For New Projects (No CONSTRUCT)
1. Clone project into workspace
2. Detect languages and frameworks
3. Suggest appropriate patterns
4. Generate .construct/patterns.yaml
5. Create initial CLAUDE.md
6. Update project's .gitignore

#### For Projects with Old CONSTRUCT
1. Clone project into workspace
2. Detect CONSTRUCT version
3. Preserve old files in import-history
4. Extract patterns and custom rules
5. Generate patterns.yaml with migration notes
6. Create new pattern-based CLAUDE.md
7. Commit migration to project's git

#### For Projects with Current CONSTRUCT
1. Clone project into workspace
2. Verify pattern system compatibility
3. Register in workspace

### Workspace Commands

#### `workspace-status`
Shows all projects, their patterns, and git status

#### `workspace-update`
Regenerates all CLAUDE.md files with latest patterns

#### `workspace-analyze`
Finds common patterns and suggests standardization

## Migration Strategy

### From unified-pattern-system-plan.md
The pattern system provides the foundation. This PRD adds:
- Workspace organization
- Git independence
- Import workflows
- Legacy migration

### Integration Points
1. Uses assemble-claude.sh for CLAUDE.md generation
2. Uses patterns.yaml structure
3. Extends migration scripts for workspace context
4. Leverages pattern promotion system

## Success Metrics

1. **Import Success Rate**: 95% of projects import without manual intervention
2. **Git History Preservation**: 100% of project history maintained
3. **Pattern Migration**: 90% of old CONSTRUCT patterns successfully extracted
4. **Developer Satisfaction**: Teams can work independently while sharing patterns

## Risks & Mitigations

### Risk: Git Complexity
**Mitigation**: Keep simple directory structure, no submodules initially

### Risk: Pattern Conflicts
**Mitigation**: Project-specific patterns.yaml allows customization

### Risk: Large Workspace
**Mitigation**: Workspace commands work with subsets of projects

## Future Enhancements

1. **Git Submodule Support**: For tighter integration
2. **Automated Pattern Discovery**: Learn from project changes
3. **CI/CD Integration**: Workspace-wide testing
4. **Pattern Analytics**: Track pattern usage and effectiveness

## Dependencies

- Pattern system (unified-pattern-system-plan.md)
- Basic CONSTRUCT structure (CONSTRUCT-RESTRUCTURE-PLAN-04.md)
- Migration tools (construct-integration-system.md)

## Timeline

- Week 1: Workspace foundation
- Week 2: Basic import functionality  
- Week 3: Legacy CONSTRUCT support
- Week 4: Testing with real projects

---

**Status**: Ready for Review
**Priority**: High (enables real-world adoption)
**Complexity**: Medium (builds on pattern system)