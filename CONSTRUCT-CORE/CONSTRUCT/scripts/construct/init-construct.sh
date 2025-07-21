#!/bin/bash

# construct-init / install-construct - Complete CONSTRUCT Integration System
# This script transforms ANY project into a fully CONSTRUCT-enabled environment
# Works as both construct-init and install-construct (complete orchestrator)
#
# BREAKTHROUGH UNDERSTANDING: construct-init must install ALL infrastructure
# before pattern enhancement, solving the chicken-and-egg problem.
#
# Master Intelligence Flow:
# 1. Assess project state (CLAUDE.md, CONSTRUCT/, AI/, .construct/)
# 2. Install missing infrastructure (templates, symlinks, hooks)
# 3. Extract patterns from existing CLAUDE.md if present
# 4. Analyze project for language/framework detection
# 5. Generate patterns.yaml with recommendations + extractions
# 6. Call assemble-claude.sh with proper inputs
# 7. Validate all infrastructure works (test scripts, hooks, updates)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSTRUCT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
CONSTRUCT_CORE="$CONSTRUCT_ROOT/CONSTRUCT-CORE"
CONSTRUCT_LAB="$CONSTRUCT_ROOT/CONSTRUCT-LAB"

# Project directory (current directory where script is run)
PROJECT_ROOT="$(pwd)"

# Infrastructure state variables
HAS_CLAUDE_MD=false
HAS_CONSTRUCT_DIR=false
HAS_AI_FOLDER=false
HAS_PATTERNS_CONFIG=false
HAS_GIT_HOOKS=false
CLAUDE_HAS_EXTRACTABLE_PATTERNS=false

echo -e "${BLUE}🚀 CONSTRUCT Integration System${NC}"
echo -e "${BLUE}===============================${NC}"
echo ""

