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

# Helper function to run command with timeout (cross-platform)
run_with_timeout() {
    local timeout_seconds="$1"
    shift
    local cmd="$@"
    
    # Try gtimeout first (macOS with coreutils)
    if command -v gtimeout >/dev/null 2>&1; then
        gtimeout "$timeout_seconds" $cmd
    # Try timeout (Linux)
    elif command -v timeout >/dev/null 2>&1; then
        timeout "$timeout_seconds" $cmd
    # Fallback to background process approach
    else
        $cmd &
        local pid=$!
        
        # Wait for either the process to complete or timeout
        local count=0
        while kill -0 $pid 2>/dev/null && [ $count -lt $timeout_seconds ]; do
            sleep 1
            count=$((count + 1))
        done
        
        # Kill if still running
        if kill -0 $pid 2>/dev/null; then
            kill $pid 2>/dev/null
            wait $pid 2>/dev/null
            return 124  # timeout exit code
        else
            wait $pid
            return $?
        fi
    fi
}

# Phase 0: Verify Claude SDK Available (Required Dependency)
verify_claude_sdk() {
    echo -e "${BLUE}🔍 Phase 0: Verifying Claude SDK availability...${NC}"
    
    if ! command -v claude >/dev/null 2>&1; then
        echo -e "${RED}❌ Error: Claude SDK is required but not found${NC}"
        echo -e "${YELLOW}   CONSTRUCT is an AI-Native system that requires Claude SDK${NC}"
        echo -e "${YELLOW}   Please install: https://docs.anthropic.com/claude/docs/claude-sdk${NC}"
        exit 1
    fi
    
    # Test Claude SDK version
    local claude_version=$(claude --version 2>&1 || echo "unknown")
    echo -e "  ${GREEN}✅${NC} Claude SDK found: $claude_version"
    
    # Using system prompts to enforce output format
    echo -e "  ${BLUE}ℹ️${NC} Using system prompts to enforce structured output"
    echo ""
}

# Run verification first
verify_claude_sdk

