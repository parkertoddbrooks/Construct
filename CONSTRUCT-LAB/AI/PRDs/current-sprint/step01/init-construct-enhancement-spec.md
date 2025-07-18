# init-construct Enhancement Specification

## 🆕 NEW THINKING: Complete Infrastructure Orchestrator (v3.0)

**BREAKTHROUGH DISCOVERY**: The core issue wasn't just pattern injection - it was the **chicken-and-egg problem**. We were trying to run `construct-init` on projects that had **no CONSTRUCT infrastructure**.

**construct-init Evolution**:
- **v1.0**: Simple pattern injection (broken - no infrastructure)
- **v2.0**: Enhanced pattern injection with project analysis (still broken - assumed infrastructure existed)  
- **v3.0**: **Complete infrastructure orchestrator** - installs everything, handles any project state

**NEW CAPABILITIES**:
- Works as both `construct-init` and `install-construct` (alias)
- Assesses project state (CLAUDE.md, CONSTRUCT/, AI/, .construct/)
- Installs missing infrastructure (templates, symlinks, hooks)
- Extracts patterns from existing CLAUDE.md
- Validates all installed components work

**This supersedes all previous approaches** and makes construct-init the complete CONSTRUCT integration system.

## Overview
Based on the insights from `integrate-init.txt`, this document specifies the enhancements needed for `construct-init` to work seamlessly with Claude Code's `/init` command.

## Core Principle
CONSTRUCT works WITH `/init`, not against it. We preserve ALL content from `/init` and add pattern-based enhancements PLUS complete infrastructure setup.

## Enhanced Operating Modes (v3.0)

### Mode 1: Fresh Project Setup (Infrastructure + Pattern Setup)
**Detection**: CLAUDE.md exists + NO CONSTRUCT infrastructure

**Enhanced Flow**:
1. **Infrastructure Assessment**: Check for CONSTRUCT/, AI/, .construct/, git hooks
2. **Infrastructure Installation**: 
   - Symlink CONSTRUCT directory for tool access
   - Install AI folder structure from templates
   - Create .construct configuration directory
   - Install git hooks for validation
3. **Project Analysis**: Detect languages, frameworks, architecture
4. **Interactive Pattern Selection**: Show recommendations, allow customization
5. **Pattern Configuration**: Create .construct/patterns.yaml with selections
6. **CLAUDE.md Enhancement**: Preserve ALL /init content + add patterns
7. **Infrastructure Validation**: Test all installed scripts and hooks work

### Mode 2: Existing CONSTRUCT User (Infrastructure + Pattern Update)
**Detection**: CLAUDE.md exists + .construct/patterns.yaml exists

**Enhanced Flow**:
1. **Infrastructure Assessment**: Verify all CONSTRUCT components present
2. **Infrastructure Repair**: Install any missing components
3. **Pattern Application**: Read existing patterns.yaml and apply
4. **CLAUDE.md Update**: Update pattern sections, preserve /init content
5. **Infrastructure Validation**: Ensure all components functional

**Note**: This mode includes infrastructure validation and repair

### Mode 3: Legacy/Custom CLAUDE.md (Complete Migration)
**Detection**: CLAUDE.md exists + custom content + NO CONSTRUCT infrastructure

**Enhanced Flow**:
1. **Custom Content Detection**: Identify manual additions, old CONSTRUCT versions, project-specific rules
2. **Pattern Extraction**: Extract custom patterns → Create project-specific injections
3. **Infrastructure Installation**: Complete CONSTRUCT setup (same as Mode 1)
4. **Technology Detection**: Analyze project for base plugins
5. **Configuration Creation**: Generate patterns.yaml with extracted + detected patterns
6. **CLAUDE.md Reconstruction**: Backup original → Rebuild with pattern system
7. **Infrastructure Validation**: Test complete setup works
8. **Migration Verification**: Ensure no custom content lost

### Mode 4: Broken/Partial Installation (Recovery Mode)
**Detection**: Some CONSTRUCT infrastructure present but broken/incomplete

**Enhanced Flow**:
1. **Damage Assessment**: Identify what's missing, broken, or outdated
2. **Selective Repair**: Fix/reinstall only what's needed
3. **Pattern Preservation**: Maintain existing patterns.yaml if valid
4. **Infrastructure Completion**: Ensure all components present and functional
5. **Validation Testing**: Verify repair successful

## Enhanced Implementation Requirements (v3.0)