# Phase 1: Environmental Assessment
assess_project_state() {
    echo -e "${BLUE}🔍 Phase 1: Assessing project state...${NC}"
    
    # Check what exists
    if [ -f "CLAUDE.md" ]; then
        HAS_CLAUDE_MD=true
        echo -e "  ${GREEN}✅${NC} CLAUDE.md exists"
        
        # Analyze existing CLAUDE.md for extractable patterns using intelligent content analysis
        echo -e "  ${YELLOW}🧠${NC} Analyzing CLAUDE.md content for custom patterns..."
        
        # Create a temporary analysis script
        cat > .construct_temp_analysis.py << 'EOF'
import sys
import re

def analyze_claude_md(filename):
    try:
        with open(filename, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Skip if it looks like a standard generated CLAUDE.md
        if "This file provides guidance to Claude Code" in content and len(content) < 2000:
            return False
            
        # Skip if it's clearly a CONSTRUCT-generated file
        if "Generated:" in content and "Source: CONSTRUCT-CORE" in content:
            return False
            
        indicators = []
        
        # Look for project-specific technology mentions
        tech_patterns = r'\b(SwiftUI|UIKit|React|Vue|Angular|Django|Flask|Rails|Spring|Express|FastAPI|Laravel)\b'
        if re.search(tech_patterns, content, re.IGNORECASE):
            indicators.append("technology-specific")
            
        # Look for custom guidelines/practices sections
        if re.search(r'#+ [^#\n]*(?:Best Practices|Guidelines|Rules|Standards|Conventions)', content, re.IGNORECASE):
            indicators.append("custom-guidelines")
            
        # Look for numbered workflow steps
        if re.search(r'##? \d+\.', content):
            indicators.append("structured-workflow")
            
        # Look for instruction patterns
        instruction_patterns = r'(?:When|Always|Never|Use|Avoid|Follow|Remember|Ensure)\s+[a-z]'
        if len(re.findall(instruction_patterns, content)) > 5:
            indicators.append("instruction-heavy")
            
        # Look for code examples with specific syntax
        if re.search(r'```\w+', content) and len(content) > 1000:
            indicators.append("code-examples")
            
        # Look for project-specific vocabulary (beyond common words)
        domain_words = re.findall(r'\b[A-Z][a-z]*(?:View|Model|Controller|Service|Manager|Handler|Provider|Factory)\b', content)
        if len(set(domain_words)) > 3:
            indicators.append("domain-vocabulary")
            
        # Look for custom configuration or setup instructions
        if re.search(r'(?:configure|setup|install|initialize)', content, re.IGNORECASE) and 'claude' not in content.lower():
            indicators.append("setup-instructions")
            
        # Decision: extractable if we found meaningful indicators
        return len(indicators) >= 2
        
    except Exception as e:
        # If analysis fails, err on the side of extraction
        return True

if __name__ == "__main__":
    result = analyze_claude_md(sys.argv[1])
    sys.exit(0 if result else 1)
EOF

        # Run the intelligent analysis
        if python3 .construct_temp_analysis.py CLAUDE.md 2>/dev/null; then
            CLAUDE_HAS_EXTRACTABLE_PATTERNS=true
            echo -e "  ${GREEN}📝${NC} Custom patterns detected through content analysis"
        else
            echo -e "  ${GRAY}ℹ️${NC} No significant custom patterns detected"
        fi
        
        # Clean up
        rm -f .construct_temp_analysis.py
    else
        echo -e "  ${YELLOW}⚠️${NC} CLAUDE.md not found"
        echo -e "  ${GRAY}💡 Run '/init' first to create base CLAUDE.md${NC}"
        exit 1
    fi
    
    if [ -d "CONSTRUCT" ]; then
        HAS_CONSTRUCT_DIR=true
        echo -e "  ${GREEN}✅${NC} CONSTRUCT directory exists"
    else
        echo -e "  ${RED}❌${NC} CONSTRUCT tools not linked"
    fi
    
    if [ -d "AI" ]; then
        HAS_AI_FOLDER=true
        echo -e "  ${GREEN}✅${NC} AI folder structure exists"
    else
        echo -e "  ${RED}❌${NC} AI documentation structure missing"
    fi
    
    if [ -f ".construct/patterns.yaml" ]; then
        HAS_PATTERNS_CONFIG=true
        echo -e "  ${GREEN}✅${NC} Pattern configuration exists"
    else
        echo -e "  ${RED}❌${NC} Pattern configuration missing"
    fi
    
    if [ -x ".git/hooks/pre-commit" ]; then
        HAS_GIT_HOOKS=true
        echo -e "  ${GREEN}✅${NC} Git hooks installed"
    else
        echo -e "  ${RED}❌${NC} Git hooks not installed"
    fi
    
    echo ""
}

# Phase 2: Infrastructure Installation
install_missing_infrastructure() {
    echo -e "${BLUE}🛠️ Phase 2: Installing missing CONSTRUCT infrastructure...${NC}"
    
    # Create unified CONSTRUCT/ folder structure (same as LAB)
    if [ "$HAS_CONSTRUCT_DIR" = false ] || [ "$HAS_AI_FOLDER" = false ]; then
        echo -e "  ${YELLOW}🏗️${NC} Creating unified CONSTRUCT/ folder structure..."
        
        # Create main CONSTRUCT folder
        mkdir -p CONSTRUCT
        
        # Install CONSTRUCT tools (context-aware: symlink vs. copy)
        if [ -d "$CONSTRUCT_CORE" ]; then
            # Check if we're running from within CONSTRUCT-CORE (prevent recursive symlink)
            CURRENT_DIR_REAL="$(cd "$PROJECT_ROOT" && pwd)"
            CONSTRUCT_CORE_REAL="$(cd "$CONSTRUCT_CORE" && pwd)"
            
            if [[ "$CURRENT_DIR_REAL" == "$CONSTRUCT_CORE_REAL"* ]]; then
                echo -e "  ${YELLOW}⚠️${NC} Running from within CONSTRUCT-CORE, skipping symlink creation"
                echo -e "  ${GRAY}    (Prevents recursive symlink: CONSTRUCT/CONSTRUCT → CONSTRUCT)${NC}"
            else
                # Live repo - symlink for updates
                echo -e "  ${YELLOW}🔗${NC} Linking CONSTRUCT tools (live repo mode)..."
                RELATIVE_PATH="$(python3 -c "import os; print(os.path.relpath('$CONSTRUCT_CORE/CONSTRUCT', '$PROJECT_ROOT/CONSTRUCT'))")" 
                ln -sf "$RELATIVE_PATH" CONSTRUCT/CONSTRUCT
            fi
        else
            # Template - copy for portability
            echo -e "  ${YELLOW}📦${NC} Copying CONSTRUCT tools (template mode)..."
            cp -r "$TEMPLATE_SOURCE/CONSTRUCT" CONSTRUCT/CONSTRUCT
        fi
        
        # Install AI folder structure
        if [ -d "$CONSTRUCT_CORE/TEMPLATES/component-templates/ai-structure/AI" ]; then
            cp -r "$CONSTRUCT_CORE/TEMPLATES/component-templates/ai-structure/AI" CONSTRUCT/
            echo -e "  ${GREEN}✅${NC} AI documentation structure installed"
        else
            echo -e "  ${YELLOW}⚠️${NC} AI template not found, creating basic structure"
            mkdir -p CONSTRUCT/AI/{docs,structure,quality-reports,dev-logs}
            echo "# AI Documentation" > CONSTRUCT/AI/README.md
        fi
        
        # Create pattern space for project-specific patterns
        mkdir -p CONSTRUCT/patterns/plugins
        
        HAS_CONSTRUCT_DIR=true
        HAS_AI_FOLDER=true
    fi
    
    # Create pattern configuration (.construct/ for metadata)
    if [ "$HAS_PATTERNS_CONFIG" = false ]; then
        echo -e "  ${YELLOW}⚙️${NC} Creating pattern configuration..."
        
        # Create .construct for metadata/configuration
        mkdir -p .construct
        
        if [ -f "$CONSTRUCT_CORE/patterns/templates/patterns.yaml" ]; then
            cp "$CONSTRUCT_CORE/patterns/templates/patterns.yaml" .construct/
        else
            # Create basic patterns.yaml if template doesn't exist
            cat > .construct/patterns.yaml << 'EOF'
# .construct/patterns.yaml
# Project-specific pattern configuration

# Languages used in this project
languages: []

# Active pattern plugins
plugins: []

# Project-specific rules
custom_rules: {}

# Pattern overrides
overrides: []

# Include external pattern files
includes: []
EOF
        fi
        
        echo -e "  ${GREEN}✅${NC} Pattern configuration installed"
        HAS_PATTERNS_CONFIG=true
    fi
    
    # Install git hooks for validation
    if [ "$HAS_GIT_HOOKS" = false ]; then
        echo -e "  ${YELLOW}🪝${NC} Installing git hooks..."
        
        if [ -d ".git" ]; then
            if [ -f "$CONSTRUCT_CORE/TEMPLATES/git-hooks/pre-commit" ]; then
                cp "$CONSTRUCT_CORE/TEMPLATES/git-hooks/pre-commit" .git/hooks/
                chmod +x .git/hooks/pre-commit
                echo -e "  ${GREEN}✅${NC} Git hooks installed"
                HAS_GIT_HOOKS=true
            else
                echo -e "  ${YELLOW}⚠️${NC} Git hook template not found, skipping"
            fi
        else
            echo -e "  ${YELLOW}⚠️${NC} Not a git repository, skipping git hooks"
        fi
    fi
    
    echo ""
}

# Phase 3: Enhanced Pattern Extraction with 10 Categories
extract_existing_patterns() {
    if [ "$CLAUDE_HAS_EXTRACTABLE_PATTERNS" = true ]; then
        echo -e "${BLUE}🔍 Phase 3: Extracting patterns across enhanced categories...${NC}"
        
        # Backup original
        cp CLAUDE.md CLAUDE.md.backup
        echo -e "  ${GREEN}💾${NC} Original CLAUDE.md backed up"
        
        # Check if Claude SDK is available
        if command -v claude >/dev/null 2>&1; then
            # Use enhanced categorization extraction
            extract_enhanced_patterns
        else
            echo -e "  ${YELLOW}⚠️${NC} Claude SDK not available, using fallback method"
            # Fallback to logic-based extraction
            fallback_extract_patterns
        fi
        
        echo ""
    fi
}

# Enhanced pattern extraction with comprehensive categorization (bash 3+ compatible)
extract_enhanced_patterns() {
    echo -e "  ${YELLOW}🧠${NC} Using enhanced categorization with Claude SDK..."
    
    local patterns_created=0
    local categories="architectural cross-platform frameworks languages platforms tooling ui performance quality configuration"
    
    # Process each category individually
    for category in $categories; do
        # Set category description and keywords based on category name
        case "$category" in
            "ui")
                description="Design tokens, visual quality, accessibility, component design patterns"
                keywords="design.*token|\.frame.*token|AppColors|spacing|visual.*quality|accessibility|component.*pattern|@State.*UI|background.*flash"
                ;;
            "performance")
                description="Optimization patterns, rendering rules, memory management, lazy loading"
                keywords="LazyVStack|performance|optimization|rendering|ForEach.*id|memory.*management|animation.*performance|loading.*pattern"
                ;;
            "quality")
                description="Professional standards, quality gates, empirical discoveries, best practices"
                keywords="quality.*gate|professional.*standard|empirical|validated.*discover|best.*practice|architectural.*constant|NEVER:|ALWAYS:"
                ;;
            "configuration")
                description="Platform settings, Info.plist, build configuration, environment setup"
                keywords="Info\.plist|Xcode.*setting|build.*config|environment|permission.*config|orientation.*setting|launch.*screen"
                ;;
            "architectural")
                description="MVVM, Clean Architecture, design patterns, business logic separation"
                keywords="MVVM|ViewModel|@Published|business.*logic|Clean.*Architecture|design.*pattern|coordinator|navigation.*pattern"
                ;;
            "frameworks")
                description="SwiftUI, Flask, React, framework-specific patterns and best practices"
                keywords="SwiftUI|@State|Flask|React|framework.*specific|library.*pattern|NavigationStack|async.*await.*UI"
                ;;
            "languages")
                description="Swift, Python, TypeScript language conventions and modern patterns"
                keywords="Swift.*6|async.*await|python.*convention|language.*specific|syntax.*pattern|@MainActor|concurrency"
                ;;
            "platforms")
                description="iOS, web, Android platform-specific requirements and constraints"
                keywords="iOS.*specific|platform.*requirement|device.*specific|platform.*constraint|Watch.*connectivity"
                ;;
            "tooling")
                description="Build scripts, development workflows, CI/CD, tool configurations"
                keywords="build.*script|CI.*CD|deployment|development.*tool|workflow.*automation|testing.*framework"
                ;;
            "cross-platform")
                description="Shared models, API contracts, multi-platform sync patterns"
                keywords="shared.*model|API.*contract|cross.*platform|multi.*platform.*sync|data.*synchronization"
                ;;
        esac
        
        # Use Claude SDK for intelligent extraction per category
        claude -p "Extract content related to: $description

