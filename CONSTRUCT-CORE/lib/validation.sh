#!/bin/bash

# Validation Library for CONSTRUCT
# Common validation functions for both CONSTRUCT development and user projects

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Validate script has required dependencies
check_dependencies() {
    local missing_deps=0
    
    echo -e "${BLUE}Checking dependencies...${NC}"
    
    # Check for required commands
    local required_commands=("grep" "find" "awk" "sed")
    
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            echo -e "${RED}❌ Missing required command: $cmd${NC}"
            ((missing_deps++))
        fi
    done
    
    if [ $missing_deps -eq 0 ]; then
        echo -e "${GREEN}✅ All dependencies available${NC}"
    else
        echo -e "${RED}❌ Missing $missing_deps dependencies${NC}"
        return 1
    fi
}

# Validate directory exists and is readable
validate_directory() {
    local dir="$1"
    local description="$2"
    
    if [ ! -d "$dir" ]; then
        echo -e "${RED}❌ $description directory does not exist: $dir${NC}"
        return 1
    fi
    
    if [ ! -r "$dir" ]; then
        echo -e "${RED}❌ $description directory is not readable: $dir${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ $description directory validated: $dir${NC}"
    return 0
}

# Validate file exists and is readable
validate_file() {
    local file="$1"
    local description="$2"
    
    if [ ! -f "$file" ]; then
        echo -e "${RED}❌ $description file does not exist: $file${NC}"
        return 1
    fi
    
    if [ ! -r "$file" ]; then
        echo -e "${RED}❌ $description file is not readable: $file${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ $description file validated: $file${NC}"
    return 0
}

# Validate script syntax
validate_script_syntax() {
    local script="$1"
    
    if [ ! -f "$script" ]; then
        echo -e "${RED}❌ Script not found: $script${NC}"
        return 1
    fi
    
    # Check if script has proper shebang
    if ! head -1 "$script" | grep -q "^#!/"; then
        echo -e "${YELLOW}⚠️ Script missing shebang: $script${NC}"
    fi
    
    # Check syntax for shell scripts
    if [[ "$script" == *.sh ]]; then
        if ! bash -n "$script" 2>/dev/null; then
            echo -e "${RED}❌ Shell script syntax error: $script${NC}"
            return 1
        fi
    fi
    
    echo -e "${GREEN}✅ Script syntax valid: $script${NC}"
    return 0
}

# Validate configuration file format
validate_config_file() {
    local config_file="$1"
    local format="$2"  # yaml, json, etc.
    
    if [ ! -f "$config_file" ]; then
        echo -e "${RED}❌ Config file not found: $config_file${NC}"
        return 1
    fi
    
    case "$format" in
        "yaml"|"yml")
            # Basic YAML validation (would need yq for full validation)
            if ! grep -q ":" "$config_file"; then
                echo -e "${YELLOW}⚠️ Config file may not be valid YAML: $config_file${NC}"
            fi
            ;;
        "json")
            # Basic JSON validation (would need jq for full validation)
            if ! grep -q "{" "$config_file"; then
                echo -e "${YELLOW}⚠️ Config file may not be valid JSON: $config_file${NC}"
            fi
            ;;
    esac
    
    echo -e "${GREEN}✅ Config file format validated: $config_file${NC}"
    return 0
}

# Validate environment setup
validate_environment() {
    echo -e "${BLUE}Validating environment...${NC}"
    
    # Check if we're in the right directory structure
    local current_dir=$(pwd)
    local construct_root=""
    
    # Find CONSTRUCT root by looking for key directories
    local search_dir="$current_dir"
    while [ "$search_dir" != "/" ]; do
        # New structure: CONSTRUCT-CORE, CONSTRUCT-LAB, TEMPLATES
        if [ -d "$search_dir/CONSTRUCT-CORE" ] && [ -d "$search_dir/CONSTRUCT-LAB" ]; then
            construct_root="$search_dir"
            break
        fi
        # Old structure for compatibility
        if [ -d "$search_dir/CONSTRUCT-LAB" ] && [ -d "$search_dir/PROJECT-TEMPLATE" ]; then
            construct_root="$search_dir"
            break
        fi
        search_dir=$(dirname "$search_dir")
    done
    
    if [ -z "$construct_root" ]; then
        echo -e "${RED}❌ Not in CONSTRUCT project directory${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ CONSTRUCT root found: $construct_root${NC}"
    export CONSTRUCT_ROOT="$construct_root"
    return 0
}

# Validate project structure
validate_project_structure() {
    local project_dir="$1"
    local project_type="$2"  # "construct" or "user"
    
    echo -e "${BLUE}Validating $project_type project structure: $project_dir${NC}"
    
    case "$project_type" in
        "construct")
            validate_directory "$project_dir/CONSTRUCT-LAB" "CONSTRUCT development"
            validate_directory "$project_dir/USER-project-files" "User project files"
            validate_file "$project_dir/construct-setup" "Setup script"
            ;;
        "user")
            validate_directory "$project_dir/AI" "User AI tools"
            validate_file "$project_dir/CLAUDE.md" "User context file"
            validate_directory "$project_dir/scripts" "User scripts"
            ;;
        *)
            echo -e "${RED}❌ Unknown project type: $project_type${NC}"
            return 1
            ;;
    esac
}

# Generate validation report
generate_validation_report() {
    local output_file="$1"
    local target_dir="$2"
    local project_type="$3"
    
    echo "# Validation Report" > "$output_file"
    echo "Generated: $(date)" >> "$output_file"
    echo "Target: $target_dir" >> "$output_file"
    echo "Type: $project_type" >> "$output_file"
    echo "" >> "$output_file"
    
    echo "## Environment Check" >> "$output_file"
    validate_environment >> "$output_file" 2>&1
    echo "" >> "$output_file"
    
    echo "## Dependencies Check" >> "$output_file"
    check_dependencies >> "$output_file" 2>&1
    echo "" >> "$output_file"
    
    echo "## Project Structure Check" >> "$output_file"
    validate_project_structure "$target_dir" "$project_type" >> "$output_file" 2>&1
    echo "" >> "$output_file"
    
    echo -e "${GREEN}✅ Validation report generated: $output_file${NC}"
}

# Exit handler for cleanup
cleanup_on_exit() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}❌ Script exited with error code: $exit_code${NC}"
    fi
    exit $exit_code
}

# Set up exit trap
trap cleanup_on_exit EXIT