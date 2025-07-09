#!/bin/bash

# Script to safely migrate scripts-new to scripts
# Handles the new subdirectory structure and updates script references
# Version 2.0 - Updated for subdirectory organization

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSTRUCT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
CONSTRUCT_CORE="$CONSTRUCT_ROOT/CONSTRUCT-CORE/CONSTRUCT"

echo -e "${BLUE}🔄 CONSTRUCT Scripts Migration Tool v2.0${NC}"
echo "========================================"

# Check current state
if [ ! -d "$CONSTRUCT_CORE/scripts" ]; then
    echo -e "${RED}❌ No scripts directory found!${NC}"
    exit 1
fi

if [ ! -d "$CONSTRUCT_CORE/scripts-new" ]; then
    echo -e "${RED}❌ No scripts-new directory found!${NC}"
    exit 1
fi

# Function to create backup
backup_current() {
    echo -e "${YELLOW}Creating backup of current scripts...${NC}"
    
    # Create timestamped backup
    BACKUP_NAME="scripts--$(date +%Y-%m-%d--%H-%M-%S)"
    cp -r "$CONSTRUCT_CORE/scripts" "$CONSTRUCT_CORE/$BACKUP_NAME"
    
    echo -e "${GREEN}✅ Backup created: $BACKUP_NAME${NC}"
    echo "$BACKUP_NAME" > "$CONSTRUCT_CORE/.last-scripts-backup"
}

# Function to migrate
migrate_scripts() {
    echo -e "${YELLOW}Migrating scripts-new to scripts...${NC}"
    
    # Remove current scripts
    rm -rf "$CONSTRUCT_CORE/scripts"
    
    # Move scripts-new to scripts
    mv "$CONSTRUCT_CORE/scripts-new" "$CONSTRUCT_CORE/scripts"
    
    echo -e "${GREEN}✅ Migration complete${NC}"
}

# Function to test basic functionality with new structure
test_migration() {
    echo -e "${YELLOW}Testing basic functionality...${NC}"
    
    # Test if key scripts exist in their new locations
    local key_scripts=(
        "core/check-architecture.sh"
        "core/check-quality.sh"
        "core/check-documentation.sh"
        "core/before_coding.sh"
        "construct/update-context.sh"
        "construct/assemble-claude.sh"
        "construct/check-symlinks.sh"
        "workspace/create-project.sh"
        "dev/session-summary.sh"
    )
    
    local all_good=true
    for script in "${key_scripts[@]}"; do
        if [ -x "$CONSTRUCT_CORE/scripts/$script" ]; then
            echo -e "  ${GREEN}✓${NC} $script"
        else
            echo -e "  ${RED}✗${NC} $script"
            all_good=false
        fi
    done
    
    # Check that subdirectories exist
    local required_dirs=("core" "construct" "workspace" "dev" "patterns")
    for dir in "${required_dirs[@]}"; do
        if [ -d "$CONSTRUCT_CORE/scripts/$dir" ]; then
            echo -e "  ${GREEN}✓${NC} $dir/ directory exists"
        else
            echo -e "  ${RED}✗${NC} $dir/ directory missing"
            all_good=false
        fi
    done
    
    if [ "$all_good" = true ]; then
        echo -e "${GREEN}✅ All key scripts and directories are accessible${NC}"
        return 0
    else
        echo -e "${RED}❌ Some scripts or directories are missing${NC}"
        return 1
    fi
}

# Function to update script references
update_script_references() {
    echo -e "${YELLOW}Updating script references to new paths...${NC}"
    
    local scripts_to_update=(
        "$CONSTRUCT_CORE/scripts/dev/setup-aliases.sh"
        "$CONSTRUCT_CORE/scripts/dev/pre-commit-review.sh"
        "$CONSTRUCT_CORE/scripts/dev/session-summary.sh"
        "$CONSTRUCT_CORE/scripts/core/before_coding.sh"
        "$CONSTRUCT_CORE/scripts/construct/scan_construct_structure.sh"
        "$CONSTRUCT_CORE/scripts/construct/update-context.sh"
        "$CONSTRUCT_CORE/scripts/construct/update-architecture.sh"
        "$CONSTRUCT_CORE/scripts/construct/check-symlinks.sh"
    )
    
    # Define path replacements
    declare -A replacements=(
        ["scripts/check-architecture.sh"]="scripts/core/check-architecture.sh"
        ["scripts/check-quality.sh"]="scripts/core/check-quality.sh"
        ["scripts/check-documentation.sh"]="scripts/core/check-documentation.sh"
        ["scripts/before_coding.sh"]="scripts/core/before_coding.sh"
        ["scripts/construct-patterns.sh"]="scripts/core/construct-patterns.sh"
        ["scripts/update-context.sh"]="scripts/construct/update-context.sh"
        ["scripts/assemble-claude.sh"]="scripts/construct/assemble-claude.sh"
        ["scripts/check-symlinks.sh"]="scripts/construct/check-symlinks.sh"
        ["scripts/scan_construct_structure.sh"]="scripts/construct/scan_construct_structure.sh"
        ["scripts/update-architecture.sh"]="scripts/construct/update-architecture.sh"
        ["scripts/session-summary.sh"]="scripts/dev/session-summary.sh"
        ["scripts/commit-with-review.sh"]="scripts/dev/commit-with-review.sh"
        ["scripts/generate-devupdate.sh"]="scripts/dev/generate-devupdate.sh"
        ["scripts/pre-commit-review.sh"]="scripts/dev/pre-commit-review.sh"
        ["scripts/setup-aliases.sh"]="scripts/dev/setup-aliases.sh"
        ["scripts/create-project.sh"]="scripts/workspace/create-project.sh"
        ["scripts/import-project.sh"]="scripts/workspace/import-project.sh"
        ["scripts/workspace-status.sh"]="scripts/workspace/workspace-status.sh"
        ["scripts/workspace-update.sh"]="scripts/workspace/workspace-update.sh"
    )
    
    # Update each script
    for script in "${scripts_to_update[@]}"; do
        if [ -f "$script" ]; then
            echo -e "  Updating $(basename "$script")..."
            
            # Create a temporary file
            temp_file=$(mktemp)
            cp "$script" "$temp_file"
            
            # Apply replacements
            for old_path in "${!replacements[@]}"; do
                new_path="${replacements[$old_path]}"
                # Use sed to replace the paths
                sed -i.bak "s|$old_path|$new_path|g" "$temp_file"
            done
            
            # Move the updated file back
            mv "$temp_file" "$script"
            rm -f "$temp_file.bak"
        fi
    done
    
    echo -e "${GREEN}✅ Script references updated${NC}"
}

