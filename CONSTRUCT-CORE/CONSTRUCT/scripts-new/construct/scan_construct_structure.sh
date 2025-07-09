#!/bin/bash

# CONSTRUCT Structure Scan Script
# Scans CONSTRUCT development environment for shell scripts, configurations, and library functions

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Source library functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPTS_ROOT/../lib/common-patterns.sh"

# Get project directories using library functions
CONSTRUCT_ROOT=$(get_construct_root)
CONSTRUCT_DEV=$(get_construct_dev)
STRUCTURE_DIR="$CONSTRUCT_DEV/AI/structure"

# Create structure directories using library function
OLD_DIR=$(create_structure_dirs "$STRUCTURE_DIR")

echo -e "${BLUE}🔍 Scanning CONSTRUCT Development Structure...${NC}"

# Archive existing construct-structure files using library function
archive_existing_files "$STRUCTURE_DIR" "construct-structure-*.md"

# Create new file with timestamp
OUTPUT_FILE="$STRUCTURE_DIR/construct-structure-$(date +%Y-%m-%d--%H-%M-%S).md"

echo "# CONSTRUCT Development Structure Scan - $(date +%Y-%m-%d)" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Function to scan for specific file patterns in CONSTRUCT-LAB
scan_for_pattern() {
    local pattern=$1
    local title=$2
    local search_path=${3:-"$CONSTRUCT_DEV"}
    
    echo "## $title" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    
    found_files=$(find "$search_path" -name "*${pattern}*" -type f | grep -v "build/" | grep -v ".git/" | sort)
    
    if [ -z "$found_files" ]; then
        echo "None found" >> "$OUTPUT_FILE"
    else
        echo "$found_files" | while read -r file; do
            # Get relative path from CONSTRUCT_ROOT
            relative_path="${file#$CONSTRUCT_ROOT/}"
            echo "$relative_path" >> "$OUTPUT_FILE"
        done
    fi
    
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
}

# Function to analyze shell script structure
analyze_shell_scripts() {
    echo "## Shell Script Analysis" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    
    # Find all shell scripts in CONSTRUCT-LAB
    shell_scripts=$(find_shell_scripts "$CONSTRUCT_DEV")
    
    if [ -n "$shell_scripts" ]; then
        echo "=== Script Categories ===" >> "$OUTPUT_FILE"
        
        # Categorize by directory
        echo "" >> "$OUTPUT_FILE"
        echo "Core Scripts:" >> "$OUTPUT_FILE"
        echo "$shell_scripts" | grep "CONSTRUCT/scripts/core/" | while read -r file; do
            basename "$file" >> "$OUTPUT_FILE"
        done
        
        echo "" >> "$OUTPUT_FILE"
        echo "CONSTRUCT Scripts:" >> "$OUTPUT_FILE"
        echo "$shell_scripts" | grep "CONSTRUCT/scripts/construct/" | while read -r file; do
            basename "$file" >> "$OUTPUT_FILE"
        done
        
        echo "" >> "$OUTPUT_FILE"
        echo "Workspace Scripts:" >> "$OUTPUT_FILE"
        echo "$shell_scripts" | grep "CONSTRUCT/scripts/workspace/" | while read -r file; do
            basename "$file" >> "$OUTPUT_FILE"
        done
        
        echo "" >> "$OUTPUT_FILE"
        echo "Dev Scripts:" >> "$OUTPUT_FILE"
        echo "$shell_scripts" | grep "CONSTRUCT/scripts/dev/" | while read -r file; do
            basename "$file" >> "$OUTPUT_FILE"
        done
        
        echo "" >> "$OUTPUT_FILE"
        echo "Library Functions:" >> "$OUTPUT_FILE"
        echo "$shell_scripts" | grep "lib/" | while read -r file; do
            basename "$file" >> "$OUTPUT_FILE"
        done
        
        echo "" >> "$OUTPUT_FILE"
        echo "Test Scripts:" >> "$OUTPUT_FILE"
        echo "$shell_scripts" | grep "tests/" | while read -r file; do
            basename "$file" >> "$OUTPUT_FILE"
        done || echo "None found" >> "$OUTPUT_FILE"
        
        echo "" >> "$OUTPUT_FILE"
        echo "=== Function Analysis ===" >> "$OUTPUT_FILE"
        
        # Count functions in each library file
        find_shell_scripts "$CONSTRUCT_DEV/CONSTRUCT/lib" | while read -r lib_file; do
            if [ -f "$lib_file" ]; then
                func_count=$(safe_grep_count "^[a-zA-Z_][a-zA-Z0-9_]*()" "$lib_file")
                echo "$(basename "$lib_file"): $func_count functions" >> "$OUTPUT_FILE"
            fi
        done
    else
        echo "No shell scripts found" >> "$OUTPUT_FILE"
    fi
    
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
}

