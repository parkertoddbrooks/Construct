#!/bin/bash

# Project Structure Scan Script
# Scans project structure based on active patterns

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

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 [PROJECT_DIR]"
    echo ""
    echo "Scan and document project structure"
    echo ""
    echo "Arguments:"
    echo "  PROJECT_DIR   Directory to scan (default: current directory)"
    echo ""
    echo "This script analyzes project structure and generates:"
    echo "  - Detailed structure documentation"
    echo "  - File type analysis"
    echo "  - Pattern detection"
    echo "  - Quick reference summary"
    echo ""
    echo "Output files:"
    echo "  PROJECT_DIR/AI/structure/project-structure-[timestamp].md"
    echo "  PROJECT_DIR/AI/structure/current-structure.md"
    exit 0
fi

# Accept PROJECT_DIR as parameter, default to current directory
PROJECT_DIR="${1:-.}"
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

# Set structure directory for this project
STRUCTURE_DIR="$PROJECT_DIR/AI/structure"

# Create structure directories using library function
OLD_DIR=$(create_structure_dirs "$STRUCTURE_DIR")

echo -e "${BLUE}🔍 Scanning Project Structure...${NC}"
echo "Project: $PROJECT_DIR"
echo ""

# Archive existing structure files using library function
archive_existing_files "$STRUCTURE_DIR" "project-structure-*.md"

# Create new file with timestamp
OUTPUT_FILE="$STRUCTURE_DIR/project-structure-$(date +%Y-%m-%d--%H-%M-%S).md"

echo "# Project Structure Scan - $(date +%Y-%m-%d)" > "$OUTPUT_FILE"
echo "Project: $PROJECT_DIR" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Function to scan for specific file patterns in project
scan_for_pattern() {
    local pattern=$1
    local title=$2
    local search_path=${3:-"$PROJECT_DIR"}
    
    echo "## $title" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    
    found_files=$(find "$search_path" -name "*${pattern}*" -type f | grep -v "build/" | grep -v ".git/" | sort)
    
    if [ -z "$found_files" ]; then
        echo "None found" >> "$OUTPUT_FILE"
    else
        echo "$found_files" | while read -r file; do
            # Get relative path from PROJECT_DIR
            relative_path="${file#$PROJECT_DIR/}"
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
    
    # Find all shell scripts in project
    shell_scripts=$(find_shell_scripts "$PROJECT_DIR")
    
    if [ -n "$shell_scripts" ]; then
        echo "=== Script Categories ===" >> "$OUTPUT_FILE"
        
        # Categorize by directory
        echo "" >> "$OUTPUT_FILE"
        echo "Scripts by Location:" >> "$OUTPUT_FILE"
        
        # Find all directories containing scripts
        local script_dirs=$(echo "$shell_scripts" | xargs -I {} dirname {} | sort -u)
        
        echo "$script_dirs" | while read -r dir; do
            local rel_dir="${dir#$PROJECT_DIR/}"
            local scripts_in_dir=$(echo "$shell_scripts" | grep "^$dir/" | xargs -I {} basename {})
            
            if [ -n "$scripts_in_dir" ]; then
                echo "" >> "$OUTPUT_FILE"
                echo "$rel_dir/:" >> "$OUTPUT_FILE"
                echo "$scripts_in_dir" | while read -r script; do
                    echo "  - $script" >> "$OUTPUT_FILE"
                done
            fi
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
        
        # Count functions in library files if they exist
        if [ -d "$PROJECT_DIR/CONSTRUCT/lib" ]; then
            find_shell_scripts "$PROJECT_DIR/CONSTRUCT/lib" | while read -r lib_file; do
            if [ -f "$lib_file" ]; then
                func_count=$(safe_grep_count "^[a-zA-Z_][a-zA-Z0-9_]*()" "$lib_file")
                echo "$(basename "$lib_file"): $func_count functions" >> "$OUTPUT_FILE"
            fi
            done
        fi
    else
        echo "No shell scripts found" >> "$OUTPUT_FILE"
    fi
    
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
}

