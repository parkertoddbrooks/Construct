#!/bin/bash

# Template Location Library
# Central functions for locating templates across CONSTRUCT

# Get the directory containing AI template structure
# Returns: Path to AI template directory
get_ai_template_dir() {
    local construct_core="${CONSTRUCT_CORE:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../" && pwd)}"
    echo "$construct_core/TEMPLATES/component-templates/ai-structure"
}

# Get the directory containing project templates
# Returns: Path to project templates directory
get_project_templates_dir() {
    local construct_core="${CONSTRUCT_CORE:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../" && pwd)}"
    echo "$construct_core/TEMPLATES/project-templates"
}

# Get the directory containing component templates
# Returns: Path to component templates directory
get_component_templates_dir() {
    local construct_core="${CONSTRUCT_CORE:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../" && pwd)}"
    echo "$construct_core/TEMPLATES/component-templates"
}

# Get pattern templates directory
# Returns: Path to pattern templates directory
get_pattern_templates_dir() {
    local construct_core="${CONSTRUCT_CORE:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../" && pwd)}"
    echo "$construct_core/patterns/templates"
}

# Check if AI template exists
# Returns: 0 if exists, 1 if not
ai_template_exists() {
    local template_dir=$(get_ai_template_dir)
    [ -d "$template_dir/AI" ]
}

# Get specific project template path
# Parameters:
#   $1 - Template name (e.g., "swift-ios", "python-fastapi")
# Returns: Path to specific project template
get_project_template_path() {
    local template_name="$1"
    local templates_dir=$(get_project_templates_dir)
    echo "$templates_dir/$template_name"
}