# Function to create complete directory tree
create_tree_structure() {
    echo "## Complete CONSTRUCT Development Tree" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    
    # Use tree command if available, otherwise use find
    if command -v tree &> /dev/null; then
        cd "$CONSTRUCT_ROOT"
        tree -I 'build|.git|node_modules|*.xcworkspace|*.xcodeproj|_old' CONSTRUCT-LAB >> "$OUTPUT_FILE"
    else
        # Fallback to find with custom formatting
        cd "$CONSTRUCT_DEV"
        find . -type d | grep -v "\.git\|build\|_old" | sort | sed 's|^./||' | sed 's|^|  |' >> "$OUTPUT_FILE"
    fi
    
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
}

# Scan for different file types
echo "Scanning for shell scripts..."
scan_for_pattern ".sh" "Shell Scripts Found"

echo "Scanning for configuration files..."
scan_for_pattern ".yaml" "YAML Configuration Files"

echo "Scanning for markdown documentation..."
scan_for_pattern ".md" "Markdown Documentation Files"

echo "Scanning for Python files..."
scan_for_pattern ".py" "Python Files Found"

# Analyze shell script structure
echo "Analyzing shell script structure..."
analyze_shell_scripts

# Create full tree structure
echo "Creating directory tree..."
create_tree_structure

# Configuration analysis
echo "## Configuration Analysis" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"

if [ -d "$CONSTRUCT_DEV/CONSTRUCT/config" ]; then
    echo "=== Configuration Files ===" >> "$OUTPUT_FILE"
    find "$CONSTRUCT_DEV/CONSTRUCT/config" -name "*.yaml" -type f | while read -r config_file; do
        echo "" >> "$OUTPUT_FILE"
        echo "File: $(basename "$config_file")" >> "$OUTPUT_FILE"
        
        # Count top-level keys
        if command -v yq &> /dev/null; then
            key_count=$(yq eval 'keys | length' "$config_file" 2>/dev/null || echo "unknown")
            echo "  Top-level keys: $key_count" >> "$OUTPUT_FILE"
        else
            # Fallback count
            key_count=$(safe_grep_count "^[a-zA-Z_].*:" "$config_file")
            echo "  Configuration sections: $key_count" >> "$OUTPUT_FILE"
        fi
        
        # Show structure
        echo "  Structure:" >> "$OUTPUT_FILE"
        grep "^[a-zA-Z_].*:" "$config_file" | sed 's/:.*//' | sed 's/^/    - /' >> "$OUTPUT_FILE"
    done
else
    echo "No config directory found" >> "$OUTPUT_FILE"
fi

echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Summary statistics
echo "## Summary Statistics" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"

echo "=== File Counts ===" >> "$OUTPUT_FILE"
echo "Shell Scripts: $(count_shell_scripts "$CONSTRUCT_DEV")" >> "$OUTPUT_FILE"
echo "YAML Configs: $(find "$CONSTRUCT_DEV" -name "*.yaml" -type f | wc -l | tr -d ' ')" >> "$OUTPUT_FILE"
echo "Markdown Docs: $(find "$CONSTRUCT_DEV" -name "*.md" -type f | wc -l | tr -d ' ')" >> "$OUTPUT_FILE"
echo "Python Files: $(find "$CONSTRUCT_DEV" -name "*.py" -type f | wc -l | tr -d ' ')" >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "=== Directory Structure ===" >> "$OUTPUT_FILE"
echo "Total Directories: $(find "$CONSTRUCT_DEV" -type d | grep -v "\.git\|build" | wc -l | tr -d ' ')" >> "$OUTPUT_FILE"

# Check for specific CONSTRUCT patterns
echo "" >> "$OUTPUT_FILE"
echo "=== CONSTRUCT Development Health ===" >> "$OUTPUT_FILE"

# Count working scripts
working_scripts=0
# Core scripts
if [ -x "$CONSTRUCT_DEV/CONSTRUCT/scripts/core/check-architecture.sh" ]; then ((working_scripts++)); fi
if [ -x "$CONSTRUCT_DEV/CONSTRUCT/scripts/core/check-quality.sh" ]; then ((working_scripts++)); fi
if [ -x "$CONSTRUCT_DEV/CONSTRUCT/scripts/core/check-documentation.sh" ]; then ((working_scripts++)); fi
if [ -x "$CONSTRUCT_DEV/CONSTRUCT/scripts/core/before_coding.sh" ]; then ((working_scripts++)); fi
# CONSTRUCT scripts
if [ -x "$CONSTRUCT_DEV/CONSTRUCT/scripts/construct/update-context.sh" ]; then ((working_scripts++)); fi
if [ -x "$CONSTRUCT_DEV/CONSTRUCT/scripts/construct/check-symlinks.sh" ]; then ((working_scripts++)); fi
if [ -x "$CONSTRUCT_DEV/CONSTRUCT/scripts/construct/assemble-claude.sh" ]; then ((working_scripts++)); fi
# Dev scripts
if [ -x "$CONSTRUCT_DEV/CONSTRUCT/scripts/dev/session-summary.sh" ]; then ((working_scripts++)); fi
# Workspace scripts
if [ -x "$CONSTRUCT_DEV/CONSTRUCT/scripts/workspace/create-project.sh" ]; then ((working_scripts++)); fi

