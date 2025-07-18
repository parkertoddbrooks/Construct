# PRD: Tracking System Evolution for CONSTRUCT

## Overview
Evolution path for CONSTRUCT's todo/bug/PRD tracking system, from simple file-based approach to scalable collaboration-ready system. Maintains CONSTRUCT's philosophy of simplicity, text-based tools, and pattern-driven development while providing clear upgrade paths as needs grow.

## Current State
```
CONSTRUCT-LAB/AI/
├── PRDs/        # Product requirement documents
├── todo/        # Todo items and tasks
└── bugs/        # Bug tracking (if exists)
```

Simple, file-based, perfect for solo development but lacks structure for collaboration.

## Problem Statement
- No standardized format for tracking items
- Difficult to query status across items
- No clear workflow states
- Hard to onboard collaborators
- No integration with external tools (GitHub)
- Manual archiving and organization

## Solution Options

### Option 1: Enhanced File-Based System (Minimal Change)
Keep current structure but add conventions and tooling:

```yaml
# .construct/tracking.yaml
tracking:
  todos:
    format: "markdown"
    template: "todo-template.md"
    states: ["pending", "in-progress", "blocked", "done"]
    archive_after: "30d"
  
  bugs:
    severity: ["critical", "high", "medium", "low"]
    auto_link_commits: true
    
  prds:
    stages: ["draft", "review", "approved", "implemented"]
    auto_generate_todos: true
```

**Pros**: Minimal change, backwards compatible
**Cons**: Still manual, limited querying

### Option 2: Git-Based Issue Tracking
Use git itself as the database:

```bash
CONSTRUCT-LAB/
└── .issues/              # Git-tracked issues
    ├── open/
    │   ├── bug-001.md
    │   ├── todo-042.md
    │   └── prd-003.md
    ├── closed/
    └── index.yaml        # Searchable index

# Commands via pattern
construct-issue create bug "Pattern validator fails on symlinks"
construct-issue list --type=todo --status=open
construct-issue close bug-001 --link-commit=abc123
```

**Pros**: Version controlled, scriptable, offline-first
**Cons**: Requires tooling development

### Option 3: GitHub Integration Pattern
Bridge file system with GitHub:

```yaml
# patterns/plugins/tracking/github-sync.md
github:
  repo: "parkertoddbrooks/CONSTRUCT"
  issue_labels:
    todo: ["todo", "construct"]
    bug: ["bug", "construct"]
    prd: ["enhancement", "prd"]
  
  sync:
    direction: "bidirectional"
    frequency: "on-commit"
```

**Pros**: Collaboration-ready, issue discussions, assignment
**Cons**: External dependency, complexity

### Option 4: Hybrid Markdown + Tooling (Recommended)
Structure existing directories better:

```
AI/tracking/                    # Renamed from todo/PRDs
├── README.md                   # Overview dashboard
├── active/
│   ├── todos.md               # Current sprint todos
│   ├── bugs.md                # Active bugs
│   └── prds/                  # Active PRDs
│       └── self-learning.md
├── backlog/
│   ├── todos/
│   ├── bugs/
│   └── prds/
├── completed/                  # Auto-archived
│   └── 2025-07/
└── .tracking/
    ├── templates/
    └── state.yaml             # Tracking metadata
```

With tooling commands:
```bash
construct-track add todo "Implement pattern fusion"
construct-track move todo-123 active backlog
construct-track report --sprint
construct-track archive --older-than=30d
```

**Pros**: 
- Minimal change from current system
- Clear structure and workflows
- Easily scriptable
- AI-friendly (markdown)
- Natural upgrade path

**Cons**: 
- Still requires some tooling
- Manual without scripts

### Option 5: Lightweight Project Management Pattern
Create a pattern plugin:

```yaml
# patterns/plugins/project/tracking.yaml
templates:
  todo: |
    # TODO: {{title}}
    ID: {{id}}
    Created: {{date}}
    Priority: {{priority}}
    Status: {{status}}
    Tags: {{tags}}
    
    ## Description
    {{description}}
    
    ## Acceptance Criteria
    - [ ] 
    
  bug: |
    # BUG: {{title}}
    ID: {{id}}
    Severity: {{severity}}
    Reported: {{date}}
    Status: {{status}}
    
    ## Steps to Reproduce
    ## Expected vs Actual
    ## Fix

workflows:
  todo_states: "idea → planned → active → review → done"
  bug_states: "reported → confirmed → fixing → testing → resolved"
  prd_states: "draft → feedback → approved → implementing → shipped"
```

## Pattern Integration Strategy

```yaml
# .construct/patterns.yaml
plugins:
  - "tracking/simple-todos"      # Current approach
  - "tracking/github-sync"       # When ready to collaborate
  - "tracking/bug-workflow"      # Bug-specific workflows

tracking:
  backend: "markdown"            # or "github", "git-bug"
  auto_id: true
  link_commits: true
  dashboards:
    - "sprint-view"
    - "bug-heatmap"
    - "prd-timeline"
```

## Recommendation

**Phase 1 (Now)**: Continue with current system
- It works for solo development
- No overhead
- Focus on building CONSTRUCT features

**Phase 2 (When needed)**: Implement Option 4 (Hybrid Markdown)
- Add structure to existing files
- Create simple tooling scripts
- Maintain markdown source of truth
- Templates for consistency

**Phase 3 (Collaboration)**: Add GitHub sync
- Keep markdown as primary
- Sync to GitHub Issues
- Enable discussions/assignment
- Maintain local-first approach

## Benefits of This Evolution

1. **No Disruption**: Current system continues working
2. **Gradual Enhancement**: Add features as needed
3. **Pattern-Driven**: Each phase is a pattern plugin
4. **Local-First**: Always works offline
5. **AI-Friendly**: Markdown remains readable
6. **Collaboration-Ready**: Clear path to team scaling

## Implementation Priority

Given current solo development status: **LOW PRIORITY**

Focus on:
1. Building core CONSTRUCT features
2. Pattern system improvements
3. Self-learning capabilities

Revisit when:
- Onboarding collaborators
- Managing 50+ active items
- Need external visibility
- Want automated workflows

## Summary

Current file-based system is appropriate for solo development. This PRD captures evolution options for when scaling is needed. The hybrid markdown approach (Option 4) provides the best balance of simplicity and future capability, maintaining CONSTRUCT's philosophy while enabling growth.