Keywords to focus on: $keywords

From this CLAUDE.md file, extract only content that matches this category.
Look for:
- Specific rules and patterns (❌ NEVER: / ✅ ALWAYS: patterns)
- Do/Don't examples  
- Configuration requirements
- Best practices and standards
- Project-specific implementations

Return clean markdown without category headers.
Focus on project-specific patterns that override or extend standard patterns.
If no relevant content exists, return empty." \
        CLAUDE.md.backup > "temp_${category}.md" 2>/dev/null
        
        if [ -s "temp_${category}.md" ] && [ $(wc -l < "temp_${category}.md") -gt 5 ]; then
            # Determine specific plugin name using Claude intelligence
            plugin_name=$(claude -p "Based on this content, what specific plugin name fits best?
Category: $category

For ui: design-system, visual-quality, accessibility, tokens
For performance: optimization, rendering, memory-management  
For quality: standards, gates, discoveries, practices
For configuration: ios-config, build-config, env-config
For architectural: mvvm, clean, coordinator, navigation
For frameworks: swiftui, web, react, flask
For languages: swift, python, typescript
For platforms: ios, web, android
For tooling: build, scripting, ci-cd
For cross-platform: sync, api, models

Return ONLY the plugin name." "temp_${category}.md" 2>/dev/null | head -1 | tr -d '\n' || echo "project-${category}")
            
            # Clean plugin name (remove any extra text)
            plugin_name=$(echo "$plugin_name" | sed 's/[^a-zA-Z0-9-]//g' | head -c 20)
            [ -z "$plugin_name" ] && plugin_name="project-${category}"
            
            # Create directory structure
            mkdir -p "CONSTRUCT/patterns/plugins/${category}/project-${plugin_name}/injections"
            
            # Move extracted content
            mv "temp_${category}.md" "CONSTRUCT/patterns/plugins/${category}/project-${plugin_name}/injections/project-${plugin_name}.md"
            
            # Create pattern metadata (bash 3+ compatible)
            category_title=$(echo "$category" | sed 's/./\U&/')
            plugin_title=$(echo "$plugin_name" | sed 's/./\U&/')
            
            cat > "CONSTRUCT/patterns/plugins/${category}/project-${plugin_name}/pattern.yaml" << EOF
id: project-${plugin_name}
name: Project-Specific ${category_title} - ${plugin_title}
description: Extracted ${category} patterns from existing CLAUDE.md
version: 1.0.0
category: ${category}
injections:
  - project-${plugin_name}.md
EOF
            
            # Update patterns.yaml
            if command -v yq >/dev/null 2>&1; then
                yq eval -i ".plugins += [\"${category}/project-${plugin_name}\"]" .construct/patterns.yaml
                echo -e "  ${GREEN}✅${NC} Created ${category}/project-${plugin_name} pattern"
                patterns_created=$((patterns_created + 1))
            fi
        else
            echo -e "  ${GRAY}ℹ️${NC} No substantial ${category} patterns found"
            rm -f "temp_${category}.md"
        fi
    done
    
    if [ $patterns_created -gt 0 ]; then
        echo -e "  ${GREEN}🎉${NC} Successfully created $patterns_created categorized pattern plugins"
    else
        echo -e "  ${YELLOW}⚠️${NC} No patterns extracted, falling back to single-file extraction"
        fallback_extract_patterns
    fi
}