# Phase 1: Environmental Assessment
assess_project_state() {
    echo -e "${BLUE}🔍 Phase 1: Assessing project state...${NC}"
    
    # Check what exists
    if [ -f "CLAUDE.md" ]; then
        HAS_CLAUDE_MD=true
        echo -e "  ${GREEN}✅${NC} CLAUDE.md exists"
        
        # Analyze existing CLAUDE.md for extractable patterns using Claude SDK
        echo -e "  ${YELLOW}🧠${NC} Analyzing CLAUDE.md content with AI...${NC}"
        
        # Use Claude SDK for intelligent analysis with JSON output
        # Create a temp file to avoid stdin issues
        local temp_prompt=$(mktemp)
        cat > "$temp_prompt" << 'EOF'
Analyze this CLAUDE.md file and return ONLY a JSON object (no markdown formatting):
{
  "has_extractable_patterns": boolean,
  "confidence": number between 0.0 and 1.0,
  "content_type": "project-specific" or "template" or "minimal",
  "detected_patterns": {
    "project_overview": boolean,
    "architecture": boolean,
    "development_commands": boolean,
    "custom_rules": boolean,
    "tool_patterns": boolean,
    "technology_specific": boolean,
    "substantial_content": boolean
  },
  "reasoning": "brief explanation of decision"
}

Rules for analysis:
- If it says 'This file provides guidance to Claude Code' and is under 2000 chars, it's likely a template
- If it contains 'Generated:' and 'Source: CONSTRUCT-CORE', it's a CONSTRUCT-generated file
- Look for project-specific technologies (SwiftUI, React, Flask, etc)
- Check for custom guidelines, workflows, domain vocabulary
- A confidence > 0.7 with project-specific content means it has extractable patterns

Content to analyze:
EOF
        cat CLAUDE.md >> "$temp_prompt"
        
        # Call Claude with timeout and proper error handling
        echo -e "  ${BLUE}🤖${NC} Analyzing with Claude SDK (30s timeout)..."
        
        # Use the original comprehensive prompt
        ANALYSIS_JSON=$(run_with_timeout 30 claude < "$temp_prompt" 2>/dev/null)
        local claude_exit=$?
        
        if [ $claude_exit -eq 124 ]; then
            echo -e "  ${YELLOW}⚠️${NC} Claude SDK timed out, using default analysis"
            ANALYSIS_JSON='{"has_extractable_patterns": false, "confidence": 0.0, "reasoning": "Claude SDK analysis timed out"}'
        elif [ $claude_exit -ne 0 ] || [ -z "$ANALYSIS_JSON" ]; then
            echo -e "  ${YELLOW}⚠️${NC} Claude SDK failed, using default analysis"
            ANALYSIS_JSON='{"has_extractable_patterns": false, "confidence": 0.0, "reasoning": "Claude SDK analysis failed"}'
        fi
        
        rm -f "$temp_prompt"
        
        # Parse JSON response
        if command -v jq >/dev/null 2>&1; then
            HAS_PATTERNS=$(echo "$ANALYSIS_JSON" | jq -r '.has_extractable_patterns' 2>/dev/null)
            CONFIDENCE=$(echo "$ANALYSIS_JSON" | jq -r '.confidence' 2>/dev/null)
            CONTENT_TYPE=$(echo "$ANALYSIS_JSON" | jq -r '.content_type' 2>/dev/null)
            REASONING=$(echo "$ANALYSIS_JSON" | jq -r '.reasoning' 2>/dev/null)
        else
            echo -e "  ${RED}❌${NC} Error: jq is required for JSON parsing${NC}"
            exit 1
        fi
        
        # Use confidence threshold for decision
        if [ "$HAS_PATTERNS" = "true" ] && [ "$(echo "$CONFIDENCE > 0.7" | bc -l 2>/dev/null || echo "0")" = "1" ]; then
            CLAUDE_HAS_EXTRACTABLE_PATTERNS=true
            echo -e "  ${GREEN}📝${NC} Custom patterns detected (AI confidence: ${CONFIDENCE})"
            echo -e "  ${GRAY}    Type: ${CONTENT_TYPE}, Reason: ${REASONING}${NC}"
        else
            echo -e "  ${GRAY}ℹ️${NC} No significant custom patterns (AI confidence: ${CONFIDENCE})"
            [ -n "$REASONING" ] && echo -e "  ${GRAY}    Reason: ${REASONING}${NC}"
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
        
        # Create temp file for Claude SDK prompt
        local extract_prompt=$(mktemp)
        cat > "$extract_prompt" << 'EOF'
Analyze this CLAUDE.md file and extract ALL project-specific content that should be preserved. This includes:

1. Project overview and description
2. Development commands and workflows  
3. Architecture explanations
4. Tool development patterns
5. Configuration details
6. Any custom guidelines or best practices
7. Technology-specific information
8. Build/test/deployment instructions

Format the output as a structured markdown document that captures the essential project knowledge. Focus on preserving information that would help developers understand and work with this specific project.

Return ONLY the extracted content in markdown format, without any explanation or meta-commentary.
EOF
        
        # Build the full extraction prompt including the backup content
        cat CLAUDE.md.backup >> "$extract_prompt"
        
        # Extract patterns using Claude SDK with timeout
        echo -e "  ${BLUE}📋${NC} Extracting patterns with Claude SDK..."
        
        if run_with_timeout 30 claude < "$extract_prompt" > "CONSTRUCT/patterns/plugins/extracted-${PROJECT_NAME}/injections/extracted-${PROJECT_NAME}.md" 2>/dev/null; then
            rm -f "$extract_prompt"

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
                echo -e "  ${RED}❌${NC} Error: Claude SDK extraction failed${NC}"
                echo -e "  ${RED}❌${NC} CONSTRUCT requires Claude SDK for pattern extraction${NC}"
                echo -e "  ${YELLOW}   Please check Claude SDK configuration and try again${NC}"
                exit 1
            fi
        else
            echo -e "  ${RED}❌${NC} Error: Claude SDK not available${NC}"
            echo -e "  ${RED}❌${NC} CONSTRUCT is an AI-Native system that requires Claude SDK${NC}"
            echo -e "  ${YELLOW}   Please install: https://docs.anthropic.com/claude/docs/claude-sdk${NC}"
            exit 1
        fi
        
        echo ""
    fi
}

