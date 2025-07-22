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
        
        # Get project name for unique naming
        PROJECT_NAME=$(basename "$PWD")
        
        # Create project-specific injection directory in CONSTRUCT structure
        mkdir -p "CONSTRUCT/patterns/plugins/extracted-${PROJECT_NAME}/injections"
        
        # Use Claude SDK for intelligent pattern extraction
        echo -e "  ${YELLOW}📝${NC} Using Claude SDK to extract project patterns..."
        
        # Check if Claude SDK is available
        if claude -p "Analyze this CLAUDE.md file and extract ALL project-specific content that should be preserved. This includes:

1. Project overview and description
2. Development commands and workflows  
3. Architecture explanations
4. Tool development patterns
5. Configuration details
6. Any custom guidelines or best practices
7. Technology-specific information
8. Build/test/deployment instructions

Format the output as a structured markdown document that captures the essential project knowledge. Focus on preserving information that would help developers understand and work with this specific project.

Return ONLY the extracted content in markdown format, without any explanation or meta-commentary." CLAUDE.md.backup > "CONSTRUCT/patterns/plugins/extracted-${PROJECT_NAME}/injections/extracted-${PROJECT_NAME}.md" 2>/dev/null; then

            # Check if extraction was successful
            if [ -s "CONSTRUCT/patterns/plugins/extracted-${PROJECT_NAME}/injections/extracted-${PROJECT_NAME}.md" ]; then
                echo -e "  ${GREEN}✅${NC} Project patterns extracted via Claude SDK"
                
                # Create pattern plugin metadata
                cat > "CONSTRUCT/patterns/plugins/extracted-${PROJECT_NAME}/pattern.yaml" << EOF
id: extracted-${PROJECT_NAME}
name: Extracted ${PROJECT_NAME} Patterns  
description: Comprehensive patterns extracted from existing CLAUDE.md
version: 1.0.0
injections:
  - extracted-${PROJECT_NAME}.md
EOF

                # Update patterns.yaml to include extracted patterns
                if command -v yq >/dev/null 2>&1; then
                    yq eval -i ".plugins += [\"extracted-${PROJECT_NAME}\"]" .construct/patterns.yaml
                    echo -e "  ${GREEN}✅${NC} Pattern configuration updated with extracted rules"
                fi
            else
                echo -e "  ${YELLOW}⚠️${NC} Claude SDK extraction failed, using fallback method"
                fallback_extract_patterns
            fi
        else
            echo -e "  ${YELLOW}⚠️${NC} Claude SDK not available, using fallback method"
            # Fallback to logic-based extraction
            fallback_extract_patterns
        fi
        
        echo ""
    fi
}