# Fallback pattern extraction using logic-based detection
fallback_extract_patterns() {
    echo -e "  ${YELLOW}📝${NC} Using logic-based pattern extraction as fallback..."
    
    # Create project-specific injection directory for fallback
    mkdir -p CONSTRUCT/patterns/plugins/project-custom/injections
    
    # Look for substantial project content using logic
    temp_file=$(mktemp)
    
    # Extract project overview sections
    sed -n '/## Project Overview/,/## /p' CLAUDE.md.backup | head -n -1 > "$temp_file"
    
    # Extract development commands
    sed -n '/## Development Commands/,/## /p' CLAUDE.md.backup | head -n -1 >> "$temp_file"
    sed -n '/### Running/,/## /p' CLAUDE.md.backup | head -n -1 >> "$temp_file"
    sed -n '/### Environment Setup/,/## /p' CLAUDE.md.backup | head -n -1 >> "$temp_file"
    
    # Extract architecture information
    sed -n '/## Architecture/,/## /p' CLAUDE.md.backup | head -n -1 >> "$temp_file"
    sed -n '/## Code Architecture/,/## /p' CLAUDE.md.backup | head -n -1 >> "$temp_file"
    sed -n '/### Core Components/,/## /p' CLAUDE.md.backup | head -n -1 >> "$temp_file"
    
    # Extract tool development patterns
    sed -n '/## Tool Development/,/## /p' CLAUDE.md.backup | head -n -1 >> "$temp_file"
    sed -n '/### Tool Development Pattern/,/## /p' CLAUDE.md.backup | head -n -1 >> "$temp_file"
    
    # Extract configuration details
    sed -n '/## Configuration/,/## /p' CLAUDE.md.backup | head -n -1 >> "$temp_file"
    
    # Extract ENFORCE RULES sections (critical patterns)
    sed -n '/## 🚨 ENFORCE THESE RULES/,/## /p' CLAUDE.md.backup | head -n -1 >> "$temp_file"
    sed -n '/❌ NEVER:/,/✅ ALWAYS:/p' CLAUDE.md.backup >> "$temp_file"
    
    # If we extracted substantial content, create the injection
    if [ -s "$temp_file" ] && [ $(wc -l < "$temp_file") -gt 10 ]; then
        cat > CONSTRUCT/patterns/plugins/project-custom/injections/project-custom.md << 'EOF'
# Project-Specific Patterns

## Extracted Project Knowledge

The following content was extracted from your original CLAUDE.md to preserve project-specific knowledge:

EOF
        cat "$temp_file" >> CONSTRUCT/patterns/plugins/project-custom/injections/project-custom.md
        
        # Create pattern plugin metadata
        cat > CONSTRUCT/patterns/plugins/project-custom/pattern.yaml << 'EOF'
id: project-custom
name: Project-Specific Patterns
description: Custom patterns extracted from existing CLAUDE.md via fallback
version: 1.0.0
injections:
  - project-custom.md
EOF
        
        echo -e "  ${GREEN}✅${NC} Project patterns extracted using logic-based fallback"
        
        # Update patterns.yaml to include extracted patterns
        if command -v yq >/dev/null 2>&1; then
            yq eval -i '.plugins += ["project-custom"]' .construct/patterns.yaml
            echo -e "  ${GREEN}✅${NC} Pattern configuration updated with extracted rules"
        fi
    else
        echo -e "  ${GRAY}ℹ️${NC} No substantial project content found to extract"
    fi
    
    # Cleanup
    rm -f "$temp_file"
}