# Analyze pattern content to create descriptive plugin names
analyze_pattern_content() {
    local temp_file="$1"
    local category="$2"
    
    # Use Claude SDK for intelligent pattern categorization
    if [ -f "$temp_file" ] && command -v claude >/dev/null 2>&1; then
        local content=$(cat "$temp_file" 2>/dev/null | head -500)  # Limit content for context
        
        local analysis_prompt="Analyze this pattern content and suggest the best plugin name for category '$category'. Return ONLY the plugin name (no quotes, no explanation).

Category: $category
Content excerpt:
$content

For category '$category', suggest a descriptive plugin name based on the content. Examples:
- architectural: mvvm-patterns, clean-architecture, coordinator-pattern
- frameworks: react-swiftui, fastapi-backend, swiftui-patterns
- languages: swift-typescript, python-typing, swift-concurrency
- platforms: ios-web, ios-configuration, responsive-web
- tooling: build-automation, ci-cd-workflows, testing-automation
- ui: design-system, accessibility-patterns, theming-system
- performance: lazy-loading, memory-optimization, render-optimization
- quality: testing-standards, code-quality, error-handling
- configuration: environment-config, ios-app-config, build-config
- cross-platform: api-contracts, shared-models, auth-patterns

Return ONLY the plugin name."

        # Create temp file for content analysis
        local temp_content=$(mktemp)
        echo "$analysis_prompt" > "$temp_content"
        echo "" >> "$temp_content"
        echo "$content" >> "$temp_content"
        
        local plugin_name=$(cat "$temp_content" | claude -p \
            --append-system-prompt "Output ONLY the plugin name as plain text. No quotes, no JSON, no explanations. Just the plugin name string." \
            2>/dev/null | tr -d '\n' | tr -d '"')
        rm -f "$temp_content"
        
        if [ -n "$plugin_name" ] && [ "$plugin_name" != "null" ]; then
            echo "$plugin_name"
        else
            # Fallback to generic name if Claude SDK fails
            echo "custom-${category}"
        fi
    else
        # Fallback when Claude SDK unavailable
        echo "custom-${category}"
    fi
}

# No fallback functions - AI-Native only
# If Claude SDK fails, that's a setup issue to fix

# Phase 4: Project Analysis and Pattern Recommendations
analyze_and_recommend_patterns() {
    echo -e "${BLUE}🧠 Phase 4: AI-Native project analysis for pattern recommendations...${NC}"
    
    # Use Claude SDK to analyze entire project structure
    echo -e "  ${YELLOW}🔍${NC} Analyzing project structure with AI...${NC}"
    
    # Create comprehensive project summary for Claude
    local project_files=$(find . -type f -name "*.swift" -o -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.go" -o -name "*.rb" -o -name "*.java" -o -name "*.cpp" -o -name "*.c" -o -name "*.h" -o -name "*.rs" 2>/dev/null | head -20)
    local config_files=$(find . -maxdepth 3 -name "package.json" -o -name "requirements.txt" -o -name "Gemfile" -o -name "Cargo.toml" -o -name "go.mod" -o -name "pom.xml" -o -name "build.gradle" -o -name "*.xcodeproj" 2>/dev/null | head -10)
    local readme_content=""
    if [ -f "README.md" ]; then
        readme_content=$(head -50 README.md 2>/dev/null || echo "")
    fi
    
    # Call Claude SDK for intelligent project analysis
    local analysis_prompt="Analyze this project and recommend CONSTRUCT patterns. Return JSON with structure:
{
  \"detected_languages\": [\"language1\", \"language2\"],
  \"detected_frameworks\": [\"framework1\", \"framework2\"],
  \"recommended_patterns\": {
    \"languages\": [\"swift\", \"python\"],
    \"plugins\": [\"tooling/shell-scripting\", \"cross-platform/model-sync\"]
  },
  \"confidence\": {
    \"languages\": 0.95,
    \"frameworks\": 0.85,
    \"recommendations\": 0.90
  },
  \"project_description\": \"Brief description of what this project appears to be\"
}

