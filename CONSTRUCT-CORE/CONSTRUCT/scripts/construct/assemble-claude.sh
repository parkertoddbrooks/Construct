#!/bin/bash

# Assembles CLAUDE.md from base + selected plugins
# Usage: ./assemble-claude.sh <project-dir> <plugins> [--languages lang1,lang2] [--dry-run]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSTRUCT_CORE="$(cd "$SCRIPT_DIR/../../.." && pwd)"
CONSTRUCT_ROOT="$(cd "$CONSTRUCT_CORE/.." && pwd)"

PROJECT_DIR="$1"
PLUGINS="$2"
CONFIG_FILE="$PROJECT_DIR/.construct/patterns.yaml"
DRY_RUN=false

# Check for dry-run mode (for validation)
if [[ "${@: -1}" == "--dry-run" ]]; then
    DRY_RUN=true
fi

# Handle special commands first
case "$1" in
    "--list-plugins")
        # List available plugins from registry
        REGISTRY_FILE="$CONSTRUCT_CORE/patterns/plugins/registry.yaml"
        if [ -f "$REGISTRY_FILE" ] && command -v yq &> /dev/null; then
            echo -e "${BLUE}📦 Available CONSTRUCT Plugins:${NC}"
            echo ""
            echo -e "${GREEN}CORE Plugins:${NC}"
            yq eval '.plugins.core | to_entries | .[] | "  \(.key) - \(.value.description)"' "$REGISTRY_FILE" 2>/dev/null
            echo ""
            if yq eval '.plugins.lab' "$REGISTRY_FILE" &>/dev/null; then
                echo -e "${GREEN}LAB Plugins:${NC}"
                yq eval '.plugins.lab | to_entries | .[] | "  \(.key) - \(.value.description)"' "$REGISTRY_FILE" 2>/dev/null
            fi
        else
            echo -e "${RED}❌ Registry not found or yq not installed${NC}"
            exit 1
        fi
        exit 0
        ;;
    "--list-sets")
        # List available project template sets
        PROJECT_SETS_FILE="$CONSTRUCT_CORE/patterns/templates/project-sets.yaml"
        if [ -f "$PROJECT_SETS_FILE" ] && command -v yq &> /dev/null; then
            echo -e "${BLUE}📋 Available Project Template Sets:${NC}"
            echo ""
            yq eval '.project_sets | to_entries | .[] | "  \(.key) - \(.value.description)"' "$PROJECT_SETS_FILE" 2>/dev/null
        else
            echo -e "${RED}❌ Project sets not found or yq not installed${NC}"
            exit 1
        fi
        exit 0
        ;;
    "--refresh-registry")
        # Run registry refresh script
        REFRESH_SCRIPT="$SCRIPT_DIR/refresh-plugin-registry.sh"
        if [ -x "$REFRESH_SCRIPT" ]; then
            echo -e "${BLUE}🔄 Refreshing plugin registry...${NC}"
            "$REFRESH_SCRIPT"
        else
            echo -e "${RED}❌ Registry refresh script not found: $REFRESH_SCRIPT${NC}"
            exit 1
        fi
        exit 0
        ;;
esac

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 <project-dir> <plugins> [--languages lang1,lang2] [--dry-run]"
    echo "       $0 --list-plugins | --list-sets | --refresh-registry"
    echo ""
    echo "Assembles CLAUDE.md from base patterns + selected plugins"
    echo ""
    echo "Arguments:"
    echo "  project-dir    Directory where CLAUDE.md will be generated"
    echo "  plugins        Comma-separated list of pattern plugins"
    echo ""
    echo "Options:"
    echo "  --languages       Auto-include language patterns"
    echo "  --dry-run         Generate hash only (for validation)"
    echo "  --list-plugins    Show available plugins from registry"
    echo "  --list-sets       Show available project template sets"
    echo "  --refresh-registry Update the plugin registry"
    echo "  --help, -h        Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 ./MyProject swift-language,mvvm --languages swift"
    echo "  $0 ./MyProject construct-dev --dry-run"
    echo "  $0 --list-plugins"
    echo "  $0 --refresh-registry"
    exit 0
fi

# Validate project directory
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}❌ Error: Project directory not found: $PROJECT_DIR${NC}"
    exit 1
fi

