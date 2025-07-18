# Enhanced init-construct: Two-Stage Initialization

This document explains the enhanced `init-construct.sh` script that provides intelligent two-stage initialization for CONSTRUCT projects, working seamlessly with Claude Code's `/init` command.

## Overview

The enhanced init-construct implements a progressive enhancement approach with three distinct operating modes:

1. **Mode 1: First-time CONSTRUCT users** - Interactive plugin selection after `/init`
2. **Mode 2: Existing CONSTRUCT users** - Pattern regeneration from `.construct/patterns.yaml`
3. **Mode 3: Legacy migration** - Extract patterns from existing CLAUDE.md files

## Philosophy: Progressive Enhancement

The key principle is to **work WITH /init, not against it**. The system preserves ALL content from `/init` while adding CONSTRUCT's pattern-based enhancements.

```
Stage 1: /init → Creates initial CLAUDE.md with project context
Stage 2: init-construct → Enhances with patterns and organization
```

## Operating Modes

### Mode 1: First-time CONSTRUCT users (Interactive Selection)

**Detection**: No `.construct/patterns.yaml` file exists

**Flow**:
1. Analyzes project structure to detect languages (Swift, Python, TypeScript, Rust)
2. Detects basic frameworks (SwiftUI via Package.swift, React via package.json)
3. Detects iOS platform (via Info.plist or .xcodeproj)
4. Shows recommendations and prompts for acceptance
5. Creates `.construct/patterns.yaml` with selected plugins
6. Enhances CLAUDE.md with pattern content

**Example Session**:
```bash
$ /init  # Claude Code creates initial CLAUDE.md
$ ./CONSTRUCT-CORE/CONSTRUCT/scripts/construct/init-construct.sh

🚀 CONSTRUCT Pattern Enhancement
================================
📍 Project root: /path/to/project
Creating .construct directory...
Creating patterns.yaml...

📦 Based on your project, we recommend these plugins:
  ✓ languages/swift
  ✓ frameworks/swiftui
  ✓ platforms/ios

Accept recommendations? [Y/n/customize]: customize

📦 Available Pattern Plugins:

languages:
  - languages/csharp
    C# language patterns and modern .NET best practices
  - languages/python
    Python language patterns following PEP 8 and modern best practices
  - languages/swift
    Swift 6 language patterns and best practices for iOS development

frameworks:
  - frameworks/ios-ui-library
    iOS UI component library patterns for SwiftUI reusable components
  - frameworks/swiftui
    SwiftUI framework patterns and best practices for modern iOS development

platforms:
  - platforms/ios
    iOS platform-specific patterns and conventions

architectural:
  - architectural/mvvm
    Model-View-ViewModel architectural pattern for clean separation of concerns
  - architectural/mvvm-ios
    MVVM architecture pattern specifically for iOS applications with SwiftUI

Enter plugins to install (comma-separated, e.g., languages/swift,platforms/ios):
```

### Mode 2: Existing User (Pattern Regeneration)

**Detection**: `.construct/patterns.yaml` exists

**Flow**:
1. Reads existing pattern configuration
2. Preserves ALL content from `/init` in CLAUDE.md
3. Regenerates pattern sections with latest content
4. Updates CURRENT-STRUCTURE section

**Example**:
```bash
$ /init  # Updates CLAUDE.md with new project info
$ ./CONSTRUCT-CORE/CONSTRUCT/scripts/construct/init-construct.sh

🔄 Refreshing CONSTRUCT patterns...
✅ Found existing configuration in .construct/patterns.yaml
📝 Preserving /init content and updating pattern sections...
✅ CLAUDE.md updated with latest patterns
```

### Mode 3: Legacy Migration (Pattern Extraction)

**Detection**: CLAUDE.md exists without being from /init and no patterns.yaml exists

**Flow**:
1. Backs up original as CLAUDE.md.pre-construct
2. Extracts sections matching: Rules, Guidelines, Standards, Patterns, Anti-patterns
3. Creates LAB plugin at `project-specific/<project-name>/`
4. Saves each extracted section as separate injection file
5. Creates plugin metadata and documentation
6. Proceeds with interactive plugin selection for base patterns