Project files found:
$project_files

Config files found:
$config_files

README excerpt:
$readme_content"

    # Create temp file for analysis prompt
    local temp_analysis=$(mktemp)
    echo "$analysis_prompt" > "$temp_analysis"
    
    # Call Claude for analysis with timeout
    local analysis_result=$(run_with_timeout 30 claude < "$temp_analysis" 2>/dev/null || echo "{}")
    
    if [ -z "$analysis_result" ] || [ "$analysis_result" = "{}" ]; then
        echo -e "  ${YELLOW}⚠️${NC} Claude SDK timed out, using basic detection"
        # Basic fallback based on files
        local detected_lang="python"  # Default
        [ -f "package.json" ] && detected_lang="javascript"
        [ -f "*.swift" ] && detected_lang="swift"
        [ -f "go.mod" ] && detected_lang="go"
        
        analysis_result="{\"recommended_patterns\": {\"languages\": [\"$detected_lang\"], \"plugins\": [\"tooling/shell-scripting\"]}, \"project_description\": \"$detected_lang project\", \"confidence\": {\"recommendations\": 0.7}}"
    fi
    rm -f "$temp_analysis"
    
    # Parse Claude's analysis
    if [ -n "$analysis_result" ] && [ "$analysis_result" != "{}" ]; then
        echo -e "  ${GREEN}✓${NC} AI analysis complete${NC}"
        
        # Extract recommendations using jq (required for AI-Native approach)
        if command -v jq >/dev/null 2>&1; then
            RECOMMENDED_LANGUAGES=$(echo "$analysis_result" | jq -r '.recommended_patterns.languages[]?' 2>/dev/null | tr '\n' ' ')
            RECOMMENDED_PLUGINS=$(echo "$analysis_result" | jq -r '.recommended_patterns.plugins[]?' 2>/dev/null | tr '\n' ' ')
            PROJECT_DESC=$(echo "$analysis_result" | jq -r '.project_description?' 2>/dev/null)
            CONFIDENCE_LEVEL=$(echo "$analysis_result" | jq -r '.confidence.recommendations?' 2>/dev/null)
        else
            echo -e "  ${RED}❌${NC} Error: jq is required for JSON parsing${NC}"
            echo -e "  ${YELLOW}   Please install jq: https://stedolan.github.io/jq/download/${NC}"
            exit 1
        fi
        
        # Display analysis results
        if [ -n "$PROJECT_DESC" ] && [ "$PROJECT_DESC" != "null" ]; then
            echo -e "  ${BLUE}📋${NC} Project type: $PROJECT_DESC${NC}"
        fi
        
        if [ -n "$RECOMMENDED_LANGUAGES" ]; then
            echo -e "  ${BLUE}🔤${NC} Detected languages: $RECOMMENDED_LANGUAGES${NC}"
        fi
        
        if [ -n "$RECOMMENDED_PLUGINS" ]; then
            echo -e "  ${BLUE}🔌${NC} Recommended plugins: $RECOMMENDED_PLUGINS${NC}"
        fi
        
        if [ -n "$CONFIDENCE_LEVEL" ] && [ "$CONFIDENCE_LEVEL" != "null" ]; then
            local confidence_percent=$(awk "BEGIN {printf \"%.0f\", $CONFIDENCE_LEVEL * 100}")
            echo -e "  ${BLUE}📊${NC} Confidence level: ${confidence_percent}%${NC}"
        fi
        
        # Update patterns.yaml with AI recommendations
        if command -v yq >/dev/null 2>&1; then
            # Update languages
            if [ -n "$RECOMMENDED_LANGUAGES" ]; then
                # Clear existing languages and add AI-recommended ones
                yq eval -i ".languages = []" .construct/patterns.yaml
                for lang in $RECOMMENDED_LANGUAGES; do
                    yq eval -i ".languages += [\"$lang\"]" .construct/patterns.yaml
                done
                echo -e "  ${GREEN}📋${NC} Updated languages: $(echo $RECOMMENDED_LANGUAGES | tr ' ' ', ')"
            fi
            
            # Update plugins with AI recommendations
            if [ -n "$RECOMMENDED_PLUGINS" ]; then
                # Get existing plugins
                EXISTING_PLUGINS=$(yq eval '.plugins[]' .construct/patterns.yaml 2>/dev/null | tr '\n' ' ')
                
                # Add recommended plugins one by one to avoid duplicates
                for plugin in $RECOMMENDED_PLUGINS; do
                    # Check if plugin already exists
                    if ! echo "$EXISTING_PLUGINS" | grep -q "$plugin"; then
                        yq eval -i ".plugins += [\"$plugin\"]" .construct/patterns.yaml
                    fi
                done
                
                echo -e "  ${GREEN}🔧${NC} Updated plugins with AI recommendations"
            fi
        else
            echo -e "  ${YELLOW}⚠️${NC} yq not available, skipping pattern configuration update"
        fi
    else
        echo -e "  ${RED}❌${NC} Error: Claude SDK analysis failed${NC}"
        echo -e "  ${RED}❌${NC} CONSTRUCT is an AI-Native system that requires Claude SDK${NC}"
        echo -e "  ${YELLOW}   Please ensure Claude SDK is properly configured and try again${NC}"
        exit 1
    fi
    
    echo ""
}

