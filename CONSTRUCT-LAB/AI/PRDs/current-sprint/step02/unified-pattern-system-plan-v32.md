## 🆕 NEW THINKING: Integration with construct-init Orchestrator

**CRITICAL UPDATE**: This pattern system now integrates with the enhanced `construct-init` as intelligent orchestrator approach discovered in Step00 recovery analysis.

**Key Integration Points**:
- **Infrastructure Installation**: construct-init now installs AI templates, symlinks CONSTRUCT, sets up .construct/ before pattern system kicks in
- **Claude SDK Pattern Extraction**: construct-init uses Claude SDK for intelligent pattern extraction from existing CLAUDE.md - no more regex parsing
- **Validation Integration**: Pattern system validation happens as part of construct-init's infrastructure validation phase
- **Template Integration**: CONSTRUCT-CORE/TEMPLATES/ now provide the infrastructure that pattern system operates on

**This enhances rather than replaces the pattern system design** - the pattern system becomes the content management layer, while construct-init provides the infrastructure layer.

### Phase 5: Documentation Updates

#### 5.1 Update README
[Previous implementation remains - see earlier in document]

#### 5.2 Create Pattern Guide (Enhanced)
[Previous implementation remains - see earlier in document]

#### 5.3 Create Migration Guide
```markdown
# Migration Guide: From Symlinked/Monolithic CLAUDE.md to Pattern System

## Overview

CONSTRUCT has evolved from using symlinked or monolithic CLAUDE.md files to a flexible pattern-based system. This guide helps you migrate existing projects.


## Migration Paths

### From Symlinked CLAUDE.md (Old Approach)

If your project has:
```
YourProject/CLAUDE.md → ../CONSTRUCT/CONSTRUCT-CORE/CLAUDE.md
```

**Steps:**
1. Remove the symlink: `rm CLAUDE.md`
2. Run: `construct-patterns init YourProject`
3. Select appropriate patterns for your project
4. Review generated `.construct/patterns.yaml`

### From Monolithic CLAUDE.md

If your project has a large, single CLAUDE.md with all rules:

**Steps:**
1. Backup: `cp CLAUDE.md CLAUDE.md.backup`
2. Run: `./CONSTRUCT/scripts/migrate-to-patterns.sh`
3. Review extracted patterns in `.construct/patterns.yaml`
4. Move custom rules from `extracted-rules.yaml` to `patterns.yaml`
5. Run: `construct-patterns regenerate`
6. Compare new CLAUDE.md with backup

### From No CLAUDE.md

For projects without any CLAUDE.md:

**Steps:**
1. Run: `./CONSTRUCT/scripts/create-project.sh . existing`
2. CONSTRUCT will analyze your project structure
3. Select suggested patterns
4. Add project-specific rules to `.construct/patterns.yaml`

## Understanding the Change

### Old Way (Deprecated)
- One CLAUDE.md symlinked everywhere
- All contexts mixed together
- Manual editing common
- Hard to maintain

### New Way (Pattern System)
- CLAUDE.md is generated from patterns
- Modular, reusable patterns
- Configuration via patterns.yaml
- Read-only generated files

## Common Migration Issues

### Issue: Custom Rules Lost
**Solution**: Check `CLAUDE.md.backup` and `extracted-rules.yaml`. Add important rules to `patterns.yaml` under `custom_rules`.

### Issue: Symlink Still Exists
**Solution**: Remove with `rm CLAUDE.md` if it's a symlink. The pattern system generates a real file.

### Issue: Conflicts with Existing Git Hooks
**Solution**: Backup existing hooks, then run `setup-git-hooks.sh` to install pattern validation.

## Deprecation Notice

⚠️ **The symlinked CLAUDE.md approach is deprecated as of v2.0**

All new projects should use the pattern system. Existing projects should migrate by Q2 2025.
```

#### 5.4 Create Testing Documentation
```markdown
# Testing Guide for Pattern System

## Pre-Implementation Testing

Before building the full system, test with static CLAUDE.md:

1. Create comprehensive CLAUDE.md with all patterns
2. Use for 1-2 sprints
3. Monitor for issues:
   - Context bloat in Claude Code responses
   - Irrelevant suggestions
   - Performance problems

## Pattern Extraction Testing

### Test 1: Language Detection
```bash
# Test language pattern extraction
./migrate-to-patterns.sh test-project/
# Verify detected languages in .construct/patterns.yaml
```

### Test 2: Multi-Language Projects
```bash
# Create test project with multiple languages
mkdir -p test-fullstack/{ios,backend,web}
echo "class ViewController {}" > test-fullstack/ios/main.swift
echo "public class UserController {}" > test-fullstack/backend/controller.cs
echo "export const App = () => {}" > test-fullstack/web/app.tsx

# Run pattern detection
./create-project.sh test-fullstack fullstack
# Verify all languages detected and appropriate patterns applied
```

### Test 3: Pattern Validation
```bash
# Test validation catches manual edits
cd test-project
echo "manual edit" >> CLAUDE.md
construct-patterns validate
# Should report modification

# Test regeneration
construct-patterns regenerate
# Should restore original
```

## Integration Testing

### With Claude Code
1. Open project with patterns
2. Edit different file types
3. Verify context switches appropriately
4. Check suggestion relevance

### With Git Workflow
1. Make changes to patterns.yaml
2. Commit and verify pre-commit hooks
3. Try to commit modified CLAUDE.md
4. Verify warnings/blocks

## Performance Testing

### Context Size Comparison
```bash
# Measure full context
wc -l CLAUDE.md  # Full patterns

# Generate task-specific
./claude-preprocess.sh . "UserView.swift"
wc -l CLAUDE-temp.md  # Should be smaller

# Compare ratios
```

### Response Time Testing
- Time Claude Code responses with full context
- Time with task-specific context
- Document improvements
```

#### 5.5 Update Change Management Documentation
```markdown
# Change Management for Pattern System

## Version Control Best Practices

### Commit Message Format
```bash
# For pattern changes
git commit -m "[patterns] Add Swift async/await patterns"
git commit -m "[patterns] Update MVVM rules for SwiftUI"
git commit -m "[patterns] Fix conflict between Swift and C# naming"

# For pattern system changes
git commit -m "[pattern-system] Add context detection for models"
git commit -m "[pattern-system] Improve validation performance"
```

### What to Commit
✅ **Always commit:**
- `.construct/patterns.yaml`
- Custom pattern files in `patterns/`
- Pattern documentation

❌ **Never commit:**
- `CLAUDE.md` (generated file)
- `CLAUDE-temp.md` (temporary file)
- Pattern backup files

### Review Process
1. Pattern changes require review for:
   - Scope conflicts
   - Rule clarity
   - Example quality
   - Documentation

2. Use PR template:
   ```markdown
   ## Pattern Change
   - [ ] Updated relevant .md files
   - [ ] Tested with sample project
   - [ ] No conflicts with existing patterns
   - [ ] Documentation updated
   ```

## Rollback Procedures

### Pattern Rollback
```bash
# Find last working pattern version
git log --oneline patterns/plugins/swift.md

# Restore specific pattern
git checkout <commit> -- patterns/plugins/swift.md

# Regenerate affected projects
find . -name "patterns.yaml" -exec grep -l "swift" {} \; | \
  xargs -I {} bash -c 'cd $(dirname {}) && construct-patterns regenerate'
```

### System Rollback
```bash
# Full system rollback
git tag last-stable-patterns
git revert --no-commit HEAD~3..HEAD
git commit -m "[pattern-system] Rollback to last stable"
```
```## Key Decisions

### What Changes from Original Plans

1. **CLAUDE.md is assembled, not symlinked**
   - Symlinks remain for CONSTRUCT tools and docs
   - CLAUDE.md is generated per project
   - **NEW**: Generated files are read-only with warning headers
   - **NEW**: Task-specific context generation for optimal LLM performance

2. **Pattern plugins are first-class citizens**
   - Not just documentation
   - Active part of project configuration
   - **NEW**: Project customizations via patterns.yaml, not direct edits
   - **NEW**: Dynamic pattern selection based on active file/task

3. **LAB gets pattern development area**
   - Test patterns before promotion
   - Community can share experimental patterns
   - **NEW**: Clear workflow prevents manual CLAUDE.md edits