# Parse languages if provided
if [[ "$3" == "--languages" ]]; then
    LANGUAGES="$4"
    # Auto-include language patterns
    IFS=',' read -ra LANG_ARRAY <<< "$LANGUAGES"
    for lang in "${LANG_ARRAY[@]}"; do
        PLUGINS="${PLUGINS},languages/${lang}"
    done
    
    # Include cross-platform if multiple languages
    if [ ${#LANG_ARRAY[@]} -gt 1 ]; then
        PLUGINS="${PLUGINS},cross-platform/model-sync"
    fi
fi

# Validate all plugins exist before assembly (check both CORE and LAB)
IFS=',' read -ra PLUGIN_ARRAY <<< "$PLUGINS"
for plugin in "${PLUGIN_ARRAY[@]}"; do
    plugin=$(echo "$plugin" | xargs) # Trim whitespace
    if [ -n "$plugin" ]; then
        # Extract plugin name from path (e.g., tooling/construct-dev -> construct-dev)
        plugin_name=$(basename "$plugin")
        
        # Check CORE first - look for pattern file in plugin directory
        core_plugin_path="$CONSTRUCT_CORE/patterns/plugins/$plugin/$plugin_name.md"
        # Check LAB second
        lab_plugin_path="$CONSTRUCT_ROOT/CONSTRUCT-LAB/patterns/plugins/$plugin/$plugin_name.md"
        # Check project-local third (for extracted patterns)
        project_plugin_path="./CONSTRUCT/patterns/plugins/$plugin/$plugin_name.md"
        project_injection_path="./CONSTRUCT/patterns/plugins/$plugin/injections/$plugin_name.md"
        
        if [ -f "$core_plugin_path" ]; then
            continue # Found in CORE
        elif [ -f "$lab_plugin_path" ]; then
            continue # Found in LAB
        elif [ -f "$project_plugin_path" ]; then
            continue # Found in project
        elif [ -f "$project_injection_path" ]; then
            continue # Found in project injections
        else
            echo -e "${RED}❌ Error: Plugin not found: $plugin${NC}"
            echo -e "${YELLOW}   Looking for:${NC}"
            echo -e "${YELLOW}     CORE: $core_plugin_path${NC}"
            echo -e "${YELLOW}     LAB:  $lab_plugin_path${NC}"
            echo -e "${YELLOW}     PROJECT: $project_plugin_path${NC}"
            echo -e "${YELLOW}     PROJECT INJECTIONS: $project_injection_path${NC}"
            echo -e "${YELLOW}   Available CORE plugins:${NC}"
            find "$CONSTRUCT_CORE/patterns/plugins" -name "*.md" -type f | sed "s|$CONSTRUCT_CORE/patterns/plugins/||" | sed 's|\.md$||' | sort
            echo -e "${YELLOW}   Available LAB plugins:${NC}"
            find "$CONSTRUCT_ROOT/CONSTRUCT-LAB/patterns/plugins" -name "*.md" -type f 2>/dev/null | sed "s|$CONSTRUCT_ROOT/CONSTRUCT-LAB/patterns/plugins/||" | sed 's|\.md$||' | sort
            exit 1
        fi
    fi
done

# Validate patterns.yaml if it exists
if [ -f "$CONFIG_FILE" ]; then
    if command -v yq >/dev/null 2>&1; then
        if ! yq eval '.' "$CONFIG_FILE" >/dev/null 2>&1; then
            echo -e "${RED}❌ Error: Invalid patterns.yaml format${NC}"
            echo -e "${YELLOW}   File: $CONFIG_FILE${NC}"
            echo -e "${YELLOW}   Please check YAML syntax${NC}"
            exit 1
        fi
    else
        echo -e "${YELLOW}⚠️ Warning: yq not installed, skipping patterns.yaml validation${NC}"
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
║ Instead, edit the source (patterns.yaml) and regenerate.                   ║
║                                                                              ║
║ See: CONSTRUCT-CORE/patterns/PATTERN-GUIDE.md for customization help        ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->

"

# Check if we have extracted project knowledge to lead with
PROJECT_CUSTOM_CONTENT=""
PROJECT_NAME=$(basename "$PROJECT_DIR")

# Check for three-level extraction structure (prioritize complete blob)
# Level 1: Complete blob (preferred for assembly)
project_all_path="$PROJECT_DIR/CONSTRUCT/patterns/plugins/extracted-${PROJECT_NAME}-all/injections/extracted-${PROJECT_NAME}-all.md"
# Level 3: Uncategorized unique patterns (fallback)
project_custom_path="$PROJECT_DIR/CONSTRUCT/patterns/plugins/extracted-${PROJECT_NAME}/injections/extracted-${PROJECT_NAME}.md"

# Use complete blob if available, otherwise use uncategorized
if [ -f "$project_all_path" ]; then
    PROJECT_CUSTOM_CONTENT=$(cat "$project_all_path")
    echo -e "${YELLOW}📋 Found complete project knowledge extraction (Level 1: all content)${NC}"
elif [ -f "$project_custom_path" ]; then
    PROJECT_CUSTOM_CONTENT=$(cat "$project_custom_path")
    echo -e "${YELLOW}📋 Found uncategorized project knowledge (Level 3: unique patterns)${NC}"
fi

# Note: Level 2 (categorized patterns) are handled separately via plugin system

# Start with project knowledge if available
if [ -n "$PROJECT_CUSTOM_CONTENT" ]; then
    CLAUDE_CONTENT+="

$PROJECT_CUSTOM_CONTENT

---

"
fi

# Add base content (universal principles) 
if [ ! -f "$CONSTRUCT_CORE/CLAUDE-BASE.md" ]; then
    echo -e "${RED}❌ Error: CLAUDE-BASE.md not found in $CONSTRUCT_CORE${NC}"
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

# Add brief pattern configuration section
CLAUDE_CONTENT+="
## 🎯 Development Patterns

### Active Pattern Configuration
This project uses the following patterns for intelligent development assistance:
"

# Add brief pattern references without full content
echo -e "${BLUE}🔄 Assembling pattern references...${NC}"
PATTERN_SUMMARIES=""
for plugin in "${PLUGIN_ARRAY[@]}"; do
    plugin=$(echo "$plugin" | xargs) # Trim whitespace
    if [ -n "$plugin" ]; then
        # Skip extracted project content as it's already featured prominently above
        # This includes: extracted-{PROJECT}-all, extracted-{PROJECT}, and {PROJECT}-{category}
        if [[ "$plugin" == extracted-* ]] || [[ "$plugin" == *-architectural ]] || 
           [[ "$plugin" == *-frameworks ]] || [[ "$plugin" == *-languages ]] || 
           [[ "$plugin" == *-platforms ]] || [[ "$plugin" == *-tooling ]] || 
           [[ "$plugin" == *-ui ]] || [[ "$plugin" == *-performance ]] || 
           [[ "$plugin" == *-quality ]] || [[ "$plugin" == *-configuration ]] || 
           [[ "$plugin" == *-cross-platform ]]; then
            continue
        fi
        
        # Extract plugin name from path (e.g., tooling/construct-dev -> construct-dev)
        plugin_name=$(basename "$plugin")
        
        # Check where pattern exists and create brief reference
        core_plugin_path="$CONSTRUCT_CORE/patterns/plugins/$plugin/$plugin_name.md"
        lab_plugin_path="$CONSTRUCT_ROOT/CONSTRUCT-LAB/patterns/plugins/$plugin/$plugin_name.md"
        
        if [ -f "$core_plugin_path" ]; then
            echo -e "${YELLOW}  Referencing: $plugin ${BLUE}(CORE)${NC}"
            PATTERN_SUMMARIES+="- **$plugin**: Active (provides language-specific guidance and best practices)
"
        elif [ -f "$lab_plugin_path" ]; then
            echo -e "${YELLOW}  Referencing: $plugin ${GREEN}(LAB)${NC}"
            PATTERN_SUMMARIES+="- **$plugin**: Active (provides experimental patterns and guidance)
"
        fi
    fi
done

CLAUDE_CONTENT+="$PATTERN_SUMMARIES

### 🔄 Context-Aware Pattern Loading
Additional patterns are automatically loaded based on your current work:
- **File Type Detection**: Opening *.py files loads Python patterns, *.sh loads shell scripting patterns
- **Task Detection**: Working on tests loads testing patterns, documentation work loads writing patterns  
- **Dynamic Context**: Patterns adapt to your current focus without cluttering the main context

### 🎯 Pattern Activation Examples
- Edit \`app.py\` → Python patterns activate for Flask best practices
- Create \`test_*.py\` → Testing patterns load with pytest guidance
- Work on \`*.sh\` → Shell scripting patterns provide bash best practices
- Switch to feature branch → Relevant feature development patterns load

### 🔄 Real-Time Context Updates
This file is automatically updated when:
- You add or remove patterns via \`.construct/patterns.yaml\`
- Project structure changes significantly
- CONSTRUCT detects new frameworks or tools

I'm immediately aware of these changes without needing a restart.

### 📚 Full Pattern Details
Complete pattern details are available but not included here to keep focus on your project. Patterns provide guidance on:
- Language-specific best practices and conventions
- Framework-specific patterns and anti-patterns
- Tool-specific workflows and quality standards
- Architecture and design pattern recommendations

*Pattern content is contextually loaded when relevant to your current work.*
"

# Process patterns.yaml for custom rules and includes
if [ -f "$CONFIG_FILE" ] && command -v yq >/dev/null 2>&1; then
    echo -e "${BLUE}🔄 Processing patterns.yaml...${NC}"
    
    # Handle includes first
    INCLUDES=$(yq eval '.includes[]' "$CONFIG_FILE" 2>/dev/null || echo "")
    MERGED_RULES=""
    
    # Merge included files
    while IFS= read -r include; do
        if [ -n "$include" ] && [ -f "$PROJECT_DIR/$include" ]; then
            echo -e "${YELLOW}  Including: $include${NC}"
            INCLUDED_RULES=$(yq eval '.custom_rules' "$PROJECT_DIR/$include" 2>/dev/null || echo "")
            if [ -n "$INCLUDED_RULES" ] && [ "$INCLUDED_RULES" != "null" ]; then
                MERGED_RULES+="$INCLUDED_RULES"
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
CLAUDE_CONTENT+="

<!-- 
Generated: $GENERATION_TIME
Assembly: Project-focused (extracted knowledge prominent, brief pattern references)
Source: CONSTRUCT-CORE/CLAUDE-BASE.md + extracted project patterns
Patterns: $PLUGINS
Note: Full pattern content available contextually, not included for focused experience
-->
"

# Output or save based on mode
if [ "$DRY_RUN" = true ]; then
    echo "dry-run"
else
    # Check if file exists and handle read-only status
    if [ -f "$PROJECT_DIR/CLAUDE.md" ]; then
        if [ ! -w "$PROJECT_DIR/CLAUDE.md" ]; then
            # File exists and is read-only - temporarily make writable
            chmod +w "$PROJECT_DIR/CLAUDE.md"
            echo -e "${BLUE}🔓 Temporarily making CLAUDE.md writable for regeneration${NC}"
        else
            echo -e "${YELLOW}⚠️ Warning: CLAUDE.md was manually made writable${NC}"
        fi
    fi
    
    # Write file
    echo "$CLAUDE_CONTENT" > "$PROJECT_DIR/CLAUDE.md"
    
    # Generate checksum file
    mkdir -p "$PROJECT_DIR/.construct"
    shasum -a 256 "$PROJECT_DIR/CLAUDE.md" > "$PROJECT_DIR/.construct/CLAUDE.md.sha256"
    
    # Make read-only to discourage edits
    chmod 444 "$PROJECT_DIR/CLAUDE.md"
    
    echo -e "${GREEN}✅ Generated CLAUDE.md (read-only) with patterns: $PLUGINS${NC}"
    echo -e "${BLUE}📍 Location: $PROJECT_DIR/CLAUDE.md${NC}"
    echo -e "${YELLOW}🔒 File is read-only. Use 'construct-patterns regenerate' to update.${NC}"
    
    # Verify the file was written correctly
    if [ ! -f "$PROJECT_DIR/CLAUDE.md" ]; then
        echo -e "${RED}❌ Error: Failed to write CLAUDE.md${NC}"
        exit 1
    fi
    
    # Verify read-only status
    if [ -w "$PROJECT_DIR/CLAUDE.md" ]; then
        echo -e "${YELLOW}⚠️ Warning: Failed to set read-only permissions${NC}"
    fi
fi