**Example**:
```bash
$ ./CONSTRUCT-CORE/CONSTRUCT/scripts/construct/init-construct.sh

🚀 CONSTRUCT Pattern Enhancement
================================
📍 Project root: /path/to/project
🔄 Detected legacy CLAUDE.md - will extract patterns
✅ Backed up original as CLAUDE.md.pre-construct
📝 Extracting custom patterns from existing CLAUDE.md...
✅ Extracted: rules
✅ Extracted: guidelines
✅ Created LAB plugin: project-specific/myproject
Creating patterns.yaml...

[Continues with normal plugin selection, adding the extracted plugin automatically]
```

## Technical Implementation

### Project Analysis

The script automatically detects:

**Languages**:
- Swift: `*.swift`, `*.xcodeproj`, `Package.swift`
- Python: `*.py`, `requirements.txt`, `setup.py`, `pyproject.toml`
- TypeScript: `*.ts`, `*.tsx`, `package.json`, `tsconfig.json`
- Rust: `*.rs`, `Cargo.toml`

**Frameworks** (limited detection):
- SwiftUI: Checks for "SwiftUI" in Package.swift
- React: Checks for "react" in package.json

**Platforms**:
- iOS: `*.xcodeproj` or `Info.plist`

### Registry Integration

The script loads available plugins from:
```
CONSTRUCT-CORE/patterns/plugins/registry.yaml
```

Each plugin provides:
- Description for user selection
- Dependencies on other plugins
- Validators for compliance checking
- Generators for code creation

### Pattern Extraction

For legacy migration, the script:
1. Searches for sections with headers matching: `## Rules`, `## Guidelines`, `## Standards`, `## Patterns`, `## Anti-patterns`
2. Extracts content between these headers and the next `##` header
3. Saves each section as a separate file in the injections directory

The extracted content is saved in this structure:
```
CONSTRUCT-LAB/patterns/plugins/project-specific/<project-name>/
├── <project-name>.md   # Auto-generated documentation
├── <project-name>.yaml # Plugin metadata
└── injections/         # Extracted sections
    ├── rules.md
    ├── guidelines.md
    └── standards.md
```

## Interactive Scripts Support

The script supports the Interactive Scripts pattern for Claude Code compatibility:

```bash
# Show prompts without executing
init-construct.sh --show-prompts

# Output format varies by mode:
# Mode 1/3 (no patterns.yaml):
1. Pattern plugins to install
   Format: comma-separated list
   
   Based on your project, we recommend:
   - languages/swift
   - frameworks/swiftui
   - platforms/ios
   
   Available plugins:
   - architectural/mvvm
   - architectural/mvvm-ios
   ... and more
   
   Default: Accept recommendations or none if no project detected

# Mode 2 (patterns.yaml exists):
No prompts needed - patterns.yaml already exists
Will regenerate from existing patterns
```

When piped input is detected, the script reads plugin selections from stdin:
```bash
echo "languages/swift,platforms/ios" | init-construct.sh
```

## Integration with Workspace Scripts

The enhanced init-construct integrates with:

**create-project.sh**:
```bash
# Two-stage initialization for new projects
create-project.sh MyApp
cd Projects/MyApp
/init                    # Stage 1
init-construct.sh        # Stage 2
```

**import-project.sh**:
```bash
# Migration path for existing projects
import-project.sh /path/to/existing/project
cd Projects/ImportedProject
init-construct.sh        # Detects Mode 3, extracts patterns
```

## Configuration

### .construct/patterns.yaml

Generated configuration structure:
```yaml
# Project pattern configuration
project_name: "MyApp"
construct_version: "2.0"

# Active patterns
languages:
  - swift
  - python

frameworks:
  - swiftui

platforms:
  - ios

# Plugin specifications
plugins:
  # Core plugins
  - "languages/swift"
  - "languages/python"
  - "frameworks/swiftui"
  - "platforms/ios"
  
  # Architecture patterns
  - "architectural/mvvm-ios"
  
  # Project-specific (LAB)
  - "projects/myapp-custom"

# Custom project rules (if not extracted to LAB)
custom_rules:
  - "Use 'Mgr' suffix for manager classes"
  - "All API calls must use async/await"
```

