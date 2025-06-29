#!/bin/bash

# Construct Architecture Enforcement Script
# Ensures all architectural patterns are followed

# Get script directory and project root
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../../.." && pwd )"
VIOLATIONS=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🏗️  Construct Architecture Check${NC}"
echo "=============================="
echo ""

# Function to check for hardcoded values
check_hardcoded_values() {
    echo "Checking for hardcoded values..."
    
    violations=$(grep -r "frame.*[0-9]\|padding.*[0-9]\|font.*size:.*[0-9]\|CGFloat.*=.*[0-9]" \
        --include="*.swift" \
        "$PROJECT_ROOT/Template" \
        2>/dev/null | \
        grep -v "tokens\|Tokens\|DesignTokens" | \
        grep -v "build/")
    
    if [ -n "$violations" ]; then
        echo -e "${RED}❌ Found hardcoded values:${NC}"
        echo "$violations" | head -5
        echo -e "${YELLOW}   Fix: Use design tokens instead of hardcoded values${NC}"
        VIOLATIONS=$((VIOLATIONS + 1))
    else
        echo -e "${GREEN}✅ No hardcoded values found${NC}"
    fi
    echo ""
}

# Function to check MVVM compliance
check_mvvm_compliance() {
    echo "Checking MVVM compliance..."
    
    # Find Views without ViewModels (excluding shared components)
    orphan_views=""
    for view_file in $(find "$PROJECT_ROOT/Template" -name "*View.swift" -type f | grep -v "Shared/Components" | grep -v "ViewModel"); do
        view_name=$(basename "$view_file" .swift)
        view_model="${view_name}Model.swift"
        
        # Skip if it's a subview or component
        if [[ "$view_name" == *"Component"* ]] || [[ "$view_name" == *"Button"* ]] || [[ "$view_name" == *"Cell"* ]]; then
            continue
        fi
        
        if ! find "$PROJECT_ROOT/Template" -name "$view_model" -type f | grep -q .; then
            orphan_views+="  - $view_name\n"
        fi
    done
    
    if [ -n "$orphan_views" ]; then
        echo -e "${YELLOW}⚠️  Views without ViewModels:${NC}"
        echo -e "$orphan_views"
        echo -e "${YELLOW}   Fix: Create corresponding ViewModels for these Views${NC}"
        VIOLATIONS=$((VIOLATIONS + 1))
    else
        echo -e "${GREEN}✅ All Views have ViewModels${NC}"
    fi
    
    # Check for business logic in Views
    logic_in_views=$(grep -l "URLSession\|await.*Service\|func fetch\|func load\|func save\|API\|Database" \
        $(find "$PROJECT_ROOT/Template" -name "*View.swift" -type f) 2>/dev/null)
    
    if [ -n "$logic_in_views" ]; then
        echo -e "${RED}❌ Business logic found in Views:${NC}"
        echo "$logic_in_views" | while read -r file; do
            echo "  - $(basename "$file")"
        done
        echo -e "${YELLOW}   Fix: Move business logic to ViewModels${NC}"
        VIOLATIONS=$((VIOLATIONS + 1))
    else
        echo -e "${GREEN}✅ No business logic in Views${NC}"
    fi
    echo ""
}

# Function to check navigation patterns
check_navigation_patterns() {
    echo "Checking navigation patterns..."
    
    # Check for direct NavigationLink usage without coordinators
    direct_nav=$(grep -r "NavigationLink.*destination:" \
        --include="*View.swift" \
        "$PROJECT_ROOT/Template" \
        2>/dev/null | \
        grep -v "coordinator\|Coordinator")
    
    if [ -n "$direct_nav" ]; then
        echo -e "${YELLOW}⚠️  Direct navigation found (consider using Coordinator):${NC}"
        echo "$direct_nav" | head -3
        echo -e "${YELLOW}   Fix: Use coordinator.navigate(to: .feature) pattern${NC}"
    else
        echo -e "${GREEN}✅ Navigation follows coordinator pattern${NC}"
    fi
    echo ""
}

# Function to check for @State misuse
check_state_usage() {
    echo "Checking @State usage..."
    
    # Check for @State used with business data
    state_misuse=$(grep -r "@State.*\(User\|Product\|Order\|Customer\|Account\|Item\|Model\)" \
        --include="*.swift" \
        "$PROJECT_ROOT/Template" \
        2>/dev/null)
    
    if [ -n "$state_misuse" ]; then
        echo -e "${RED}❌ @State used for business data:${NC}"
        echo "$state_misuse" | head -3
        echo -e "${YELLOW}   Fix: Use @Published in ViewModel for business data${NC}"
        VIOLATIONS=$((VIOLATIONS + 1))
    else
        echo -e "${GREEN}✅ @State used correctly (UI state only)${NC}"
    fi
    echo ""
}