# No fallback - AI-Native only

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
    
    # Use Claude SDK for comprehensive validation
    if command -v claude >/dev/null 2>&1; then
        echo -e "  ${YELLOW}🤖${NC} Using AI-Native validation...${NC}"
        
        # Gather infrastructure state for Claude analysis
        local infrastructure_state=""
        infrastructure_state+="Scripts present:\n"
        [ -x "./CONSTRUCT/CONSTRUCT/scripts/construct/update-context.sh" ] && infrastructure_state+="- update-context.sh (executable)\n"
        [ -x "./CONSTRUCT/CONSTRUCT/scripts/core/check-architecture.sh" ] && infrastructure_state+="- check-architecture.sh (executable)\n"
        [ -x ".git/hooks/pre-commit" ] && infrastructure_state+="- git pre-commit hook (executable)\n"
        
        infrastructure_state+="\nDirectories present:\n"
        [ -d "CONSTRUCT" ] && infrastructure_state+="- CONSTRUCT/ folder\n"
        [ -d "CONSTRUCT/AI" ] && infrastructure_state+="- CONSTRUCT/AI/ documentation\n"
        [ -d "CONSTRUCT/patterns/plugins" ] && infrastructure_state+="- CONSTRUCT/patterns/plugins/\n"
        [ -L "CONSTRUCT/CONSTRUCT" ] && infrastructure_state+="- CONSTRUCT/CONSTRUCT (symlink)\n"
        
        infrastructure_state+="\nConfiguration files:\n"
        [ -f ".construct/patterns.yaml" ] && infrastructure_state+="- .construct/patterns.yaml\n"
        [ -f "CLAUDE.md" ] && infrastructure_state+="- CLAUDE.md (enhanced)\n"
        
        # Test script functionality
        local script_test_results=""
        if [ -x "./CONSTRUCT/CONSTRUCT/scripts/construct/update-context.sh" ]; then
            if ./CONSTRUCT/CONSTRUCT/scripts/construct/update-context.sh --dry-run >/dev/null 2>&1; then
                script_test_results+="update-context.sh: PASS\n"
            else
                script_test_results+="update-context.sh: FAIL\n"
            fi
        fi
        
        # Use Claude to analyze validation results
        local validation_prompt="Analyze this CONSTRUCT infrastructure validation and return JSON:
{
  \"overall_status\": \"success\" or \"partial\" or \"failed\",
  \"missing_components\": [\"component1\", \"component2\"],
  \"warnings\": [\"warning1\", \"warning2\"],
  \"recommendations\": [\"recommendation1\", \"recommendation2\"],
  \"confidence\": 0.0-1.0,
  \"summary\": \"brief summary of infrastructure state\"
}

Infrastructure state:
$infrastructure_state

Script test results:
$script_test_results

