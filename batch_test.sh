#!/bin/bash

# Test batch processing with simpler approach
set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Testing batch 2 categories individually...${NC}"

# Test individual category extraction for batch 2 categories
categories="tooling ui performance quality configuration"

for category in $categories; do
    echo -e "${YELLOW}Testing $category extraction...${NC}"
    
    case "$category" in
        "ui")
            description="Design tokens, visual quality, accessibility, component design patterns"
            ;;
        "performance") 
            description="Optimization patterns, rendering rules, memory management, lazy loading"
            ;;
        "quality")
            description="Professional standards, quality gates, empirical discoveries, best practices"
            ;;
        "configuration")
            description="Platform settings, Info.plist, build configuration, environment setup"
            ;;
        "tooling")
            description="Build scripts, development workflows, CI/CD, tool configurations"
            ;;
    esac
    
    echo -e "${YELLOW}Extracting $category: $description${NC}"
    
    # Simple extraction without JSON formatting
    claude -p "From this CLAUDE.md file, extract ONLY content related to: $description

Extract substantial content (10+ lines) that matches this category.
Focus on:
- Specific rules and patterns
- Code examples  
- Configuration requirements
- Best practices

Return plain markdown without headers or formatting.
If no relevant content exists, return 'NONE'." \
    CLAUDE.md.backup > "test_${category}.md" 2>/dev/null
    
    if [ -s "test_${category}.md" ] && [ $(wc -l < "test_${category}.md") -gt 5 ]; then
        echo -e "${GREEN}✅ $category: $(wc -l < "test_${category}.md") lines extracted${NC}"
        head -3 "test_${category}.md"
        echo "..."
    else
        echo -e "${RED}❌ $category: No content extracted${NC}"
    fi
    
    echo "---"
done

echo -e "${GREEN}Individual testing complete${NC}"