echo "Working Scripts: $working_scripts/9 key scripts" >> "$OUTPUT_FILE"

# Library completeness
lib_files=$(count_shell_scripts "$CONSTRUCT_DEV/CONSTRUCT/lib")
echo "Library Files: $lib_files" >> "$OUTPUT_FILE"

# Config completeness
config_files=$(find "$CONSTRUCT_DEV/CONSTRUCT/config" -name "*.yaml" -type f | wc -l | tr -d ' ')
echo "Configuration Files: $config_files" >> "$OUTPUT_FILE"

echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Development insights
echo "## Development Insights" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### Current State" >> "$OUTPUT_FILE"
echo "- CONSTRUCT development environment is $(echo "scale=0; $working_scripts * 100 / 9" | bc 2>/dev/null || echo "~56")% complete" >> "$OUTPUT_FILE"
echo "- Infrastructure libraries are established ($lib_files files)" >> "$OUTPUT_FILE"
echo "- Configuration-driven validation is active ($config_files configs)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### Next Development Priorities" >> "$OUTPUT_FILE"
echo "- [ ] Complete remaining $(echo "9 - $working_scripts" | bc 2>/dev/null || echo "4") AI scripts" >> "$OUTPUT_FILE"
echo "- [ ] Add more library functions for common operations" >> "$OUTPUT_FILE"
echo "- [ ] Expand configuration-driven validation rules" >> "$OUTPUT_FILE"
echo "- [ ] Create cross-environment analysis tools" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### Architecture Quality" >> "$OUTPUT_FILE"
# Check if architecture validation exists
if [ -f "$CONSTRUCT_DEV/CONSTRUCT/scripts/core/check-architecture.sh" ]; then
    echo "- [ ] Run ./CONSTRUCT/scripts/core/check-architecture.sh for current quality status" >> "$OUTPUT_FILE"
else
    echo "- [ ] Architecture validation not yet available" >> "$OUTPUT_FILE"
fi

echo "- [ ] Verify all scripts follow error handling patterns" >> "$OUTPUT_FILE"
echo "- [ ] Ensure proper path resolution in all scripts" >> "$OUTPUT_FILE"
echo "- [ ] Validate configuration file schemas" >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "---" >> "$OUTPUT_FILE"
echo "*Generated by scan_construct_structure.sh on $(date)*" >> "$OUTPUT_FILE"

echo -e "${GREEN}✅ Structure scan complete!${NC}"
echo "Output saved to: $OUTPUT_FILE"

# Also create a simplified current structure for quick reference
QUICK_REF="$CONSTRUCT_DEV/AI/structure/current-structure.md"
echo "# Current CONSTRUCT Development Components ($(date +%Y-%m-%d))" > "$QUICK_REF"
echo "" >> "$QUICK_REF"

echo "## Working Scripts by Category" >> "$QUICK_REF"
echo "" >> "$QUICK_REF"
echo "### Core Scripts" >> "$QUICK_REF"
find_shell_scripts "$CONSTRUCT_DEV/CONSTRUCT/scripts/core" 2>/dev/null | xargs -I {} basename {} | sort >> "$QUICK_REF" || echo "None found" >> "$QUICK_REF"
echo "" >> "$QUICK_REF"
echo "### CONSTRUCT Scripts" >> "$QUICK_REF"
find_shell_scripts "$CONSTRUCT_DEV/CONSTRUCT/scripts/construct" 2>/dev/null | xargs -I {} basename {} | sort >> "$QUICK_REF" || echo "None found" >> "$QUICK_REF"
echo "" >> "$QUICK_REF"
echo "### Workspace Scripts" >> "$QUICK_REF"
find_shell_scripts "$CONSTRUCT_DEV/CONSTRUCT/scripts/workspace" 2>/dev/null | xargs -I {} basename {} | sort >> "$QUICK_REF" || echo "None found" >> "$QUICK_REF"
echo "" >> "$QUICK_REF"
echo "### Dev Scripts" >> "$QUICK_REF"
find_shell_scripts "$CONSTRUCT_DEV/CONSTRUCT/scripts/dev" 2>/dev/null | xargs -I {} basename {} | sort >> "$QUICK_REF" || echo "None found" >> "$QUICK_REF"

echo "" >> "$QUICK_REF"
echo "## Library Functions" >> "$QUICK_REF"
find_shell_scripts "$CONSTRUCT_DEV/CONSTRUCT/lib" | xargs -I {} basename {} | sort >> "$QUICK_REF"

echo "" >> "$QUICK_REF"
echo "## Configuration Files" >> "$QUICK_REF"
find "$CONSTRUCT_DEV/CONSTRUCT/config" -name "*.yaml" -type f | xargs -I {} basename {} | sort >> "$QUICK_REF"

echo -e "${BLUE}📄 Quick reference saved to: $QUICK_REF${NC}"
echo ""
echo "Next steps:"
echo "  ./CONSTRUCT/scripts/construct/update-context.sh      # Update development context"
echo "  ./CONSTRUCT/scripts/core/check-architecture.sh      # Validate current architecture"