### Environment Variables

The script uses standard CONSTRUCT environment variables:
```bash
# These are auto-detected, not typically overridden
CONSTRUCT_ROOT   # Git repository root
CONSTRUCT_CORE   # $CONSTRUCT_ROOT/CONSTRUCT-CORE
PROJECT_ROOT     # Where .git is located
```

Note: The script does not currently support debug mode or auto-accept flags.

## Error Handling

The script handles various error conditions:

1. **Missing /init content**: Prompts user to run `/init` first
2. **Invalid plugin selection**: Shows error and re-prompts
3. **Missing registry**: Falls back to manual configuration
4. **Write permissions**: Checks before modifying files
5. **Malformed CLAUDE.md**: Preserves original with .backup

## Best Practices

### For New Projects

1. Always run `/init` first to establish base context
2. Run `init-construct.sh` immediately after for pattern selection
3. Review generated `.construct/patterns.yaml` 
4. Commit both CLAUDE.md and patterns.yaml to version control

### For Existing Projects

1. Back up your current CLAUDE.md before migration
2. Review extracted patterns in LAB plugin
3. Adjust plugin selection based on actual needs
4. Test pattern compliance with `check-architecture.sh`

### For Claude Code Integration

1. Use `--show-prompts` when running from Claude Code
2. Provide structured inputs as shown in prompts
3. Let Claude Code handle file modifications
4. Verify results with `construct-patterns.sh list`

## Troubleshooting

### Common Issues

**"CLAUDE.md not found!"**
- You need to run `/init` first to create the base CLAUDE.md
- The script requires an existing CLAUDE.md to enhance

**"CLAUDE.md already enhanced"**
- The script detected enhancement markers
- Use `--regenerate` flag to update from patterns

**"yq not installed"**
- Plugin descriptions will be limited
- The script falls back to directory scanning
- Install yq for full registry features

### Current Limitations

1. No debug mode implemented
2. No `--force-migration` option
3. Limited framework detection (only SwiftUI and React)
4. No validation of plugin selections against registry
5. Pattern injection is basic (adds markers but limited content merging)

## Migration Guide

### From Manual CLAUDE.md

1. **Backup current file**:
   ```bash
   cp CLAUDE.md CLAUDE.md.pre-construct
   ```

2. **Run migration**:
   ```bash
   init-construct.sh
   ```

3. **Review extracted patterns**:
   ```bash
   cat CONSTRUCT-LAB/patterns/plugins/projects/*/pattern.md
   ```

4. **Adjust if needed**:
   - Edit LAB plugin files
   - Add/remove plugins in patterns.yaml
   - Re-run `update-context.sh`

### From Older CONSTRUCT Versions

If you have an older CONSTRUCT project:

1. **Run with --regenerate**:
   ```bash
   init-construct.sh --regenerate
   ```

2. **Review the enhanced CLAUDE.md**

3. **Run update-context to populate dynamic sections**:
   ```bash
   construct-update
   ```

## Actual Implementation Notes

### What's Working
- Basic three-mode detection logic
- Project analysis for Swift, Python, TypeScript, Rust
- Interactive plugin selection with Y/n/customize prompts
- Pattern extraction from legacy CLAUDE.md files
- Registry loading with fallback to directory scanning
- Creation of patterns.yaml with selected plugins
- Basic CLAUDE.md enhancement with markers

### What's Partially Implemented
- Pattern injection system (adds header and markers but limited content merging)
- Framework detection (only SwiftUI and React)
- /init content preservation (basic implementation)
- Interactive prompts support (works but output format differs from spec)

### What's Not Implemented
- Advanced pattern content injection from plugin files
- Debug mode and environment variable controls
- Plugin validation against registry
- Force migration options
- Comprehensive framework/platform detection
- Full template processing with all injection points

## Related Documentation

- [Plugin Registry](./plugin-registry.md) - How plugins are organized
- [Interactive Scripts](./interactive-scripts.md) - Claude Code integration patterns
- [Init and Construct Init](./init-and-construct-init.md) - Two-stage initialization concept
- [Workspace Management](../core/workspace-management.md) - Project creation and import