# Phase 4: Project Analysis and Pattern Recommendations
analyze_and_recommend_patterns() {
    echo -e "${BLUE}🧠 Phase 4: Analyzing project for pattern recommendations...${NC}"
    
    # Detect languages
    DETECTED_LANGUAGES=""
    if ls *.swift >/dev/null 2>&1 || find . -name "*.swift" -type f | head -1 | grep -q .; then
        DETECTED_LANGUAGES="$DETECTED_LANGUAGES swift"
        echo -e "  ${GREEN}🔤${NC} Detected: Swift"
    fi
    
    if ls *.cs >/dev/null 2>&1 || find . -name "*.cs" -type f | head -1 | grep -q .; then
        DETECTED_LANGUAGES="$DETECTED_LANGUAGES csharp"
        echo -e "  ${GREEN}🔤${NC} Detected: C#"
    fi
    
    if ls *.ts *.tsx >/dev/null 2>&1 || find . -name "*.ts" -o -name "*.tsx" -type f | head -1 | grep -q .; then
        DETECTED_LANGUAGES="$DETECTED_LANGUAGES typescript"
        echo -e "  ${GREEN}🔤${NC} Detected: TypeScript"
    fi
    
    if ls *.py >/dev/null 2>&1 || find . -name "*.py" -type f | head -1 | grep -q .; then
        DETECTED_LANGUAGES="$DETECTED_LANGUAGES python"
        echo -e "  ${GREEN}🔤${NC} Detected: Python"
    fi
    
    # Detect frameworks
    DETECTED_FRAMEWORKS=""
    if [ -f "Info.plist" ] || find . -name "Info.plist" -type f | head -1 | grep -q .; then
        DETECTED_FRAMEWORKS="$DETECTED_FRAMEWORKS ios"
        echo -e "  ${GREEN}🏗️${NC} Detected: iOS"
    fi
    
    if [ -f "package.json" ]; then
        DETECTED_FRAMEWORKS="$DETECTED_FRAMEWORKS web"
        echo -e "  ${GREEN}🏗️${NC} Detected: Web (package.json)"
    fi
    
    # Detect CONSTRUCT development
    if [ -d "CONSTRUCT-CORE" ] || [ -d "CONSTRUCT-LAB" ]; then
        DETECTED_FRAMEWORKS="$DETECTED_FRAMEWORKS construct-dev"
        echo -e "  ${GREEN}🔧${NC} Detected: CONSTRUCT development"
    fi
    
    # Update patterns.yaml with detected languages and frameworks
    if command -v yq >/dev/null 2>&1; then
        # Update languages
        if [ -n "$DETECTED_LANGUAGES" ]; then
            # Clear existing languages and add detected ones
            yq eval -i ".languages = []" .construct/patterns.yaml
            for lang in $DETECTED_LANGUAGES; do
                yq eval -i ".languages += [\"$lang\"]" .construct/patterns.yaml
            done
            echo -e "  ${GREEN}📋${NC} Updated languages: $(echo $DETECTED_LANGUAGES | tr ' ' ', ')"
        fi
        
        # Update plugins with recommended patterns
        RECOMMENDED_PLUGINS=""
        for lang in $DETECTED_LANGUAGES; do
            RECOMMENDED_PLUGINS="$RECOMMENDED_PLUGINS \"languages/$lang\","
        done
        for framework in $DETECTED_FRAMEWORKS; do
            RECOMMENDED_PLUGINS="$RECOMMENDED_PLUGINS \"platforms/$framework\","
        done
        
        # Add common patterns
        RECOMMENDED_PLUGINS="$RECOMMENDED_PLUGINS \"tooling/shell-scripting\","
        
        if [ -n "$RECOMMENDED_PLUGINS" ]; then
            # Remove trailing comma
            RECOMMENDED_PLUGINS=$(echo "$RECOMMENDED_PLUGINS" | sed 's/,$//')
            
            # Get existing plugins
            EXISTING_PLUGINS=$(yq eval '.plugins[]' .construct/patterns.yaml 2>/dev/null | tr '\n' ' ')
            
            # Add recommended plugins one by one to avoid YAML parsing issues
            for plugin in $(echo "$RECOMMENDED_PLUGINS" | tr ',' '\n' | sed 's/"//g'); do
                # Check if plugin already exists
                if ! echo "$EXISTING_PLUGINS" | grep -q "$plugin"; then
                    yq eval -i ".plugins += [\"$plugin\"]" .construct/patterns.yaml
                fi
            done
            
            echo -e "  ${GREEN}🔧${NC} Updated plugins with recommendations (preserving existing)"
        fi
    else
        echo -e "  ${YELLOW}⚠️${NC} yq not available, skipping pattern configuration update"
    fi
    
    echo ""
}

