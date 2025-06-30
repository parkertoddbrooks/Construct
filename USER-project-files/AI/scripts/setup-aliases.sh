#!/bin/bash

# Setup script for RUN architecture tools aliases

PROJECT_DIR="/Users/parker/Documents/dev/claude-engineer/_Projects/RUN/xcode/RUN"

echo "🔧 Setting up RUN architecture tool aliases..."

# Determine shell config file
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f "$HOME/.bash_profile" ]; then
    SHELL_CONFIG="$HOME/.bash_profile"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
else
    echo "❌ Could not find shell configuration file"
    exit 1
fi

# Check if aliases already exist
if grep -q "# RUN Architecture Tools" "$SHELL_CONFIG"; then
    echo "⚠️  Aliases already exist in $SHELL_CONFIG"
    echo "Remove them first if you want to update"
    exit 0
fi

# Add aliases
cat >> "$SHELL_CONFIG" <<EOF

# RUN Architecture Tools (added $(date))
alias run-update="cd $PROJECT_DIR && ./AI/scripts/update-context.sh"
alias run-arch="cd $PROJECT_DIR && ./AI/scripts/update-architecture.sh"
alias run-check="cd $PROJECT_DIR && ./AI/scripts/check-architecture.sh"
alias run-quality="cd $PROJECT_DIR && ./AI/scripts/check-quality.sh"
alias run-accessibility="cd $PROJECT_DIR && ./AI/scripts/check-accessibility.sh"
alias run-before="cd $PROJECT_DIR && ./AI/scripts/before_coding.sh"
alias run-scan="cd $PROJECT_DIR && ./AI/scripts/scan_mvvm_structure.sh"
alias run-claude="cd $PROJECT_DIR && code CLAUDE.md"
alias run-full="cd $PROJECT_DIR && ./AI/scripts/update-context.sh && ./AI/scripts/update-architecture.sh && ./AI/scripts/check-quality.sh && ./AI/scripts/check-accessibility.sh"
alias run-session-summary="cd $PROJECT_DIR && ./AI/scripts/session-summary.sh"

# Quick RUN navigation
alias run-cd="cd $PROJECT_DIR"
alias run-ios="cd $PROJECT_DIR/RUN-Project/iOS-App"
alias run-watch="cd $PROJECT_DIR/RUN-Project/Watch-App"

# PRD workflow
alias run-prd="cd $PROJECT_DIR && open AI/PRDs/current-sprint/*.md"
alias run-prd-check="cd $PROJECT_DIR && grep -r -i \"\$1\" AI/PRDs/current-sprint/"
alias run-sprint-plan="cd $PROJECT_DIR && echo 'Creating new sprint PRD...' && touch AI/PRDs/current-sprint/\$(date +%Y-%m-%d)-\$1-prd.md"
EOF

echo "✅ Aliases added to $SHELL_CONFIG"
echo ""
echo "📝 Available commands:"
echo "  run-update      - Update CLAUDE.md with current project state"
echo "  run-check       - Check for architecture violations"
echo "  run-quality     - Check SwiftUI quality standards"
echo "  run-accessibility - Check accessibility compliance"
echo "  run-before      - Check before creating new component"
echo "  run-scan        - Scan MVVM structure"
echo "  run-claude      - Open CLAUDE.md in VSCode"
echo "  run-full        - Run all updates and checks"
echo "  run-prd         - Open current sprint PRD"
echo "  run-prd-check   - Search PRDs for a term"
echo "  run-sprint-plan - Create new sprint PRD"
echo "  run-cd          - Navigate to RUN project"
echo "  run-ios         - Navigate to iOS app"
echo "  run-watch       - Navigate to Watch app"
echo ""
echo "🔄 Run 'source $SHELL_CONFIG' to activate aliases"