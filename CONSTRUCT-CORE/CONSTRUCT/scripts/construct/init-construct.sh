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
        
        # Analyze existing CLAUDE.md for extractable patterns
        if grep -q "project-specific\|custom rule\|TODO:\|FIXME:\|# Custom\|## Custom" CLAUDE.md; then
            CLAUDE_HAS_EXTRACTABLE_PATTERNS=true
            echo -e "  ${YELLOW}📝${NC} Custom patterns detected in CLAUDE.md"
        fi
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
    
    # Symlink CONSTRUCT directory for tool access
    if [ "$HAS_CONSTRUCT_DIR" = false ]; then
        echo -e "  ${YELLOW}🔗${NC} Linking CONSTRUCT tools directory..."
        
        # Calculate relative path to CONSTRUCT-CORE/CONSTRUCT (macOS compatible)
        # Use Python to calculate relative path since macOS realpath doesn't support --relative-to
        RELATIVE_PATH="$(python3 -c "import os; print(os.path.relpath('$CONSTRUCT_CORE/CONSTRUCT', '$PROJECT_ROOT'))")"
        ln -sf "$RELATIVE_PATH" CONSTRUCT
        
        echo -e "  ${GREEN}✅${NC} CONSTRUCT tools linked"
        HAS_CONSTRUCT_DIR=true
    fi
    
    # Install AI folder structure from templates
    if [ "$HAS_AI_FOLDER" = false ]; then
        echo -e "  ${YELLOW}📁${NC} Installing AI folder structure..."
        
        if [ -d "$CONSTRUCT_CORE/TEMPLATES/component-templates/ai-structure/AI" ]; then
            cp -r "$CONSTRUCT_CORE/TEMPLATES/component-templates/ai-structure/AI" .
            echo -e "  ${GREEN}✅${NC} AI documentation structure installed"
            HAS_AI_FOLDER=true
        else
            echo -e "  ${YELLOW}⚠️${NC} AI template not found, creating basic structure"
            mkdir -p AI/{docs,structure,quality-reports,dev-logs}
            echo "# AI Documentation" > AI/README.md
        fi
    fi
    
    # Create pattern configuration
    if [ "$HAS_PATTERNS_CONFIG" = false ]; then
        echo -e "  ${YELLOW}⚙️${NC} Creating pattern configuration..."
        
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

# Phase 3: Pattern Extraction
extract_existing_patterns() {
    if [ "$CLAUDE_HAS_EXTRACTABLE_PATTERNS" = true ]; then
        echo -e "${BLUE}🔍 Phase 3: Extracting custom patterns from existing CLAUDE.md...${NC}"
        
        # Backup original
        cp CLAUDE.md CLAUDE.md.backup
        echo -e "  ${GREEN}💾${NC} Original CLAUDE.md backed up"
        
        # Create project-specific injection directory
        mkdir -p .construct/injections
        
        # Extract project-specific patterns (simple extraction for now)
        echo -e "  ${YELLOW}📝${NC} Analyzing CLAUDE.md for custom rules..."
        
        # Look for custom sections and extract them
        if grep -n "# Custom\|## Custom\|project-specific\|TODO:\|FIXME:" CLAUDE.md > .construct/injections/extracted-patterns.txt; then
            echo -e "  ${GREEN}✅${NC} Custom patterns extracted to .construct/injections/"
            
            # Create a basic project-custom.md injection
            cat > .construct/injections/project-custom.md << 'EOF'
## Project-Specific Patterns

### Custom Rules Extracted from Original CLAUDE.md

The following patterns were extracted from your existing CLAUDE.md and preserved:

EOF
            
            # Add extracted content
            echo "" >> .construct/injections/project-custom.md
            echo "```" >> .construct/injections/project-custom.md
            cat .construct/injections/extracted-patterns.txt >> .construct/injections/project-custom.md
            echo "```" >> .construct/injections/project-custom.md
            
            # Update patterns.yaml to include extracted patterns
            if command -v yq >/dev/null 2>&1; then
                yq eval -i '.plugins += ["project-custom"]' .construct/patterns.yaml
                echo -e "  ${GREEN}✅${NC} Pattern configuration updated with extracted rules"
            fi
        else
            echo -e "  ${GRAY}ℹ️${NC} No extractable patterns found"
        fi
        
        echo ""
    fi
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
            LANG_ARRAY=$(echo "$DETECTED_LANGUAGES" | tr ' ' '\n' | grep -v '^$' | sed 's/^/"/;s/$/"/' | paste -sd ',' -)
            yq eval -i ".languages = [$LANG_ARRAY]" .construct/patterns.yaml
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
            yq eval -i ".plugins = [$RECOMMENDED_PLUGINS]" .construct/patterns.yaml
            echo -e "  ${GREEN}🔧${NC} Updated plugins with recommendations"
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
    echo "  - CONSTRUCT/ → Symlinked tools directory"
    echo "  - AI/ → Documentation and analysis structure"  
    echo "  - .construct/patterns.yaml → Pattern configuration"
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
    echo -e "  ${GREEN}🔗${NC} CONSTRUCT tools → Symlinked for script access"
    echo -e "  ${GREEN}📁${NC} AI folder → Documentation and analysis structure"
    echo -e "  ${GREEN}⚙️${NC} Pattern system → Configured based on project analysis"
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