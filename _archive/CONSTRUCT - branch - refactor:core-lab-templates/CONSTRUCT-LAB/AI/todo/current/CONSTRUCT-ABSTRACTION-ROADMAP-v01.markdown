# CONSTRUCT Abstraction Roadmap

## Overview
CONSTRUCT originated in RUN (an iOS/Watch app) and is being abstracted into a general-purpose, open-source tool for AI-assisted development. This roadmap tracks the steps to extract iOS-specific patterns, integrate with Claude Code’s `/init`, and support multi-language projects, reducing context overload.

## Current State
- **CONSTRUCT/CLAUDE.md**: Created by `/init`, to be enhanced as the system orchestrator.
- **CONSTRUCT-CORE/CLAUDE.md**: Legacy iOS-specific rules from RUN, needs extraction.
- **CONSTRUCT-CORE/CLAUDE-BASE.md**: Template for project `CLAUDE.md` files, includes universal principles, pattern integration, and language-specific scripts.
- **CONSTRUCT-LAB/CLAUDE.md**: Unnecessary, to be removed.
- **Projects/*/CLAUDE.md**: Generated per project using `CLAUDE-BASE.md` + `patterns.yaml`.

## Abstraction Todos
### Priority 0 (P0): Critical for RUN
- [ ] **Extract iOS Patterns**:
  - Move iOS-specific rules from `CONSTRUCT-CORE/CLAUDE.md` to:
    - `patterns/languages/swift.md`
    - `patterns/frameworks/swiftui.md`
    - `patterns/architecture/mvvm-ios.md`
  - Example: Swift concurrency, MVVM rules.
- [ ] **Convert CLAUDE-BASE.md**:
  - Update `CONSTRUCT-CORE/CLAUDE-BASE.md` to be a universal template:
    - Universal principles (e.g., error handling).
    - Pattern system integration (how to use `patterns.yaml`).
    - Placeholder for language-specific scripts.
  - Remove iOS-specific content.
- [ ] **Remove CONSTRUCT-CORE/CLAUDE.md**:
  - After extraction, delete to avoid confusion.
- [ ] **Remove CONSTRUCT-LAB/CLAUDE.md**:
  - Merge any CONSTRUCT dev patterns into `CONSTRUCT/CLAUDE.md`.

### Priority 1 (P1): Enhance Integration
- [ ] **Document `/init` Integration**:
  - Create `construct-init.sh` to enhance `/init`-generated `CONSTRUCT/CLAUDE.md`:
    ```bash
    #!/bin/bash
    # CONSTRUCT-CORE/CONSTRUCT/scripts/construct-init.sh
    if [ ! -f "CLAUDE.md" ]; then
        echo "Run /init first to create CLAUDE.md"
        exit 1
    fi
    cat >> CLAUDE.md << 'EOF'
## 🚀 CONSTRUCT Enhancement
This is a CONSTRUCT workspace with pattern-based context management.
### Commands
- `check context`: Detect project and load patterns.
- `load project [name]`: Load specific project context.
- `refresh patterns`: Regenerate CLAUDE.md.
### Projects
$(for project in Projects/*/; do echo "- $project"; done)
EOF
    ```
- [ ] **Define Root CLAUDE.md Role**:
  - Update `CONSTRUCT/CLAUDE.md` to include:
    - CONSTRUCT system overview.
    - Dynamic context loading instructions (e.g., `cat Projects/*/CLAUDE.md`).
    - List of projects from `.construct-workspace/registry.yaml`.

### Priority 2 (P2): Scalability
- [ ] **Test `import-project.sh`**:
  - Import RUN’s iOS, backend, and web repos (`v11.md`).
  - Verify `CLAUDE.md` generation and git history preservation.
- [ ] **Migrate Scripts**:
  - Move `scripts-new/` to `CONSTRUCT-CORE/CONSTRUCT/scripts/`.
- [ ] **Add Dynamic Context Detection**:
  - Implement `context-detect.sh` if static `CLAUDE.md` shows bloat (per `v32.md` addendum).

## Key Clarifications
- **One `CLAUDE.md` for CONSTRUCT**: `CONSTRUCT/CLAUDE.md` is the system orchestrator, enhanced post-`/init`.
- **Project `CLAUDE.md` Generation**: Uses `CLAUDE-BASE.md` + `patterns.yaml` for each project.
- **No `CLAUDE.md` in CORE/LAB**: Avoid redundancy; CORE has `CLAUDE-BASE.md` only.
- **`/init` Integration**: `/init` creates `CONSTRUCT/CLAUDE.md`, enhanced by `construct-init.sh`.

## Next Steps
- Start with P0 todos in a four-day sprint.
- Update `CONSTRUCT-ARCHITECTURE-CHEATSHEET.md` with abstraction progress.
- Test with RUN to validate `CLAUDE.md` generation.