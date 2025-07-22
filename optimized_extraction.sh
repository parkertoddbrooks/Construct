#!/bin/bash

# Optimized enhanced pattern extraction with batch processing
extract_enhanced_patterns_optimized() {
    echo -e "  ${YELLOW}🧠${NC} Using optimized batch extraction with Claude SDK..."
    
    local patterns_created=0
    
    # Batch 1: First 5 categories
    echo -e "  ${BLUE}📦${NC} Processing batch 1/2 (architectural, cross-platform, frameworks, languages, platforms)..."
    
    timeout 300 claude -p "Extract patterns from this CLAUDE.md file for multiple categories simultaneously.

For each category below, extract relevant content and provide it in this JSON format:
{
  \"architectural\": \"extracted content or empty if none\",
  \"cross-platform\": \"extracted content or empty if none\", 
  \"frameworks\": \"extracted content or empty if none\",
  \"languages\": \"extracted content or empty if none\",
  \"platforms\": \"extracted content or empty if none\"
}

Category definitions:
- architectural: MVVM, Clean Architecture, design patterns, business logic separation, ViewModel, @Published, coordinator patterns
- cross-platform: Shared models, API contracts, multi-platform sync patterns, data synchronization
- frameworks: SwiftUI, Flask, React, framework-specific patterns, @State, NavigationStack, async/await UI
- languages: Swift 6, async/await, Python conventions, TypeScript, language-specific syntax patterns, @MainActor
- platforms: iOS-specific, platform requirements, device-specific, platform constraints, Watch connectivity

Extract only substantial content (10+ lines). Focus on:
- Specific rules and patterns (❌ NEVER: / ✅ ALWAYS: patterns)
- Do/Don't examples  
- Configuration requirements
- Best practices and standards
- Project-specific implementations

Return clean JSON with extracted content or empty string if no relevant content." \
    --output-format json CLAUDE.md.backup > batch1_result.json 2>/dev/null || {
        echo -e "  ${RED}❌${NC} Batch 1 failed, falling back to rule-based extraction"
        fallback_extract_patterns
        return
    }
    
    # Batch 2: Last 5 categories  
    echo -e "  ${BLUE}📦${NC} Processing batch 2/2 (tooling, ui, performance, quality, configuration)..."
    
    timeout 300 claude -p "Extract patterns from this CLAUDE.md file for multiple categories simultaneously.

For each category below, extract relevant content and provide it in this JSON format:
{
  \"tooling\": \"extracted content or empty if none\",
  \"ui\": \"extracted content or empty if none\",
  \"performance\": \"extracted content or empty if none\", 
  \"quality\": \"extracted content or empty if none\",
  \"configuration\": \"extracted content or empty if none\"
}

Category definitions:
- tooling: Build scripts, development workflows, CI/CD, deployment, testing frameworks, automation
- ui: Design tokens, visual quality, accessibility, component design, spacing, colors, typography
- performance: Optimization patterns, rendering rules, memory management, lazy loading, LazyVStack, ForEach
- quality: Professional standards, quality gates, empirical discoveries, best practices, NEVER:/ALWAYS: rules
- configuration: Platform settings, Info.plist, build config, environment setup, permissions, orientation

Extract only substantial content (10+ lines). Focus on:
- Specific rules and patterns (❌ NEVER: / ✅ ALWAYS: patterns)
- Do/Don't examples  
- Configuration requirements
- Best practices and standards
- Project-specific implementations

Return clean JSON with extracted content or empty string if no relevant content." \
    --output-format json CLAUDE.md.backup > batch2_result.json 2>/dev/null || {
        echo -e "  ${RED}❌${NC} Batch 2 failed, falling back to rule-based extraction"
        fallback_extract_patterns
        return
    }
    
    # Process results from both batches
    echo -e "  ${BLUE}🔍${NC} Processing extraction results..."
    
    for batch_file in batch1_result.json batch2_result.json; do
        if [ -f "$batch_file" ] && [ -s "$batch_file" ]; then
            # Parse JSON and create patterns
            categories=$(jq -r 'keys[]' "$batch_file" 2>/dev/null || echo "")
            
            for category in $categories; do
                content=$(jq -r ".\"$category\"" "$batch_file" 2>/dev/null || echo "")
                
                if [ -n "$content" ] && [ "$content" != "null" ] && [ "$content" != "" ] && [ "${#content}" -gt 50 ]; then
                    echo "$content" > "temp_${category}.md"
                    
                    # Use rule-based plugin naming instead of additional Claude call
                    plugin_name="project-$(echo "$category" | head -c 10)"
                    
                    # Create directory structure
                    mkdir -p "CONSTRUCT/patterns/plugins/${category}/${plugin_name}/injections"
                    
                    # Move extracted content
                    mv "temp_${category}.md" "CONSTRUCT/patterns/plugins/${category}/${plugin_name}/injections/${plugin_name}.md"
                    
                    # Create pattern metadata
                    category_title=$(echo "$category" | sed 's/./\U&/')
                    plugin_title=$(echo "$plugin_name" | sed 's/./\U&/')
                    
                    cat > "CONSTRUCT/patterns/plugins/${category}/${plugin_name}/pattern.yaml" << EOF
id: ${plugin_name}
name: Project-Specific ${category_title}
description: Extracted ${category} patterns from existing CLAUDE.md
version: 1.0.0
category: ${category}
injections:
  - ${plugin_name}.md
EOF
                    
                    # Update patterns.yaml
                    if command -v yq >/dev/null 2>&1; then
                        yq eval -i ".plugins += [\"${category}/${plugin_name}\"]" .construct/patterns.yaml
                        echo -e "  ${GREEN}✅${NC} Created ${category}/${plugin_name} pattern"
                        patterns_created=$((patterns_created + 1))
                    fi
                else
                    echo -e "  ${GRAY}ℹ️${NC} No substantial ${category} patterns found"
                fi
            done
        fi
    done
    
    # Cleanup
    rm -f batch1_result.json batch2_result.json
    
    if [ $patterns_created -gt 0 ]; then
        echo -e "  ${GREEN}🎉${NC} Successfully created $patterns_created categorized pattern plugins using optimized batch processing"
    else
        echo -e "  ${YELLOW}⚠️${NC} No patterns extracted from batches, falling back to rule-based extraction"
        fallback_extract_patterns
    fi
}