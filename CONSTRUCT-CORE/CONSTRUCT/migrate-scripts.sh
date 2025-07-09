#!/bin/bash

# Script to safely migrate scripts-new to scripts
# This handles the migration with rollback capability

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

echo -e "${BLUE}🔄 CONSTRUCT Scripts Migration Tool${NC}"
echo "===================================="

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
    BACKUP_NAME="scripts-backup-$(date +%Y-%m-%d--%H-%M-%S)"
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

# Function to test basic functionality
test_migration() {
    echo -e "${YELLOW}Testing basic functionality...${NC}"
    
    # Test if key scripts exist and are executable
    local key_scripts=(
        "check-architecture.sh"
        "check-quality.sh"
        "update-context.sh"
        "assemble-claude.sh"
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
    
    if [ "$all_good" = true ]; then
        echo -e "${GREEN}✅ All key scripts are accessible${NC}"
        return 0
    else
        echo -e "${RED}❌ Some scripts are missing or not executable${NC}"
        return 1
    fi
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
    echo "2. Replace scripts/ with scripts-new/"
    echo "3. Test basic functionality"
    echo "4. Rollback if tests fail"
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
    
    # Test migration
    if test_migration; then
        echo -e "${GREEN}✅ Migration successful!${NC}"
        echo ""
        echo "Next steps:"
        echo "1. Update any symlinks pointing to scripts/"
        echo "2. Test pre-commit hooks"
        echo "3. Run a full validation cycle"
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