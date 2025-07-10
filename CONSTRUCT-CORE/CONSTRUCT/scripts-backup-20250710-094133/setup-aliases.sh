#!/bin/bash

# CONSTRUCT Development Aliases Setup Script
# Creates convenient shell aliases for CONSTRUCT development workflow

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Source library functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common-patterns.sh"

# Get project directories using library functions
CONSTRUCT_ROOT=$(get_construct_root)
CONSTRUCT_DEV=$(get_construct_dev)

echo -e "${BLUE}🔧 Setting up CONSTRUCT Development Aliases...${NC}"
echo ""

# Detect shell
detect_shell() {
    if [ -n "$ZSH_VERSION" ]; then
        echo "zsh"
    elif [ -n "$BASH_VERSION" ]; then
        echo "bash"
    else
        echo "unknown"
    fi
}

SHELL_TYPE=$(detect_shell)
echo -e "${YELLOW}Detected shell: $SHELL_TYPE${NC}"

# Determine config file
get_shell_config() {
    case "$SHELL_TYPE" in
        "zsh")
            if [ -f "$HOME/.zshrc" ]; then
                echo "$HOME/.zshrc"
            else
                echo "$HOME/.zshrc"  # Create it
            fi
            ;;
        "bash")
            if [ -f "$HOME/.bashrc" ]; then
                echo "$HOME/.bashrc"
            elif [ -f "$HOME/.bash_profile" ]; then
                echo "$HOME/.bash_profile"
            else
                echo "$HOME/.bashrc"  # Create it
            fi
            ;;
        *)
            echo "$HOME/.profile"
            ;;
    esac
}

SHELL_CONFIG=$(get_shell_config)
echo -e "${YELLOW}Using config file: $SHELL_CONFIG${NC}"

# Create backup of existing config
backup_config() {
    if [ -f "$SHELL_CONFIG" ]; then
        local backup_file="${SHELL_CONFIG}.construct-backup-$(date +%Y%m%d-%H%M%S)"
        cp "$SHELL_CONFIG" "$backup_file"
        echo -e "${GREEN}✅ Backup created: $backup_file${NC}"
    fi
}

# Check if aliases already exist
check_existing_aliases() {
    if [ -f "$SHELL_CONFIG" ] && grep -q "# CONSTRUCT Development Aliases" "$SHELL_CONFIG"; then
        echo -e "${YELLOW}⚠️ CONSTRUCT aliases already exist in $SHELL_CONFIG${NC}"
        echo "Would you like to update them? (y/n)"
        read -r response
        if [[ "$response" != "y" && "$response" != "Y" ]]; then
            echo "Skipping alias setup."
            exit 0
        fi
        # Remove existing aliases
        remove_existing_aliases
    fi
}

# Remove existing CONSTRUCT aliases
remove_existing_aliases() {
    if [ -f "$SHELL_CONFIG" ]; then
        # Create temp file without CONSTRUCT aliases
        grep -v "# CONSTRUCT" "$SHELL_CONFIG" | grep -v "construct-dev" > "${SHELL_CONFIG}.tmp"
        mv "${SHELL_CONFIG}.tmp" "$SHELL_CONFIG"
        echo -e "${GREEN}✅ Removed existing CONSTRUCT aliases${NC}"
    fi
}

