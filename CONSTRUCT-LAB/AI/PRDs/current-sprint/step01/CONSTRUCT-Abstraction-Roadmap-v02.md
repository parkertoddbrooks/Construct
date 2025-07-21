# CONSTRUCT Abstraction Roadmap v02

## Overview
This roadmap guides the transformation of CONSTRUCT from a Swift/iOS-influenced system to a truly AI-native universal development framework. The goal is to extract all language-specific content into pattern plugins while implementing a two-stage initialization process that works seamlessly with Claude Code's `/init` command.

## 🚀 AI-Native Paradigm (2025-07-21 Update)

**Paradigm Shift**: CONSTRUCT is now an AI-native system where Claude SDK provides the intelligence layer:

- **Scripts = Orchestration**: Handle file operations, installations, workflow
- **Claude SDK = Intelligence**: All analysis, decisions, content generation
- **No Regex Fallbacks**: All pattern detection uses Claude intelligence
- **Focused Output**: User feedback confirms preference for project-centric CLAUDE.md files

**Key Insight from Recovery**: The real issue was that `construct-init` assumed projects already had CONSTRUCT infrastructure, creating a chicken-and-egg problem.

## Key Innovation: Two-Stage Initialization

### Understanding /init Behavior
- `/init` is **git repository-based** - creates CLAUDE.md at git root
- Each git repository gets its own CLAUDE.md
- Perfect for CONSTRUCT's multi-project architecture
- No cross-contamination between projects

### Two-Stage Process (AI-Native)
1. **Stage 1: `/init`** - Creates standard CLAUDE.md at git root
2. **Stage 2: `construct-init`** - AI-powered CONSTRUCT integration

**Stage 2 is now an AI-Native Intelligent Orchestrator that:**
- **Assesses project state** using Claude SDK analysis
- **Installs complete infrastructure** (unified CONSTRUCT/ folder structure)
- **Extracts existing patterns** using Claude content analysis
- **Analyzes project intelligently** (languages, frameworks, recommendations)
- **Creates focused output** based on user feedback (project knowledge prominent)

This works because:
- Leverages Claude Code's built-in tooling
- Claude SDK provides true intelligence instead of regex patterns
- Progressive enhancement approach with complete infrastructure installation
- User controls when to add CONSTRUCT features
- Handles any project state (no infrastructure assumptions)

## Current State Analysis

### Existing Files (All 4 Exist!)
1. **CONSTRUCT-CORE/CLAUDE-BASE.md** - ✅ EXISTS (universal principles)
2. **CONSTRUCT-CORE/CLAUDE.md** - ✅ EXISTS (Swift/iOS template)
3. **CONSTRUCT/CLAUDE.md** - ✅ EXISTS (created by /init)
4. **CONSTRUCT-LAB/CLAUDE.md** - ✅ EXISTS (CONSTRUCT dev context)