# Function to create complete directory tree
create_tree_structure() {
    echo "## Complete Project Tree" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    
    # Use tree command if available, otherwise use find
    if command -v tree &> /dev/null; then
        cd "$PROJECT_DIR"
        tree -I 'build|.git|node_modules|*.xcworkspace|*.xcodeproj|_old|.DS_Store' . >> "$OUTPUT_FILE"
    else
        # Fallback to find with custom formatting
        cd "$PROJECT_DIR"
        find . -type d | grep -v "\.git\|build\|_old\|node_modules" | sort | sed 's|^./||' | sed 's|^|  |' >> "$OUTPUT_FILE"
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

if [ -d "$PROJECT_DIR/CONSTRUCT/config" ]; then
    echo "=== Configuration Files ===" >> "$OUTPUT_FILE"
    find "$PROJECT_DIR/CONSTRUCT/config" -name "*.yaml" -type f | while read -r config_file; do
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
echo "Shell Scripts: $(count_shell_scripts "$PROJECT_DIR")" >> "$OUTPUT_FILE"
echo "YAML Configs: $(find "$PROJECT_DIR" -name "*.yaml" -type f | wc -l | tr -d ' ')" >> "$OUTPUT_FILE"
echo "Markdown Docs: $(find "$PROJECT_DIR" -name "*.md" -type f | wc -l | tr -d ' ')" >> "$OUTPUT_FILE"
echo "Python Files: $(find "$PROJECT_DIR" -name "*.py" -type f | wc -l | tr -d ' ')" >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "=== Directory Structure ===" >> "$OUTPUT_FILE"
echo "Total Directories: $(find "$PROJECT_DIR" -type d | grep -v "\.git\|build" | wc -l | tr -d ' ')" >> "$OUTPUT_FILE"

# Check patterns if available
echo "" >> "$OUTPUT_FILE"
echo "=== Project Health ===" >> "$OUTPUT_FILE"

# Check for pattern configuration
if [ -f "$PROJECT_DIR/.construct/patterns.yaml" ]; then
    echo "Pattern Configuration: Found" >> "$OUTPUT_FILE"
    
    # Try to extract patterns if yq is available
    if command -v yq >/dev/null 2>&1; then
        echo "Active Patterns:" >> "$OUTPUT_FILE"
        yq eval '.plugins[]' "$PROJECT_DIR/.construct/patterns.yaml" 2>/dev/null | while read -r pattern; do
            echo "  - $pattern" >> "$OUTPUT_FILE"
        done
    fi
else
    echo "Pattern Configuration: Not found (.construct/patterns.yaml)" >> "$OUTPUT_FILE"
fi

# Library completeness
if [ -d "$PROJECT_DIR/CONSTRUCT/lib" ]; then
    lib_files=$(count_shell_scripts "$PROJECT_DIR/CONSTRUCT/lib")
    echo "Library Files: $lib_files" >> "$OUTPUT_FILE"
fi

# Config completeness
if [ -d "$PROJECT_DIR/CONSTRUCT/config" ]; then
    config_files=$(find "$PROJECT_DIR/CONSTRUCT/config" -name "*.yaml" -type f | wc -l | tr -d ' ')
    echo "Configuration Files: $config_files" >> "$OUTPUT_FILE"
fi

echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Project insights based on patterns
echo "## Project Insights" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### Structure Analysis" >> "$OUTPUT_FILE"

# Analyze project type based on file extensions
local swift_files=$(find "$PROJECT_DIR" -name "*.swift" -type f 2>/dev/null | wc -l | tr -d ' ')
local js_files=$(find "$PROJECT_DIR" -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" -type f 2>/dev/null | wc -l | tr -d ' ')
local py_files=$(find "$PROJECT_DIR" -name "*.py" -type f 2>/dev/null | wc -l | tr -d ' ')
local cs_files=$(find "$PROJECT_DIR" -name "*.cs" -type f 2>/dev/null | wc -l | tr -d ' ')

if [ $swift_files -gt 0 ]; then
    echo "- Swift/iOS project detected ($swift_files .swift files)" >> "$OUTPUT_FILE"
fi
if [ $js_files -gt 0 ]; then
    echo "- JavaScript/TypeScript project detected ($js_files files)" >> "$OUTPUT_FILE"
fi
if [ $py_files -gt 0 ]; then
    echo "- Python project detected ($py_files .py files)" >> "$OUTPUT_FILE"
fi
if [ $cs_files -gt 0 ]; then
    echo "- C# project detected ($cs_files .cs files)" >> "$OUTPUT_FILE"
fi

echo "" >> "$OUTPUT_FILE"
echo "### Documentation Status" >> "$OUTPUT_FILE"

# Check for key documentation files
if [ -f "$PROJECT_DIR/README.md" ]; then
    echo "- ✅ README.md found" >> "$OUTPUT_FILE"
else
    echo "- ❌ README.md missing" >> "$OUTPUT_FILE"
fi

if [ -f "$PROJECT_DIR/CLAUDE.md" ]; then
    echo "- ✅ CLAUDE.md found" >> "$OUTPUT_FILE"
else
    echo "- ❌ CLAUDE.md missing" >> "$OUTPUT_FILE"
fi

if [ -d "$PROJECT_DIR/AI/docs" ]; then
    local doc_count=$(find "$PROJECT_DIR/AI/docs" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
    echo "- AI documentation: $doc_count files" >> "$OUTPUT_FILE"
else
    echo "- AI documentation directory missing" >> "$OUTPUT_FILE"
fi

echo "" >> "$OUTPUT_FILE"
echo "---" >> "$OUTPUT_FILE"
echo "*Generated by scan_project_structure.sh on $(date)*" >> "$OUTPUT_FILE"
echo "*Project: $PROJECT_DIR*" >> "$OUTPUT_FILE"

echo -e "${GREEN}✅ Structure scan complete!${NC}"
echo "Output saved to: $OUTPUT_FILE"

# Also create a simplified current structure for quick reference
QUICK_REF="$PROJECT_DIR/AI/structure/current-structure.md"
echo "# Current Project Structure ($(date +%Y-%m-%d))" > "$QUICK_REF"
echo "Project: $PROJECT_DIR" >> "$QUICK_REF"
echo "" >> "$QUICK_REF"

echo "## Project Components" >> "$QUICK_REF"
echo "" >> "$QUICK_REF"

# Patterns configuration
if [ -f "$PROJECT_DIR/.construct/patterns.yaml" ]; then
    echo "### Active Patterns" >> "$QUICK_REF"
    if command -v yq >/dev/null 2>&1; then
        yq eval '.plugins[]' "$PROJECT_DIR/.construct/patterns.yaml" 2>/dev/null | while read -r pattern; do
            echo "- $pattern" >> "$QUICK_REF"
        done
    else
        echo "- Install yq to see patterns" >> "$QUICK_REF"
    fi
    echo "" >> "$QUICK_REF"
fi

# Scripts by category if CONSTRUCT scripts exist
if [ -d "$PROJECT_DIR/CONSTRUCT/scripts" ]; then
    echo "### Scripts" >> "$QUICK_REF"
    find "$PROJECT_DIR/CONSTRUCT/scripts" -name "*.sh" -type f | xargs -I {} basename {} | sort >> "$QUICK_REF" || echo "None found" >> "$QUICK_REF"
    echo "" >> "$QUICK_REF"
fi

# Library functions if they exist
if [ -d "$PROJECT_DIR/CONSTRUCT/lib" ]; then
    echo "### Library Functions" >> "$QUICK_REF"
    find_shell_scripts "$PROJECT_DIR/CONSTRUCT/lib" | xargs -I {} basename {} | sort >> "$QUICK_REF"
    echo "" >> "$QUICK_REF"
fi

# Configuration files if they exist
if [ -d "$PROJECT_DIR/CONSTRUCT/config" ]; then
    echo "### Configuration Files" >> "$QUICK_REF"
    find "$PROJECT_DIR/CONSTRUCT/config" -name "*.yaml" -type f | xargs -I {} basename {} | sort >> "$QUICK_REF"
    echo "" >> "$QUICK_REF"
fi

# Key project files
echo "### Key Files" >> "$QUICK_REF"
[ -f "$PROJECT_DIR/README.md" ] && echo "- README.md" >> "$QUICK_REF"
[ -f "$PROJECT_DIR/CLAUDE.md" ] && echo "- CLAUDE.md" >> "$QUICK_REF"
[ -f "$PROJECT_DIR/.gitignore" ] && echo "- .gitignore" >> "$QUICK_REF"
[ -f "$PROJECT_DIR/package.json" ] && echo "- package.json" >> "$QUICK_REF"
[ -f "$PROJECT_DIR/Podfile" ] && echo "- Podfile" >> "$QUICK_REF"
[ -f "$PROJECT_DIR/requirements.txt" ] && echo "- requirements.txt" >> "$QUICK_REF"

echo -e "${BLUE}📄 Quick reference saved to: $QUICK_REF${NC}"
echo ""
echo "Next steps:"
echo "  update-context $PROJECT_DIR       # Update project context"
echo "  check-architecture $PROJECT_DIR   # Validate architecture"