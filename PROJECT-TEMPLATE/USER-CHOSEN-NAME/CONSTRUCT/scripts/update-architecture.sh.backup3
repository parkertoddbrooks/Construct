#!/bin/bash

# Architecture Documentation Auto-Updater
# Updates the current implementation status while preserving planned architecture

# Source project detection library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/project-detection.sh"

# Get project paths
PROJECT_ROOT="$(get_project_root)"
PROJECT_NAME="$(get_project_name)"
XCODE_DIR="$(get_xcode_project_dir)"
ARCH_FILE="$PROJECT_ROOT/AI/docs/automated/app_structure_and_architecture_combined-automated.md"
TEMP_DIR=$(mktemp -d)

# Backup before updating
# Create trash directory with date
TRASH_DIR="$PROJECT_ROOT/_trash/$(date +%Y-%m-%d)"
mkdir -p "$TRASH_DIR"
# Move backup to trash
cp "$ARCH_FILE" "$TRASH_DIR/app_structure_and_architecture_combined-automated.md.backup-$(date +%H%M%S)"

# Function to update a section between markers
update_section() {
    local start_marker="$1"
    local end_marker="$2"
    local content_file="$3"
    
    perl -i -pe "
        if (/\Q$start_marker\E/../\Q$end_marker\E/) {
            if (/\Q$start_marker\E/) {
                print;
                open(FH, '<', '$content_file');
                while(<FH>) { print }
                close(FH);
            }
            \$_ = '' unless /\Q$end_marker\E/;
        }
    " "$ARCH_FILE"
}

# Generate implementation status
generate_status() {
    cat > "$TEMP_DIR/status.txt" <<EOF
## Current Implementation Status (Auto-Updated)
**Last Updated**: $(date '+%Y-%m-%d %H:%M:%S')
**Branch**: $(cd "$PROJECT_ROOT" && git branch --show-current)
**Status**: $(find "$XCODE_DIR" -name "*.swift" | wc -l | tr -d ' ') Swift files implemented

### 📊 Architecture Metrics
- **Views**: $(find "$XCODE_DIR" -name "*View.swift" | wc -l | tr -d ' ') implemented
- **ViewModels**: $(find "$XCODE_DIR" -name "*ViewModel*.swift" | wc -l | tr -d ' ') implemented
- **Services**: $(find "$XCODE_DIR" -name "*Service*.swift" | wc -l | tr -d ' ') implemented
- **Design Tokens**: $(find "$XCODE_DIR" -name "*Tokens*.swift" | wc -l | tr -d ' ') implemented
- **Tests**: $(find "$XCODE_DIR" -name "*Test*.swift" -o -name "*Tests.swift" | wc -l | tr -d ' ') test files

### 🎯 MVVM Compliance Check
EOF

    # Find Views without ViewModels
    local views_without_vm=0
    find "$XCODE_DIR" -name "*View.swift" | while read -r view; do
        local view_name=$(basename "$view" .swift)
        if [[ ! "$view_name" =~ "Component" ]] && [[ ! "$view_name" =~ "ContentView" ]]; then
            local viewmodel_exists=$(find "$XCODE_DIR" -name "${view_name}Model*.swift" 2>/dev/null | wc -l)
            if [ "$viewmodel_exists" -eq 0 ]; then
                echo "- ⚠️ $view_name is missing ViewModel" >> "$TEMP_DIR/status.txt"
                ((views_without_vm++))
            fi
        fi
    done
    
    if [ "$views_without_vm" -eq 0 ]; then
        echo "✅ All Views have corresponding ViewModels" >> "$TEMP_DIR/status.txt"
    fi
}

# Generate actual implementation tree
generate_actual_tree() {
    cat > "$TEMP_DIR/actual.txt" <<'EOF'
## 📁 Actual Implementation (Auto-Generated)

```
EOF
    
    # Generate tree showing what actually exists
    cd "$XCODE_DIR"
    
    # Function to mark implementation status
    check_implementation() {
        local path="$1"
        if [ -f "$path" ]; then
            echo "✅"
        elif [ -d "$path" ] && [ "$(find "$path" -name "*.swift" 2>/dev/null | wc -l)" -gt 0 ]; then
            echo "✅"
        else
            echo "⭕"
        fi
    }
    
    echo "$PROJECT_NAME-Project/" >> "$TEMP_DIR/actual.txt"
    
    # List actual structure with status
    for entry in "iOS-App"/*; do
        if [ -f "$entry" ] && [[ "$entry" == *.swift ]]; then
            echo "├── $(basename "$entry") ✅" >> "$TEMP_DIR/actual.txt"
        fi
    done
    
    # Features
    if [ -d "iOS-App/Features" ]; then
        echo "├── Features/" >> "$TEMP_DIR/actual.txt"
        for feature in "iOS-App/Features"/*; do
            if [ -d "$feature" ]; then
                local status=$(check_implementation "$feature")
                echo "│   ├── $(basename "$feature")/ $status" >> "$TEMP_DIR/actual.txt"
                
                # Show actual files in feature
                find "$feature" -name "*.swift" -maxdepth 2 2>/dev/null | head -5 | while read -r file; do
                    local relative_path=${file#$feature/}
                    echo "│   │   └── $relative_path" >> "$TEMP_DIR/actual.txt"
                done
            fi
        done
    fi
    
    # Shared
    if [ -d "iOS-App/Shared" ]; then
        echo "├── Shared/" >> "$TEMP_DIR/actual.txt"
        
        # Components
        if [ -d "iOS-App/Shared/Components" ]; then
            echo "│   ├── Components/" >> "$TEMP_DIR/actual.txt"
            for comp in "iOS-App/Shared/Components"/*.swift; do
                if [ -f "$comp" ]; then
                    echo "│   │   ├── $(basename "$comp") ✅" >> "$TEMP_DIR/actual.txt"
                fi
            done
        fi
        
        # Utilities
        if [ -d "iOS-App/Shared/Utilities" ]; then
            echo "│   └── Utilities/" >> "$TEMP_DIR/actual.txt"
            for util in "iOS-App/Shared/Utilities"/*.swift; do
                if [ -f "$util" ]; then
                    echo "│       ├── $(basename "$util") ✅" >> "$TEMP_DIR/actual.txt"
                fi
            done
        fi
    fi
    
    echo '```' >> "$TEMP_DIR/actual.txt"
}

