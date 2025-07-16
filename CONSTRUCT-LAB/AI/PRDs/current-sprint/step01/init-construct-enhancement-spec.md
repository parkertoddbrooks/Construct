# init-construct Enhancement Specification

## Overview
Based on the insights from `integrate-init.txt`, this document specifies the enhancements needed for `construct-init` to work seamlessly with Claude Code's `/init` command.

## Core Principle
CONSTRUCT works WITH `/init`, not against it. We preserve ALL content from `/init` and add pattern-based enhancements.

## Three Operating Modes

### Mode 1: First-time CONSTRUCT User (No patterns.yaml)
**Detection**: CLAUDE.md exists + NO .construct/patterns.yaml

**Flow**:
1. Analyze project structure (detect languages, frameworks)
2. Show available plugins from registry with recommendations
3. Interactive plugin selection
4. Create .construct/patterns.yaml
5. Enhance CLAUDE.md with patterns (preserve ALL /init content)

### Mode 2: Existing CONSTRUCT User (patterns.yaml exists)
**Detection**: CLAUDE.md exists + .construct/patterns.yaml exists

**Flow**:
1. Read existing patterns.yaml
2. Apply configured patterns
3. Update pattern sections in CLAUDE.md
4. Preserve ALL /init content

**Note**: This mode already works with `--regenerate` flag

### Mode 3: Legacy/Manual CLAUDE.md (Pattern extraction)
**Detection**: CLAUDE.md exists + NO .construct/patterns.yaml + content not from /init

**Flow**:
1. Detect custom content:
   - Manual additions to CLAUDE.md
   - Old CONSTRUCT versions
   - Project-specific rules
2. Extract custom patterns → Create LAB plugins
3. Detect base technology → Select core plugins
4. Create patterns.yaml
5. Backup original → Rebuild with patterns
6. Continue as Mode 2

## Implementation Requirements

### 1. Pattern Extraction (Mode 3)
```bash
extract_patterns_from_claude_md() {
    # Parse CLAUDE.md for:
    # - Custom rules sections
    # - Project-specific patterns
    # - Non-standard content
    
    # Create LAB plugin structure:
    # CONSTRUCT-LAB/patterns/plugins/project-specific/
    #   └── <project-name>/
    #       ├── <project-name>.yaml
    #       ├── <project-name>.md
    #       └── injections/
    #           └── custom-rules.md
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