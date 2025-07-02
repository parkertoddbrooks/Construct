#!/bin/bash

# CONSTRUCT Promotion Script - Promotes validated changes from LAB to CORE
# This script processes PROMOTE-TO-CORE.yaml and executes promotions

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONSTRUCT_ROOT="$(cd "$LAB_ROOT/.." && pwd)"
CORE_ROOT="$CONSTRUCT_ROOT/CONSTRUCT-CORE"

# Promotion manifest
PROMOTION_MANIFEST="$LAB_ROOT/PROMOTE-TO-CORE.yaml"
PROMOTION_LOG="$CORE_ROOT/PROMOTION-LOG.md"

echo -e "${BLUE}🚀 CONSTRUCT Promotion System${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Validate environment
if [ ! -f "$PROMOTION_MANIFEST" ]; then
    echo -e "${RED}❌ Error: Promotion manifest not found: $PROMOTION_MANIFEST${NC}"
    exit 1
fi

if [ ! -d "$CORE_ROOT" ]; then
    echo -e "${RED}❌ Error: CONSTRUCT-CORE not found: $CORE_ROOT${NC}"
    exit 1
fi

# Parse promotions from YAML (simple approach)
# In production, use a proper YAML parser
parse_promotions() {
    local in_promotions=false
    local promotion_count=0
    
    while IFS= read -r line; do
        # Skip comments and empty lines
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ -z "${line// }" ]] && continue
        
        # Check if we're in the promotions section
        if [[ "$line" =~ ^promotions: ]]; then
            in_promotions=true
            continue
        fi
        
        # If we're in promotions and line starts with "- type:"
        if [[ "$in_promotions" == true ]] && [[ "$line" =~ ^[[:space:]]*-[[:space:]]*type: ]]; then
            promotion_count=$((promotion_count + 1))
        fi
    done < "$PROMOTION_MANIFEST"
    
    echo "$promotion_count"
}

# Check if there are any active promotions
promotion_count=$(parse_promotions)

if [ "$promotion_count" -eq 0 ]; then
    echo -e "${YELLOW}⚠️  No active promotions found in manifest${NC}"
    echo ""
    echo "To add promotions, edit: $PROMOTION_MANIFEST"
    echo "Then run this script again."
    exit 0
fi

echo -e "${GREEN}✅ Found $promotion_count promotion(s) to process${NC}"
echo ""

# Function to bump version
bump_version() {
    local version_file="$CORE_ROOT/VERSION"
    local bump_type="$1"
    
    if [ ! -f "$version_file" ]; then
        echo "1.0.0" > "$version_file"
        echo -e "${YELLOW}⚠️  Created VERSION file: 1.0.0${NC}"
        return
    fi
    
    local current_version=$(cat "$version_file")
    local major=$(echo "$current_version" | cut -d. -f1)
    local minor=$(echo "$current_version" | cut -d. -f2)
    local patch=$(echo "$current_version" | cut -d. -f3)
    
    case "$bump_type" in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
    esac
    
    local new_version="$major.$minor.$patch"
    echo "$new_version" > "$version_file"
    echo -e "${GREEN}✅ Version bumped: $current_version → $new_version${NC}"
}

# Process promotions (simplified for now)
echo -e "${BLUE}Processing promotions...${NC}"
echo ""

# For now, we'll just show what would be promoted
# In a full implementation, this would actually copy files

echo -e "${YELLOW}📋 Promotion Preview:${NC}"
echo ""
echo "The following would be promoted:"
echo "- Source files in LAB would be copied to CORE"
echo "- VERSION would be bumped based on change type"
echo "- Promotion log would be updated"
echo ""

# Ask for confirmation
read -p "Continue with promotion? (y/N) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}⚠️  Promotion cancelled${NC}"
    exit 0
fi

# Create promotion log entry
create_promotion_log() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local version=$(cat "$CORE_ROOT/VERSION" 2>/dev/null || echo "1.0.0")
    
    if [ ! -f "$PROMOTION_LOG" ]; then
        echo "# CONSTRUCT-CORE Promotion Log" > "$PROMOTION_LOG"
        echo "" >> "$PROMOTION_LOG"
        echo "This log tracks all promotions from CONSTRUCT-LAB to CONSTRUCT-CORE." >> "$PROMOTION_LOG"
        echo "" >> "$PROMOTION_LOG"
    fi
    
    echo "## Promotion: $timestamp" >> "$PROMOTION_LOG"
    echo "**Version**: $version" >> "$PROMOTION_LOG"
    echo "" >> "$PROMOTION_LOG"
    echo "### Promoted Items" >> "$PROMOTION_LOG"
    echo "- Details from PROMOTE-TO-CORE.yaml would be listed here" >> "$PROMOTION_LOG"
    echo "" >> "$PROMOTION_LOG"
    echo "---" >> "$PROMOTION_LOG"
    echo "" >> "$PROMOTION_LOG"
}

# Execute promotion
echo ""
echo -e "${BLUE}Executing promotion...${NC}"