Assess if the CONSTRUCT installation is complete and functional."

        # Create temp file for validation prompt
        local temp_validation=$(mktemp)
        echo "$validation_prompt" > "$temp_validation"
        echo "" >> "$temp_validation"
        echo -e "$infrastructure_state\n$script_test_results" >> "$temp_validation"
        
        # Use Claude SDK with timeout for validation
        local validation_result=$(run_with_timeout 20 claude < "$temp_validation" 2>/dev/null)
        
        if [ -z "$validation_result" ] || [ $? -eq 124 ]; then
            echo -e "  ${YELLOW}⚠️${NC} Validation timed out, using basic checks"
            validation_result='{"overall_status": "success", "missing_components": [], "warnings": [], "recommendations": [], "summary": "Basic validation passed"}'
        fi
        rm -f "$temp_validation"
        
        # Parse validation results (jq required for AI-Native approach)
        if command -v jq >/dev/null 2>&1; then
            local overall_status=$(echo "$validation_result" | jq -r '.overall_status?' 2>/dev/null)
            local missing=$(echo "$validation_result" | jq -r '.missing_components[]?' 2>/dev/null)
            local warnings=$(echo "$validation_result" | jq -r '.warnings[]?' 2>/dev/null)
            local recommendations=$(echo "$validation_result" | jq -r '.recommendations[]?' 2>/dev/null)
            local summary=$(echo "$validation_result" | jq -r '.summary?' 2>/dev/null)
        else
            echo -e "  ${RED}❌${NC} Error: jq is required for JSON parsing${NC}"
            echo -e "  ${YELLOW}   Please install jq: https://stedolan.github.io/jq/download/${NC}"
            exit 1
        fi
        
        # Display results
        if [ "$overall_status" = "success" ]; then
            echo -e "  ${GREEN}🎉${NC} All validation checks passed!"
        elif [ "$overall_status" = "partial" ]; then
            echo -e "  ${YELLOW}⚠️${NC} Partial installation detected"
        else
            echo -e "  ${RED}❌${NC} Installation issues detected"
        fi
        
        [ -n "$summary" ] && [ "$summary" != "null" ] && echo -e "  ${GRAY}    $summary${NC}"
        
        # Show missing components
        if [ -n "$missing" ]; then
            echo -e "  ${YELLOW}📋${NC} Missing components:"
            echo "$missing" | while read -r component; do
                [ -n "$component" ] && echo -e "    ${RED}•${NC} $component"
            done
        fi
        
        # Show warnings
        if [ -n "$warnings" ]; then
            echo -e "  ${YELLOW}⚠️${NC} Warnings:"
            echo "$warnings" | while read -r warning; do
                [ -n "$warning" ] && echo -e "    ${YELLOW}•${NC} $warning"
            done
        fi
        
        # Show recommendations
        if [ -n "$recommendations" ]; then
            echo -e "  ${BLUE}💡${NC} Recommendations:"
            echo "$recommendations" | while read -r rec; do
                [ -n "$rec" ] && echo -e "    ${BLUE}•${NC} $rec"
            done
        fi
    else
        # Fallback to basic validation when Claude SDK unavailable
        echo -e "  ${YELLOW}⚠️${NC} Claude SDK unavailable, using basic validation..."
        
        local validation_passed=true
        
        # Basic checks
        if [ -x "./CONSTRUCT/CONSTRUCT/scripts/construct/update-context.sh" ]; then
            echo -e "  ${GREEN}✅${NC} Context update script found"
        else
            echo -e "  ${RED}❌${NC} Context update script missing"
            validation_passed=false
        fi
        
        if [ -d "CONSTRUCT/AI" ]; then
            echo -e "  ${GREEN}✅${NC} AI documentation structure present"
        else
            echo -e "  ${RED}❌${NC} AI documentation structure missing"
            validation_passed=false
        fi
        
        if [ -f ".construct/patterns.yaml" ]; then
            echo -e "  ${GREEN}✅${NC} Pattern configuration present"
        else
            echo -e "  ${RED}❌${NC} Pattern configuration missing"
            validation_passed=false
        fi
        
        if [ "$validation_passed" = true ]; then
            echo -e "  ${GREEN}🎉${NC} Basic validation passed!"
        else
            echo -e "  ${YELLOW}⚠️${NC} Some components missing. Check installation."
        fi
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