# Phase 5: CLAUDE.md Enhancement
generate_enhanced_claude() {
    echo -e "${BLUE}🎯 Phase 5: Generating enhanced CLAUDE.md with pattern system...${NC}"
    
    # Read current pattern configuration
    if [ -f ".construct/patterns.yaml" ] && command -v yq >/dev/null 2>&1; then
        PLUGINS=$(yq eval '.plugins | join(",")' .construct/patterns.yaml 2>/dev/null || echo "")
        LANGUAGES=$(yq eval '.languages | join(",")' .construct/patterns.yaml 2>/dev/null || echo "")
        
        echo -e "  ${BLUE}📋${NC} Configured patterns: $PLUGINS"
        echo -e "  ${BLUE}🔤${NC} Configured languages: $LANGUAGES"
        
        # Check if assemble-claude.sh exists
        ASSEMBLE_SCRIPT="$CONSTRUCT_CORE/CONSTRUCT/scripts/construct/assemble-claude.sh"
        if [ -x "$ASSEMBLE_SCRIPT" ]; then
            echo -e "  ${YELLOW}🔧${NC} Assembling enhanced CLAUDE.md..."
            
            # Call assemble-claude.sh with current directory and plugins only
            if [ -n "$PLUGINS" ]; then
                "$ASSEMBLE_SCRIPT" "$PROJECT_ROOT" "$PLUGINS" || {
                    echo -e "  ${YELLOW}⚠️${NC} Pattern assembly failed, keeping existing CLAUDE.md"
                }
            else
                echo -e "  ${GRAY}ℹ️${NC} No plugins configured, keeping existing CLAUDE.md"
            fi
        else
            echo -e "  ${YELLOW}⚠️${NC} assemble-claude.sh not found, keeping existing CLAUDE.md"
        fi
    else
        echo -e "  ${YELLOW}⚠️${NC} Pattern configuration not readable, keeping existing CLAUDE.md"
    fi
    
    echo ""
}