# Generate recent changes
generate_changes() {
    cat > "$TEMP_DIR/changes.txt" <<'EOF'
## 🔄 Recent Architecture Changes (Auto-Updated)

EOF
    
    cd "$PROJECT_ROOT"
    
    echo "### Last 5 Architecture-Related Commits" >> "$TEMP_DIR/changes.txt"
    git log --oneline -5 --grep="feat\|fix\|refactor" -- "*.swift" >> "$TEMP_DIR/changes.txt"
    
    echo "" >> "$TEMP_DIR/changes.txt"
    echo "### Files Modified in Last 24 Hours" >> "$TEMP_DIR/changes.txt"
    find "$XCODE_DIR" -name "*.swift" -mtime -1 2>/dev/null | while read -r file; do
        echo "- ${file#$PROJECT_ROOT/}" >> "$TEMP_DIR/changes.txt"
    done
}

# Generate component relationships
generate_relationships() {
    cat > "$TEMP_DIR/relationships.txt" <<'EOF'
## 🔗 Component Relationships (Auto-Generated)

### View → ViewModel Mappings
EOF
    
    # Find View-ViewModel pairs
    find "$XCODE_DIR" -name "*View.swift" | while read -r view; do
        local view_name=$(basename "$view" .swift)
        local viewmodel=$(find "$XCODE_DIR" -name "${view_name}Model*.swift" 2>/dev/null | head -1)
        if [ -n "$viewmodel" ]; then
            echo "- $view_name → $(basename "$viewmodel" .swift)" >> "$TEMP_DIR/relationships.txt"
        fi
    done
    
    echo "" >> "$TEMP_DIR/relationships.txt"
    echo "### Service Dependencies" >> "$TEMP_DIR/relationships.txt"
    
    # Find services and their users
    find "$XCODE_DIR" -name "*Service.swift" | while read -r service; do
        local service_name=$(basename "$service" .swift)
        local users=$(grep -l "$service_name" "$XCODE_DIR"/**/*.swift 2>/dev/null | grep -v "$service" | head -3)
        if [ -n "$users" ]; then
            echo "" >> "$TEMP_DIR/relationships.txt"
            echo "**$service_name** used by:" >> "$TEMP_DIR/relationships.txt"
            echo "$users" | while read -r user; do
                echo "  - $(basename "$user" .swift)" >> "$TEMP_DIR/relationships.txt"
            done
        fi
    done
}

# Check if sections exist, if not add them
add_sections_if_missing() {
    if ! grep -q "<!-- START:AUTO-STATUS -->" "$ARCH_FILE"; then
        echo "Adding auto-update sections to architecture file..."
        
        # Add after the header
        perl -i -pe 's/(^## Current Implementation Status.*$)/$1\n\n<!-- START:AUTO-STATUS -->\n<!-- END:AUTO-STATUS -->\n\n<!-- START:ACTUAL-TREE -->\n<!-- END:ACTUAL-TREE -->\n\n<!-- START:RELATIONSHIPS -->\n<!-- END:RELATIONSHIPS -->\n\n<!-- START:CHANGES -->\n<!-- END:CHANGES -->/' "$ARCH_FILE"
    fi
}

# Execute updates
echo "🏗️ Updating Architecture Documentation..."

add_sections_if_missing
generate_status
generate_actual_tree
generate_relationships
generate_changes

# Update sections
update_section "<!-- START:AUTO-STATUS -->" "<!-- END:AUTO-STATUS -->" "$TEMP_DIR/status.txt"
update_section "<!-- START:ACTUAL-TREE -->" "<!-- END:ACTUAL-TREE -->" "$TEMP_DIR/actual.txt"
update_section "<!-- START:RELATIONSHIPS -->" "<!-- END:RELATIONSHIPS -->" "$TEMP_DIR/relationships.txt"
update_section "<!-- START:CHANGES -->" "<!-- END:CHANGES -->" "$TEMP_DIR/changes.txt"

# Cleanup
rm -rf "$TEMP_DIR"

echo "✅ Architecture documentation updated!"
echo ""
echo "📊 Updated sections:"
echo "  - Implementation status and metrics"
echo "  - Actual file tree (what exists now)"
echo "  - Component relationships"
echo "  - Recent changes"
echo ""
echo "Your planned architecture sections remain untouched!"