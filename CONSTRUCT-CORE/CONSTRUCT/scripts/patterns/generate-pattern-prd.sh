#!/bin/bash

# generate-pattern-prd.sh - Generate PRDs for missing pattern plugins
# Creates Product Requirements Documents for patterns that don't exist yet

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSTRUCT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
CONSTRUCT_CORE="$CONSTRUCT_ROOT/CONSTRUCT-CORE"
CONSTRUCT_LAB="$CONSTRUCT_ROOT/CONSTRUCT-LAB"

# Source library functions
source "$CONSTRUCT_CORE/CONSTRUCT/lib/common-patterns.sh" 2>/dev/null || true

# Function to create a single pattern PRD
create_pattern_prd() {
    local language="$1"
    local percentage="$2"
    local plugin_path="$3"
    local priority="$4"
    
    # Default plugin path if not provided
    if [ -z "$plugin_path" ]; then
        plugin_path="languages/$(echo "$language" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"
    fi
    
    local prd_dir="$CONSTRUCT_LAB/AI/PRDs/future"
    mkdir -p "$prd_dir"
    
    local plugin_name=$(basename "$plugin_path")
    local prd_file="$prd_dir/plugin-${plugin_name}-pattern.md"
    
    # Determine priority if not provided
    if [ -z "$priority" ]; then
        if [ -n "$percentage" ]; then
            if (( $(echo "$percentage > 10" | bc -l) )); then
                priority="High"
            elif (( $(echo "$percentage > 5" | bc -l) )); then
                priority="Medium"
            else
                priority="Low"
            fi
        else
            priority="Medium"
        fi
    fi
    
    cat > "$prd_file" << EOF
# Pattern Plugin PRD: $plugin_path

## Overview
Create a CONSTRUCT pattern plugin for $language development.

## Context
- Language: $language
$([ -n "$percentage" ] && echo "- Usage percentage in project: $percentage%")
- Plugin path: $plugin_path
- Pattern type: $(dirname "$plugin_path")

## Requirements

### Pattern Content
- Language-specific best practices and idioms
- Common anti-patterns to avoid
- Security considerations for $language
- Performance optimization patterns
- Testing patterns and practices
- Error handling conventions
- Documentation standards

### Pattern Structure
\`\`\`
$plugin_path/
├── pattern.yaml         # Metadata and configuration
├── pattern.md          # Pattern rules and guidelines
├── injections/         # Content to inject into CLAUDE.md
│   ├── guidelines.md   # Development guidelines
│   ├── examples.md     # Code examples
│   └── anti-patterns.md # What to avoid
├── validators/         # Scripts to check compliance
│   └── check-$plugin_name.sh
└── generators/         # Code generation scripts
    └── generate-$plugin_name.sh
\`\`\`

### Validators
- Code quality checks specific to $language
- Style validation based on community standards
- Security vulnerability scanning
- Pattern compliance verification
- Dependency management checks

### Integration Requirements
- Must work with existing CONSTRUCT patterns
- Should complement related patterns (frameworks, platforms)
- Support common $language frameworks and tools
- Compatible with CONSTRUCT's pattern loading system

### Tags for Detection
Consider appropriate tags that will match in CLAUDE.md:
- Primary: $(echo "$language" | tr '[:upper:]' '[:lower:]')
- Secondary: Related framework/tool names
- Avoid overly generic terms

## Priority
$priority - $([ -n "$percentage" ] && echo "Based on $percentage% usage in project" || echo "User requested")

## Success Criteria
1. Pattern correctly identifies $language projects
2. Validators catch common $language issues
3. Guidelines improve code quality
4. Examples demonstrate best practices
5. Integration with pattern system is seamless

## Related Patterns
- Consider dependencies on other patterns
- List complementary patterns
- Note any conflicts to avoid

## Notes
Generated on: $(date)
Generator: generate-pattern-prd.sh
EOF

    echo -e "${GREEN}✅ Created PRD: $(basename "$prd_file")${NC}"
    echo "$prd_file"
}

# Function to create PRDs from GitHub language analysis
create_prds_from_github() {
    local languages_json="$1"
    local prd_files=()
    
    echo -e "${BLUE}📊 Analyzing GitHub languages for missing patterns...${NC}"
    
    # Parse JSON and create PRDs for languages without patterns
    while IFS=: read -r language bytes; do
        # Clean up the input
        language=$(echo "$language" | tr -d '"' | xargs)
        bytes=$(echo "$bytes" | tr -d ',' | xargs)
        
        [ -z "$language" ] && continue
        
        # Calculate percentage (would need total for accurate calc)
        # For now, just mark as detected
        
        # Check if pattern exists
        local plugin_path="languages/$(echo "$language" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"
        if [ ! -d "$CONSTRUCT_CORE/patterns/plugins/$plugin_path" ]; then
            echo -e "${YELLOW}Missing pattern for: $language${NC}"
            prd_file=$(create_pattern_prd "$language" "" "$plugin_path" "")
            prd_files+=("$prd_file")
        fi
    done < <(echo "$languages_json" | grep -E '^\s*"[^"]+"\s*:' | sed 's/[{}]//g')
    
    # Create summary if PRDs were generated
    if [ ${#prd_files[@]} -gt 0 ]; then
        create_prd_summary "${prd_files[@]}"
    fi
}

# Function to create a summary PRD
create_prd_summary() {
    local prd_files=("$@")
    local prd_dir="$CONSTRUCT_LAB/AI/PRDs/future"
    local summary_file="$prd_dir/pattern-coverage-summary.md"
    
    {
        echo "# Pattern Coverage Summary"
        echo ""
        echo "Generated: $(date)"
        echo ""
        echo "## Missing Pattern Plugins"
        echo ""
        for prd in "${prd_files[@]}"; do
            local plugin_name=$(basename "$prd" | sed 's/plugin-//; s/-pattern\.md//')
            echo "- $plugin_name"
        done
        echo ""
        echo "## Generated PRDs"
        echo ""
        for prd in "${prd_files[@]}"; do
            echo "- [$(basename "$prd")]($prd)"
        done
        echo ""
        echo "## Next Steps"
        echo "1. Review individual PRDs for accuracy"
        echo "2. Prioritize based on project needs"
        echo "3. Implement patterns incrementally"
        echo "4. Test with real projects"
        echo ""
        echo "## Implementation Guide"
        echo "1. Start with pattern.yaml metadata"
        echo "2. Define pattern.md rules"
        echo "3. Create injections for CLAUDE.md"
        echo "4. Implement validators"
        echo "5. Add generators if applicable"
        echo "6. Test with construct-patterns.sh"
    } > "$summary_file"
    
    echo -e "${GREEN}✅ Created summary: pattern-coverage-summary.md${NC}"
}

# Show help
show_help() {
    echo "Usage: $0 [options] <language> [percentage] [priority]"
    echo ""
    echo "Generate PRDs for missing CONSTRUCT pattern plugins"
    echo ""
    echo "Arguments:"
    echo "  language    Programming language name"
    echo "  percentage  Usage percentage in project (optional)"
    echo "  priority    Priority level: High|Medium|Low (optional)"
    echo ""
    echo "Options:"
    echo "  --github    Read from GitHub API JSON on stdin"
    echo "  --list      List existing pattern plugins"
    echo "  -h, --help  Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 Rust 45 High"
    echo "  $0 'Objective-C'"
    echo "  gh api repos/owner/repo/languages | $0 --github"
}

# Main logic
case "${1:-}" in
    --help|-h)
        show_help
        exit 0
        ;;
    --list)
        echo -e "${BLUE}📦 Existing Pattern Plugins:${NC}"
        find "$CONSTRUCT_CORE/patterns/plugins" -name "*.yaml" -o -name "pattern.md" | \
            sed "s|$CONSTRUCT_CORE/patterns/plugins/||" | \
            sed 's|/pattern\.md||; s|/[^/]*\.yaml||' | \
            sort -u
        exit 0
        ;;
    --github)
        # Read GitHub languages JSON from stdin
        languages_json=$(cat)
        create_prds_from_github "$languages_json"
        ;;
    "")
        show_help
        exit 1
        ;;
    *)
        # Direct language specification
        create_pattern_prd "$1" "$2" "" "$3"
        ;;
esac