4. **Context Intelligence**
   - **NEW**: Task-specific context detection reduces LLM context window
   - **NEW**: Only relevant patterns loaded for current task
   - **NEW**: Integration hooks for editor/Claude Code support# CONSTRUCT Pattern System Implementation Plan

## Overview
This document unifies the pattern plugin system with the existing CONSTRUCT restructuring plans and TODOs, creating a cohesive implementation strategy that builds on what's already working.

## The Unified Vision

### What We're Building
A flexible pattern system where:
1. **CLAUDE-BASE.md** provides universal rules (in CONSTRUCT-CORE)
2. **Pattern plugins** offer optional/alternative patterns
3. **Projects assemble** their CLAUDE.md from base + selected plugins
4. **LAB enables** pattern development and testing
5. **Symlinks remain** for CONSTRUCT tools and documentation

### How It Fits With Existing Plans

#### From CONSTRUCT-RESTRUCTURE-PLAN-04.md:
- ✅ Keep the template-first architecture
- ✅ Keep the promotion system (LAB → CORE)
- **ADD**: Pattern plugin system alongside templates
- **ADD**: CLAUDE.md assembly instead of symlinks for context

#### From unified-claude-todo.md:
- ❌ **CHANGE**: Don't symlink CLAUDE.md everywhere
- ✅ **KEEP**: Unified context approach
- **NEW**: Assemble CLAUDE.md per project from patterns

#### From claude-md-mitigation-strategies.md:
- ✅ All mitigation strategies still apply
- **ENHANCED**: Pattern plugins naturally solve size/complexity issues

## Implementation Plan

### Phase 1: Restructure for Pattern System

#### 1.1 Create Pattern Infrastructure
```bash
# In CONSTRUCT-CORE
mkdir -p patterns/plugins/languages      # Language-specific patterns
mkdir -p patterns/plugins/architectural  # Architecture patterns (MVVM, VIPER, etc.)
mkdir -p patterns/plugins/cross-platform # Multi-language coordination
mkdir -p patterns/plugins/tooling        # CONSTRUCT dev, CI/CD, etc.
mkdir -p patterns/lib                    # Pattern utilities
mkdir -p patterns/templates              # Default configurations
mkdir -p AI/examples                     # Referenced by patterns

# Create default patterns.yaml template
cat > patterns/templates/patterns.yaml << 'EOF'
# .construct/patterns.yaml
# Project-specific pattern configuration
# This file controls which patterns are active in your CLAUDE.md

# Languages used in this project
languages: []

# Active pattern plugins (from CONSTRUCT-CORE/patterns/plugins/)
plugins: []

# Project-specific rules (added to CLAUDE.md)
# Format: language -> list of rules
custom_rules: {}

# Pattern overrides (exceptions to base patterns)
# Format: pattern, exception, scope
overrides: []

# Include external pattern files (optional)
# Useful for large projects to modularize rules
includes: []
EOF

# In CONSTRUCT-LAB  
mkdir -p patterns/plugins                # Development patterns
mkdir -p patterns/experiments            # Pattern ideas
```

#### 1.2 Convert Current CLAUDE.md to Base + Plugins
```bash
# Current locations:
# - CONSTRUCT-CORE/CLAUDE.md (doesn't exist yet)
# - CONSTRUCT-LAB/CLAUDE.md (CONSTRUCT development)
# - RUN/CLAUDE.md (has valuable patterns)

# New structure:
CONSTRUCT-CORE/CLAUDE-BASE.md     # Core rules from all three
CONSTRUCT-CORE/patterns/plugins/
├── languages/
│   ├── swift.md                  # Swift language patterns
│   ├── csharp.md                 # C# language patterns
│   └── typescript.md             # TypeScript patterns
├── architectural/
│   ├── mvvm.md                   # MVVM pattern (from RUN)
│   ├── clean-architecture.md     # Clean Architecture pattern
│   └── viper.md                  # VIPER alternative
├── tooling/
│   ├── construct-dev.md          # CONSTRUCT development rules
│   └── ci-cd.md                  # CI/CD patterns
├── cross-platform/
│   └── model-sync.md             # Multi-language model synchronization
└── discoveries/
    ├── background-flash.md       # Discovered pattern from RUN
    └── watch-patterns.md         # Watch-specific from RUN
```

#### 1.3 Update File Structure (Building on RESTRUCTURE-PLAN-04)
```
CONSTRUCT-CORE/
├── CLAUDE-BASE.md                    # NEW: Base patterns
├── patterns/                         # NEW: Pattern system
│   ├── plugins/                      # Stable plugins
│   └── lib/                          # Pattern utilities
├── CONSTRUCT/
│   ├── scripts/
│   │   ├── assemble-claude.sh       # NEW: Builds CLAUDE.md
│   │   ├── create-project.sh        # UPDATED: Uses patterns
│   │   └── construct-patterns.sh    # NEW: Pattern control
│   └── adapters/                     # As planned
├── AI/
│   ├── template-structure/          # As planned
│   └── manifest.yaml                # UPDATED: Includes patterns
└── TEMPLATES/                        # As planned
```

### Phase 2: Build Pattern Assembly System

#### 2.1 Create `assemble-claude.sh`
```bash
#!/bin/bash
# CONSTRUCT-CORE/CONSTRUCT/scripts/assemble-claude.sh

# Assembles CLAUDE.md from base + selected plugins
# Usage: ./assemble-claude.sh <project-dir> <plugins> [--languages lang1,lang2] [--dry-run]

set -e
source "$(dirname "$0")/../lib/common.sh"

PROJECT_DIR="$1"
PLUGINS="$2"
CONFIG_FILE="$PROJECT_DIR/.construct/patterns.yaml"
DRY_RUN=false

# Check for dry-run mode (for validation)
if [[ "${@: -1}" == "--dry-run" ]]; then
    DRY_RUN=true
fi

# Validate project directory
if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ Error: Project directory not found: $PROJECT_DIR"
    exit 1
fi

# Parse languages if provided
if [[ "$3" == "--languages" ]]; then
    LANGUAGES="$4"
    # Auto-include language patterns
    IFS=',' read -ra LANG_ARRAY <<< "$LANGUAGES"
    for lang in "${LANG_ARRAY[@]}"; do
        PLUGINS="${PLUGINS},${lang}-language"
    done
    
    # Include cross-platform if multiple languages
    if [ ${#LANG_ARRAY[@]} -gt 1 ]; then
        PLUGINS="${PLUGINS},cross-platform/model-sync"
    fi
fi

# Validate all plugins exist before assembly
IFS=',' read -ra PLUGIN_ARRAY <<< "$PLUGINS"
for plugin in "${PLUGIN_ARRAY[@]}"; do
    plugin=$(echo "$plugin" | xargs) # Trim whitespace
    if [ -n "$plugin" ]; then
        plugin_path="$CONSTRUCT_CORE/patterns/plugins/$plugin.md"
        if [ ! -f "$plugin_path" ]; then
            echo "❌ Error: Plugin not found: $plugin.md"
            echo "   Looking in: $CONSTRUCT_CORE/patterns/plugins/"
            echo "   Available plugins:"
            find "$CONSTRUCT_CORE/patterns/plugins" -name "*.md" -type f | sed 's|.*/||' | sed 's|\.md$||' | sort
            exit 1
        fi
    fi
done

# Validate patterns.yaml if it exists
if [ -f "$CONFIG_FILE" ]; then
    if ! yq eval '.' "$CONFIG_FILE" >/dev/null 2>&1; then
        echo "❌ Error: Invalid patterns.yaml format"
        echo "   File: $CONFIG_FILE"
        echo "   Please check YAML syntax"
        exit 1
    fi
fi

# Build CLAUDE.md content
CLAUDE_CONTENT=""

# Add generated file warning
CLAUDE_CONTENT+="<!-- 
╔══════════════════════════════════════════════════════════════════════════════╗
║                           DO NOT EDIT THIS FILE                              ║
╠══════════════════════════════════════════════════════════════════════════════╣
║ This is a GENERATED file, like a compiled binary. Manual edits will be lost. ║
║                                                                              ║
║ To modify patterns:                                                          ║
║ 1. Edit .construct/patterns.yaml for project-specific rules                  ║
║ 2. Create new plugins in CONSTRUCT-LAB/patterns/plugins/                     ║
║ 3. Run: construct-patterns regenerate                                        ║
║                                                                              ║
║ Think of this like Photoshop's .exe - you don't edit the binary!           ║
║                                                                              ║
║ See: CONSTRUCT-CORE/patterns/PATTERN-GUIDE.md for customization help        ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->

"

# Add base content
if [ ! -f "$CONSTRUCT_CORE/CLAUDE-BASE.md" ]; then
    echo "❌ Error: CLAUDE-BASE.md not found in $CONSTRUCT_CORE"
    exit 1
fi
CLAUDE_CONTENT+=$(cat "$CONSTRUCT_CORE/CLAUDE-BASE.md")

# Add context intelligence section
CLAUDE_CONTENT+="

## 🧠 Context Intelligence

### Active Language Contexts
Based on your project structure, I'll apply the appropriate patterns:

| File Pattern | Context Applied |
|-------------|-----------------|
| *.swift, *.xcodeproj | Swift patterns |
| *.cs, *.csproj | C# patterns |
| *.ts, *.tsx | TypeScript patterns |
| CONSTRUCT/**/*.sh | CONSTRUCT development |

### Cross-Platform Awareness
When you mention entities that exist across your stack, I'll consider all implementations:
- \"User model\" → Check Swift, C#, and TypeScript versions
- \"API endpoint\" → Consider backend implementation and client consumers
- \"Update schema\" → Propagate through all layers

"

# Add pattern configuration panel
CLAUDE_CONTENT+="
## 🎛️ Pattern Configuration

### Active Patterns (Toggle ✓/✗ to enable/disable)
"

# Add plugins based on configuration
for plugin in "${PLUGIN_ARRAY[@]}"; do
    plugin=$(echo "$plugin" | xargs) # Trim whitespace
    if [ -n "$plugin" ]; then
        CLAUDE_CONTENT+="- ✓ $plugin
"
    fi
done

# Process patterns.yaml for custom rules and includes
if [ -f "$CONFIG_FILE" ]; then
    # Handle includes first
    INCLUDES=$(yq eval '.includes[]' "$CONFIG_FILE" 2>/dev/null || echo "")
    MERGED_RULES=""
    
    # Merge included files
    while IFS= read -r include; do
        if [ -n "$include" ] && [ -f "$PROJECT_DIR/$include" ]; then
            echo "  Including: $include"
            INCLUDED_RULES=$(yq eval '.custom_rules' "$PROJECT_DIR/$include" 2>/dev/null || echo "")
            if [ -n "$INCLUDED_RULES" ] && [ "$INCLUDED_RULES" != "null" ]; then
                MERGED_RULES+="$INCLUDED_RULES"

#### 2.2 Create Pattern Control Interface
```bash
#!/bin/bash
# CONSTRUCT-CORE/CONSTRUCT/scripts/construct-patterns.sh

