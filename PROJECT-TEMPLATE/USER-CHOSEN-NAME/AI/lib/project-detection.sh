#!/bin/bash

# Project Detection Library for CONSTRUCT Template Projects
# Dynamically detects project name and paths

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Get the project root directory (directory containing CLAUDE.md and AI/)
get_project_root() {
    local current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Walk up from AI/lib/ to find directory with CLAUDE.md
    while [[ "$current_dir" != "/" ]]; do
        if [[ -f "$current_dir/CLAUDE.md" && -d "$current_dir/AI" ]]; then
            echo "$current_dir"
            return 0
        fi
        current_dir="$(dirname "$current_dir")"
    done
    
    echo -e "${RED}Error: Could not find project root (directory with CLAUDE.md and AI/)${NC}" >&2
    return 1
}

# Get the project name from the project root directory name
get_project_name() {
    local project_root="$(get_project_root)"
    basename "$project_root"
}

# Get the Xcode project container directory ({PROJECT_NAME}-Project)
get_xcode_project_dir() {
    local project_root="$(get_project_root)"
    local project_name="$(get_project_name)"
    local xcode_dir="$project_root/${project_name}-Project"
    
    if [[ -d "$xcode_dir" ]]; then
        echo "$xcode_dir"
        return 0
    else
        echo -e "${RED}Error: Xcode project directory not found: $xcode_dir${NC}" >&2
        return 1
    fi
}

# Get the .xcodeproj file path
get_xcodeproj_file() {
    local xcode_dir="$(get_xcode_project_dir)"
    local project_name="$(get_project_name)"
    local xcodeproj="$xcode_dir/${project_name}.xcodeproj"
    
    if [[ -d "$xcodeproj" ]]; then
        echo "$xcodeproj"
        return 0
    else
        echo -e "${RED}Error: .xcodeproj file not found: $xcodeproj${NC}" >&2
        return 1
    fi
}

# Get iOS app source directory
get_ios_app_dir() {
    local xcode_dir="$(get_xcode_project_dir)"
    echo "$xcode_dir/iOS-App"
}

# Get Watch app source directory  
get_watch_app_dir() {
    local xcode_dir="$(get_xcode_project_dir)"
    echo "$xcode_dir/Watch-App"
}

# Get shared source directory
get_shared_dir() {
    local xcode_dir="$(get_xcode_project_dir)"
    echo "$xcode_dir/Shared"
}

# Verify project structure is valid
verify_project_structure() {
    local project_root="$(get_project_root)"
    local project_name="$(get_project_name)"
    local xcode_dir="$(get_xcode_project_dir)"
    local ios_dir="$(get_ios_app_dir)"
    local watch_dir="$(get_watch_app_dir)"
    
    echo -e "${GREEN}✅ Project Structure Detected:${NC}"
    echo "  Project Name: $project_name"
    echo "  Project Root: $project_root"
    echo "  Xcode Container: $xcode_dir"
    echo "  iOS App: $ios_dir"
    echo "  Watch App: $watch_dir"
    
    # Verify key directories exist
    local errors=0
    
    if [[ ! -d "$xcode_dir" ]]; then
        echo -e "${RED}❌ Missing: $xcode_dir${NC}"
        errors=$((errors + 1))
    fi
    
    if [[ ! -d "$ios_dir" ]]; then
        echo -e "${RED}❌ Missing: $ios_dir${NC}"
        errors=$((errors + 1))
    fi
    
    if [[ ! -d "$watch_dir" ]]; then
        echo -e "${RED}❌ Missing: $watch_dir${NC}"
        errors=$((errors + 1))
    fi
    
    if [[ $errors -eq 0 ]]; then
        echo -e "${GREEN}✅ Project structure is valid${NC}"
        return 0
    else
        echo -e "${RED}❌ Found $errors structural issues${NC}"
        return 1
    fi
}

# Helper function to get all source directories (iOS + Watch + Shared)
get_all_source_dirs() {
    local ios_dir="$(get_ios_app_dir)"
    local watch_dir="$(get_watch_app_dir)"
    local shared_dir="$(get_shared_dir)"
    
    echo "$ios_dir"
    echo "$watch_dir"
    if [[ -d "$shared_dir" ]]; then
        echo "$shared_dir"
    fi
}