# Function to check Swift 6 patterns
check_swift6_patterns() {
    echo "Checking Swift 6 patterns..."
    
    # Check for @MainActor on ViewModels
    viewmodels_without_mainactor=$(find "$PROJECT_ROOT/Template" -name "*ViewModel.swift" -type f | \
        while read -r file; do
            if ! grep -q "@MainActor" "$file"; then
                echo "  - $(basename "$file")"
            fi
        done)
    
    if [ -n "$viewmodels_without_mainactor" ]; then
        echo -e "${YELLOW}⚠️  ViewModels without @MainActor:${NC}"
        echo "$viewmodels_without_mainactor"
        echo -e "${YELLOW}   Fix: Add @MainActor to ViewModel classes${NC}"
    else
        echo -e "${GREEN}✅ All ViewModels use @MainActor${NC}"
    fi
    
    # Check for DispatchQueue.main usage
    dispatch_usage=$(grep -r "DispatchQueue.main" \
        --include="*.swift" \
        "$PROJECT_ROOT/Template" \
        2>/dev/null)
    
    if [ -n "$dispatch_usage" ]; then
        echo -e "${YELLOW}⚠️  DispatchQueue.main usage found:${NC}"
        echo "$dispatch_usage" | head -3
        echo -e "${YELLOW}   Fix: Use async/await with @MainActor instead${NC}"
    fi
    echo ""
}

# Function to check design token usage
check_design_tokens() {
    echo "Checking Design Token usage..."
    
    # Check if DesignTokens exist for feature Views
    missing_tokens=0
    for view_file in $(find "$PROJECT_ROOT/Template/iOS-App/Features" -name "*View.swift" -type f 2>/dev/null); do
        view_dir=$(dirname "$view_file")
        view_name=$(basename "$view_file" .swift)
        
        # Skip if it's a subview
        if [[ "$view_name" == *"Sub"* ]] || [[ "$view_name" == *"Cell"* ]]; then
            continue
        fi
        
        tokens_file="${view_dir}/*Tokens.swift"
        if ! ls $tokens_file 2>/dev/null | grep -q .; then
            echo -e "${YELLOW}⚠️  Missing DesignTokens for $view_name${NC}"
            missing_tokens=$((missing_tokens + 1))
        fi
    done
    
    if [ $missing_tokens -eq 0 ]; then
        echo -e "${GREEN}✅ All features have design tokens${NC}"
    else
        echo -e "${YELLOW}   Fix: Create DesignTokens.swift for each feature${NC}"
    fi
    echo ""
}

# Function to check iOS configuration in code
check_ios_configuration() {
    echo "Checking iOS Configuration placement..."
    
    # Check for orientation settings in code
    orientation_in_code=$(grep -r "UIInterfaceOrientation\|supportedInterfaceOrientations\|UIDevice.*orientation" \
        --include="*.swift" \
        "$PROJECT_ROOT/Template" \
        2>/dev/null | \
        grep -v "// Allowed\|// Info.plist")
    
    if [ -n "$orientation_in_code" ]; then
        echo -e "${RED}❌ iOS configuration found in code:${NC}"
        echo "$orientation_in_code" | head -3
        echo -e "${YELLOW}   Fix: Move to Xcode project settings or Info.plist${NC}"
        VIOLATIONS=$((VIOLATIONS + 1))
    else
        echo -e "${GREEN}✅ No iOS configuration in code${NC}"
    fi
    echo ""
}

# Function to check accessibility
check_accessibility() {
    echo "Checking accessibility compliance..."
    
    # Check for images without accessibility labels
    images_without_labels=$(grep -r "Image(\|\.image(\|systemName:" \
        --include="*.swift" \
        "$PROJECT_ROOT/Template" \
        2>/dev/null | \
        grep -v "accessibilityLabel\|decorative")
    
    if [ -n "$images_without_labels" ]; then
        echo -e "${YELLOW}⚠️  Images without accessibility labels:${NC}"
        echo "$images_without_labels" | head -3
        echo -e "${YELLOW}   Fix: Add .accessibilityLabel() to all images${NC}"
    else
        echo -e "${GREEN}✅ Images have accessibility labels${NC}"
    fi
    
    # Check for fixed font sizes
    fixed_fonts=$(grep -r "\.font.*size:.*[0-9]" \
        --include="*.swift" \
        "$PROJECT_ROOT/Template" \
        2>/dev/null | \
        grep -v "tokens\|dynamicTypeSize")
    
    if [ -n "$fixed_fonts" ]; then
        echo -e "${YELLOW}⚠️  Fixed font sizes found:${NC}"
        echo "$fixed_fonts" | head -3
        echo -e "${YELLOW}   Fix: Use Dynamic Type (.font(.body), .font(.title))${NC}"
    fi
    echo ""
}