# Interactive pattern management
# Shows available patterns, current config, allows toggling

set -e

PROJECT_DIR="${1:-.}"
CONFIG_FILE="$PROJECT_DIR/.construct/patterns.yaml"

case "${1:-show}" in
    "regenerate")
        echo "⚠️  Regenerating CLAUDE.md will overwrite any manual changes."
        read -p "Continue? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Make writable temporarily
            chmod +w "$PROJECT_DIR/CLAUDE.md"
            
            # Read current configuration
            PLUGINS=$(yq eval '.plugins | join(",")' "$CONFIG_FILE")
            LANGUAGES=$(yq eval '.languages | join(",")' "$CONFIG_FILE")
            
            # Regenerate
            ./assemble-claude.sh "$PROJECT_DIR" "$PLUGINS" --languages "$LANGUAGES"
            echo "✅ CLAUDE.md regenerated from patterns.yaml"
        fi
        ;;
        
    "validate")
        echo "🔍 Validating CLAUDE.md integrity..."
        
        # Generate expected hash
        EXPECTED_HASH=$(./assemble-claude.sh "$PROJECT_DIR" "" --dry-run)
        
        # Extract actual hash from file
        ACTUAL_HASH=$(grep "Hash:" "$PROJECT_DIR/CLAUDE.md" | awk '{print $2}')
        
        if [ "$EXPECTED_HASH" = "$ACTUAL_HASH" ]; then
            echo "✅ CLAUDE.md is unmodified"
        else
            echo "❌ CLAUDE.md has been manually edited!"
            echo "Expected: $EXPECTED_HASH"
            echo "Actual: $ACTUAL_HASH"
            echo "Run 'construct-patterns regenerate' to restore"
            exit 1
        fi
        ;;
        
    *)
        echo "Usage: construct-patterns [regenerate|validate|show]"
        ;;
esac
```

#### 2.3 Create patterns.yaml Template
```yaml
# .construct/patterns.yaml
# Project-specific pattern configuration

# Languages used in this project
languages:
  - swift
  - csharp

# Active pattern plugins
plugins:
  - mvvm
  - cross-platform/model-sync
  - background-flash

# Project-specific rules (added to CLAUDE.md)
custom_rules:
  swift:
    - "Use 'Coordinator' suffix for navigation coordinators"
    - "Prefix private properties with underscore in ViewModels"
  csharp:
    - "Use 'Async' suffix for all async methods"
    - "Group related endpoints in partial controller classes"
  all:
    - "Add ticket number to TODO comments: // TODO (JIRA-123): Fix this"

# Pattern overrides (for exceptions to base rules)
overrides:
  - pattern: "mvvm/no-logic-in-views"
    exception: "Allow computed properties for pure UI calculations"
    scope: "swift"
```

#### 2.3 Update `create-project.sh`
```bash
# Add pattern selection to project creation
echo "What type of project is this?"
echo "1. iOS App (Swift)"
echo "2. Web App (TypeScript/React)"
echo "3. Backend API (C#/.NET)"
echo "4. Full Stack (Multiple languages)"
echo "5. Custom"
read -p "Select type (1-5): " PROJECT_TYPE

case $PROJECT_TYPE in
    1)
        LANGUAGES="swift"
        SUGGESTED_PLUGINS="mvvm,swift-ui-quality"
        ;;
    2)
        LANGUAGES="typescript"
        SUGGESTED_PLUGINS="react-patterns,typescript-strict"
        ;;
    3)
        LANGUAGES="csharp"
        SUGGESTED_PLUGINS="clean-architecture,api-patterns"
        ;;
    4)
        echo "Which languages? (comma-separated: swift,csharp,typescript)"
        read -p "Languages: " LANGUAGES
        SUGGESTED_PLUGINS="cross-platform/model-sync"
        ;;
    5)
        read -p "Languages: " LANGUAGES
        SUGGESTED_PLUGINS=""
        ;;
esac

echo "Additional pattern plugins (comma-separated, or press enter for none):"
echo "Available: watch-patterns, background-flash, construct-dev, startup-velocity"
read -p "Plugins: " ADDITIONAL_PLUGINS

# Combine all plugins
ALL_PLUGINS="${SUGGESTED_PLUGINS}"
if [ -n "$ADDITIONAL_PLUGINS" ]; then
    ALL_PLUGINS="${ALL_PLUGINS},${ADDITIONAL_PLUGINS}"
fi

# Create .construct directory and copy default patterns.yaml
mkdir -p "$PROJECT_DIR/.construct"
cp "$CONSTRUCT_CORE/patterns/templates/patterns.yaml" "$PROJECT_DIR/.construct/patterns.yaml"

# Pre-populate patterns.yaml with selections
yq eval -i ".languages = [$(echo $LANGUAGES | sed 's/,/", "/g' | sed 's/^/"/;s/$/"/')]" "$PROJECT_DIR/.construct/patterns.yaml"
yq eval -i ".plugins = [$(echo $ALL_PLUGINS | sed 's/,/", "/g' | sed 's/^/"/;s/$/"/')]" "$PROJECT_DIR/.construct/patterns.yaml"

# Assemble CLAUDE.md with selected patterns and languages
./assemble-claude.sh "$PROJECT_DIR" "$ALL_PLUGINS" --languages "$LANGUAGES"

