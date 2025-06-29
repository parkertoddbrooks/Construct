#!/bin/bash

# Construct Pre-Coding Discovery Tool
# Shows what already exists before creating new components

# Get script directory and project root
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../../.." && pwd )"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if component name provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Please provide a component name${NC}"
    echo "Usage: construct-before ComponentName"
    exit 1
fi

COMPONENT_NAME="$1"

echo -e "${BLUE}🔍 Construct Pre-Coding Check: $COMPONENT_NAME${NC}"
echo "============================================"
echo ""

# Function to check existing components
check_existing_components() {
    echo -e "${CYAN}📦 Checking for existing components...${NC}"
    
    # Search for similar files
    similar_files=$(find "$PROJECT_ROOT/Template" -name "*${COMPONENT_NAME}*.swift" -type f 2>/dev/null)
    
    if [ -n "$similar_files" ]; then
        echo -e "${YELLOW}Found similar components:${NC}"
        echo "$similar_files" | while read -r file; do
            echo "  - $(basename "$file") in $(dirname "$file" | sed "s|$PROJECT_ROOT/||")"
        done
    else
        echo -e "${GREEN}✅ No similar components found${NC}"
    fi
    echo ""
}

# Function to check shared components
check_shared_components() {
    echo -e "${CYAN}🧩 Available shared components:${NC}"
    
    if [ -d "$PROJECT_ROOT/Template/iOS-App/Shared/Components" ]; then
        components=$(find "$PROJECT_ROOT/Template/iOS-App/Shared/Components" -name "*.swift" -type f 2>/dev/null)
        if [ -n "$components" ]; then
            echo "$components" | while read -r component; do
                echo "  - $(basename "$component" .swift)"
            done
        else
            echo "  No shared components yet"
        fi
    else
        echo "  Shared components directory not found"
    fi
    echo ""
}

# Function to check design tokens
check_design_tokens() {
    echo -e "${CYAN}🎨 Available design tokens:${NC}"
    
    tokens=$(find "$PROJECT_ROOT/Template" -name "*Tokens.swift" -type f 2>/dev/null)
    if [ -n "$tokens" ]; then
        echo "$tokens" | while read -r token; do
            echo "  - $(basename "$token" .swift)"
        done
    else
        echo "  No design tokens found"
    fi
    echo ""
}

# Function to check PRD alignment
check_prd_alignment() {
    echo -e "${CYAN}📋 Checking PRD alignment...${NC}"
    
    # Check current sprint PRDs
    if ls "$PROJECT_ROOT/Template/AI/PRDs/current-sprint/"*.md 2>/dev/null | head -1 > /dev/null; then
        for prd in "$PROJECT_ROOT/Template/AI/PRDs/current-sprint/"*.md; do
            if [ -f "$prd" ]; then
                # Search for component name in PRD
                if grep -qi "$COMPONENT_NAME" "$prd"; then
                    echo -e "${GREEN}✅ Component mentioned in PRD: $(basename "$prd")${NC}"
                    
                    # Show relevant lines
                    echo -e "${YELLOW}Relevant sections:${NC}"
                    grep -i -B1 -A1 "$COMPONENT_NAME" "$prd" | head -6
                else
                    echo -e "${YELLOW}⚠️  Component not found in current sprint PRD${NC}"
                fi
            fi
        done
    else
        echo -e "${YELLOW}⚠️  No active sprint PRD found${NC}"
    fi
    echo ""
}

# Function to suggest structure
suggest_structure() {
    echo -e "${CYAN}📁 Suggested structure for $COMPONENT_NAME:${NC}"
    
    # Determine component type
    if [[ "$COMPONENT_NAME" == *"View" ]]; then
        echo "Feature structure:"
        echo "  Template/iOS-App/Features/$COMPONENT_NAME/"
        echo "    ├── ${COMPONENT_NAME}.swift"
        echo "    ├── ${COMPONENT_NAME}Model.swift"
        echo "    └── ${COMPONENT_NAME}Tokens.swift"
        
        echo ""
        echo -e "${YELLOW}Commands to create:${NC}"
        echo "  mkdir -p Template/iOS-App/Features/$COMPONENT_NAME"
        echo "  touch Template/iOS-App/Features/$COMPONENT_NAME/${COMPONENT_NAME}.swift"
        echo "  touch Template/iOS-App/Features/$COMPONENT_NAME/${COMPONENT_NAME}Model.swift"
        echo "  touch Template/iOS-App/Features/$COMPONENT_NAME/${COMPONENT_NAME}Tokens.swift"
        
    elif [[ "$COMPONENT_NAME" == *"Service" ]]; then
        echo "Service structure:"
        echo "  Template/iOS-App/Services/"
        echo "    ├── ${COMPONENT_NAME}Protocol.swift"
        echo "    └── ${COMPONENT_NAME}.swift"
        
        echo ""
        echo -e "${YELLOW}Commands to create:${NC}"
        echo "  touch Template/iOS-App/Services/${COMPONENT_NAME}Protocol.swift"
        echo "  touch Template/iOS-App/Services/${COMPONENT_NAME}.swift"
        
    else
        echo "Component structure:"
        echo "  Template/iOS-App/Shared/Components/${COMPONENT_NAME}.swift"
        
        echo ""
        echo -e "${YELLOW}Command to create:${NC}"
        echo "  touch Template/iOS-App/Shared/Components/${COMPONENT_NAME}.swift"
    fi
    echo ""
}

# Function to show patterns
show_patterns() {
    echo -e "${CYAN}📚 Patterns to follow:${NC}"
    
    if [[ "$COMPONENT_NAME" == *"View" ]]; then
        cat << 'EOF'
// View Pattern
struct ExampleView: View {
    @StateObject private var viewModel: ExampleViewModel
    private let tokens: ExampleTokens
    
    init(tokens: ExampleTokens = .default) {
        self.tokens = tokens
        self._viewModel = StateObject(wrappedValue: ExampleViewModel())
    }
    
    var body: some View {
        // UI implementation
    }
}

// ViewModel Pattern
@MainActor
class ExampleViewModel: ObservableObject {
    @Published private(set) var state: ViewState = .idle
    
    private let service: ExampleServiceProtocol
    
    init(service: ExampleServiceProtocol = ExampleService()) {
        self.service = service
    }
    
    func loadData() async {
        // Business logic
    }
}
EOF
    elif [[ "$COMPONENT_NAME" == *"Service" ]]; then
        cat << 'EOF'
// Service Protocol
protocol ExampleServiceProtocol {
    func fetchData() async throws -> [Model]
}

// Service Implementation
class ExampleService: ExampleServiceProtocol {
    func fetchData() async throws -> [Model] {
        // Implementation
    }
}
EOF
    fi
    echo ""
}

# Main execution
check_existing_components
check_shared_components
check_design_tokens
check_prd_alignment
suggest_structure
show_patterns

# Summary
echo "============================================"
echo -e "${GREEN}Ready to create $COMPONENT_NAME?${NC}"
echo ""
echo "Next steps:"
echo "1. Review existing components above"
echo "2. Check if you can reuse any shared components"
echo "3. Follow the suggested structure"
echo "4. Use 'construct-new $COMPONENT_NAME' to create from template"
echo ""
echo -e "${BLUE}Trust The Process.${NC}"