# Function to check PRD compliance
check_prd_compliance() {
    echo "Checking PRD compliance..."
    
    # Get current sprint PRD
    if ls "$PROJECT_ROOT/Template/AI/PRDs/current-sprint/"*.md 2>/dev/null | head -1 > /dev/null; then
        for prd in "$PROJECT_ROOT/Template/AI/PRDs/current-sprint/"*.md; do
            if [ -f "$prd" ]; then
                prd_name=$(basename "$prd")
                echo "  Current Sprint: $prd_name"
                
                # Extract and check key requirements
                requirements=$(grep -E "^- \[.\]" "$prd" 2>/dev/null)
                if [ -n "$requirements" ]; then
                    incomplete=$(echo "$requirements" | grep -c "^\- \[ \]")
                    complete=$(echo "$requirements" | grep -c "^\- \[x\]")
                    
                    if [ $incomplete -gt 0 ]; then
                        echo -e "  ${YELLOW}⚠️  $incomplete incomplete requirements${NC}"
                    fi
                    if [ $complete -gt 0 ]; then
                        echo -e "  ${GREEN}✅ $complete completed requirements${NC}"
                    fi
                fi
            fi
        done
    else
        echo -e "  ${YELLOW}⚠️  No active sprint PRD found${NC}"
        echo -e "  ${YELLOW}   Fix: Create a PRD in Template/AI/PRDs/current-sprint/${NC}"
    fi
    echo ""
}

# Function to check for anti-patterns
check_antipatterns() {
    echo "Checking for anti-patterns..."
    
    # Check for Constants enum (forbidden pattern)
    constants_enum=$(grep -r "enum Constants\|enum AppConstants" \
        --include="*.swift" \
        "$PROJECT_ROOT/Template" \
        2>/dev/null)
    
    if [ -n "$constants_enum" ]; then
        echo -e "${RED}❌ Constants enum found (forbidden pattern):${NC}"
        echo "$constants_enum" | head -3
        echo -e "${YELLOW}   Fix: Use design tokens or configuration files${NC}"
        VIOLATIONS=$((VIOLATIONS + 1))
    else
        echo -e "${GREEN}✅ No Constants enum found${NC}"
    fi
    
    # Check for Spacer with frame
    spacer_frame=$(grep -r "Spacer().*\.frame" \
        --include="*.swift" \
        "$PROJECT_ROOT/Template" \
        2>/dev/null)
    
    if [ -n "$spacer_frame" ]; then
        echo -e "${YELLOW}⚠️  Spacer().frame() found:${NC}"
        echo "$spacer_frame" | head -3
        echo -e "${YELLOW}   Fix: Use Color.clear.frame() instead${NC}"
    fi
    echo ""
}

# Function to suggest existing components
suggest_components() {
    if [ -n "$1" ]; then
        echo -e "${BLUE}🔍 Looking for components similar to '$1'...${NC}"
        
        echo "Existing components you might reuse:"
        find "$PROJECT_ROOT/Template/iOS-App/Shared/Components" -name "*.swift" -type f 2>/dev/null | \
            while read -r component; do
                echo "  - $(basename "$component")"
            done
        
        echo ""
        echo "Existing design tokens:"
        find "$PROJECT_ROOT/Template" -name "*Tokens.swift" -type f 2>/dev/null | \
            while read -r tokens; do
                echo "  - $(basename "$tokens")"
            done
    fi
}

# Main execution
echo "Running architecture checks..."
echo ""

check_hardcoded_values
check_mvvm_compliance
check_navigation_patterns
check_state_usage
check_swift6_patterns
check_design_tokens
check_ios_configuration
check_accessibility
check_prd_compliance
check_antipatterns

# If component name provided, suggest existing components
if [ "$1" == "--component" ] && [ -n "$2" ]; then
    suggest_components "$2"
fi

# Summary
echo "=============================="
if [ $VIOLATIONS -eq 0 ]; then
    echo -e "${GREEN}✅ All architecture checks passed!${NC}"
    echo -e "${GREEN}Trust The Process.${NC}"
    exit 0
else
    echo -e "${RED}❌ Found $VIOLATIONS architecture violations${NC}"
    echo ""
    echo "Run 'construct-protect' for quality checks"
    echo "Run 'construct-update' to update CLAUDE.md"
    exit 1
fi