echo "✅ Created .construct/patterns.yaml for future customization"
echo "📝 Edit .construct/patterns.yaml to add project-specific rules"
```

### Phase 3: Implement Pattern Promotion & Validation

#### 3.1 Extend PROMOTE-TO-CORE.yaml
```yaml
# Existing file promotion
promotions:
  - type: file
    source: experiments/script.sh
    dest: CONSTRUCT-CORE/CONSTRUCT/scripts/script.sh
    
  # Pattern promotion
  - type: pattern
    source: patterns/plugins/new-pattern.md
    dest: CONSTRUCT-CORE/patterns/plugins/new-pattern.md
    description: "Promotes tested pattern to stable"
    bump_version: minor
    
  # Project-specific pattern promotion
  - type: project-pattern
    source: ../RUN/patterns/custom-navigation.md
    dest: CONSTRUCT-CORE/patterns/plugins/custom-navigation.md
    description: "Promotes project discovery to reusable plugin"
    bump_version: minor
```

#### 3.2 Add Pre-commit Validation
```bash
#!/bin/bash
# .git/hooks/pre-commit (or CONSTRUCT-CORE/hooks/pre-commit)

# Validate CLAUDE.md hasn't been manually edited
VALIDATION_FAILED=false

for project in $(find . -name "CLAUDE.md" -not -path "*/CONSTRUCT-*/*"); do
    project_dir=$(dirname "$project")
    
    echo "Validating $project..."
    if ! ./CONSTRUCT/scripts/construct-patterns.sh validate "$project_dir"; then
        echo "❌ Pre-commit check failed: CLAUDE.md has been manually edited"
        echo "📝 To fix: Update .construct/patterns.yaml and run:"
        echo "   construct-patterns regenerate"
        VALIDATION_FAILED=true
    fi
done

if [ "$VALIDATION_FAILED" = true ]; then
    echo ""
    echo "⚠️  For advanced users: Use --no-verify to bypass (not recommended)"
    exit 1
fi

echo "✅ All CLAUDE.md files are unmodified"
```

#### 3.3 Update promote-to-core.sh
```bash
# Add pattern promotion support
case "$type" in
  "file")
    # Existing logic
    ;;
  "pattern"|"project-pattern")
    # Validate pattern format
    if ! grep -q "^## \[" "$source"; then
        echo "❌ Pattern must start with ## [SCOPE] header"
        exit 1
    fi
    
    # Enhanced conflict detection - check for content overlap
    pattern_name=$(basename "$dest" .md)
    echo "🔍 Checking for conflicts with existing patterns..."
    
    # Extract rules section from new pattern
    NEW_RULES=$(sed -n '/^### Rules/,/^###/p' "$source" | grep -E "^- " || true)
    
    # Check each existing pattern for rule overlap
    for existing in "$CONSTRUCT_CORE/patterns/plugins"/**/*.md; do
        if [ -f "$existing" ] && [ "$existing" != "$dest" ]; then
            EXISTING_RULES=$(sed -n '/^### Rules/,/^###/p' "$existing" | grep -E "^- " || true)
            
            # Look for overlapping rules
            while IFS= read -r rule; do
                if echo "$EXISTING_RULES" | grep -F "$rule" >/dev/null 2>&1; then
                    echo "⚠️  Rule overlap detected with $(basename "$existing"):"
                    echo "   $rule"
                    read -p "Continue anyway? [y/N] " -n 1 -r
                    echo
                    [[ ! $REPLY =~ ^[Yy]$ ]] && exit 1
                fi
            done <<< "$NEW_RULES"
        fi
    done
    
    # Check for explicit conflicts
    if grep -r "conflicts:.*$pattern_name" "$CONSTRUCT_CORE/patterns/" >/dev/null 2>&1; then
        echo "⚠️  Pattern explicitly conflicts with existing patterns"
        read -p "Continue? [y/N] " -n 1 -r
        [[ ! $REPLY =~ ^[Yy]$ ]] && exit 1
    fi
    
    # Copy pattern to CORE
    mkdir -p "$(dirname "$dest")"
    cp "$source" "$dest"
    echo "✅ Pattern promoted to CORE: $dest"
    ;;
