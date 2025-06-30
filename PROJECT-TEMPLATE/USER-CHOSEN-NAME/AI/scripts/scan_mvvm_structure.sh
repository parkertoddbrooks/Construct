#!/bin/bash

# Script to scan Swift project for MVVM components and generate updated structure

# Source project detection library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/project-detection.sh"

# Get project paths
PROJECT_ROOT="$(get_project_root)"
PROJECT_NAME="$(get_project_name)"
XCODE_DIR="$(get_xcode_project_dir)"
STRUCTURE_DIR="$PROJECT_ROOT/AI/structure"
OLD_DIR="$STRUCTURE_DIR/_old"

# Move existing mvvm-structure files to _old
if ls "$STRUCTURE_DIR"/mvvm-structure-*.md 2>/dev/null 1>&2; then
    echo "Moving existing mvvm-structure files to _old directory..."
    mv "$STRUCTURE_DIR"/mvvm-structure-*.md "$OLD_DIR/" 2>/dev/null || true
fi

# Create new file with timestamp
OUTPUT_FILE="$STRUCTURE_DIR/mvvm-structure-$(date +%Y-%m-%d--%H-%M-%S).md"

echo "# Swift Project MVVM Structure Scan - $(date +%Y-%m-%d)" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Function to scan for specific file patterns
scan_for_pattern() {
    local pattern=$1
    local title=$2
    
    echo "## $title" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    
    found_files=$(find "$XCODE_DIR" -name "*${pattern}*.swift" -type f | grep -v "build/" | grep -v "DerivedData/" | sort)
    
    if [ -z "$found_files" ]; then
        echo "None found" >> "$OUTPUT_FILE"
    else
        echo "$found_files" | while read -r file; do
            # Get relative path from PROJECT_ROOT
            relative_path="${file#$PROJECT_ROOT/}"
            echo "$relative_path" >> "$OUTPUT_FILE"
        done
    fi
    
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
}

# Function to create tree structure
create_tree_structure() {
    echo "## Complete MVVM Structure" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    
    # Use tree command if available, otherwise use find
    if command -v tree &> /dev/null; then
        cd "$PROJECT_ROOT"
        tree -I 'build|DerivedData|*.xcworkspace|*.xcodeproj' "$XCODE_DIR" -P "*.swift" >> "$OUTPUT_FILE"
    else
        # Fallback to find
        cd "$XCODE_DIR"
        find . -name "*.swift" -type f | grep -v "build/" | grep -v "DerivedData/" | sort | sed 's|^\./||' >> "$OUTPUT_FILE"
    fi
    
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
}

# Scan for MVVM components
echo "Scanning for ViewModels..."
scan_for_pattern "ViewModel" "ViewModels Found"

echo "Scanning for Services..."
scan_for_pattern "Service" "Services Found"

echo "Scanning for Views..."
scan_for_pattern "View" "Views Found (excluding ViewModels)"

echo "Scanning for Coordinators..."
scan_for_pattern "Coordinator" "Coordinators Found"

echo "Scanning for Managers..."
scan_for_pattern "Manager" "Managers Found"

echo "Scanning for Repositories..."
scan_for_pattern "Repository" "Repositories Found"

# Create full tree structure
echo "Creating tree structure..."
create_tree_structure

# Summary statistics
echo "## Summary Statistics" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "ViewModels: $(find "$XCODE_DIR" -name "*ViewModel*.swift" -type f | grep -v "build/" | wc -l | tr -d ' ')" >> "$OUTPUT_FILE"
echo "Services: $(find "$XCODE_DIR" -name "*Service*.swift" -type f | grep -v "build/" | wc -l | tr -d ' ')" >> "$OUTPUT_FILE"
echo "Views: $(find "$XCODE_DIR" -name "*View*.swift" -type f | grep -v "ViewModel" | grep -v "build/" | wc -l | tr -d ' ')" >> "$OUTPUT_FILE"
echo "Coordinators: $(find "$XCODE_DIR" -name "*Coordinator*.swift" -type f | grep -v "build/" | wc -l | tr -d ' ')" >> "$OUTPUT_FILE"
echo "Managers: $(find "$XCODE_DIR" -name "*Manager*.swift" -type f | grep -v "build/" | wc -l | tr -d ' ')" >> "$OUTPUT_FILE"
echo "Total Swift Files: $(find "$XCODE_DIR" -name "*.swift" -type f | grep -v "build/" | wc -l | tr -d ' ')" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "## Key Observations" >> "$OUTPUT_FILE"
echo "- [ ] Check if all Views have corresponding ViewModels" >> "$OUTPUT_FILE"
echo "- [ ] Verify Service layer completeness" >> "$OUTPUT_FILE"
echo "- [ ] Confirm proper MVVM separation" >> "$OUTPUT_FILE"
echo "- [ ] Identify missing components" >> "$OUTPUT_FILE"

echo "Structure scan complete! Output saved to:"
echo "$OUTPUT_FILE"

# Also create a simplified current structure for quick reference
QUICK_REF="$PROJECT_ROOT/AI/structure/current-structure.md"
echo "# Current MVVM Components ($(date +%Y-%m-%d))" > "$QUICK_REF"
echo "" >> "$QUICK_REF"
echo "## Active ViewModels" >> "$QUICK_REF"
find "$XCODE_DIR" -name "*ViewModel*.swift" -type f | grep -v "build/" | xargs -I {} basename {} | sort >> "$QUICK_REF"
echo "" >> "$QUICK_REF"
echo "## Active Services" >> "$QUICK_REF"
find "$XCODE_DIR" -name "*Service*.swift" -type f | grep -v "build/" | xargs -I {} basename {} | sort >> "$QUICK_REF"

echo "Quick reference saved to: $QUICK_REF"