### Future State (Simplified)
1. **CONSTRUCT-CORE/CLAUDE-BASE.md** - Universal template (enhanced) - KEEPS
2. **CONSTRUCT/CLAUDE.md** - Enhanced by pattern system after /init - KEEPS (MAIN WORKING FILE)
3. **Projects/*/CLAUDE.md** - Enhanced by pattern system after /init
4. ~~CONSTRUCT-LAB/CLAUDE.md~~ - Content moved to patterns, file REMOVED
5. ~~CONSTRUCT-CORE/CLAUDE.md~~ - iOS content moved to patterns, file REMOVED

### CRITICAL UNDERSTANDING
- **CONSTRUCT/CLAUDE.md** (root) = Created by /init, enhanced by construct-init - THIS IS THE MAIN FILE
- **CONSTRUCT-CORE/CLAUDE.md** = OLD iOS/Swift content - CAN BE DELETED
- **CONSTRUCT-LAB/CLAUDE.md** = OLD LAB context - CAN BE DELETED
- **CONSTRUCT-CORE/CLAUDE-BASE.md** = Template for construct-init and assemble - this is the claude template that powers the assemble and injection - KEEP THIS (it needs to b reworked to work like CONSTRUCT-LAB/CLAUDE.md + CONSTRUCT-CORE/CLAUDE.md (but 100% automated) : )

### The Elegant Solution
```bash
# For CONSTRUCT itself
cd CONSTRUCT
/init                          # Creates CONSTRUCT/CLAUDE.md
"construct init"               # Enhances with CONSTRUCT patterns

# For any project
cd Projects/MyApp/ios
/init                          # Creates Projects/MyApp/ios/CLAUDE.md  
"construct init"               # Enhances with project patterns
```

## Pattern System Architecture

### How Claude SDK Enhances Pattern Selection
```yaml
# CONSTRUCT/.construct/patterns.yaml
plugins:
  - "tooling/construct-dev"    # CONSTRUCT development patterns
  - "tooling/shell-scripting"  # Shell script standards
  - "documentation/living"     # Self-updating docs

# Projects/MyApp/ios/.construct/patterns.yaml
plugins:
  - "languages/swift"          # Swift patterns detected by Claude SDK
  - "architecture/mvvm"        # MVVM patterns identified via AI analysis
  - "platform/ios"            # iOS specifics recognized through Claude intelligence
```

### The Claude SDK Enhancement Process
1. Read existing CLAUDE.md (from /init)
2. Load CLAUDE-BASE.md sections
3. Apply patterns from patterns.yaml (selected via Claude SDK analysis)
4. Inject pattern-specific content using Claude-guided content assembly
5. Update CLAUDE.md with AI-enhanced content

## Roadmap Phases

### Phase 1: Audit & Planning (Week 1)
**Goal**: Map all content and plan consolidation

1. **Audit All CLAUDE.md Files**
   - CONSTRUCT-CORE/CLAUDE-BASE.md - identify gaps
   - CONSTRUCT-CORE/CLAUDE.md - extract iOS/Swift content
   - CONSTRUCT/CLAUDE.md - understand /init output
   - CONSTRUCT-LAB/CLAUDE.md - extract CONSTRUCT dev patterns

2. **Document Enhancement Points**
   - Where CLAUDE-BASE.md content should inject
   - How patterns modify base content
   - What sections are dynamic vs static

3. **Design Two-Stage Process**
   - Define "construct init" command behavior
   - Map pattern injections
   - Plan user experience

**Deliverables**:
- `claude-md-audit.md` listing all content mappings
- Two-stage init specification
- Pattern injection design

### Phase 2: Create Enhancement System (Week 2)
**Goal**: Build the two-stage initialization

1. **Create construct-init Command**
   ```bash
   # CONSTRUCT-CORE/CONSTRUCT/scripts/construct/init-construct.sh
   - Detects if CLAUDE.md exists (from /init)
   - Reads .construct/patterns.yaml
   - Assembles enhanced content
   - Updates CLAUDE.md
   ```

2. **Define Injection Protocol**
   ```markdown
   # Sections that get enhanced
   {{CONSTRUCT:PATTERNS}} - Active patterns
   {{CONSTRUCT:GUIDELINES}} - Pattern guidelines
   {{CONSTRUCT:EXAMPLES}} - Language examples
   {{CONSTRUCT:CONTEXT}} - Dynamic context
   ```

3. **Test Two-Stage Flow**
   - Run /init in test project
   - Run construct init
   - Verify enhancement works

**Deliverables**:
- Working construct-init script
- Injection protocol specification
- Test results documentation

### Phase 3: Extract CONSTRUCT Development Patterns (Week 3)
**Goal**: Move CONSTRUCT-LAB/CLAUDE.md content to patterns

1. **Create construct-dev Plugin**
   ```
   patterns/plugins/tooling/construct-dev/
   ├── README.md
   ├── pattern.yaml
   ├── guidelines/
   │   ├── symlink-rules.md
   │   ├── promotion-workflow.md
   │   ├── dual-environment.md
   │   └── development-flow.md
   ├── validators/
   │   └── architecture-check.sh
   └── generators/
       ├── update-context.sh
       └── documentation.sh
   ```

2. **Extract All CONSTRUCT-Specific Content**
   - Symlink management rules
   - LAB-to-CORE promotion
   - Development workflows
   - Architecture principles
   - Script development patterns

3. **Configure CONSTRUCT's patterns.yaml**
   ```yaml
   # CONSTRUCT/.construct/patterns.yaml
   plugins:
     - "tooling/construct-dev"
     - "tooling/shell-scripting"
     - "tooling/unix-philosophy"
     - "documentation/living"
   ```

**Deliverables**:
- Complete construct-dev pattern plugin
- CONSTRUCT configured to use patterns
- Removal of CONSTRUCT-LAB/CLAUDE.md

### Phase 4: Extract iOS/Swift Patterns (Week 4)
**Goal**: Move all iOS-specific content to plugins

1. **Create Swift Pattern Plugin**
   ```
   patterns/plugins/languages/swift/
   ├── README.md
   ├── pattern.yaml
   ├── guidelines/
   │   ├── error-handling.md
   │   ├── concurrency.md
   │   ├── naming-conventions.md
   │   └── swift6-migration.md
   ├── examples/
   │   ├── mvvm-template.swift
   │   ├── coordinator.swift
   │   └── service-pattern.swift
   └── validators/
       └── swift-quality.sh
   ```

2. **Create iOS Platform Plugin**
   ```
   patterns/plugins/platform/ios/
   ├── guidelines/
   │   ├── xcode-config.md
   │   ├── info-plist.md
   │   └── app-lifecycle.md
   └── validators/
       └── ios-config-check.sh
   ```

3. **Archive CONSTRUCT-CORE/CLAUDE.md**
   ```bash
   mv CONSTRUCT-CORE/CLAUDE.md CONSTRUCT-CORE/ARCHIVED-CLAUDE-iOS.md
   ```

**Deliverables**:
- Complete Swift language plugin
- Complete iOS platform plugin  
- Archived iOS template

### Phase 5: Enhance CLAUDE-BASE.md (Week 5)
**Goal**: Make CLAUDE-BASE.md the perfect universal template

1. **Structure for Enhancement**
   ```markdown
   # CLAUDE-BASE.md
   
   # Development Context
   {{CONSTRUCT:HEADER}}
   
   ## Active Patterns
   {{CONSTRUCT:PATTERNS}}
   
   ## Development Guidelines
   {{CONSTRUCT:GUIDELINES}}
   
   ## Project Structure
   {{CONSTRUCT:STRUCTURE}}
   
   ## Examples
   {{CONSTRUCT:EXAMPLES}}
   
   ## Current Context
   {{CONSTRUCT:CONTEXT}}
   ```

2. **Add Universal Sections**
   - Security principles
   - Performance awareness
   - Testing philosophy
   - Documentation standards
   - Version control best practices

3. **Remove Any Language Bias**
   - No Swift/iOS references
   - Language-agnostic examples
   - Universal terminology

**Deliverables**:
- Enhanced CLAUDE-BASE.md
- Injection point documentation
- Universal principles guide

### Phase 6: Create Language Templates (Month 2)
**Goal**: Prove universality with multiple languages

1. **Python Pattern Plugin**
   ```
   patterns/plugins/languages/python/
   ├── guidelines/
   │   ├── pep8-style.md
   │   ├── type-hints.md
   │   └── async-patterns.md
   ├── examples/
   └── validators/
   ```

2. **TypeScript Pattern Plugin**
   ```
   patterns/plugins/languages/typescript/
   ├── guidelines/
   │   ├── type-safety.md
   │   ├── async-await.md
   │   └── module-patterns.md
   ├── examples/
   └── validators/
   ```

3. **Test Full Flow**
   ```bash
   # Create Python project
   mkdir Projects/PyApp && cd Projects/PyApp
   git init
   /init                    # Creates CLAUDE.md
   "construct init python"  # Enhances with Python patterns
   
   # Verify no Swift bias remains
   ```

**Deliverables**:
- 2-3 additional language plugins
- Multi-language test results
- Cross-language validation

### Phase 7: Update All Systems (Month 2-3)
**Goal**: Complete integration with all CONSTRUCT tools

1. **Update Core Scripts**
   - `update-context.sh` - Work with enhanced CLAUDE.md
   - `create-project.sh` - Include two-stage init
   - `import-project.sh` - Integrate with two-stage init
   - `workspace-update.sh` - Regenerate all project CLAUDE.md files

2. **Workspace Import Integration**
   ```bash
   # import-project.sh enhancement
   import_project() {
       # ... existing import logic ...
       echo "Project imported. Run '/init' to create CLAUDE.md"
       echo "Then run 'construct init' to enhance with patterns"
   }
   
   # workspace-update.sh enhancement  
   update_all_projects() {
       for project in Projects/*; do
           cd "$project"
           if [ -f CLAUDE.md ]; then
               construct init --regenerate
           fi
       done
   }
   ```

3. **Multi-Repository Support**
   ```bash
   # Handle multi-repo projects
   cd Projects/MyApp/ios
   /init && construct init
   
   cd ../backend
   /init && construct init
   
   # Shared patterns from parent
   construct init --include-parent
   ```

4. **Migration Tools**
   ```bash
   # For existing CONSTRUCT users
   construct-migrate two-stage
   # - Detects old CLAUDE.md structure
   # - Extracts customizations
   # - Runs two-stage init
   # - Preserves user content
   ```

5. **Documentation Updates**
   - User guides for two-stage init
   - Pattern development guides
   - Migration documentation
   - Workspace import guides

**Deliverables**:
- Updated all scripts with workspace support
- Multi-repo coordination tools
- Migration tooling
- Complete documentation

## Success Metrics

### Quantitative
- 4 CLAUDE.md files → 1 base + dynamic generation
- Zero hardcoded language references in CLAUDE-BASE.md
- 100% pattern-based content injection
- Two-stage init works for all projects
- Git repository isolation maintained

### Qualitative
- CONSTRUCT uses same system as projects
- Clear separation of concerns
- Easy to add new languages
- Users understand the flow
- No confusion about file purposes

## Workspace Import Compatibility

### Perfect Alignment with workspace-import-prd-v11.md

The two-stage initialization system is designed to work seamlessly with CONSTRUCT's workspace import system:

#### 1. **Git Repository Boundaries**
- `/init` respects git roots (perfect for multi-repo projects)
- Each component gets its own CLAUDE.md
- No cross-contamination between projects

#### 2. **Multi-Repository Projects**
```bash
# Import structure
Projects/MyApp/
├── ios/          # Separate git repo
│   ├── .git/
│   ├── .construct/patterns.yaml
│   └── CLAUDE.md (created by /init, enhanced by construct init)
├── backend/      # Separate git repo
│   ├── .git/
│   ├── .construct/patterns.yaml
│   └── CLAUDE.md (created by /init, enhanced by construct init)
└── .construct/   # Shared patterns
    └── patterns.yaml
```

#### 3. **Pattern Inheritance**
- Project-level patterns (shared)
- Component-level patterns (specific)
- Both applied during "construct init"

#### 4. **Import Workflow Integration**
```bash
# 1. Import repository
import-project.sh https://github.com/team/myapp-ios MyApp/ios

# 2. User runs /init
cd Projects/MyApp/ios
/init  # Creates base CLAUDE.md

# 3. Enhance with patterns
construct init  # Applies ios + shared patterns
```

#### 5. **Legacy Migration**
- Preserve old CLAUDE.md in import-history/
- Extract patterns to patterns.yaml
- Run two-stage init for modern setup

## Risk Mitigation

### Risk: Users Confused by Two Stages
**Mitigation**: 
- Clear prompts after /init
- CLAUDE.md includes instructions
- "construct init" explains what it does
- import-project.sh guides through process

### Risk: Pattern Injection Complexity
**Mitigation**:
- Start simple with clear sections
- Test with multiple patterns
- Gradual enhancement approach
- Handle pattern inheritance clearly

### Risk: Breaking Existing Projects
**Mitigation**:
- Migration tools preserve content
- Backward compatibility mode
- Extensive testing before release
- Import history preservation

### Risk: Multi-Repo Coordination
**Mitigation**:
- Clear workspace commands
- Batch update tools
- Pattern inheritance documentation

## Implementation Order

1. **Build Two-Stage Init** - Core functionality first
2. **Extract construct-dev patterns** - Dogfood the system
3. **Test with CONSTRUCT** - Ensure it works for us
4. **Extract Swift/iOS patterns** - Preserve excellence
5. **Enhance CLAUDE-BASE.md** - Universal foundation
6. **Add more languages** - Prove universality
7. **Update all tools** - Complete integration

## Next Steps

1. Start Phase 1 audit of all CLAUDE.md files
2. Design construct-init command
3. Create injection protocol specification
4. Test /init behavior in various scenarios
5. Document git repository isolation benefits

## Key Benefits of Two-Stage Approach

1. **Works WITH Claude Code**: No fighting /init
2. **Progressive Enhancement**: Start simple, add power
3. **Git Repository Isolation**: Each project independent  
4. **User Control**: Choose when to add CONSTRUCT
5. **Same Process Everywhere**: CONSTRUCT and projects identical
6. **Clear Mental Model**: Stage 1 = standard, Stage 2 = enhanced
7. **Multi-Repo Ready**: Perfect for complex project structures
8. **Workspace Friendly**: Integrates with import/update commands

This two-stage initialization transforms CONSTRUCT from a complex multi-file system to an elegant enhancement layer that works naturally with Claude Code's tooling while maintaining complete project isolation through git repository boundaries. The system seamlessly handles everything from simple single-repo projects to complex multi-repository architectures with shared patterns.