esac
```

### Phase 4: Migration from Current State

#### 4.1 Extract Patterns from Existing Files
1. **From CONSTRUCT-LAB/CLAUDE.md**:
   - Shell scripting rules → `tooling/shell-scripting.md` plugin
   - Symlink management → `tooling/construct-dev.md` plugin  
   - Promotion workflow → `tooling/construct-dev.md` plugin

2. **From RUN/CLAUDE.md**:
   - Background flash prevention → `discoveries/background-flash.md` plugin
   - Watch-specific patterns → `discoveries/watch-patterns.md` plugin
   - Swift MVVM patterns → `architectural/mvvm.md` plugin
   - Swift language rules → `languages/swift.md` plugin

3. **Create Initial CLAUDE-BASE.md**:
   ```markdown
   # CONSTRUCT Base Patterns
   
   ## Universal Development Principles
   - Never break existing tests
   - Document why, not what
   - Token-first development
   - Error handling is mandatory
   
   ## Multi-Context Awareness
   This context system understands your entire project stack.
   Language-specific patterns are applied based on file types.
   Cross-platform patterns help coordinate changes across languages.
   
   ## Pattern System
   See active patterns below. Toggle ✓/✗ to change what rules I follow.
   Say "reload patterns" after making changes.
   ```

4. **Create Cross-Platform Plugin**:
   ```markdown
   # cross-platform/model-sync.md
   
   ## Cross-Platform Model Synchronization
   
   When updating data models, consider all representations:
   
   ### Model Change Checklist
   - [ ] Update backend model (C#/Python/etc.)
   - [ ] Update database schema/migration
   - [ ] Update API DTOs/contracts
   - [ ] Update frontend models (Swift/TypeScript/etc.)
   - [ ] Update API client code
   - [ ] Update tests across all platforms
   
   ### Common Patterns
   1. **Adding a field**: Propagates through entire stack
   2. **Renaming**: Requires API versioning consideration
   3. **Removing**: Check for breaking changes
   4. **Type changes**: Validate serialization compatibility
   ```

#### 4.2 Test Migration Path
```bash
# Test with RUN project (Swift-heavy)
echo "Testing with RUN project..."
cd RUN
mv CLAUDE.md CLAUDE.md.backup

# Assemble new CLAUDE.md
../CONSTRUCT/CONSTRUCT-CORE/CONSTRUCT/scripts/assemble-claude.sh . \
  "swift-mvvm,watch-patterns,background-flash" --languages "swift"

# Verify all rules present
diff CLAUDE.md.backup CLAUDE.md

# Test with a C# backend project
echo "Testing with C# backend project..."
cd ../TEST_CSHARP_PROJECT
mv CLAUDE.md CLAUDE.md.backup

../CONSTRUCT/CONSTRUCT-CORE/CONSTRUCT/scripts/assemble-claude.sh . \
  "clean-architecture,api-patterns" --languages "csharp"

# Verify C# patterns applied correctly
grep "Clean Architecture" CLAUDE.md
grep "API patterns" CLAUDE.md

# Test with full-stack project
echo "Testing with full-stack project..."
cd ../TEST_FULLSTACK_PROJECT

../CONSTRUCT/CONSTRUCT-CORE/CONSTRUCT/scripts/assemble-claude.sh . \
  "mvvm,clean-architecture,cross-platform/model-sync" --languages "swift,csharp,typescript"

# Verify multi-language support
grep "Swift patterns" CLAUDE.md
grep "C# patterns" CLAUDE.md
grep "TypeScript patterns" CLAUDE.md
grep "Cross-Platform" CLAUDE.md

echo "✅ Migration testing complete"
```

### Phase 5: Documentation Updates

#### 5.1 Update README.md
- Explain pattern system
- Show both workflows (templates vs local)
- Document pattern creation

#### 5.2 Create Pattern Guide
```markdown
# patterns/PATTERN-GUIDE.md

## Understanding the Pattern System

### ⚠️ IMPORTANT: Don't Edit CLAUDE.md Directly!

Think of CLAUDE.md like a compiled binary (e.g., Photoshop's .exe file). You wouldn't edit Photoshop's binary to change a setting - you'd use the preferences menu. Similarly:

- ❌ **NEVER** edit CLAUDE.md directly
- ✅ **ALWAYS** use `.construct/patterns.yaml` for customizations
- ✅ **CREATE** new pattern plugins for reusable patterns

### Why CLAUDE.md is Read-Only

1. **It's Generated**: Like compiled code, it's built from source files
2. **Updates Overwrite**: When patterns update, your changes are lost
3. **No Version Control**: Git can't track what changed in generated files
4. **Team Confusion**: Others won't know about your local modifications

## Creating a Pattern Plugin

### For Project-Specific Rules
Edit `.construct/patterns.yaml`:
```yaml
custom_rules:
  swift:
    - "Use 'Coordinator' suffix for navigation"
    - "Prefix private properties with underscore"
```

### For Reusable Patterns
1. Create in LAB: `CONSTRUCT-LAB/patterns/plugins/your-pattern.md`
2. Test locally by adding to `.construct/patterns.yaml`
3. Promote to CORE using `promote-to-core.sh`
4. Now all projects can use it!

## Pattern Format
```markdown
## [SCOPE] Pattern Name

### When to Use
- Specific use cases
- Problem this solves

### Rules
- ✅ DO: Positive patterns
- ❌ DON'T: Anti-patterns

### Examples
\`\`\`swift
// Good example
\`\`\`

### Conflicts
- conflicts: [other-pattern]
- overrides: [base-rule]
```

## Troubleshooting Manual Edits

If you accidentally edited CLAUDE.md:

1. **Backup your changes**: 
   ```bash
   cp CLAUDE.md my-custom-rules.txt
   ```

2. **Extract relevant rules**: Copy them to `.construct/patterns.yaml`:
   ```yaml
   custom_rules:
     swift:
       - "Your custom rule here"
   ```

3. **Regenerate CLAUDE.md**:
   ```bash
   construct-patterns regenerate
   ```

4. **Validate integrity**:
   ```bash
   construct-patterns validate
   ```

5. **Commit the right file**:
   ```bash
   git add .construct/patterns.yaml
   # NOT CLAUDE.md - it's generated!
   ```

## FAQ

**Q: Why is CLAUDE.md read-only?**  
A: It's a generated file, like a compiled binary. Editing it directly causes divergence and breaks updates. Use patterns.yaml instead.

**Q: How do I add a project-specific rule?**  
A: Edit `.construct/patterns.yaml` and add your rule under `custom_rules`. Then run `construct-patterns regenerate`.

**Q: Can I override a base pattern?**  
A: Yes! Use the `overrides` section in patterns.yaml:
```yaml
overrides:
  - pattern: "mvvm/no-logic-in-views"
    exception: "Allow computed properties for pure UI calculations"
    scope: "swift"
```

**Q: What if my patterns.yaml gets too large?**  
A: Use the `includes` feature to modularize:
```yaml
includes:
  - custom/swift-rules.yaml
  - custom/api-patterns.yaml
```

**Q: How do I share patterns with my team?**  
A: Create a pattern plugin in CONSTRUCT-LAB, test it, then promote to CORE. This makes it available to all projects.

## Pattern Best Practices

1. **Start with patterns.yaml** - Only create plugins for truly reusable patterns
2. **Use clear scopes** - Mark patterns as [SWIFT], [C#], [ALL], etc.
3. **Document exceptions** - Explain when NOT to use a pattern
4. **Include examples** - Show both good and bad code
5. **Test before promoting** - Ensure patterns work across projects

## Advanced: Creating Complex Patterns

For patterns that need to modify multiple aspects:

```markdown
## [ARCHITECTURAL] Custom MVVM+ Pattern

### Metadata
conflicts: [standard-mvvm, viper]
requires: [swift-language, combine-framework]
overrides: [base-mvvm/viewmodel-naming]

### Rules
- ✅ ViewModels must use 'VM' suffix not 'ViewModel'
- ✅ All ViewModels inherit from BaseVM
- ❌ Don't use @ObservedObject for ViewModels

### Integration
When this pattern is active:
- Disable standard MVVM pattern
- Enable Combine framework patterns
- Override ViewModel naming conventions
```

Remember: The pattern system is designed to be flexible while maintaining consistency. When in doubt, check if your customization should be project-specific (patterns.yaml) or reusable (pattern plugin). plugins for reusable patterns

### Why CLAUDE.md is Read-Only

1. **It's Generated**: Like compiled code, it's built from source files
2. **Updates Overwrite**: When patterns update, your changes are lost
3. **No Version Control**: Git can't track what changed in generated files
4. **Team Confusion**: Others won't know about your local modifications

## Creating a Pattern Plugin

### For Project-Specific Rules
Edit `.construct/patterns.yaml`:
```yaml
custom_rules:
  swift:
    - "Use 'Coordinator' suffix for navigation"
    - "Prefix private properties with underscore"
```

### For Reusable Patterns
1. Create in LAB: `CONSTRUCT-LAB/patterns/plugins/your-pattern.md`
2. Test locally by adding to `.construct/patterns.yaml`
3. Promote to CORE using `promote-to-core.sh`
4. Now all projects can use it!

## Pattern Format
```markdown
## [SCOPE] Pattern Name

### When to Use
- Specific use cases
- Problem this solves

### Rules
- ✅ DO: Positive patterns
- ❌ DON'T: Anti-patterns

### Examples
\`\`\`swift
// Good example
\`\`\`

### Conflicts
- conflicts: [other-pattern]
- overrides: [base-rule]
```

## If You've Already Edited CLAUDE.md

1. **Save your changes**: Copy custom rules to a temporary file
2. **Update patterns.yaml**: Add your rules to `custom_rules`
3. **Regenerate**: Run `construct-patterns regenerate`
4. **Verify**: Check your rules appear in the new CLAUDE.md
5. **Commit**: Only commit `.construct/patterns.yaml`, not CLAUDE.md
```

## Integration Timeline

### Week 1: Foundation
- [ ] Create pattern directory structure
- [ ] Build assemble-claude.sh script
- [ ] Extract patterns from existing CLAUDE.md files
- [ ] Create initial CLAUDE-BASE.md

### Week 2: Assembly System  
- [ ] Implement pattern selection in create-project.sh
- [ ] Build construct-patterns control script
- [ ] Test with RUN project
- [ ] Document pattern format

### Week 3: Promotion & Polish
- [ ] Add pattern promotion to promote-to-core.sh
- [ ] Create pattern development guide
- [ ] Update all documentation
- [ ] Test complete workflow

## Success Criteria

1. **Flexibility**: Projects can choose their patterns
2. **Simplicity**: Clear base + plugins model
3. **Extensibility**: Easy to add new patterns
4. **Compatibility**: Works with existing CONSTRUCT structure
5. **Discovery**: Patterns can flow from projects back to CORE
6. **Integrity**: Projects cannot diverge by editing CLAUDE.md directly
7. **Validation**: Pre-commit hooks catch unauthorized modifications
8. **Traceability**: All customizations traced back to patterns.yaml or plugins

## Key Decisions

### What Changes from Original Plans

1. **CLAUDE.md is assembled, not symlinked**
   - Symlinks remain for CONSTRUCT tools and docs
   - CLAUDE.md is generated per project
   - **NEW**: Generated files are read-only with warning headers

2. **Pattern plugins are first-class citizens**
   - Not just documentation
   - Active part of project configuration
   - **NEW**: Project customizations via patterns.yaml, not direct edits

3. **LAB gets pattern development area**
   - Test patterns before promotion
   - Community can share experimental patterns
   - **NEW**: Clear workflow prevents manual CLAUDE.md edits

### What Stays the Same

1. **Template-first architecture** (from RESTRUCTURE-PLAN-04)
2. **Promotion system** (LAB → CORE)
3. **Symlinked CONSTRUCT directory**
4. **AI template structure**

### The "Don't Edit the Binary" Philosophy

Just as you wouldn't edit Photoshop's executable to change settings, you shouldn't edit CLAUDE.md directly:

- **Source Files**: CLAUDE-BASE.md, pattern plugins, patterns.yaml
- **Compiled Output**: CLAUDE.md (read-only, generated)
- **Customization**: Through configuration, not binary editing
- **Updates**: Regenerate from source, don't patch the output

### Task-Specific Context Philosophy

Following context engineering best practices:

- **Minimal Context**: Only load patterns relevant to current task
- **Dynamic Selection**: Detect context needs from active file
- **Performance First**: Smaller context = faster, more accurate responses
- **Fallback Available**: Full context still accessible when needed

## The Pattern Configuration Experience

When working in Claude Code:

```markdown
## 🎛️ Pattern Configuration

### Active Patterns (Toggle ✓/✗ to enable/disable)

#### Base Patterns (Always Active)
- ✓ Token-first development
- ✓ Error handling standards
- ✓ Documentation requirements

#### Language Patterns (Project: Swift + C#)
- ✓ swift-language - Swift/iOS development patterns
- ✓ csharp-language - C#/.NET patterns
- ✓ cross-platform/model-sync - Multi-language coordination

#### Architectural Patterns
- ✓ mvvm - Model-View-ViewModel architecture
- ✗ viper - VIPER architecture (alternative)
- ✗ clean-architecture - Clean Architecture pattern

#### Optional Patterns
- ✓ watch-patterns - Apple Watch specific
- ✗ construct-dev - CONSTRUCT development
- ✗ startup-velocity - Rapid prototyping

To change: Edit ✓/✗ above and say "reload patterns"

### Quick Context Commands
- "Enable CONSTRUCT development" - When you need to work on CONSTRUCT itself
- "Switch to API context" - Focus on C# backend patterns
- "Update User model everywhere" - I'll guide through all languages
```

## Task-Specific Context Example

When editing a SwiftUI View file:

```bash
# context-detect.sh identifies:
# - File: MyView.swift
# - Needs: swift-language, swift-ui-quality
# - Excludes: csharp, watch-patterns, model-sync

# Generated CLAUDE-temp.md contains only:
# - Base patterns
# - Swift language rules
# - SwiftUI quality patterns
# = Focused, relevant context
```

Result: Claude Code gives SwiftUI-specific suggestions without noise from unrelated patterns.

## Multi-Language Project Example

When you say: "I need to add a profile picture to the User model"

Claude responds using multiple active patterns:

```
I'll help you add profile picture across your stack. Based on your active patterns (Swift + C# + cross-platform), here's what we need to update:

1. **C# Backend** (clean-architecture pattern):
   - Update User entity in Domain/Entities/User.cs
   - Add ProfilePictureUrl property
   - Create migration: Add-Migration AddUserProfilePicture
   
2. **API Layer**:
   - Update UserDto in Application/DTOs/UserDto.cs
   - Update API documentation/OpenAPI spec
   
3. **Swift iOS** (MVVM pattern):
   - Update User model in Models/User.swift
   - Add profilePictureURL to Codable properties
   - Update UserViewModel to handle image loading
   
4. **Database**:
   - Run migration on development database
   - Update seed data if needed

Would you like me to show the code for each layer?
```

This creates a truly context-aware system that understands your entire project stack while maintaining the flexibility to toggle patterns on and off as needed.

## References

- See: `CONSTRUCT-RESTRUCTURE-PLAN-04.md` for template architecture
- See: `unified-claude-todo.md` for original symlink approach (superseded)
- See: `claude-md-mitigation-strategies.md` for complexity management
- See: `tools/README.md` for promotion workflow

---

**Next Step**: Begin Phase 1.1 - Create pattern infrastructure with task detection support

## Addendum: Implementation Priority

Given the task-specific context detection feature, consider this implementation order:

1. **Test Current System First**: Use the static CLAUDE.md approach for 1-2 sprints
2. **Measure Context Bloat**: Monitor if Claude Code responses include irrelevant patterns
3. **Implement Task Detection**: If needed, add context-detect.sh in a follow-up sprint
4. **Iterate on Detection Rules**: Refine based on real usage patterns

This allows you to validate the need for dynamic context before adding complexity.

## The Pattern Configuration Experience

When working in Claude Code:

```markdown
## 🎛️ Pattern Configuration

### Active Patterns (Toggle ✓/✗ to enable/disable)

#### Base Patterns (Always Active)
- ✓ Token-first development
- ✓ Error handling standards
- ✓ Documentation requirements

#### Language Patterns (Project: Swift + C#)
- ✓ swift-language - Swift/iOS development patterns
- ✓ csharp-language - C#/.NET patterns
- ✓ cross-platform/model-sync - Multi-language coordination

#### Architectural Patterns
- ✓ mvvm - Model-View-ViewModel architecture
- ✗ viper - VIPER architecture (alternative)
- ✗ clean-architecture - Clean Architecture pattern

#### Optional Patterns
- ✓ watch-patterns - Apple Watch specific
- ✗ construct-dev - CONSTRUCT development
- ✗ startup-velocity - Rapid prototyping

To change: Edit ✓/✗ above and say "reload patterns"

### Quick Context Commands
- "Enable CONSTRUCT development" - When you need to work on CONSTRUCT itself
- "Switch to API context" - Focus on C# backend patterns
- "Update User model everywhere" - I'll guide through all languages
```

## Multi-Language Project Example

When you say: "I need to add a profile picture to the User model"

Claude responds using multiple active patterns:

```
I'll help you add profile picture across your stack. Based on your active patterns (Swift + C# + cross-platform), here's what we need to update:

1. **C# Backend** (clean-architecture pattern):
   - Update User entity in Domain/Entities/User.cs
   - Add ProfilePictureUrl property
   - Create migration: Add-Migration AddUserProfilePicture
   
2. **API Layer**:
   - Update UserDto in Application/DTOs/UserDto.cs
   - Update API documentation/OpenAPI spec
   
3. **Swift iOS** (MVVM pattern):
   - Update User model in Models/User.swift
   - Add profilePictureURL to Codable properties
   - Update UserViewModel to handle image loading
   
4. **Database**:
   - Run migration on development database
   - Update seed data if needed

Would you like me to show the code for each layer?
```

This creates a truly context-aware system that understands your entire project stack while maintaining the flexibility to toggle patterns on and off as needed.

## References

- See: `CONSTRUCT-RESTRUCTURE-PLAN-04.md` for template architecture
- See: `unified-claude-todo.md` for original symlink approach (superseded)
- See: `claude-md-mitigation-strategies.md` for complexity management
- See: `tools/README.md` for promotion workflow

---

**Next Step**: Begin Phase 1.1 - Create pattern infrastructure\n'
            fi
        fi
    done <<< "$INCLUDES"
    
    # Get main custom rules
    CUSTOM_RULES=$(yq eval '.custom_rules' "$CONFIG_FILE" 2>/dev/null || echo "")
    if [ -n "$CUSTOM_RULES" ] && [ "$CUSTOM_RULES" != "null" ]; then
        MERGED_RULES+="$CUSTOM_RULES"
    fi
    
    # Add custom rules section if any exist
    if [ -n "$MERGED_RULES" ]; then
        CLAUDE_CONTENT+="
## Project-Specific Rules
<!-- Loaded from .construct/patterns.yaml -->
$MERGED_RULES
"
    fi
    
    # Handle overrides
    OVERRIDES=$(yq eval '.overrides' "$CONFIG_FILE" 2>/dev/null || echo "")
    if [ -n "$OVERRIDES" ] && [ "$OVERRIDES" != "null" ] && [ "$OVERRIDES" != "[]" ]; then
        CLAUDE_CONTENT+="
## Pattern Overrides
<!-- Project-specific exceptions to base patterns -->
$OVERRIDES
"
    fi
fi

# Add generation metadata
GENERATION_TIME=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
CONTENT_HASH=$(echo -n "$CLAUDE_CONTENT" | shasum -a 256 | cut -d' ' -f1)
CLAUDE_CONTENT+="

<!-- 
Generated: $GENERATION_TIME
Source: CONSTRUCT-CORE/CLAUDE-BASE.md
Plugins: $PLUGINS
Hash: $CONTENT_HASH
-->
"

# Output or save based on mode
if [ "$DRY_RUN" = true ]; then
    echo -n "$CONTENT_HASH"
else
    # Check if file is writable (warn if it is)
    if [ -f "$PROJECT_DIR/CLAUDE.md" ] && [ -w "$PROJECT_DIR/CLAUDE.md" ]; then
        echo "⚠️  Warning: CLAUDE.md is writable; setting to read-only"
    fi
    
    # Write file
    echo "$CLAUDE_CONTENT" > "$PROJECT_DIR/CLAUDE.md"
    
    # Make read-only to discourage edits
    chmod 444 "$PROJECT_DIR/CLAUDE.md"
    
    echo "✅ Generated CLAUDE.md (read-only) with patterns: $PLUGINS"
    echo "📍 Location: $PROJECT_DIR/CLAUDE.md"
    echo "🔒 File is read-only. Use 'construct-patterns regenerate' to update."
fi
```

#### 2.2 Create Pattern Control Interface
```bash
#!/bin/bash
# CONSTRUCT-CORE/CONSTRUCT/scripts/construct-patterns.sh

# Interactive pattern management
# Shows available patterns, current config, allows toggling

set -e

PROJECT_DIR="${1:-.}"
CONFIG_FILE="$PROJECT_DIR/.construct/patterns.yaml"

case "${1:-show}" in
    "regenerate")
        echo "⚠️  Regenerating CLAUDE.md will overwrite any manual changes."
        read -p "Continue? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Make writable temporarily
            chmod +w "$PROJECT_DIR/CLAUDE.md"
            
            # Read current configuration
            PLUGINS=$(yq eval '.plugins | join(",")' "$CONFIG_FILE")
            LANGUAGES=$(yq eval '.languages | join(",")' "$CONFIG_FILE")
            
            # Regenerate
            ./assemble-claude.sh "$PROJECT_DIR" "$PLUGINS" --languages "$LANGUAGES"
            echo "✅ CLAUDE.md regenerated from patterns.yaml"
        fi
        ;;
        
    "validate")
        echo "🔍 Validating CLAUDE.md integrity..."
        
        # Generate expected hash
        EXPECTED_HASH=$(./assemble-claude.sh "$PROJECT_DIR" "" --dry-run)
        
        # Extract actual hash from file
        ACTUAL_HASH=$(grep "Hash:" "$PROJECT_DIR/CLAUDE.md" | awk '{print $2}')
        
        if [ "$EXPECTED_HASH" = "$ACTUAL_HASH" ]; then
            echo "✅ CLAUDE.md is unmodified"
        else
            echo "❌ CLAUDE.md has been manually edited!"
            echo "Expected: $EXPECTED_HASH"
            echo "Actual: $ACTUAL_HASH"
            echo "Run 'construct-patterns regenerate' to restore"
            exit 1
        fi
        ;;
        
    *)
        echo "Usage: construct-patterns [regenerate|validate|show]"
        ;;
esac
```

#### 2.3 Create patterns.yaml Template
```yaml
# .construct/patterns.yaml
# Project-specific pattern configuration

# Languages used in this project
languages:
  - swift
  - csharp

# Active pattern plugins
plugins:
  - mvvm
  - cross-platform/model-sync
  - background-flash

# Project-specific rules (added to CLAUDE.md)
custom_rules:
  swift:
    - "Use 'Coordinator' suffix for navigation coordinators"
    - "Prefix private properties with underscore in ViewModels"
  csharp:
    - "Use 'Async' suffix for all async methods"
    - "Group related endpoints in partial controller classes"
  all:
    - "Add ticket number to TODO comments: // TODO (JIRA-123): Fix this"

# Pattern overrides (for exceptions to base rules)
overrides:
  - pattern: "mvvm/no-logic-in-views"
    exception: "Allow computed properties for pure UI calculations"
    scope: "swift"
```

#### 2.3 Update `create-project.sh`
```bash
# Add pattern selection to project creation
echo "What type of project is this?"
echo "1. iOS App (Swift)"
echo "2. Web App (TypeScript/React)"
echo "3. Backend API (C#/.NET)"
echo "4. Full Stack (Multiple languages)"
echo "5. Custom"
read -p "Select type (1-5): " PROJECT_TYPE

case $PROJECT_TYPE in
    1)
        LANGUAGES="swift"
        SUGGESTED_PLUGINS="mvvm,swift-ui-quality"
        ;;
    2)
        LANGUAGES="typescript"
        SUGGESTED_PLUGINS="react-patterns,typescript-strict"
        ;;
    3)
        LANGUAGES="csharp"
        SUGGESTED_PLUGINS="clean-architecture,api-patterns"
        ;;
    4)
        echo "Which languages? (comma-separated: swift,csharp,typescript)"
        read -p "Languages: " LANGUAGES
        SUGGESTED_PLUGINS="cross-platform/model-sync"
        ;;
    5)
        read -p "Languages: " LANGUAGES
        SUGGESTED_PLUGINS=""
        ;;
esac

echo "Additional pattern plugins (comma-separated, or press enter for none):"
echo "Available: watch-patterns, background-flash, construct-dev, startup-velocity"
read -p "Plugins: " ADDITIONAL_PLUGINS

# Combine all plugins
ALL_PLUGINS="${SUGGESTED_PLUGINS}"
if [ -n "$ADDITIONAL_PLUGINS" ]; then
    ALL_PLUGINS="${ALL_PLUGINS},${ADDITIONAL_PLUGINS}"
fi

# Assemble CLAUDE.md with selected patterns and languages
./assemble-claude.sh "$PROJECT_DIR" "$ALL_PLUGINS" --languages "$LANGUAGES"
```

### Phase 3: Implement Pattern Promotion & Validation

#### 3.1 Extend PROMOTE-TO-CORE.yaml
```yaml
# Existing file promotion
promotions:
  - type: file
    source: experiments/script.sh
    dest: CONSTRUCT-CORE/CONSTRUCT/scripts/script.sh
    
  # Pattern promotion
  - type: pattern
    source: patterns/plugins/new-pattern.md
    dest: CONSTRUCT-CORE/patterns/plugins/new-pattern.md
    description: "Promotes tested pattern to stable"
    bump_version: minor
    
  # Project-specific pattern promotion
  - type: project-pattern
    source: ../RUN/patterns/custom-navigation.md
    dest: CONSTRUCT-CORE/patterns/plugins/custom-navigation.md
    description: "Promotes project discovery to reusable plugin"
    bump_version: minor
```

#### 3.2 Add Pre-commit Validation
```bash
#!/bin/bash
# .git/hooks/pre-commit (or CONSTRUCT-CORE/hooks/pre-commit)

# Validate CLAUDE.md hasn't been manually edited
for project in $(find . -name "CLAUDE.md" -not -path "*/CONSTRUCT-*/*"); do
    project_dir=$(dirname "$project")
    
    echo "Validating $project..."
    if ! ./CONSTRUCT/scripts/construct-patterns.sh validate "$project_dir"; then
        echo "❌ Pre-commit check failed: CLAUDE.md has been manually edited"
        echo "📝 To fix: Update .construct/patterns.yaml and run:"
        echo "   construct-patterns regenerate"
        exit 1
    fi
done

echo "✅ All CLAUDE.md files are unmodified"
```

#### 3.3 Update promote-to-core.sh
```bash
# Add pattern promotion support
case "$type" in
  "file")
    # Existing logic
    ;;
  "pattern"|"project-pattern")
    # Validate pattern format
    if ! grep -q "^## \[" "$source"; then
        echo "❌ Pattern must start with ## [SCOPE] header"
        exit 1
    fi
    
    # Check for conflicts with existing patterns
    pattern_name=$(basename "$dest" .md)
    if grep -r "conflicts:.*$pattern_name" "$CONSTRUCT_CORE/patterns/"; then
        echo "⚠️  Pattern may conflict with existing patterns"
        read -p "Continue? [y/N] " -n 1 -r
        [[ ! $REPLY =~ ^[Yy]$ ]] && exit 1
    fi
    
    # Copy pattern to CORE
    cp "$source" "$dest"
    echo "✅ Pattern promoted to CORE"
    ;;
esac
```

### Phase 4: Migration from Current State

#### 4.1 Extract Patterns from Existing Files
1. **From CONSTRUCT-LAB/CLAUDE.md**:
   - Shell scripting rules → `tooling/shell-scripting.md` plugin
   - Symlink management → `tooling/construct-dev.md` plugin  
   - Promotion workflow → `tooling/construct-dev.md` plugin

2. **From RUN/CLAUDE.md**:
   - Background flash prevention → `discoveries/background-flash.md` plugin
   - Watch-specific patterns → `discoveries/watch-patterns.md` plugin
   - Swift MVVM patterns → `architectural/mvvm.md` plugin
   - Swift language rules → `languages/swift.md` plugin

3. **Create Initial CLAUDE-BASE.md**:
   ```markdown
   # CONSTRUCT Base Patterns
   
   ## Universal Development Principles
   - Never break existing tests
   - Document why, not what
   - Token-first development
   - Error handling is mandatory
   
   ## Multi-Context Awareness
   This context system understands your entire project stack.
   Language-specific patterns are applied based on file types.
   Cross-platform patterns help coordinate changes across languages.
   
   ## Pattern System
   See active patterns below. Toggle ✓/✗ to change what rules I follow.
   Say "reload patterns" after making changes.
   ```

4. **Create Cross-Platform Plugin**:
   ```markdown
   # cross-platform/model-sync.md
   
   ## Cross-Platform Model Synchronization
   
   When updating data models, consider all representations:
   
   ### Model Change Checklist
   - [ ] Update backend model (C#/Python/etc.)
   - [ ] Update database schema/migration
   - [ ] Update API DTOs/contracts
   - [ ] Update frontend models (Swift/TypeScript/etc.)
   - [ ] Update API client code
   - [ ] Update tests across all platforms
   
   ### Common Patterns
   1. **Adding a field**: Propagates through entire stack
   2. **Renaming**: Requires API versioning consideration
   3. **Removing**: Check for breaking changes
   4. **Type changes**: Validate serialization compatibility
   ```

#### 4.2 Test Migration Path
```bash
# Test with RUN project
cd RUN
mv CLAUDE.md CLAUDE.md.backup

# Assemble new CLAUDE.md
../CONSTRUCT/CONSTRUCT-CORE/CONSTRUCT/scripts/assemble-claude.sh . \
  "swift-mvvm,watch-patterns,background-flash"

# Verify all rules present
diff CLAUDE.md.backup CLAUDE.md
```

### Phase 5: Documentation Updates

#### 5.1 Update README.md
- Explain pattern system
- Show both workflows (templates vs local)
- Document pattern creation

#### 5.2 Create Pattern Guide
```markdown
# patterns/PATTERN-GUIDE.md

## Understanding the Pattern System

### ⚠️ IMPORTANT: Don't Edit CLAUDE.md Directly!

Think of CLAUDE.md like a compiled binary (e.g., Photoshop's .exe file). You wouldn't edit Photoshop's binary to change a setting - you'd use the preferences menu. Similarly:

- ❌ **NEVER** edit CLAUDE.md directly
- ✅ **ALWAYS** use `.construct/patterns.yaml` for customizations
- ✅ **CREATE** new pattern plugins for reusable patterns

### Why CLAUDE.md is Read-Only

1. **It's Generated**: Like compiled code, it's built from source files
2. **Updates Overwrite**: When patterns update, your changes are lost
3. **No Version Control**: Git can't track what changed in generated files
4. **Team Confusion**: Others won't know about your local modifications

## Creating a Pattern Plugin

### For Project-Specific Rules
Edit `.construct/patterns.yaml`:
```yaml
custom_rules:
  swift:
    - "Use 'Coordinator' suffix for navigation"
    - "Prefix private properties with underscore"
```

### For Reusable Patterns
1. Create in LAB: `CONSTRUCT-LAB/patterns/plugins/your-pattern.md`
2. Test locally by adding to `.construct/patterns.yaml`
3. Promote to CORE using `promote-to-core.sh`
4. Now all projects can use it!

## Pattern Format
```markdown
## [SCOPE] Pattern Name

### When to Use
- Specific use cases
- Problem this solves

### Rules
- ✅ DO: Positive patterns
- ❌ DON'T: Anti-patterns

### Examples
\`\`\`swift
// Good example
\`\`\`

### Conflicts
- conflicts: [other-pattern]
- overrides: [base-rule]
```

## If You've Already Edited CLAUDE.md

1. **Save your changes**: Copy custom rules to a temporary file
2. **Update patterns.yaml**: Add your rules to `custom_rules`
3. **Regenerate**: Run `construct-patterns regenerate`
4. **Verify**: Check your rules appear in the new CLAUDE.md
5. **Commit**: Only commit `.construct/patterns.yaml`, not CLAUDE.md
```

## Integration Timeline

### Week 1: Foundation
- [ ] Create pattern directory structure
- [ ] Build assemble-claude.sh script
- [ ] Extract patterns from existing CLAUDE.md files
- [ ] Create initial CLAUDE-BASE.md

### Week 2: Assembly System  
- [ ] Implement pattern selection in create-project.sh
- [ ] Build construct-patterns control script
- [ ] Test with RUN project
- [ ] Document pattern format

### Week 3: Promotion & Polish
- [ ] Add pattern promotion to promote-to-core.sh
- [ ] Create pattern development guide
- [ ] Update all documentation
- [ ] Test complete workflow

## Success Criteria

1. **Flexibility**: Projects can choose their patterns
2. **Simplicity**: Clear base + plugins model
3. **Extensibility**: Easy to add new patterns
4. **Compatibility**: Works with existing CONSTRUCT structure
5. **Discovery**: Patterns can flow from projects back to CORE
6. **Integrity**: Projects cannot diverge by editing CLAUDE.md directly
7. **Validation**: Pre-commit hooks catch unauthorized modifications
8. **Traceability**: All customizations traced back to patterns.yaml or plugins

## Key Decisions

### What Changes from Original Plans

1. **CLAUDE.md is assembled, not symlinked**
   - Symlinks remain for CONSTRUCT tools and docs
   - CLAUDE.md is generated per project
   - **NEW**: Generated files are read-only with warning headers

2. **Pattern plugins are first-class citizens**
   - Not just documentation
   - Active part of project configuration
   - **NEW**: Project customizations via patterns.yaml, not direct edits

3. **LAB gets pattern development area**
   - Test patterns before promotion
   - Community can share experimental patterns
   - **NEW**: Clear workflow prevents manual CLAUDE.md edits

### What Stays the Same

1. **Template-first architecture** (from RESTRUCTURE-PLAN-04)
2. **Promotion system** (LAB → CORE)
3. **Symlinked CONSTRUCT directory**
4. **AI template structure**

### The "Don't Edit the Binary" Philosophy

Just as you wouldn't edit Photoshop's executable to change settings, you shouldn't edit CLAUDE.md directly:

- **Source Files**: CLAUDE-BASE.md, pattern plugins, patterns.yaml
- **Compiled Output**: CLAUDE.md (read-only, generated)
- **Customization**: Through configuration, not binary editing
- **Updates**: Regenerate from source, don't patch the output

## The Pattern Configuration Experience

When working in Claude Code:

```markdown
## 🎛️ Pattern Configuration

### Active Patterns (Toggle ✓/✗ to enable/disable)

#### Base Patterns (Always Active)
- ✓ Token-first development
- ✓ Error handling standards
- ✓ Documentation requirements

#### Language Patterns (Project: Swift + C#)
- ✓ swift-language - Swift/iOS development patterns
- ✓ csharp-language - C#/.NET patterns
- ✓ cross-platform/model-sync - Multi-language coordination

#### Architectural Patterns
- ✓ mvvm - Model-View-ViewModel architecture
- ✗ viper - VIPER architecture (alternative)
- ✗ clean-architecture - Clean Architecture pattern

#### Optional Patterns
- ✓ watch-patterns - Apple Watch specific
- ✗ construct-dev - CONSTRUCT development
- ✗ startup-velocity - Rapid prototyping

To change: Edit ✓/✗ above and say "reload patterns"

### Quick Context Commands
- "Enable CONSTRUCT development" - When you need to work on CONSTRUCT itself
- "Switch to API context" - Focus on C# backend patterns
- "Update User model everywhere" - I'll guide through all languages
```

## Multi-Language Project Example

When you say: "I need to add a profile picture to the User model"

Claude responds using multiple active patterns:

```
I'll help you add profile picture across your stack. Based on your active patterns (Swift + C# + cross-platform), here's what we need to update:

1. **C# Backend** (clean-architecture pattern):
   - Update User entity in Domain/Entities/User.cs
   - Add ProfilePictureUrl property
   - Create migration: Add-Migration AddUserProfilePicture
   
2. **API Layer**:
   - Update UserDto in Application/DTOs/UserDto.cs
   - Update API documentation/OpenAPI spec
   
3. **Swift iOS** (MVVM pattern):
   - Update User model in Models/User.swift
   - Add profilePictureURL to Codable properties
   - Update UserViewModel to handle image loading
   
4. **Database**:
   - Run migration on development database
   - Update seed data if needed

Would you like me to show the code for each layer?
```

This creates a truly context-aware system that understands your entire project stack while maintaining the flexibility to toggle patterns on and off as needed.

## References

- See: `CONSTRUCT-RESTRUCTURE-PLAN-04.md` for template architecture
- See: `unified-claude-todo.md` for original symlink approach (superseded)
- See: `claude-md-mitigation-strategies.md` for complexity management
- See: `tools/README.md` for promotion workflow

---

**Next Step**: Begin Phase 1.1 - Create pattern infrastructure