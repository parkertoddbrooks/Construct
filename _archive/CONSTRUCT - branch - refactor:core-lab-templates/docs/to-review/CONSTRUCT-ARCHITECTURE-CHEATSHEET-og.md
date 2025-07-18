# CONSTRUCT Architecture Cheat Sheet

## 🎯 Quick Reference - What Goes Where

### CLAUDE.md Files

| File | Purpose | How It's Created |
|------|---------|------------------|
| `/CONSTRUCT/CLAUDE.md` | CONSTRUCT system documentation + Orchestrator | 1. `/init` creates it<br>2. We enhance with CONSTRUCT awareness<br>3. Teaches dynamic context loading |
| `CONSTRUCT-CORE/CLAUDE-BASE.md` | Template for ALL project CLAUDE.md files | Hand-written, universal template |
| `CONSTRUCT-CORE/CLAUDE.md` | Legacy iOS-specific (from RUN) | TO BE REMOVED - content moved to patterns |
| `Projects/*/CLAUDE.md` | Project-specific context | Generated: CLAUDE-BASE.md + patterns |

### Pattern Plugin System

```
CONSTRUCT-CORE/patterns/
├── lib/                    # Pattern utilities (planned)
├── plugins/               # Complete pattern plugins
│   └── [category]/
│       └── [plugin-name]/
│           ├── [plugin-name].md     # Pattern rules (required)
│           ├── [plugin-name].yaml   # Metadata (required)
│           └── validators/          # Validation scripts (optional)
│               ├── quality.sh
│               ├── architecture.sh
│               └── documentation.sh
└── templates/             # Configuration templates
    └── patterns.yaml      # Project pattern config template
```

**Categories**: architectural, cross-platform, frameworks, languages, platforms, tooling

### Pattern System Flow

```
Project runs: construct-patterns regenerate
↓
Reads: .construct/patterns.yaml
↓
Loads: CLAUDE-BASE.md (template)
↓
Adds: Pattern files from plugins/ based on config
↓
Adds: Language-specific scripts
↓
Creates: Project's CLAUDE.md
```

### Pattern Validation Flow

```
Run: check-quality.sh Projects/MyApp
↓
Reads: Projects/MyApp/.construct/patterns.yaml
↓
For each pattern (e.g., languages/swift):
↓
Checks: patterns/plugins/languages/swift/validators/quality.sh
↓
Runs validator with PROJECT_DIR parameter
↓
Reports combined results
```

### Key Directories

```
CONSTRUCT/
├── CLAUDE.md                    # CONSTRUCT system docs (from /init)
├── CONSTRUCT-CORE/
│   ├── CLAUDE-BASE.md          # Template for project CLAUDE.md files
│   ├── patterns/               # Pattern system
│   │   ├── lib/               # Pattern utilities (future)
│   │   ├── plugins/           # All pattern files
│   │   └── templates/         # Config templates
│   └── CONSTRUCT/scripts/      # All the tools
├── CONSTRUCT-LAB/
│   └── [NO CLAUDE.md needed]   # Development/testing area
└── Projects/
    └── MyApp/
        ├── .construct/patterns.yaml  # Project config
        └── CLAUDE.md                 # Generated from BASE + patterns
```

### The Abstraction Story

1. **Origin**: CONSTRUCT was built inside RUN (iOS app)
2. **Current**: Extracting it to work with any language/platform
3. **Challenge**: iOS-specific stuff mixed with universal concepts
4. **Solution**: Move iOS stuff to pattern files, keep universal in BASE

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

# From CONSTRUCT root:
construct-enhance               # Enhances /init output with CONSTRUCT awareness
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

### Pattern File Status

Current pattern files in `CONSTRUCT-CORE/patterns/plugins/`:
- ✅ `languages/swift.md` - Swift patterns (has duplicate swift-new.md to merge)
- ✅ `frameworks/swiftui.md` - SwiftUI patterns  
- ✅ `architectural/mvvm-ios.md` - MVVM architecture
- ✅ `platforms/ios.md` - iOS platform specifics
- ✅ `cross-platform/model-sync.md` - Multi-platform sync
- ✅ `tooling/*` - Shell scripting, error handling, etc.

Extraction needed from `CONSTRUCT-CORE/CLAUDE.md`:
- Remaining iOS-specific content → appropriate pattern files
- Universal principles → `CLAUDE-BASE.md`

---
**Remember**: CONSTRUCT is becoming language-agnostic. iOS was just the beginning.