# Add CONSTRUCT development aliases
add_construct_aliases() {
    echo ""
    echo "# CONSTRUCT Development Aliases" >> "$SHELL_CONFIG"
    echo "# Generated on $(date)" >> "$SHELL_CONFIG"
    echo "" >> "$SHELL_CONFIG"
    
    # Core CONSTRUCT development workflow
    echo "# Core CONSTRUCT Development Workflow" >> "$SHELL_CONFIG"
    echo "alias construct-dev-update='cd \"$CONSTRUCT_ROOT\" && ./CONSTRUCT-LAB/CONSTRUCT/scripts/update-context.sh'" >> "$SHELL_CONFIG"
    echo "alias construct-dev-check='cd \"$CONSTRUCT_ROOT\" && ./CONSTRUCT-LAB/CONSTRUCT/scripts/check-architecture.sh'" >> "$SHELL_CONFIG"
    echo "alias construct-dev-quality='cd \"$CONSTRUCT_ROOT\" && ./CONSTRUCT-LAB/CONSTRUCT/scripts/check-quality.sh'" >> "$SHELL_CONFIG"
    echo "alias construct-dev-before='cd \"$CONSTRUCT_ROOT\" && ./CONSTRUCT-LAB/CONSTRUCT/scripts/before_coding.sh'" >> "$SHELL_CONFIG"
    echo "alias construct-dev-scan='cd \"$CONSTRUCT_ROOT\" && ./CONSTRUCT-LAB/CONSTRUCT/scripts/scan_construct_structure.sh'" >> "$SHELL_CONFIG"
    echo "alias construct-dev-docs='cd \"$CONSTRUCT_ROOT\" && ./CONSTRUCT-LAB/CONSTRUCT/scripts/check-documentation.sh'" >> "$SHELL_CONFIG"
    echo "alias construct-dev-session='cd \"$CONSTRUCT_ROOT\" && ./CONSTRUCT-LAB/CONSTRUCT/scripts/session-summary.sh'" >> "$SHELL_CONFIG"
    echo "" >> "$SHELL_CONFIG"
    
    # Navigation aliases
    echo "# CONSTRUCT Navigation" >> "$SHELL_CONFIG"
    echo "alias cd-construct='cd \"$CONSTRUCT_ROOT\"'" >> "$SHELL_CONFIG"
    echo "alias cd-construct-dev='cd \"$CONSTRUCT_DEV\"'" >> "$SHELL_CONFIG"
    echo "alias cd-construct-scripts='cd \"$CONSTRUCT_DEV/CONSTRUCT/scripts\"'" >> "$SHELL_CONFIG"
    echo "alias cd-construct-lib='cd \"$CONSTRUCT_DEV/CONSTRUCT/lib\"'" >> "$SHELL_CONFIG"
    echo "alias cd-construct-config='cd \"$CONSTRUCT_DEV/CONSTRUCT/config\"'" >> "$SHELL_CONFIG"
    echo "" >> "$SHELL_CONFIG"
    
    # User project aliases (for template testing)
    echo "# User Project Development (Template Testing)" >> "$SHELL_CONFIG"
    echo "alias construct-user-update='cd \"$CONSTRUCT_ROOT/USER-project-files\" && ./CONSTRUCT/scripts/update-context.sh'" >> "$SHELL_CONFIG"
    echo "alias construct-user-check='cd \"$CONSTRUCT_ROOT/USER-project-files\" && ./CONSTRUCT/scripts/check-architecture.sh'" >> "$SHELL_CONFIG"
    echo "alias construct-user-quality='cd \"$CONSTRUCT_ROOT/USER-project-files\" && ./CONSTRUCT/scripts/check-quality.sh'" >> "$SHELL_CONFIG"
    echo "alias construct-user-before='cd \"$CONSTRUCT_ROOT/USER-project-files\" && ./CONSTRUCT/scripts/before_coding.sh'" >> "$SHELL_CONFIG"
    echo "alias construct-user-scan='cd \"$CONSTRUCT_ROOT/USER-project-files\" && ./CONSTRUCT/scripts/scan_mvvm_structure.sh'" >> "$SHELL_CONFIG"
    echo "alias construct-user-access='cd \"$CONSTRUCT_ROOT/USER-project-files\" && ./CONSTRUCT/scripts/check-accessibility.sh'" >> "$SHELL_CONFIG"
    echo "" >> "$SHELL_CONFIG"
    
    # Development workflow combinations
    echo "# CONSTRUCT Development Workflows" >> "$SHELL_CONFIG"
    echo "alias construct-dev-start='construct-dev-update && construct-dev-check'" >> "$SHELL_CONFIG"
    echo "alias construct-dev-validate='construct-dev-check && construct-dev-quality && construct-dev-docs'" >> "$SHELL_CONFIG"
    echo "alias construct-dev-analyze='construct-dev-scan && construct-dev-update'" >> "$SHELL_CONFIG"
    echo "" >> "$SHELL_CONFIG"
    
    # Git workflow helpers
    echo "# CONSTRUCT Git Workflows" >> "$SHELL_CONFIG"
    echo "alias construct-commit='construct-dev-validate && git add . && git commit'" >> "$SHELL_CONFIG"
    echo "alias construct-status='cd \"$CONSTRUCT_ROOT\" && git status'" >> "$SHELL_CONFIG"
    echo "" >> "$SHELL_CONFIG"
    
    # Quick access to important files
    echo "# CONSTRUCT Quick File Access" >> "$SHELL_CONFIG"
    echo "alias construct-claude='cd \"$CONSTRUCT_ROOT\" && code CONSTRUCT-LAB/AI/CLAUDE.md'" >> "$SHELL_CONFIG"
    echo "alias construct-todo='cd \"$CONSTRUCT_ROOT\" && ls CONSTRUCT-LAB/AI/todo/'" >> "$SHELL_CONFIG"
    echo "alias construct-logs='cd \"$CONSTRUCT_ROOT\" && ls CONSTRUCT-LAB/AI/dev-logs/dev-udpates/'" >> "$SHELL_CONFIG"
    echo "" >> "$SHELL_CONFIG"
    
    echo "# End CONSTRUCT Development Aliases" >> "$SHELL_CONFIG"
    echo "" >> "$SHELL_CONFIG"
}