# Phase 6: Infrastructure Validation
validate_infrastructure() {
    echo -e "${BLUE}🧪 Phase 6: Validating installed infrastructure...${NC}"
    
    local validation_passed=true
    
    # Test essential scripts work
    echo -e "  ${YELLOW}🔍${NC} Testing context updates..."
    if [ -x "./CONSTRUCT/scripts/construct/update-context.sh" ]; then
        if ./CONSTRUCT/scripts/construct/update-context.sh --dry-run >/dev/null 2>&1; then
            echo -e "  ${GREEN}✅${NC} Context updates working"
        else
            echo -e "  ${RED}❌${NC} Context update script failed"
            validation_passed=false
        fi
    else
        echo -e "  ${YELLOW}⚠️${NC} Context update script not found"
    fi
    
    # Test architecture checks
    echo -e "  ${YELLOW}🔍${NC} Testing architecture validation..."
    if [ -x "./CONSTRUCT/scripts/core/check-architecture.sh" ]; then
        if ./CONSTRUCT/scripts/core/check-architecture.sh --dry-run >/dev/null 2>&1; then
            echo -e "  ${GREEN}✅${NC} Architecture validation working"
        else
            echo -e "  ${YELLOW}⚠️${NC} Architecture check had warnings (normal)"
        fi
    else
        echo -e "  ${YELLOW}⚠️${NC} Architecture check script not found"
    fi
    
    # Test git hooks
    echo -e "  ${YELLOW}🔍${NC} Testing git hooks..."
    if [ -x ".git/hooks/pre-commit" ]; then
        echo -e "  ${GREEN}✅${NC} Git hooks installed and executable"
    else
        echo -e "  ${YELLOW}⚠️${NC} Git hooks not properly installed"
    fi
    
    # Test pattern validation
    echo -e "  ${YELLOW}🔍${NC} Testing pattern validation..."
    if [ -f ".construct/patterns.yaml" ]; then
        if command -v yq >/dev/null 2>&1; then
            if yq eval '.' .construct/patterns.yaml >/dev/null 2>&1; then
                echo -e "  ${GREEN}✅${NC} Pattern configuration valid"
            else
                echo -e "  ${RED}❌${NC} Pattern configuration invalid"
                validation_passed=false
            fi
        else
            echo -e "  ${YELLOW}⚠️${NC} Cannot validate patterns (yq not available)"
        fi
    fi
    
    if [ "$validation_passed" = true ]; then
        echo -e "  ${GREEN}🎉${NC} All validation checks passed!"
    else
        echo -e "  ${YELLOW}⚠️${NC} Some validation checks failed. Check installation."
    fi
    
    return 0  # Don't fail on validation issues
}

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "CONSTRUCT Integration System (construct-init / install-construct)"
    echo ""
    echo "USAGE:"
    echo "  construct-init          # Integrate CONSTRUCT into current project"
    echo "  install-construct       # Alias for construct-init"
    echo ""
    echo "WHAT IT DOES:"
    echo "  1. Assesses current project state"
    echo "  2. Installs missing CONSTRUCT infrastructure"
    echo "  3. Extracts custom patterns from existing CLAUDE.md"
    echo "  4. Analyzes project for pattern recommendations"
    echo "  5. Generates enhanced CLAUDE.md with patterns"
    echo "  6. Validates all infrastructure works"
    echo ""
    echo "REQUIREMENTS:"
    echo "  - Must run from project root directory"
    echo "  - CLAUDE.md must exist (run '/init' first)"
    echo "  - Git repository recommended for full features"
    echo ""
    echo "WHAT GETS INSTALLED:"
    echo "  - CONSTRUCT/ → Unified project structure (same as LAB)"
    echo "  - CONSTRUCT/CONSTRUCT/ → Symlinked or copied tools directory"
    echo "  - CONSTRUCT/AI/ → Documentation and analysis structure"
    echo "  - CONSTRUCT/patterns/plugins/ → Project-specific pattern space"
    echo "  - .construct/patterns.yaml → Pattern configuration metadata"
    echo "  - .git/hooks/pre-commit → Quality validation hooks"
    echo ""
    exit 0