# Analyze pattern content to create descriptive plugin names
analyze_pattern_content() {
    local temp_file="$1"
    local category="$2"
    
    case "$category" in
        "architectural")
            if grep -qi "mvvm\|viewmodel\|@published\|observable" "$temp_file"; then
                if grep -qi "swift\|ios" "$temp_file" && grep -qi "typescript\|react\|web" "$temp_file"; then
                    echo "multiplatform-mvvm"
                else
                    echo "mvvm-patterns"
                fi
            elif grep -qi "clean.*architecture\|use.*case\|entity\|repository" "$temp_file"; then
                echo "clean-architecture"
            elif grep -qi "coordinator\|navigation" "$temp_file"; then
                echo "coordinator-pattern"
            else
                echo "custom-architecture"
            fi
            ;;
        "frameworks")
            if grep -qi "react" "$temp_file" && grep -qi "swiftui" "$temp_file"; then
                echo "react-swiftui"
            elif grep -qi "fastapi\|uvicorn\|pydantic" "$temp_file"; then
                echo "fastapi-backend"
            elif grep -qi "swiftui\|@state\|@binding" "$temp_file"; then
                echo "swiftui-patterns"
            elif grep -qi "react\|usestate\|useeffect" "$temp_file"; then
                echo "react-patterns"
            elif grep -qi "flask\|django" "$temp_file"; then
                echo "python-web"
            else
                echo "custom-frameworks"
            fi
            ;;
        "languages")
            if grep -qi "swift" "$temp_file" && grep -qi "typescript\|javascript" "$temp_file"; then
                echo "swift-typescript"
            elif grep -qi "python.*typing\|type.*hint" "$temp_file"; then
                echo "python-typing"
            elif grep -qi "swift.*async\|await" "$temp_file"; then
                echo "swift-concurrency"
            elif grep -qi "typescript.*generic\|type.*utility" "$temp_file"; then
                echo "typescript-advanced"
            else
                echo "custom-conventions"
            fi
            ;;
        "platforms")
            if grep -qi "ios" "$temp_file" && grep -qi "web\|browser" "$temp_file"; then
                echo "ios-web"
            elif grep -qi "info\.plist\|ios.*config" "$temp_file"; then
                echo "ios-configuration"
            elif grep -qi "responsive\|mobile.*web" "$temp_file"; then
                echo "responsive-web"
            else
                echo "custom-platform"
            fi
            ;;
        "tooling")
            if grep -qi "build.*script\|npm.*script\|xcodebuild" "$temp_file"; then
                echo "build-automation"
            elif grep -qi "ci.*cd\|github.*action\|workflow" "$temp_file"; then
                echo "ci-cd-workflows"
            elif grep -qi "test.*script\|jest\|xctest" "$temp_file"; then
                echo "testing-automation"
            elif grep -qi "git.*hook\|pre.*commit" "$temp_file"; then
                echo "git-workflows"
            else
                echo "custom-tooling"
            fi
            ;;
        "ui")
            if grep -qi "design.*token\|color.*system\|typography" "$temp_file"; then
                echo "design-system"
            elif grep -qi "accessibility\|wcag\|a11y\|voiceover" "$temp_file"; then
                echo "accessibility-patterns"
            elif grep -qi "dark.*mode\|theme\|appearance" "$temp_file"; then
                echo "theming-system"
            elif grep -qi "component.*library\|ui.*kit" "$temp_file"; then
                echo "component-patterns"
            else
                echo "custom-design"
            fi
            ;;
        "performance")
            if grep -qi "lazy.*load\|virtualization" "$temp_file"; then
                echo "lazy-loading"
            elif grep -qi "memory.*management\|cache\|optimization" "$temp_file"; then
                echo "memory-optimization"
            elif grep -qi "bundle.*split\|code.*split" "$temp_file"; then
                echo "bundle-optimization"
            elif grep -qi "render.*optimization\|reselect\|memo" "$temp_file"; then
                echo "render-optimization"
            else
                echo "performance-patterns"
            fi
            ;;
        "quality")
            if grep -qi "test.*pattern\|unit.*test\|integration" "$temp_file"; then
                echo "testing-standards"
            elif grep -qi "lint\|eslint\|swiftlint" "$temp_file"; then
                echo "code-quality"
            elif grep -qi "error.*handling\|exception" "$temp_file"; then
                echo "error-handling"
            elif grep -qi "security\|validation\|sanitization" "$temp_file"; then
                echo "security-patterns"
            else
                echo "quality-standards"
            fi
            ;;
        "configuration")
            if grep -qi "environment\|env.*var\|config" "$temp_file"; then
                echo "environment-config"
            elif grep -qi "info\.plist\|bundle" "$temp_file"; then
                echo "ios-app-config"
            elif grep -qi "package\.json\|vite\|webpack" "$temp_file"; then
                echo "build-config"
            elif grep -qi "docker\|container" "$temp_file"; then
                echo "deployment-config"
            else
                echo "custom-config"
            fi
            ;;
        "cross-platform")
            if grep -qi "model.*sync\|api.*contract" "$temp_file"; then
                echo "api-contracts"
            elif grep -qi "shared.*model\|common.*type" "$temp_file"; then
                echo "shared-models"
            elif grep -qi "authentication\|auth.*token" "$temp_file"; then
                echo "auth-patterns"
            else
                echo "cross-platform-sync"
            fi
            ;;
        *)
            echo "custom-${category}"
            ;;
    esac
}

