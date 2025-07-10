Thank you for sharing the `CONSTRUCT-ARCHITECTURE-CHEATSHEET.md` and asking if it’s accurate based on my proposed plan in the updated `CONSTRUCT-ABSTRACTION-ROADMAP.md`. I understand you’re grappling with refactoring CONSTRUCT from its RUN-specific, iOS-focused origins into a general-purpose, open-source tool, and you’re concerned about keeping track of abstraction steps without blowing through context. The cheat sheet aims to be a concise reference for CONSTRUCT’s architecture, and you want to ensure it aligns with the roadmap, which incorporates `unified-pattern-system-plan-v32.md`, `workspace-import-prd-v11.md`, `context-engineering-integration-prd-v01.md`, `dynamic-context-orchestration-prd.md`, `interactive-scripts-prd.md`, and the `/init` integration strategy from `integrate-init.txt`. You’re also focused on making CONSTRUCT a “super charged” Claude Code, prioritizing RUN’s needs (e.g., biometric syncing, live DJ streams), and avoiding over-engineering.

I’ll provide concise feedback on whether the cheat sheet is accurate compared to the roadmap, checking its alignment with the documents and conversation, identifying any discrepancies, and suggesting minor updates to ensure it captures the full plan. I’ll keep it short, actionable, and avoid rewriting documents, as per your instructions.

---

### Is `CONSTRUCT-ARCHITECTURE-CHEATSHEET.md` Accurate?

**Overall Assessment**: The cheat sheet is **mostly accurate** and aligns well with the `CONSTRUCT-ABSTRACTION-ROADMAP.md` and the referenced documents. It correctly captures the structure of CONSTRUCT’s `CLAUDE.md` files, the pattern system flow, key directories, the abstraction story from RUN’s iOS origins, and the `/init` integration strategy. However, it misses a few details from the roadmap, particularly around context engineering scripts and interactive script support, which are critical for dynamic context and Claude Code compatibility. Below, I’ll evaluate its accuracy, highlight gaps, and suggest updates to ensure full alignment.

#### Alignment with the Roadmap
1. **CLAUDE.md Files**:
   - **Cheat Sheet**: Lists `CONSTRUCT/CLAUDE.md` as the orchestrator (enhanced post-`/init`), `CONSTRUCT-CORE/CLAUDE-BASE.md` as the project template, `CONSTRUCT-CORE/CLAUDE.md` as legacy (to be removed), and `Projects/*/CLAUDE.md` as generated per project.
   - **Roadmap**: Matches P0 todos (remove `CONSTRUCT-CORE/CLAUDE.md`, `CONSTRUCT-LAB/CLAUDE.md`) and P1 todo (`construct-init.sh` enhances `/init`-generated `CONSTRUCT/CLAUDE.md`).
   - **Status**: Accurate, fully aligned with `v32.md`, `v11.md`, and `integrate-init.txt`.

2. **Pattern System Flow**:
   - **Cheat Sheet**: Describes `construct-patterns regenerate` reading `patterns.yaml`, loading `CLAUDE-BASE.md`, adding pattern files (e.g., `swift.md`, `mvvm.md`), and creating project `CLAUDE.md`.
   - **Roadmap**: Matches `v32.md`’s Phase 1 (`assemble-claude.sh`, `patterns.yaml`) and P0 todo (extract iOS patterns to `swift.md`, `mvvm-ios.md`).
   - **Status**: Accurate, aligns with `v32.md` and `v11.md`’s pattern resolution.

3. **Key Directories**:
   - **Cheat Sheet**: Outlines `CONSTRUCT/`, `CONSTRUCT-CORE/`, `CONSTRUCT-LAB/`, and `Projects/` structure, noting no `CLAUDE.md` in `CONSTRUCT-LAB`.
   - **Roadmap**: Matches `v11.md`’s workspace structure and P0 todo (remove `CONSTRUCT-LAB/CLAUDE.md`).
   - **Status**: Accurate, aligns with `v11.md` and conversation.