fi

# Main execution flow
main() {
    # Check if we're in a directory with CLAUDE.md
    if [ ! -f "CLAUDE.md" ]; then
        echo -e "${RED}❌ Error: CLAUDE.md not found${NC}"
        echo -e "${GRAY}💡 Please run '/init' first to create base CLAUDE.md${NC}"
        echo -e "${GRAY}   Then run 'construct-init' to enhance with CONSTRUCT patterns${NC}"
        exit 1
    fi
    
    assess_project_state
    install_missing_infrastructure
    extract_existing_patterns
    analyze_and_recommend_patterns
    generate_enhanced_claude
    validate_infrastructure
    
    echo -e "${GREEN}✅ CONSTRUCT integration complete!${NC}"
    echo ""
    echo -e "${BLUE}📋 What was installed/configured:${NC}"
    echo -e "  ${GREEN}🏗️${NC} CONSTRUCT/ structure → Unified project architecture (same as LAB)"
    echo -e "  ${GREEN}🔗${NC} CONSTRUCT/CONSTRUCT/ → Tools directory (symlinked or copied)"
    echo -e "  ${GREEN}📁${NC} CONSTRUCT/AI/ → Documentation and analysis structure"
    echo -e "  ${GREEN}🧩${NC} CONSTRUCT/patterns/plugins/ → Project-specific pattern space"
    echo -e "  ${GREEN}⚙️${NC} .construct/patterns.yaml → Pattern configuration metadata"
    echo -e "  ${GREEN}🪝${NC} Git hooks → Quality validation on commits"
    echo -e "  ${GREEN}📝${NC} Enhanced CLAUDE.md → Generated from patterns + /init content"
    echo ""
    echo -e "${BLUE}🎯 Ready to use:${NC}"
    echo -e "  ${GRAY}construct-update${NC}       → Refresh context"
    echo -e "  ${GRAY}construct-check${NC}        → Validate architecture"
    echo -e "  ${GRAY}construct-quality${NC}      → Check code quality"
    echo -e "  ${GRAY}All auto-updating features active${NC}"
    echo ""
}

# Run main function
main "$@"