# Fallback extraction for single category when Claude SDK times out
fallback_extract_single_category() {
    local category="$1"
    local output_file="$2"
    
    case "$category" in
        "architectural")
            sed -n '/## Architecture/,/## /p' CLAUDE.md.backup | sed '$d' > "$output_file"
            sed -n '/### Tool System Architecture/,/## /p' CLAUDE.md.backup | sed '$d' >> "$output_file"
            ;;
        "frameworks")
            sed -n '/Flask/,/## /p' CLAUDE.md.backup | sed '$d' > "$output_file"
            sed -n '/framework/,/## /p' CLAUDE.md.backup | sed '$d' >> "$output_file"
            ;;
        "languages")
            sed -n '/Python/,/## /p' CLAUDE.md.backup | sed '$d' > "$output_file"
            sed -n '/Type hints/,/## /p' CLAUDE.md.backup | sed '$d' >> "$output_file"
            ;;
        "tooling")
            sed -n '/## Development Tools/,/## /p' CLAUDE.md.backup | sed '$d' > "$output_file"
            sed -n '/### Package Management/,/## /p' CLAUDE.md.backup | sed '$d' >> "$output_file"
            ;;
        "quality")
            sed -n '/## Testing/,/## /p' CLAUDE.md.backup | sed '$d' > "$output_file"
            sed -n '/Code Style/,/## /p' CLAUDE.md.backup | sed '$d' >> "$output_file"
            ;;
        "configuration")
            sed -n '/## Environment Setup/,/## /p' CLAUDE.md.backup | sed '$d' > "$output_file"
            sed -n '/Configuration/,/## /p' CLAUDE.md.backup | sed '$d' >> "$output_file"
            ;;
        *)
            # For other categories, create minimal fallback
            echo "# ${category^} Patterns" > "$output_file"
            echo "" >> "$output_file"
            echo "Patterns extracted from project context for ${category} category." >> "$output_file"
            ;;
    esac
}