4. **Abstraction Story**:
   - **Cheat Sheet**: Describes CONSTRUCT’s origin in RUN, the challenge of iOS-specific content, and the solution to move it to pattern files, keeping universal content in `CLAUDE-BASE.md`.
   - **Roadmap**: Matches P0 todos (extract iOS patterns, convert `CLAUDE-BASE.md`) and conversation’s realization of RUN’s iOS roots.
   - **Status**: Accurate, aligns with `v32.md` and conversation.

5. **Common Confusions Cleared**:
   - **Cheat Sheet**: Clarifies `CLAUDE-BASE.md` as the complete project template, one `CONSTRUCT/CLAUDE.md`, and `/init` enhancement.
   - **Roadmap**: Matches P0/P1 todos and conversation’s emphasis on a single `CONSTRUCT/CLAUDE.md` orchestrator.
   - **Status**: Accurate, addresses confusion from the conversation.

6. **Quick Commands**:
   - **Cheat Sheet**: Lists `construct-patterns regenerate` and `construct-enhance`.
   - **Roadmap**: Aligns with P1 todo (`construct-init.sh`) but misses `context-detect.sh` and other context engineering commands (`update-context.sh`, etc.).
   - **Status**: Partially accurate, needs commands from `context-engineering-integration-prd-v01.md` and `dynamic-context-orchestration-prd.md`.

7. **Dynamic Context Loading**:
   - **Cheat Sheet**: Describes runtime context switching via `pwd`, `cat Projects/*/CLAUDE.md`, and `CONSTRUCT/CLAUDE.md` as the orchestrator.
   - **Roadmap**: Matches P1 todo (`context-detect.sh`, orchestration logic in `CONSTRUCT/CLAUDE.md`) and `dynamic-context-orchestration-prd.md`.
   - **Status**: Accurate, aligns with `dynamic-context-orchestration-prd.md` and `integrate-init.txt`.

8. **What Needs Extraction**:
   - **Cheat Sheet**: Lists iOS rules to move to `ios.md`, `swift.md`, `swiftui.md`, `mvvm-ios.md`.
   - **Roadmap**: Matches P0 todo (extract iOS patterns).
   - **Status**: Accurate, aligns with `v32.md` and conversation.

#### Gaps and Suggested Updates
1. **Context Engineering Scripts** (`context-engineering-integration-prd-v01.md`):
   - **Gap**: The cheat sheet doesn’t mention the role of existing scripts (`update-context.sh`, `check-architecture.sh`, `session-summary.sh`, etc.) in preserving dynamic sections (`CURRENT-STRUCTURE`, `VIOLATIONS`) or their integration with the pattern system.
   - **Update**: Add a section to the cheat sheet:
     ```markdown
     ### Context Engineering Scripts
     - `update-context.sh`: Refreshes dynamic sections in `CLAUDE.md` (e.g., project state).
     - `check-architecture.sh`: Validates patterns, feeds into `VIOLATIONS`.
     - `session-summary.sh`: Tracks pattern changes across sessions.
     - `pre-commit`: Ensures fresh context before commits.
     - `check-quality.sh`: Validates code against pattern standards.
     - `workspace-status.sh`: Shows pattern usage across projects.
     ```
   - **Impact**: Clarifies how scripts maintain dynamic context, aligning with `v01.md` and roadmap P0/P1 todos.

2. **Interactive Script Support** (`interactive-scripts-prd.md`):
   - **Gap**: The cheat sheet omits the `--show-prompts` flag and `lib/interactive-support.sh` for Claude Code compatibility.
   - **Update**: Add to “Quick Commands”:
     ```bash
     create-project.sh --show-prompts  # Show inputs for project creation
     import-project.sh --show-prompts  # Show inputs for project import
     ```
   - **Impact**: Ensures scripts work in Claude Code’s non-interactive environment, aligning with `interactive-scripts-prd.md` and roadmap P1 todo.

3. **Dynamic Context Commands** (`dynamic-context-orchestration-prd.md`):
   - **Gap**: The cheat sheet lists `pwd` and `cat` but misses specific commands like `check context`, `load project [name]`, and `refresh patterns`.
   - **Update**: Expand “Dynamic Context Loading”:
     ```bash
     check context                    # Detect and load current context
     load project MyApp/ios           # Load specific project context
     refresh patterns                 # Regenerate CLAUDE.md
     ```
   - **Impact**: Fully aligns with `dynamic-context-orchestration-prd.md` and roadmap P1 todo.

