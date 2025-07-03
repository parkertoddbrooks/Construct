#!/bin/bash

# Common Script Patterns Library for CONSTRUCT
# Reusable patterns to reduce code duplication across scripts

set -e

# Get the directory of the calling script
# Usage: SCRIPT_DIR=$(get_script_dir)
get_script_dir() {
    cd "$(dirname "${BASH_SOURCE[1]}")" && pwd
}

# Get CONSTRUCT root directory from any script location
# Usage: CONSTRUCT_ROOT=$(get_construct_root)
get_construct_root() {
    local script_dir=$(get_script_dir)
    cd "$script_dir/../../.." && pwd
}

# Get CONSTRUCT-LAB directory
# Usage: CONSTRUCT_DEV=$(get_construct_dev) 
get_construct_dev() {
    echo "$(get_construct_root)/CONSTRUCT-LAB"
}

# Standard script directory resolution pattern (legacy - use individual functions above)
get_script_paths() {
    local script_dir=$(get_script_dir)
    local construct_root=$(get_construct_root)
    local construct_dev=$(get_construct_dev)
    
    echo "$script_dir|$construct_root|$construct_dev"
}

# Common file finding pattern for shell scripts
find_shell_scripts() {
    local search_dir="$1"
    find "$search_dir" -name "*.sh" -type f | grep -v "build/" | grep -v ".git/" | sort
}

# Common grep pattern with error handling
safe_grep_count() {
    local pattern="$1"
    local file="$2"
    
    grep -c "$pattern" "$file" 2>/dev/null || echo "0"
}

# Common pattern: find shell scripts in directory
find_shell_scripts_in() {
    local search_dir="$1"
    find "$search_dir" -name "*.sh" -type f 2>/dev/null | sort
}

# Common pattern: count shell scripts
count_shell_scripts() {
    local search_dir="$1"
    find_shell_scripts_in "$search_dir" | wc -l | tr -d ' '
}

# Common pattern: find yaml files  
find_yaml_files_in() {
    local search_dir="$1"
    find "$search_dir" -name "*.yaml" -type f 2>/dev/null | sort
}

# Common pattern: count yaml files
count_yaml_files() {
    local search_dir="$1"
    find_yaml_files_in "$search_dir" | wc -l | tr -d ' '
}

# Create and manage temporary directory
create_temp_dir() {
    local temp_dir="${TMPDIR:-/tmp}/construct-$$"
    mkdir -p "$temp_dir"
    echo "$temp_dir"
}

# Cleanup temporary directory
cleanup_temp_dir() {
    local temp_dir="$1"
    if [ -n "$temp_dir" ] && [ -d "$temp_dir" ]; then
        rm -rf "$temp_dir" 2>/dev/null || true
    fi
}

# Standard structure directory creation
create_structure_dirs() {
    local structure_dir="$1"
    local old_dir="$structure_dir/_old"
    
    mkdir -p "$structure_dir" "$old_dir"
    echo "$old_dir"
}

# Move existing files to old directory
archive_existing_files() {
    local structure_dir="$1"
    local pattern="$2"
    local old_dir="$structure_dir/_old"
    
    if ls "$structure_dir"/$pattern 2>/dev/null 1>&2; then
        echo "Moving existing $pattern files to _old directory..."
        mv "$structure_dir"/$pattern "$old_dir/" 2>/dev/null || true
    fi
}