# Show available aliases
show_aliases() {
    echo -e "${BLUE}📋 Available CONSTRUCT Development Aliases:${NC}"
    echo ""
    
    echo -e "${YELLOW}Core Development Workflow:${NC}"
    echo "  construct-dev-update    # Update CONSTRUCT development context"
    echo "  construct-dev-check     # Check CONSTRUCT architecture"
    echo "  construct-dev-quality   # Run quality checks"
    echo "  construct-dev-before    # Search before coding"
    echo "  construct-dev-scan      # Scan CONSTRUCT structure"
    echo "  construct-dev-docs      # Check documentation"
    echo "  construct-dev-session   # Create session summary"
    echo ""
    
    echo -e "${YELLOW}Navigation:${NC}"
    echo "  cd-construct           # Go to CONSTRUCT root"
    echo "  cd-construct-dev       # Go to CONSTRUCT-LAB/"
    echo "  cd-construct-scripts   # Go to scripts directory"
    echo "  cd-construct-lib       # Go to lib directory"
    echo "  cd-construct-config    # Go to config directory"
    echo ""
    
    echo -e "${YELLOW}User Project Testing:${NC}"
    echo "  construct-user-update   # Test user project scripts"
    echo "  construct-user-check    # Test user architecture check"
    echo "  construct-user-quality  # Test user quality check"
    echo ""
    
    echo -e "${YELLOW}Workflow Combinations:${NC}"
    echo "  construct-dev-start     # Update context + check architecture"
    echo "  construct-dev-validate  # Full validation suite"
    echo "  construct-dev-analyze   # Scan + update context"
    echo ""
    
    echo -e "${YELLOW}Git Workflows:${NC}"
    echo "  construct-commit        # Validate + commit"
    echo "  construct-status        # Git status from root"
    echo ""
    
    echo -e "${YELLOW}Quick Access:${NC}"
    echo "  construct-claude        # Open CLAUDE.md in editor"
    echo "  construct-todo          # Show todo files"
    echo "  construct-logs          # Show dev update logs"
}

# Test aliases function
test_aliases() {
    echo -e "${BLUE}🧪 Testing alias functionality...${NC}"
    
    # Source the updated config to test
    if [ -f "$SHELL_CONFIG" ]; then
        # shellcheck source=/dev/null
        source "$SHELL_CONFIG" 2>/dev/null || echo -e "${YELLOW}⚠️ May need to restart shell for aliases to work${NC}"
    fi
    
    # Test a few key aliases
    if command -v construct-dev-update &> /dev/null; then
        echo -e "${GREEN}✅ Aliases loaded successfully${NC}"
    else
        echo -e "${YELLOW}⚠️ Aliases not yet active - restart shell or run: source $SHELL_CONFIG${NC}"
    fi
}

# Main execution
main() {
    echo "Setting up CONSTRUCT development aliases..."
    echo ""
    
    # Create backup
    backup_config
    
    # Check for existing aliases
    check_existing_aliases
    
    # Add new aliases
    add_construct_aliases
    echo -e "${GREEN}✅ CONSTRUCT aliases added to $SHELL_CONFIG${NC}"
    
    # Show available aliases
    show_aliases
    
    # Test aliases
    test_aliases
    
    echo ""
    echo -e "${BLUE}🎉 CONSTRUCT Development Aliases Setup Complete!${NC}"
    echo ""
    echo "To activate aliases in current session:"
    echo "  source $SHELL_CONFIG"
    echo ""
    echo "Or restart your terminal for aliases to be available."
    echo ""
    echo "Try: construct-dev-start"
}

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "CONSTRUCT Development Aliases Setup"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --help, -h     Show this help message"
    echo "  --list         List all available aliases"
    echo "  --remove       Remove CONSTRUCT aliases"
    echo ""
    echo "This script adds convenient aliases for CONSTRUCT development"
    echo "workflow to your shell configuration file."
    exit 0
fi

# List aliases if requested
if [[ "$1" == "--list" ]]; then
    show_aliases
    exit 0
fi

# Remove aliases if requested
if [[ "$1" == "--remove" ]]; then
    remove_existing_aliases
    echo -e "${GREEN}✅ CONSTRUCT aliases removed${NC}"
    exit 0
fi

# Run main function
main