### 1. Infrastructure Assessment and Installation
```bash
assess_project_infrastructure() {
    echo "🔍 Assessing project infrastructure..."
    HAS_CLAUDE_MD=false
    HAS_CONSTRUCT_DIR=false
    HAS_AI_FOLDER=false
    HAS_PATTERNS_CONFIG=false
    HAS_GIT_HOOKS=false
    
    [ -f "CLAUDE.md" ] && HAS_CLAUDE_MD=true
    [ -d "CONSTRUCT" ] && HAS_CONSTRUCT_DIR=true
    [ -d "AI" ] && HAS_AI_FOLDER=true
    [ -f ".construct/patterns.yaml" ] && HAS_PATTERNS_CONFIG=true
    [ -x ".git/hooks/pre-commit" ] && HAS_GIT_HOOKS=true
}

install_missing_infrastructure() {
    echo "🛠️ Installing missing CONSTRUCT infrastructure..."
    
    # Symlink CONSTRUCT for tool access
    if [ "$HAS_CONSTRUCT_DIR" = false ]; then
        ln -sf "$(realpath --relative-to=. "$CONSTRUCT_CORE/CONSTRUCT")" CONSTRUCT
        echo "✅ CONSTRUCT tools linked"
    fi
    
    # Install AI folder structure
    if [ "$HAS_AI_FOLDER" = false ]; then
        cp -r "$CONSTRUCT_CORE/TEMPLATES/component-templates/ai-structure/AI" .
        echo "✅ AI documentation structure installed"
    fi
    
    # Create pattern configuration
    if [ "$HAS_PATTERNS_CONFIG" = false ]; then
        mkdir -p .construct
        cp "$CONSTRUCT_CORE/TEMPLATES/patterns/patterns.yaml" .construct/
        echo "✅ Pattern configuration installed"
    fi
    
    # Install git hooks
    if [ "$HAS_GIT_HOOKS" = false ]; then
        cp "$CONSTRUCT_CORE/TEMPLATES/git-hooks/pre-commit" .git/hooks/
        chmod +x .git/hooks/pre-commit
        echo "✅ Git hooks installed"
    fi
}

validate_infrastructure() {
    echo "🧪 Validating installed infrastructure..."
    validation_passed=true
    
    # Test scripts work
    ./CONSTRUCT/scripts/construct/update-context.sh --dry-run || validation_passed=false
    ./CONSTRUCT/scripts/core/check-architecture.sh --dry-run || validation_passed=false
    
    [ "$validation_passed" = true ] && echo "✅ Infrastructure validation passed"
}
```

### 2. Enhanced Pattern Extraction (Mode 3)
```bash
extract_patterns_from_claude_md() {
    echo "🔍 Extracting custom patterns from existing CLAUDE.md..."
    
    # Backup original
    cp CLAUDE.md CLAUDE.md.backup
    
    # Parse CLAUDE.md for:
    # - Custom rules sections
    # - Project-specific patterns  
    # - Non-standard content
    # - Manual additions
    
    # Create project-specific injection:
    mkdir -p .construct/injections
    ./CONSTRUCT/scripts/construct/extract-patterns.sh CLAUDE.md.backup \
        > .construct/injections/project-custom.md
    
    echo "✅ Custom patterns extracted to .construct/injections/"
}
```

### 2. Interactive Plugin Selection (Mode 1)
```bash
show_plugin_recommendations() {
    # Use registry to get available plugins
    # Analyze project to recommend plugins
    # Show interactive selection:
    
    echo "📦 Based on your project, we recommend:"
    echo "  ✓ languages/swift (detected: *.swift files)"
    echo "  ✓ platforms/ios (detected: Info.plist)"
    echo ""
    echo "Additional plugins available:"
    echo "  - architectural/mvvm-ios"
    echo "  - tooling/error-handling"
    echo ""
    echo "Accept recommendations? [Y/n/customize]:"
}
```

### 3. Registry Integration
- Load plugin registry for available options
- Show plugin descriptions to help users choose
- Validate selected plugins exist
- Future: Resolve plugin dependencies

## Key Design Decisions

1. **Always Preserve /init Content**: Never remove or modify what /init creates
2. **Progressive Enhancement**: Add value on top of standard CLAUDE.md
3. **Pattern Authority**: patterns.yaml is the single source of truth
4. **Graceful Migration**: Extract and preserve all custom content

## User Experience Flow

### New User Journey
```
cd Projects/MyApp
/init                    # Creates standard CLAUDE.md
construct-init           # Shows recommendations, creates patterns
                        # Result: Enhanced CLAUDE.md with patterns
```

### Existing User Journey
```
cd Projects/MyApp
/init                    # Creates standard CLAUDE.md  
construct-init           # Detects patterns.yaml, applies patterns
                        # Result: Enhanced CLAUDE.md with existing patterns
```

### Legacy Migration Journey
```
cd Projects/OldApp       # Has custom CLAUDE.md
construct-init           # Extracts patterns, creates LAB plugins
                        # Result: Pattern-based CLAUDE.md preserving all custom content
```

## Success Criteria

1. **No Breaking Changes**: All existing workflows continue to work
2. **Seamless Integration**: Works naturally with /init
3. **Pattern Preservation**: No custom content is lost during migration
4. **User Choice**: Interactive selection for new users
5. **Clear Communication**: Users understand what's happening at each step

## Next Steps

1. Implement pattern extraction functionality
2. Add interactive plugin selection using registry
3. Update documentation
4. Test with various project types
5. Create migration guide for existing users