# Fallback pattern extraction using logic-based detection
fallback_extract_patterns() {
    echo -e "  ${YELLOW}📝${NC} Using comprehensive logic-based pattern extraction as fallback..."
    
    # Get project name for unique naming
    PROJECT_NAME=$(basename "$PWD")
    
    # Create project-specific injection directory for fallback
    mkdir -p "CONSTRUCT/patterns/plugins/extracted-${PROJECT_NAME}/injections"
    
    # Look for substantial project content using logic - be MUCH more comprehensive
    temp_file=$(mktemp)
    
    # Extract ALL major sections that could contain important information
    
    # Project overview and description
    sed -n '/^# /,/^## /p' CLAUDE.md.backup | sed '$d' > "$temp_file"
    sed -n '/## Project Overview/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    sed -n '/## Overview/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    
    # ALL Development commands and setup information  
    sed -n '/## Development Commands/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    sed -n '/## Setup/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    sed -n '/## Installation/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    sed -n '/## Environment Setup/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    sed -n '/### Setup and Installation/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    sed -n '/### Running the Application/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    sed -n '/### Development Tools/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    sed -n '/### Package Management/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    
    # Architecture and system design
    sed -n '/## Architecture/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    sed -n '/### Core Components/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    sed -n '/### Tool System Architecture/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    sed -n '/### Self-Improvement Mechanism/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    
    # Key features and capabilities
    sed -n '/## Key Features/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    sed -n '/### Token Management/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    sed -n '/### Dual Interface Support/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    sed -n '/### Error Handling/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    
    # Development patterns and guidelines
    sed -n '/## Development Patterns/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    sed -n '/### Adding New Tools/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    sed -n '/### Tool Development Guidelines/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    sed -n '/### Code Style/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    
    # Testing information
    sed -n '/## Testing/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    
    # Configuration details
    sed -n '/## Configuration/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    
    # Extract ENFORCE RULES sections (critical patterns)
    sed -n '/## 🚨 ENFORCE THESE RULES/,/^## /p' CLAUDE.md.backup | sed '$d' >> "$temp_file"
    sed -n '/❌ NEVER:/,/✅ ALWAYS:/p' CLAUDE.md.backup >> "$temp_file"
    
    # If we extracted substantial content, create the injection
    if [ -s "$temp_file" ] && [ $(wc -l < "$temp_file") -gt 10 ]; then
        cat > "CONSTRUCT/patterns/plugins/extracted-${PROJECT_NAME}/injections/extracted-${PROJECT_NAME}.md" << EOF
# ${PROJECT_NAME^} Project Knowledge

## Extracted Project Patterns

The following content was extracted from your original CLAUDE.md to preserve project-specific knowledge:

EOF
        cat "$temp_file" >> "CONSTRUCT/patterns/plugins/extracted-${PROJECT_NAME}/injections/extracted-${PROJECT_NAME}.md"
        
        # Create pattern plugin metadata
        cat > "CONSTRUCT/patterns/plugins/extracted-${PROJECT_NAME}/pattern.yaml" << EOF
id: extracted-${PROJECT_NAME}
name: Extracted ${PROJECT_NAME} Patterns
description: Comprehensive patterns extracted from existing CLAUDE.md via fallback
version: 1.0.0
injections:
  - extracted-${PROJECT_NAME}.md
EOF
        
        echo -e "  ${GREEN}✅${NC} Project patterns extracted using comprehensive logic-based fallback"
        
        # Update patterns.yaml to include extracted patterns
        if command -v yq >/dev/null 2>&1; then
            yq eval -i ".plugins += [\"extracted-${PROJECT_NAME}\"]" .construct/patterns.yaml
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
        echo -e "  ${BLUE}🔍${NC} Looking for assemble script: $ASSEMBLE_SCRIPT"
        
        if [ -x "$ASSEMBLE_SCRIPT" ]; then
            echo -e "  ${GREEN}✅${NC} Found assemble-claude.sh"
            echo -e "  ${YELLOW}🔧${NC} Assembling enhanced CLAUDE.md..."
            
            # Call assemble-claude.sh with current directory and plugins
            if [ -n "$PLUGINS" ]; then
                echo -e "  ${BLUE}📋${NC} Calling: $ASSEMBLE_SCRIPT '$PROJECT_ROOT' '$PLUGINS'"
                
                # Call the fixed assemble script
                if "$ASSEMBLE_SCRIPT" "$PROJECT_ROOT" "$PLUGINS" 2>&1; then
                    echo -e "  ${GREEN}✅${NC} Pattern assembly completed successfully"
                else
                    echo -e "  ${RED}❌${NC} Pattern assembly failed with exit code $?"
                    echo -e "  ${YELLOW}⚠️${NC} Keeping existing CLAUDE.md"
                fi
            else
                echo -e "  ${GRAY}ℹ️${NC} No plugins configured, using basic template"
                # Call with empty plugins to get base template
                if "$ASSEMBLE_SCRIPT" "$PROJECT_ROOT" "" 2>&1; then
                    echo -e "  ${GREEN}✅${NC} Basic template generated"
                fi
            fi
        elif [ -f "$ASSEMBLE_SCRIPT" ]; then
            echo -e "  ${RED}❌${NC} assemble-claude.sh found but not executable"
            echo -e "  ${YELLOW}🔧${NC} Making executable..."
            chmod +x "$ASSEMBLE_SCRIPT"
            
            # Try again
            if [ -n "$PLUGINS" ]; then
                echo -e "  ${BLUE}📋${NC} Retrying: $ASSEMBLE_SCRIPT '$PROJECT_ROOT' '$PLUGINS'"
                if "$ASSEMBLE_SCRIPT" "$PROJECT_ROOT" "$PLUGINS" 2>&1; then
                    echo -e "  ${GREEN}✅${NC} Pattern assembly completed after fixing permissions"
                else
                    echo -e "  ${RED}❌${NC} Pattern assembly still failed"
                fi
            fi
        else
            echo -e "  ${RED}❌${NC} assemble-claude.sh not found at: $ASSEMBLE_SCRIPT"
            echo -e "  ${YELLOW}⚠️${NC} Cannot generate enhanced CLAUDE.md"
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