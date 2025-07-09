#!/bin/bash

# Interactive Support Library
# Provides functions for making scripts work in non-interactive environments
# Supports Claude Code, CI/CD, and automated workflows

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Check if script should show prompts instead of running
# Returns: 0 if should show prompts, 1 if should run normally
# Usage: if should_show_prompts "$@"; then
should_show_prompts() {
    # Check for explicit flags
    for arg in "$@"; do
        case "$arg" in
            --show-prompts|--dry-run|-p|--prompts)
                return 0
                ;;
        esac
    done
    
    # Check if in Claude Code environment
    if [ -n "$CLAUDE_CODE" ]; then
        return 0
    fi
    
    # Check if running non-interactively (no TTY)
    if [ ! -t 0 ] && [ -z "$CONSTRUCT_INTERACTIVE" ]; then
        # But only if no input is piped
        if [ -t 0 ] || [ -p /dev/stdin ]; then
            return 1
        fi
        return 0
    fi
    
    return 1
}

# Check if running in interactive mode
# Returns: 0 if interactive, 1 if non-interactive
is_interactive() {
    # Force interactive mode if requested
    if [ -n "$CONSTRUCT_INTERACTIVE" ]; then
        return 0
    fi
    
    # Check if stdout is a terminal
    if [ -t 1 ] && [ -t 0 ]; then
        return 0
    fi
    
    return 1
}

# Display standardized prompt format
# Parameters:
#   $1 - Script name
#   $2 - Function name that displays prompts
# Usage: show_script_prompts "$(basename "$0")" show_my_prompts
show_script_prompts() {
    local script_name="$1"
    local prompt_function="$2"
    
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}Script: ${script_name}${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}This script needs the following inputs:${NC}"
    echo ""
    
    # Call the provided function to show specific prompts
    if type "$prompt_function" >/dev/null 2>&1; then
        $prompt_function
    else
        echo -e "${RED}Error: Prompt function '$prompt_function' not found${NC}"
    fi
    
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}To run with defaults:${NC}"
    echo -e "  ${BOLD}echo '' | $script_name${NC} [args]"
    echo ""
    echo -e "${GREEN}To run with specific values:${NC}"
    echo -e "  ${BOLD}echo 'value1' | $script_name${NC} [args]"
    echo ""
    echo -e "${GREEN}For multiple inputs:${NC}"
    echo -e "  ${BOLD}echo -e 'value1\\\\nvalue2\\\\nvalue3' | $script_name${NC} [args]"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Get input with default value
# Handles both interactive and non-interactive modes
# Parameters:
#   $1 - Prompt text
#   $2 - Default value
# Returns: User input or default
# Usage: VAR=$(get_input_with_default "Enter name" "default")
get_input_with_default() {
    local prompt="$1"
    local default="$2"
    local input=""
    
    if is_interactive; then
        # Interactive mode - show prompt
        if [ -n "$default" ]; then
            echo -ne "${BLUE}$prompt${NC} [${GREEN}$default${NC}]: "
        else
            echo -ne "${BLUE}$prompt${NC}: "
        fi
        read -r input
    else
        # Non-interactive - read from stdin
        read -r input || true
    fi
    
    # Use default if no input provided
    if [ -z "$input" ]; then
        echo "$default"
    else
        echo "$input"
    fi
}

# Select from options with default
# Parameters:
#   $1 - Prompt text
#   $2 - Comma-separated options
#   $3 - Default option
# Returns: Selected option
# Usage: OPT=$(select_with_default "Choose type" "ios,web,api" "ios")
select_with_default() {
    local prompt="$1"
    local options="$2"
    local default="$3"
    local input=""
    
    if is_interactive; then
        # Show options
        echo -e "${BLUE}$prompt${NC}"
        echo -e "${YELLOW}Options: [${options//,/|}]${NC}"
        echo -ne "${BLUE}Selection${NC} [${GREEN}$default${NC}]: "
        read -r input
    else
        # Non-interactive - read from stdin
        read -r input || true
    fi
    
    # Use default if no input
    if [ -z "$input" ]; then
        echo "$default"
    else
        echo "$input"
    fi
}

# Yes/No prompt with default
# Parameters:
#   $1 - Prompt text
#   $2 - Default (y/n)
# Returns: y or n
# Usage: if [ "$(yes_no_prompt "Continue?" "y")" = "y" ]; then
yes_no_prompt() {
    local prompt="$1"
    local default="$2"
    local input=""
    
    if is_interactive; then
        if [ "$default" = "y" ]; then
            echo -ne "${BLUE}$prompt${NC} [${GREEN}Y/n${NC}]: "
        else
            echo -ne "${BLUE}$prompt${NC} [${GREEN}y/N${NC}]: "
        fi
        read -r input
    else
        read -r input || true
    fi
    
    # Normalize input
    input=$(echo "$input" | tr '[:upper:]' '[:lower:]')
    
    # Use default if no input
    if [ -z "$input" ]; then
        echo "$default"
    elif [[ "$input" =~ ^y(es)?$ ]]; then
        echo "y"
    elif [[ "$input" =~ ^n(o)?$ ]]; then
        echo "n"
    else
        echo "$default"
    fi
}

# Multi-select with defaults
# Parameters:
#   $1 - Prompt text
#   $2 - Comma-separated available options
#   $3 - Comma-separated default selections
# Returns: Comma-separated selections
# Usage: PLUGINS=$(multi_select "Choose plugins" "swift,mvvm,api" "swift")
multi_select() {
    local prompt="$1"
    local available="$2"
    local defaults="$3"
    local input=""
    
    if is_interactive; then
        echo -e "${BLUE}$prompt${NC}"
        echo -e "${YELLOW}Available: $available${NC}"
        echo -e "${GREEN}Default: $defaults${NC}"
        echo -ne "${BLUE}Selection (comma-separated)${NC}: "
        read -r input
    else
        read -r input || true
    fi
    
    # Use defaults if no input
    if [ -z "$input" ]; then
        echo "$defaults"
    else
        echo "$input"
    fi
}

# Show informational message in interactive mode only
# Parameters:
#   $1 - Message to display
# Usage: show_info "Processing files..."
show_info() {
    if is_interactive; then
        echo -e "${CYAN}ℹ️  $1${NC}"
    fi
}

# Show success message
# Parameters:
#   $1 - Message to display
# Usage: show_success "Project created successfully"
show_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Show error message
# Parameters:
#   $1 - Message to display
# Usage: show_error "Failed to create project"
show_error() {
    echo -e "${RED}❌ $1${NC}" >&2
}

# Show warning message
# Parameters:
#   $1 - Message to display
# Usage: show_warning "Using default configuration"
show_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# List available options from directory
# Parameters:
#   $1 - Directory path
#   $2 - File extension (optional)
# Returns: Comma-separated list
# Usage: THEMES=$(list_directory_options "themes/" ".css")
list_directory_options() {
    local dir="$1"
    local ext="${2:-}"
    local options=""
    
    if [ -d "$dir" ]; then
        if [ -n "$ext" ]; then
            options=$(find "$dir" -name "*$ext" -type f | xargs -n1 basename | sed "s/$ext$//" | tr '\n' ',' | sed 's/,$//')
        else
            options=$(find "$dir" -type f | xargs -n1 basename | tr '\n' ',' | sed 's/,$//')
        fi
    fi
    
    echo "$options"
}