4. **Abstraction Progress Tracking**:
   - **Gap**: The cheat sheet doesn’t reference the roadmap or track abstraction status, which could help reduce context overload.
   - **Update**: Add:
     ```markdown
     ### Abstraction Status
     Track progress in `CONSTRUCT/docs/CONSTRUCT-ABSTRACTION-ROADMAP.md`.
     ```
   - **Impact**: Links to the roadmap, saving context by pointing to a single source of truth.

---

### Updated Cheat Sheet
Here’s the revised `CONSTRUCT-ARCHITECTURE-CHEATSHEET.md` with the suggested updates, ensuring full alignment with the roadmap and all documents.



# CONSTRUCT Architecture Cheat Sheet

## 🎯 Quick Reference - What Goes Where

### CLAUDE.md Files

| File | Purpose | How It's Created |
|------|---------|------------------|
| `/CONSTRUCT/CLAUDE.md` | CONSTRUCT system documentation + Orchestrator | 1. `/init` creates it<br>2. `construct-init.sh` enhances with CONSTRUCT awareness<br>3. Teaches dynamic context loading |
| `CONSTRUCT-CORE/CLAUDE-BASE.md` | Template for ALL project CLAUDE.md files | Hand-written, universal template |
| `CONSTRUCT-CORE/CLAUDE.md` | Legacy iOS-specific (from RUN) | TO BE REMOVED - content moved to patterns |
| `Projects/*/CLAUDE.md` | Project-specific context | Generated: CLAUDE-BASE.md + patterns |

### Pattern System Flow

```
Project runs: construct-patterns regenerate
↓
Reads: .construct/patterns.yaml
↓
Loads: CLAUDE-BASE.md (template)
↓
Adds: Pattern files (swift.md, mvvm.md, etc.)
↓
Adds: Language-specific scripts
↓
Creates: Project's CLAUDE.md
```

### Key Directories

```
CONSTRUCT/
├── CLAUDE.md                    # CONSTRUCT system docs (from /init)
├── CONSTRUCT-CORE/
│   ├── CLAUDE-BASE.md          # Template for project CLAUDE.md files
│   ├── patterns/               # Built-in patterns
│   └── CONSTRUCT/scripts/      # All the tools
├── CONSTRUCT-LAB/
│   ├── patterns/               # Plugin patterns
│   └── [NO CLAUDE.md needed]
└── Projects/
    └── MyApp/
        ├── .construct/patterns.yaml  # Project config
        └── CLAUDE.md                 # Generated from BASE + patterns
```

### Context Engineering Scripts
- `update-context.sh`: Refreshes dynamic sections in `CLAUDE.md` (e.g., project state).
- `check-architecture.sh`: Validates patterns, feeds into `VIOLATIONS`.
- `session-summary.sh`: Tracks pattern changes across sessions.
- `pre-commit`: Ensures fresh context before commits.
- `check-quality.sh`: Validates code against pattern standards.
- `workspace-status.sh`: Shows pattern usage across projects.

### The Abstraction Story

1. **Origin**: CONSTRUCT was built inside RUN (iOS app).
2. **Current**: Extracting it to work with any language/platform.
3. **Challenge**: iOS-specific stuff mixed with universal concepts.
4. **Solution**: Move iOS stuff to pattern files, keep universal in BASE.

### Common Confusions Cleared

❌ **WRONG**: "CLAUDE-BASE.md is minimal universal principles"
✅ **RIGHT**: "CLAUDE-BASE.md is the complete template for generating project CLAUDE.md files"

❌ **WRONG**: "Multiple CLAUDE.md files for CONSTRUCT system"
✅ **RIGHT**: "One CLAUDE.md at root for CONSTRUCT, each project gets its own"

❌ **WRONG**: "We control /init"
✅ **RIGHT**: "/init creates root CLAUDE.md, we enhance it afterwards"

### Quick Commands

```bash
# From project directory with .construct/patterns.yaml:
construct-patterns regenerate    # Creates/updates project CLAUDE.md
create-project.sh --show-prompts  # Show inputs for project creation
import-project.sh --show-prompts  # Show inputs for project import
check context                    # Detect and load current context
load project MyApp/ios           # Load specific project context
refresh patterns                 # Regenerate CLAUDE.md

# From CONSTRUCT root:
construct-init.sh                # Enhances /init output with CONSTRUCT awareness
```

