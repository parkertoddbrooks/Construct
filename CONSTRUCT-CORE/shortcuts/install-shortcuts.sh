#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$SCRIPT_DIR/claude"
CLAUDE_CONFIG_DIR="$HOME/.config/claude/shortcuts"

echo -e "${BLUE}🚀 CONSTRUCT Claude Shortcuts Installer${NC}"
echo -e "${BLUE}===========================================${NC}"
echo ""

# Check if Claude config directory exists
if [ ! -d "$HOME/.config/claude" ]; then
    echo -e "${YELLOW}⚠️  Claude config directory not found at ~/.config/claude${NC}"
    echo -e "   This might mean Claude Code is not installed or hasn't been run yet."
    echo ""
fi

# Create shortcuts directory if it doesn't exist
echo -e "${BLUE}📁 Creating Claude shortcuts directory...${NC}"
mkdir -p "$CLAUDE_CONFIG_DIR"

# Find all .md files in the claude subdirectory
if [ ! -d "$CLAUDE_DIR" ]; then
    echo -e "${RED}❌ Error: No claude subdirectory found at $CLAUDE_DIR${NC}"
    exit 1
fi

SHORTCUTS=$(find "$CLAUDE_DIR" -name "*.md" -type f)

if [ -z "$SHORTCUTS" ]; then
    echo -e "${YELLOW}⚠️  No shortcuts found in $CLAUDE_DIR${NC}"
    exit 0
fi

# Install each shortcut
echo -e "${BLUE}📦 Installing shortcuts...${NC}"
echo ""

INSTALLED=0
SKIPPED=0

for shortcut in $SHORTCUTS; do
    BASENAME=$(basename "$shortcut")
    SHORTCUT_NAME="${BASENAME%.md}"
    TARGET="$CLAUDE_CONFIG_DIR/$BASENAME"
    
    if [ -f "$TARGET" ]; then
        # Check if it's already a symlink to our file
        if [ -L "$TARGET" ] && [ "$(readlink "$TARGET")" = "$shortcut" ]; then
            echo -e "${BLUE}✓${NC} /$SHORTCUT_NAME ${GRAY}(already linked)${NC}"
            SKIPPED=$((SKIPPED + 1))
        else
            echo -e "${YELLOW}⚠️${NC}  /$SHORTCUT_NAME ${YELLOW}already exists${NC}"
            echo -n "   Overwrite? (y/N): "
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                ln -sf "$shortcut" "$TARGET"
                echo -e "   ${GREEN}✓ Updated${NC}"
                INSTALLED=$((INSTALLED + 1))
            else
                echo -e "   ${YELLOW}Skipped${NC}"
                SKIPPED=$((SKIPPED + 1))
            fi
        fi
    else
        ln -s "$shortcut" "$TARGET"
        echo -e "${GREEN}✓${NC} /$SHORTCUT_NAME ${GREEN}installed${NC}"
        INSTALLED=$((INSTALLED + 1))
    fi
done

echo ""
echo -e "${BLUE}===========================================${NC}"
echo -e "${GREEN}✨ Installation complete!${NC}"
echo -e "   ${GREEN}$INSTALLED${NC} shortcuts installed"
echo -e "   ${BLUE}$SKIPPED${NC} shortcuts skipped"
echo ""
echo -e "${BLUE}📝 Available shortcuts:${NC}"

for shortcut in $SHORTCUTS; do
    BASENAME=$(basename "$shortcut")
    SHORTCUT_NAME="${BASENAME%.md}"
    # Extract description from the shortcut file
    DESCRIPTION=$(grep -m 1 "^This shortcut" "$shortcut" 2>/dev/null | sed 's/This shortcut //' || echo "No description available")
    echo -e "   ${GREEN}/$SHORTCUT_NAME${NC} - $DESCRIPTION"
done

echo ""
echo -e "${BLUE}💡 Usage:${NC} Type any shortcut command in Claude Code"
echo -e "   Example: ${GREEN}/init-construct${NC}"
echo ""