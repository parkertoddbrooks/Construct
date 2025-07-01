#!/bin/bash

# Run this before creating any new component
# Usage: ./before-coding.sh ConnectWearable

COMPONENT_NAME=$1
# Source project detection library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/project-detection.sh"

# Get project paths
PROJECT_ROOT="$(get_project_root)"
PROJECT_NAME="$(get_project_name)"
XCODE_DIR="$(get_xcode_project_dir)"
IOS_DIR="$(get_ios_app_dir)"

if [ -z "$COMPONENT_NAME" ]; then
    echo "Usage: ./before-coding.sh ComponentName"
    exit 1
fi

echo "🏗️  Pre-Coding Check for: $COMPONENT_NAME"
echo "========================================"
echo ""

echo "📦 Existing Components You Can Use:"
echo "-----------------------------------"
ls -1 "$IOS_DIR/Shared/Components/" | grep -v ".DS_Store"
echo ""

echo "🎨 Design System Available:"
echo "---------------------------"
echo "• AppColors (from Colors.swift)"
echo "• Spacing.small, .medium, .large (from Spacing.swift)"
echo "• Radius.small, .medium, .large (from Radius.swift)"
echo "• Typography system (from Typography.swift)"
echo ""

echo "📐 Existing Design Tokens:"
echo "-------------------------"
find "$XCODE_DIR" -name "*DesignTokens.swift" -type f | xargs basename -a
echo ""

echo "🔍 Similar Components Found:"
echo "----------------------------"
find "$XCODE_DIR" -name "*${COMPONENT_NAME}*.swift" -o -name "*${COMPONENT_NAME,,}*.swift" 2>/dev/null | head -5
echo ""

echo "📋 PRD Alignment Check:"
echo "----------------------"
# Check current sprint PRD
if [ -f "$PROJECT_ROOT/AI/PRDs/current-sprint/"*.md ]; then
    for prd in "$PROJECT_ROOT/AI/PRDs/current-sprint/"*.md; do
        if [ -f "$prd" ]; then
            if grep -qi "$COMPONENT_NAME" "$prd" 2>/dev/null; then
                echo "✅ Component '$COMPONENT_NAME' is mentioned in current sprint PRD!"
                echo "   Found in: $(basename "$prd")"
                # Show relevant context
                echo ""
                echo "   Context from PRD:"
                grep -B 2 -A 2 -i "$COMPONENT_NAME" "$prd" | head -10
            else
                echo "⚠️  Component '$COMPONENT_NAME' not found in current sprint PRD"
                echo "   Current sprint: $(basename "$prd")"
                echo "   Make sure this aligns with sprint goals!"
            fi
        fi
    done
else
    echo "❓ No active sprint PRD found"
fi

# Check if it's in future PRDs
if grep -r -qi "$COMPONENT_NAME" "$PROJECT_ROOT/AI/PRDs/future/" 2>/dev/null; then
    echo ""
    echo "🔮 Found in future PRDs:"
    grep -r -l -i "$COMPONENT_NAME" "$PROJECT_ROOT/AI/PRDs/future/" | while read -r file; do
        echo "   - $(basename "$file")"
    done
fi
echo ""

echo "📋 Required Files for $COMPONENT_NAME:"
echo "--------------------------------------"
echo "□ ${COMPONENT_NAME}View.swift"
echo "□ ${COMPONENT_NAME}ViewModel.swift"
echo "□ ${COMPONENT_NAME}DesignTokens.swift"
echo "□ Add route to Route.swift"
echo "□ Update AppCoordinator.swift"
echo ""

echo "🚀 Quick Start Template:"
echo "-----------------------"
echo "mkdir -p Features/$COMPONENT_NAME"
echo "touch Features/$COMPONENT_NAME/${COMPONENT_NAME}View.swift"
echo "touch Features/$COMPONENT_NAME/${COMPONENT_NAME}ViewModel.swift"
echo "touch Features/$COMPONENT_NAME/${COMPONENT_NAME}DesignTokens.swift"
echo ""

echo "⚠️  Remember:"
echo "• Use AppColors, not Color()"
echo "• Use Spacing.*, not hardcoded padding"
echo "• Check Shared/Components first!"
echo "• All navigation through AppCoordinator"