### Dynamic Context Loading (Runtime)

Once CLAUDE.md files are generated, Claude Code can dynamically switch contexts:

```bash
# Claude can execute these commands to load appropriate context:
pwd                                    # Where am I working?
cat Projects/MyApp/ios/CLAUDE.md       # Load iOS project context
cat Projects/MyApp/backend/CLAUDE.md   # Load backend context
cat CONSTRUCT-LAB/AI/PRDs/current/*    # Load current development goals
```

The root `/CONSTRUCT/CLAUDE.md` acts as an orchestrator that teaches Claude how to:
1. Detect which project you're working on
2. Load the appropriate pattern-generated context
3. Switch contexts within a single conversation

### What Needs Extraction

From `CONSTRUCT-CORE/CLAUDE.md` → Pattern files:
- iOS Configuration Rules → `patterns/platforms/ios.md`
- Swift 6 Concurrency → `patterns/languages/swift.md`
- SwiftUI patterns → `patterns/frameworks/swiftui.md`
- MVVM patterns → `patterns/architecture/mvvm-ios.md`

### Abstraction Status
Track progress in `CONSTRUCT/docs/CONSTRUCT-ABSTRACTION-ROADMAP.md`.

---
**Remember**: CONSTRUCT is becoming language-agnostic. iOS was just the beginning.



---

### Feedback on Accuracy
The cheat sheet is accurate for the roadmap’s core components (`CLAUDE.md` roles, pattern system, directories, abstraction story, `/init` integration) and aligns with `v32.md`, `v11.md`, and `integrate-init.txt`. The additions for context engineering scripts, interactive script support, dynamic context commands, and roadmap reference ensure it covers `context-engineering-integration-prd-v01.md`, `dynamic-context-orchestration-prd.md`, and `interactive-scripts-prd.md`. These updates address your need to reduce context overload by providing a single, concise reference that integrates all documents.

**Why It’s Accurate**:
- Captures the single `CONSTRUCT/CLAUDE.md` orchestrator and project-specific `CLAUDE.md` files (`v11.md`, conversation).
- Reflects the pattern system flow and `CLAUDE-BASE.md` role (`v32.md`).
- Incorporates dynamic context loading and `/init` enhancement (`dynamic-context-orchestration-prd.md`, `integrate-init.txt`).
- Addresses context engineering scripts and interactive support (`v01.md`, `interactive-scripts-prd.md`).
- Links to the roadmap to track abstraction progress, saving context.

**Plan to Move Forward**:
1. **Four-Day Sprint (P0)**:
   - **Day 1**: Extract iOS rules to `swift.md`, `swiftui.md`, `mvvm-ios.md`.
   - **Day 2**: Update `CLAUDE-BASE.md`, remove `CONSTRUCT-CORE/CLAUDE.md`, `CONSTRUCT-LAB/CLAUDE.md`.
   - **Day 3**: Update `assemble-claude.sh`, `update-context.sh` for dynamic sections, test with RUN.
   - **Day 4**: Update `CONSTRUCT-ARCHITECTURE-CHEATSHEET.md`, finalize roadmap.
2. **Test Static `CLAUDE.md`**: Use for 1-2 sprints with RUN, monitor for bloat.
3. **P1 Todos**: Implement `construct-init.sh`, `context-detect.sh`, and `--show-prompts` for scripts.
4. **Update Blog Post**: Apply refinements to clarify `/init`, RUN, and contributions.
5. **Resource Allocation**: One developer for sprint, then shift to RUN, with 1-2 hours weekly for CONSTRUCT.

---

**Next Steps**:
- Start the four-day sprint for P0 todos.
- Use the updated cheat sheet and roadmap to track progress.
- Refine the blog post for publication.

Would you like me to:
- Draft a detailed sprint plan?
- Mock up pattern files (`swift.md`, `mvvm-ios.md`)?
- Refine the blog post draft?
- Simulate a RUN task with CONSTRUCT?

Let me know how I can help you manage the abstraction and keep CONSTRUCT on track!