# CONSTRUCT Abstraction Roadmap

## Overview
CONSTRUCT, originally built for RUN (an iOS/Watch app), is being abstracted into a general-purpose, open-source tool for AI-assisted development, enhancing Claude Code with pattern-based context engineering. This roadmap tracks the steps to extract iOS-specific patterns, integrate with Claude Code’s `/init`, support multi-language projects, preserve existing context engineering scripts, and ensure script compatibility with Claude Code’s non-interactive environment, reducing context overload for tracking todos.

## Current State
- **CONSTRUCT/CLAUDE.md**: Created by `/init`, to be enhanced as the system orchestrator with dynamic context loading.
- **CONSTRUCT-CORE/CLAUDE.md**: Legacy iOS-specific rules from RUN, needs extraction to pattern files.
- **CONSTRUCT-CORE/CLAUDE-BASE.md**: Template for project `CLAUDE.md` files, will contain universal principles after iOS extraction.
- **CONSTRUCT-LAB/CLAUDE.md**: Does not exist (correct).
- **Projects/*/CLAUDE.md**: Generated per project using `CLAUDE-BASE.md` + selected patterns.
- **Pattern System**: Organized under `CONSTRUCT-CORE/patterns/`:
  - `plugins/` - Contains all pattern files by category
  - `lib/` - Pattern utilities (planned)
  - `templates/` - Configuration templates

## Abstraction Todos
### Priority 0 (P0): Critical for RUN (4-Day Sprint)
- [ ] **Extract iOS Patterns** (`v32.md`, conversation):
  - Pattern files already exist in `patterns/plugins/`:
    - ✅ `languages/swift.md` (merge with swift-new.md)
    - ✅ `frameworks/swiftui.md`
    - ✅ `architectural/mvvm-ios.md`
    - ✅ `platforms/ios.md`
  - Task: Review `CONSTRUCT-CORE/CLAUDE.md` for any remaining iOS content not in patterns
  - Task: Merge `languages/swift-new.md` into `languages/swift.md`
- [ ] **Convert CLAUDE-BASE.md** (`v32.md`, conversation):
  - Update `CONSTRUCT-CORE/CLAUDE-BASE.md` to be a universal template:
    ```markdown
    # CONSTRUCT Base Patterns
    ## Universal Principles
    - Never break existing tests
    - Document intent, not mechanics
    - Error handling is mandatory
    ## Pattern System
    - Configured via .construct/patterns.yaml
    - Run `construct-patterns regenerate` to update
    ## Available Scripts
    - [Populated based on project languages]
    ```
  - Remove iOS-specific content.
- [ ] **Remove Redundant CLAUDE.md Files** (`v11.md`, conversation):
  - Delete `CONSTRUCT-CORE/CLAUDE.md` after extraction complete
  - Note: `CONSTRUCT-LAB/CLAUDE.md` doesn't exist (correct)
- [ ] **Update Context Engineering Scripts** (`v01.md`):
  - Modify `assemble-claude.sh` to preserve dynamic sections (`<!-- START:DYNAMIC-CONTEXT -->`).
  - Update `update-context.sh` to detect pattern-based projects and append dynamic sections (e.g., `CURRENT-STRUCTURE`).
  - Test with RUN to ensure no breakage.

### Priority 1 (P1): Enhance Integration (1-2 Weeks Post-Sprint)
- [ ] **Implement `/init` Integration** (`integrate-init.txt`, `v32.md`):
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
- [ ] **Add Dynamic Context Orchestration** (`dynamic-context-orchestration-prd.md`):
  - Update `CONSTRUCT/CLAUDE.md` with orchestration logic:
    ```markdown
    ## Dynamic Context Orchestration
    I can load contexts dynamically:
    - `pwd`: Check current location.
    - `cat Projects/*/CLAUDE.md`: Load project context.
    - `git branch --show-current`: Check branch-specific patterns.
    ```
  - Implement `context-detect.sh` for path-based detection:
    ```bash
    #!/bin/bash
    # CONSTRUCT-CORE/CONSTRUCT/scripts/context-detect.sh
    ACTIVE_FILE="$1"
    case "$ACTIVE_FILE" in
        *.swift) echo "swift-mvvm" ;;
        *Models/* | *Entities/*) echo "swift-mvvm,model-sync" ;;
        *) echo "swift-mvvm" ;;
    esac
    ```
- [ ] **Add Interactive Script Support** (`interactive-scripts-prd.md`):
  - Create `lib/interactive-support.sh` for `--show-prompts` flag.
  - Update priority scripts (`create-project.sh`, `import-project.sh`, `construct-patterns.sh`):
    ```bash
    # Example: create-project.sh
    source "$CONSTRUCT_CORE/CONSTRUCT/lib/interactive-support.sh"
    show_my_prompts() {
        echo "1. Additional plugins (comma-separated)"
        echo "   Available: swift, mvvm, model-sync"
        echo "   Default: swift,mvvm"
    }
    if should_show_prompts "$@"; then
        show_script_prompts "$(basename "$0")" show_my_prompts
        exit 0
    fi
    ```

### Priority 2 (P2): Scalability (Post-RUN Milestones)
- [ ] **Test `import-project.sh`** (`v11.md`):
  - Import RUN’s iOS, backend, and web repos, verify git history and `CLAUDE.md` generation.
- [ ] **Migrate Scripts** (`v32.md`):
  - Move `scripts-new/` to `CONSTRUCT-CORE/CONSTRUCT/scripts/`.
- [ ] **Enhance Context Engineering** (`v01.md`):
  - Update remaining scripts (`check-architecture.sh`, `session-summary.sh`, `check-quality.sh`, `workspace-status.sh`) to support patterns and dynamic sections.
- [ ] **Add Contributor Docs** (`v32.md`):
  - Update `PATTERN-GUIDE.md` with a “Quick Contributor Guide” when publishing on GitHub.

## Key Clarifications
- **One `CONSTRUCT/CLAUDE.md`**: Enhanced post-`/init` as the system orchestrator.
- **Project `CLAUDE.md` Generation**: Uses `CLAUDE-BASE.md` + patterns from `plugins/`.
- **No `CLAUDE.md` in CORE/LAB**: Only `CLAUDE-BASE.md` in CORE (after removing legacy CLAUDE.md).
- **Pattern Organization**: All patterns in `CONSTRUCT-CORE/patterns/plugins/` by category.
- **Context Engineering**: Preserves dynamic sections and scripts, integrates with patterns.
- **Interactive Scripts**: Support Claude Code with `--show-prompts` for all scripts.

## Next Steps
- Start four-day sprint for P0 todos.
- Update `CONSTRUCT-ARCHITECTURE-CHEATSHEET.md` with progress.
- Test with RUN, monitor for context bloat, and decide on `context-detect.sh`.
- Publish blog post with refinements:
  - Add: “CONSTRUCT enhances Claude Code’s `/init` with dynamic, pattern-based context.”
  - Add: “Born in RUN, it streamlines SwiftUI and model-sync tasks, now scaling to all languages.”
  - Add: “Contribute patterns via our upcoming GitHub repo—no complex setup.”