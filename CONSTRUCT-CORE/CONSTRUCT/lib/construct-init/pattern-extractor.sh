#!/bin/bash
# Pattern extraction module for CONSTRUCT init

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Extract patterns with concurrent processing
extract_patterns_concurrent() {
    local project_name="$1"
    local claude_content="$2"
    local output_dir="$3"
    local max_concurrent="${4:-3}"  # Process 3 categories at a time
    
    # Categories to extract
    local categories=(
        "architectural"
        "frameworks"
        "languages"
        "platforms"
        "tooling"
        "ui"
        "performance"
        "quality"
        "configuration"
        "cross-platform"
    )
    
    # Allow override via environment
    if [ -n "$CONSTRUCT_CATEGORIES" ]; then
        IFS=',' read -ra categories <<< "$CONSTRUCT_CATEGORIES"
    fi
    
    log_info "Starting concurrent pattern extraction for ${#categories[@]} categories"
    
    # Create output directories
    for category in "${categories[@]}"; do
        mkdir -p "$output_dir/${project_name}-${category}/injections"
    done
    
    # Process categories in batches
    local pids=()
    local completed=0
    local total=${#categories[@]}
    
    for i in "${!categories[@]}"; do
        local category="${categories[$i]}"
        
        # Wait if we've reached max concurrent
        while [ ${#pids[@]} -ge $max_concurrent ]; do
            # Check for completed processes
            local new_pids=()
            for pid in "${pids[@]}"; do
                if kill -0 "$pid" 2>/dev/null; then
                    new_pids+=("$pid")
                else
                    completed=$((completed + 1))
                fi
            done
            pids=("${new_pids[@]}")
            
            [ ${#pids[@]} -ge $max_concurrent ] && sleep 1
        done
        
        # Launch extraction in background
        (
            extract_single_category "$project_name" "$category" "$claude_content" "$output_dir"
        ) &
        
        local pid=$!
        pids+=("$pid")
        
        show_progress $((i + 1)) "$total" "Launched extraction for $category"
    done
    
    # Wait for all remaining processes
    log_info "Waiting for all extractions to complete..."
    for pid in "${pids[@]}"; do
        wait "$pid"
        completed=$((completed + 1))
        show_progress "$completed" "$total" "Extractions completed"
    done
    
    log_success "All pattern extractions completed"
}

# Extract patterns for a single category
extract_single_category() {
    local project_name="$1"
    local category="$2"
    local content="$3"
    local output_dir="$4"
    
    local start_time=$(date +%s)
    log_debug "Starting extraction for $category"
    
    # Create prompt file
    local prompt_file=$(mktemp)
    add_temp_file "$prompt_file"
    
    cat > "$prompt_file" << EOF
Analyze the project content and extract patterns related to ${category}.

Return ONLY a JSON object with this structure:
{
  "category": "${category}",
  "patterns": "# ${category^} Patterns\n\nExtracted patterns in markdown format...",
  "has_content": true,
  "status": "success",
  "error": ""
}

If no ${category} patterns are found:
- Set has_content to false
- Set patterns to "# No ${category} patterns found"

Category definitions:
- architectural: Design patterns, MVVM, Clean Architecture, coordinators, app structure
- frameworks: Framework-specific patterns (SwiftUI, React, Flask, etc.)
- languages: Language-specific conventions, modern features, idioms
- platforms: Platform requirements (iOS, web, Android), platform-specific features
- tooling: Build scripts, CI/CD, testing, development workflows, automation
- ui: Design tokens, visual quality, accessibility, component patterns
- performance: Optimization, rendering, memory management, lazy loading
- quality: Professional standards, quality gates, testing, error handling
- configuration: Platform settings, Info.plist, build config, environment setup
- cross-platform: Shared models, API contracts, sync patterns, multi-platform

Content to analyze:
${content}
EOF
    
    # Extract with retry logic
    local output_file=$(mktemp)
    add_temp_file "$output_file"
    
    if call_claude_with_cache 30 "$prompt_file" "$output_file" "json" "${project_name}-${category}"; then
        # Parse JSON response
        if command -v jq >/dev/null 2>&1; then
            local result_json=$(jq -r '.result' "$output_file" 2>/dev/null | sed 's/```json//' | sed 's/```//')
            
            if [ -n "$result_json" ]; then
                local has_content=$(echo "$result_json" | jq -r '.has_content' 2>/dev/null)
                local patterns=$(echo "$result_json" | jq -r '.patterns' 2>/dev/null)
                
                if [ -n "$patterns" ]; then
                    echo "$patterns" > "$output_dir/${project_name}-${category}/injections/${project_name}-${category}.md"
                    
                    # Create metadata only if content found
                    if [ "$has_content" = "true" ]; then
                        create_pattern_metadata "$project_name" "$category" "$output_dir"
                        log_success "Extracted $category patterns"
                    else
                        log_info "No $category patterns found"
                    fi
                else
                    log_warning "Failed to parse patterns for $category"
                    echo "# No ${category} patterns found" > "$output_dir/${project_name}-${category}/injections/${project_name}-${category}.md"
                fi
            else
                log_warning "Failed to extract JSON from Claude response for $category"
                echo "# No ${category} patterns found" > "$output_dir/${project_name}-${category}/injections/${project_name}-${category}.md"
            fi
        else
            # Fallback without jq
            log_warning "jq not available, saving raw output for $category"
            cp "$output_file" "$output_dir/${project_name}-${category}/injections/${project_name}-${category}.md"
        fi
    else
        log_error "Failed to extract $category patterns after retries"
        echo "# No ${category} patterns found" > "$output_dir/${project_name}-${category}/injections/${project_name}-${category}.md"
    fi
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    log_debug "$category extraction completed in ${duration}s"
    
    # Rate limiting delay
    sleep 2
}

# Create pattern metadata
create_pattern_metadata() {
    local project_name="$1"
    local category="$2"
    local output_dir="$3"
    
    # Capitalize first letter
    local category_cap="$(echo "${category:0:1}" | tr '[:lower:]' '[:upper:]')${category:1}"
    
    cat > "$output_dir/${project_name}-${category}/pattern.yaml" << EOF
id: ${project_name}-${category}
name: ${project_name} ${category_cap} Patterns
description: ${category_cap} patterns extracted from ${project_name}
version: 1.0.0
category: ${category}
injections:
  - ${project_name}-${category}.md
EOF
}

# Export functions
export -f extract_patterns_concurrent extract_single_category create_pattern_metadata