# Function to create compatibility symlinks
create_compatibility_links() {
    echo -e "${YELLOW}Creating compatibility symlinks...${NC}"
    
    # Create symlinks at the root level for commonly used scripts
    cd "$CONSTRUCT_CORE/scripts"
    
    # Core scripts
    ln -sf core/check-architecture.sh check-architecture.sh
    ln -sf core/check-quality.sh check-quality.sh
    ln -sf core/check-documentation.sh check-documentation.sh
    ln -sf core/before_coding.sh before_coding.sh
    
    # Construct scripts
    ln -sf construct/update-context.sh update-context.sh
    ln -sf construct/check-symlinks.sh check-symlinks.sh
    ln -sf construct/assemble-claude.sh assemble-claude.sh
    
    # Dev scripts
    ln -sf dev/session-summary.sh session-summary.sh
    
    echo -e "${GREEN}✅ Compatibility symlinks created${NC}"
}

# Function to rollback
rollback() {
    echo -e "${RED}Rolling back migration...${NC}"
    
    if [ -f "$CONSTRUCT_CORE/.last-scripts-backup" ]; then
        BACKUP_NAME=$(cat "$CONSTRUCT_CORE/.last-scripts-backup")
        
        # Remove failed migration
        rm -rf "$CONSTRUCT_CORE/scripts"
        
        # Restore backup
        cp -r "$CONSTRUCT_CORE/$BACKUP_NAME" "$CONSTRUCT_CORE/scripts"
        
        echo -e "${GREEN}✅ Rollback complete${NC}"
    else
        echo -e "${RED}❌ No backup found to restore!${NC}"
        exit 1
    fi
}

# Main execution
main() {
    echo -e "${BLUE}This will:${NC}"
    echo "1. Backup current scripts/ directory"
    echo "2. Replace scripts/ with scripts-new/ (with subdirectories)"
    echo "3. Update all script references to use new paths"
    echo "4. Create compatibility symlinks"
    echo "5. Test basic functionality"
    echo "6. Rollback if tests fail"
    echo ""
    echo -e "${YELLOW}New directory structure:${NC}"
    echo "  scripts/"
    echo "    ├── core/        # General-purpose orchestrators"
    echo "    ├── construct/   # CONSTRUCT-specific tools"
    echo "    ├── workspace/   # Workspace management"
    echo "    ├── dev/         # Development tools"
    echo "    └── patterns/    # Pattern validators"
    echo ""
    
    read -p "Continue with migration? [y/N] " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Migration cancelled"
        exit 0
    fi
    
    # Create backup
    backup_current
    
    # Perform migration
    migrate_scripts
    
    # Update script references
    update_script_references
    
    # Create compatibility symlinks
    create_compatibility_links
    
    # Test migration
    if test_migration; then
        echo -e "${GREEN}✅ Migration successful!${NC}"
        echo ""
        echo "What's changed:"
        echo "- Scripts are now organized in subdirectories"
        echo "- All internal references have been updated"
        echo "- Compatibility symlinks created for common scripts"
        echo ""
        echo "Next steps:"
        echo "1. Test key workflows (update-context, check-quality, etc.)"
        echo "2. Update any external references to use new paths"
        echo "3. Update pre-commit hooks if needed"
        echo ""
        echo "If issues occur, run: $0 --rollback"
    else
        echo -e "${RED}❌ Migration tests failed!${NC}"
        rollback
        exit 1
    fi
}

# Handle rollback option
if [ "$1" = "--rollback" ]; then
    rollback
    exit 0
fi

# Run main migration
main