# Process each promotion (simple YAML parsing)
process_promotions() {
    local in_promotions=false
    local current_type=""
    local current_source=""
    local current_dest=""
    local current_desc=""
    local current_bump=""
    local highest_bump="patch"
    local promotions_executed=0
    
    while IFS= read -r line; do
        # Skip comments and empty lines
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ -z "${line// }" ]] && continue
        
        # Check if we're in the promotions section
        if [[ "$line" =~ ^promotions: ]]; then
            in_promotions=true
            continue
        fi
        
        # Parse promotion entries
        if [[ "$in_promotions" == true ]]; then
            # New promotion entry
            if [[ "$line" =~ ^[[:space:]]*-[[:space:]]*type:[[:space:]]*(.+) ]]; then
                # Execute previous promotion if exists
                if [[ -n "$current_type" && -n "$current_source" && -n "$current_dest" ]]; then
                    execute_single_promotion "$current_type" "$current_source" "$current_dest" "$current_desc"
                    promotions_executed=$((promotions_executed + 1))
                fi
                
                # Start new promotion
                current_type="${BASH_REMATCH[1]}"
                current_source=""
                current_dest=""
                current_desc=""
                current_bump=""
            fi
            
            # Parse fields
            if [[ "$line" =~ ^[[:space:]]*source:[[:space:]]*(.+) ]]; then
                current_source="${BASH_REMATCH[1]}"
            elif [[ "$line" =~ ^[[:space:]]*dest:[[:space:]]*(.+) ]]; then
                current_dest="${BASH_REMATCH[1]}"
            elif [[ "$line" =~ ^[[:space:]]*description:[[:space:]]*\"(.+)\" ]]; then
                current_desc="${BASH_REMATCH[1]}"
            elif [[ "$line" =~ ^[[:space:]]*bump_version:[[:space:]]*(.+) ]]; then
                current_bump="${BASH_REMATCH[1]}"
                # Track highest bump level
                if [[ "$current_bump" == "major" ]]; then
                    highest_bump="major"
                elif [[ "$current_bump" == "minor" && "$highest_bump" != "major" ]]; then
                    highest_bump="minor"
                fi
            fi
        fi
    done < "$PROMOTION_MANIFEST"
    
    # Execute final promotion if exists
    if [[ -n "$current_type" && -n "$current_source" && -n "$current_dest" ]]; then
        execute_single_promotion "$current_type" "$current_source" "$current_dest" "$current_desc"
        promotions_executed=$((promotions_executed + 1))
    fi
    
    # Bump version based on highest bump type
    if [[ $promotions_executed -gt 0 ]]; then
        bump_version "$highest_bump"
        create_promotion_log
    fi
    
    echo ""
    echo -e "${GREEN}✅ Promoted $promotions_executed item(s)${NC}"
}

# Execute a single promotion
execute_single_promotion() {
    local type="$1"
    local source="$2"
    local dest="$3"
    local desc="$4"
    
    echo ""
    echo -e "${BLUE}Promoting: $source${NC}"
    echo "Description: $desc"
    
    # Validate source exists
    if [[ ! -f "$LAB_ROOT/$source" ]]; then
        echo -e "${RED}❌ Error: Source file not found: $source${NC}"
        return 1
    fi
    
    # Create destination directory if needed
    local dest_dir=$(dirname "$dest")
    if [[ ! -d "$dest_dir" ]]; then
        mkdir -p "$dest_dir"
        echo -e "${YELLOW}📁 Created directory: $dest_dir${NC}"
    fi
    
    # Backup existing file if it exists
    if [[ -f "$dest" ]]; then
        cp "$dest" "$dest.bak"
        echo -e "${YELLOW}📦 Backed up existing file to: $(basename "$dest").bak${NC}"
    fi
    
    # Copy file
    cp "$LAB_ROOT/$source" "$dest"
    echo -e "${GREEN}✅ Copied to: $dest${NC}"
    
    # Handle symlinked-file type
    if [[ "$type" == "symlinked-file" ]]; then
        echo -e "${BLUE}🔗 Creating symlink in LAB...${NC}"
        
        # Remove original file in LAB
        rm "$LAB_ROOT/$source"
        
        # Calculate relative path from source to dest
        local source_dir=$(dirname "$LAB_ROOT/$source")
        local relative_path=$(realpath --relative-to="$source_dir" "$dest")
        
        # Create symlink
        ln -s "$relative_path" "$LAB_ROOT/$source"
        echo -e "${GREEN}✅ Created symlink: $source -> $relative_path${NC}"
        
        # Update check-symlinks.sh
        update_check_symlinks_script "$source" "$relative_path"
    fi
}

# Update check-symlinks.sh with new symlink
update_check_symlinks_script() {
    local symlink_path="$1"
    local target_path="$2"
    local check_symlinks_script="$CORE_ROOT/CONSTRUCT/scripts/check-symlinks.sh"
    
    echo -e "${BLUE}📝 Updating check-symlinks.sh...${NC}"
    
    # Create the new entry
    local new_entry="    [\"\$CONSTRUCT_LAB/$symlink_path\"]=\"$target_path\""
    
    # Insert before the closing parenthesis of EXPECTED_SYMLINKS
    sed -i.bak "/^)$/i\\
$new_entry" "$check_symlinks_script"
    
    echo -e "${GREEN}✅ Updated check-symlinks.sh with new symlink${NC}"
}

# Process promotions
process_promotions

echo ""
echo -e "${GREEN}✅ Promotion completed successfully!${NC}"
echo ""
echo "Next steps:"
echo "1. Review changes in CONSTRUCT-CORE"
echo "2. Test that everything still works"
echo "3. Commit the changes to git"
echo "4. Clear the promotion manifest"

# Offer to clear the manifest
echo ""
read -p "Clear promotion manifest? (y/N) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Comment out all active promotions
    sed -i.bak '/^[[:space:]]*-[[:space:]]*type:/,/^[[:space:]]*bump_version:/ s/^/# /' "$PROMOTION_MANIFEST"
    echo -e "${GREEN}✅ Promotion manifest cleared${NC}"
fi