# CONSTRUCT Workspace Management

## Overview

CONSTRUCT uses two distinct configuration directories to manage projects and workspaces:

- `.construct/` - Project-level configuration
- `.construct-workspace/` - Workspace-level management

## Directory Structure

```
Your-Workspace/                     # Root workspace directory
├── .construct-workspace/           # Workspace management (only at root)
│   ├── registry.yaml              # Tracks all imported projects
│   └── import-history/            # Backup of migrated files
│
├── .construct/                    # CONSTRUCT's own project config
│   └── patterns.yaml             # Patterns for CONSTRUCT itself
│
├── CONSTRUCT-CORE/               # Core CONSTRUCT code
├── CONSTRUCT-LAB/                # Experimental features
│
└── Projects/                     # Imported projects live here
    ├── MyApp/
    │   ├── .construct/           # MyApp's project config
    │   │   └── patterns.yaml     # MyApp's active patterns
    │   └── [app code...]
    │
    └── AnotherProject/
        ├── .construct/           # AnotherProject's config
        │   └── patterns.yaml
        └── [project code...]
```

## `.construct/` - Project Configuration

**Purpose**: Configure patterns and rules for a specific project

**Location**: In EVERY project root that uses CONSTRUCT

**Contains**:
- `patterns.yaml` - Defines active patterns, languages, and custom rules
- `CLAUDE.md.sha256` - Checksum for generated CLAUDE.md

**Created by**:
- `create-project.sh` - When creating new projects
- `import-project.sh` - When importing existing projects
- Manual creation with `construct-patterns init`

**Example patterns.yaml**:
```yaml
# Languages used in this project
languages:
  - swift
  - python

# Active pattern plugins
plugins:
  - languages/swift
  - architectural/mvvm-ios
  - tooling/error-handling

# Project-specific rules
custom_rules:
  ui:
    - "All views must support dark mode"
    - "Use design tokens for spacing"

# Pattern overrides
overrides: []

# Include external patterns
includes: []
```

## `.construct-workspace/` - Workspace Management

**Purpose**: Manage multiple projects in a monorepo/workspace setup

**Location**: ONLY at the workspace root (where CONSTRUCT lives)

**Contains**:
- `registry.yaml` - Tracks all imported projects and their metadata
- `import-history/` - Backups from project migrations

**Created by**:
- `import-project.sh` - When first importing a project
- `import-component.sh` - When adding multi-repo components

**Example registry.yaml**:
```yaml
construct:
  branch: main
  version: 2.0.0
  last_updated: 2025-07-10

projects:
  MyApp:
    path: ./Projects/MyApp
    repo: https://github.com/user/MyApp
    branch: feature/new-ui
    default_branch: main
    patterns:
      - languages/swift
      - architectural/mvvm-ios
    components:
      - name: MyApp-API
        path: ./Projects/MyApp/API
        repo: https://github.com/user/MyApp-API

workspace:
  created: 2025-07-07
  total_projects: 1
  active_plugins:
    - languages/swift
    - architectural/mvvm-ios
```

## Use Cases

### Single Project Development

If you're just using CONSTRUCT for one project:
- Only `.construct/` matters
- No need for `.construct-workspace/`
- Your project has its own `patterns.yaml`

### Multi-Project Workspace (Monorepo Style)

When managing multiple related projects:
- `.construct-workspace/` at the root tracks everything
- Each project has its own `.construct/` config
- Use workspace scripts to manage:
  - `import-project.sh` - Import new projects
  - `workspace-status.sh` - View all projects
  - `workspace-update.sh` - Update all CLAUDE.md files

### CONSTRUCT Development

The CONSTRUCT repository itself has both:
- `.construct/` - Because CONSTRUCT is a project with patterns
- `.construct-workspace/` - To manage imported test projects

## Key Commands

### Project Level
```bash
# Create new project with patterns
create-project.sh ./MyNewApp ios

# Regenerate CLAUDE.md for current project
construct-patterns regenerate

# Check project quality
check-quality.sh .
```

### Workspace Level
```bash
# Import existing project
import-project.sh ~/Code/MyApp

# Check status of all projects
workspace-status.sh

# Update all projects' CLAUDE.md
workspace-update.sh --all

# Add component to multi-repo project
import-component.sh ~/Code/MyApp-API MyApp API
```

## Best Practices

1. **Don't edit `.construct-workspace/` manually**
   - Use the workspace scripts
   - Registry is automatically maintained

2. **Each project owns its `.construct/`**
   - Commit patterns.yaml with the project
   - Don't share between projects

3. **Workspace root is special**
   - Only place with `.construct-workspace/`
   - Usually where CONSTRUCT itself lives

4. **Git independence**
   - Each project keeps its own git repo
   - Workspace doesn't interfere with project git

## Migration from Old CONSTRUCT

If importing projects from CONSTRUCT v1:
- Old files backed up to `.construct-workspace/import-history/`
- Automatic pattern detection
- Custom rules preserved

## Troubleshooting

**"No .construct/patterns.yaml found"**
- Run `construct-patterns init` in the project
- Or use `create-project.sh` to set up properly

**"Workspace registry not found"**
- You're not in a workspace root
- Or need to import your first project

**Multiple `.construct-workspace/` directories**
- Only have one at workspace root
- Remove any in subdirectories