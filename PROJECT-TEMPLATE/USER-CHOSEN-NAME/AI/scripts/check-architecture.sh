#!/bin/bash

# Architecture Enforcement Script for CONSTRUCT Template Projects
# This ensures all architectural patterns are followed

# Source project detection library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/project-detection.sh"

# Get project paths
PROJECT_ROOT="$(get_project_root)"
PROJECT_NAME="$(get_project_name)"
XCODE_DIR="$(get_xcode_project_dir)"
IOS_DIR="$(get_ios_app_dir)"
WATCH_DIR="$(get_watch_app_dir)"
VIOLATIONS=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🏗️  CONSTRUCT Project Architecture Check"
echo "=============================="
echo ""

# Function to check for hardcoded values
check_hardcoded_values() {
    echo "Checking for hardcoded values..."
    
    violations=$(grep -r "frame.*[0-9]\|padding.*[0-9]\|font.*size:.*[0-9]\|CGFloat.*=.*[0-9]" \
        --include="*.swift" \
        "$XCODE_DIR" \
        2>/dev/null | \
        grep -v "tokens\|DesignTokens" | \
        grep -v "build/")
    
    if [ -n "$violations" ]; then
        echo -e "${RED}❌ Found hardcoded values:${NC}"
        echo "$violations" | head -5
        VIOLATIONS=$((VIOLATIONS + 1))
    else
        echo -e "${GREEN}✅ No hardcoded values found${NC}"
    fi
    echo ""
}

# Function to check MVVM compliance
check_mvvm_compliance() {
    echo "Checking MVVM compliance..."
    
    # Find Views without ViewModels
    orphan_views=""
    for view_file in $(find "$XCODE_DIR" -name "*View.swift" -type f | grep -v "ViewModel"); do
        view_name=$(basename "$view_file" .swift)
        view_model="${view_name}Model.swift"
        
        if ! find "$XCODE_DIR" -name "$view_model" -type f | grep -q .; then
            orphan_views+="  - $view_name\n"
        fi
    done
    
    if [ -n "$orphan_views" ]; then
        echo -e "${YELLOW}⚠️  Views without ViewModels:${NC}"
        echo -e "$orphan_views"
        VIOLATIONS=$((VIOLATIONS + 1))
    else
        echo -e "${GREEN}✅ All Views have ViewModels${NC}"
    fi
    
    # Check for business logic in Views
    logic_in_views=$(grep -l "URLSession\|await.*Service\|func fetch\|func load\|func save" \
        $(find "$XCODE_DIR" -name "*View.swift" -type f) 2>/dev/null)
    
    if [ -n "$logic_in_views" ]; then
        echo -e "${RED}❌ Business logic found in Views:${NC}"
        echo "$logic_in_views" | while read -r file; do
            echo "  - $(basename "$file")"
        done
        VIOLATIONS=$((VIOLATIONS + 1))
    fi
    echo ""
}

# Function to check Coordinator usage
check_coordinator_usage() {
    echo "Checking Coordinator usage..."
    
    # Check for direct navigation in Views
    direct_nav=$(grep -r "NavigationLink\|\.sheet.*isPresented\|\.fullScreenCover" \
        --include="*View.swift" \
        "$XCODE_DIR" \
        2>/dev/null | \
        grep -v "Coordinator")
    
    if [ -n "$direct_nav" ]; then
        echo -e "${RED}❌ Direct navigation found (should use Coordinator):${NC}"
        echo "$direct_nav" | head -5
        VIOLATIONS=$((VIOLATIONS + 1))
    else
        echo -e "${GREEN}✅ All navigation uses Coordinators${NC}"
    fi
    echo ""
}

# Function to check Feature Flags
check_feature_flags() {
    echo "Checking Feature Flags..."
    
    # Look for experimental or new features without flags
    unguarded_features=$(grep -r "// TODO\|// EXPERIMENTAL\|// NEW FEATURE" \
        --include="*.swift" \
        "$XCODE_DIR" \
        2>/dev/null | \
        grep -v "FeatureFlags")
    
    if [ -n "$unguarded_features" ]; then
        echo -e "${YELLOW}⚠️  Potential unguarded features:${NC}"
        echo "$unguarded_features" | head -3
    else
        echo -e "${GREEN}✅ Features appear to be properly flagged${NC}"
    fi
    echo ""
}

# Function to check component reuse
check_component_reuse() {
    echo "Checking for duplicate components..."
    
    # Common component patterns that might be duplicated
    patterns=("Button" "Loading" "Error" "Gauge" "Display")
    
    for pattern in "${patterns[@]}"; do
        similar_components=$(find "$XCODE_DIR" -name "*${pattern}*.swift" -type f | \
            grep -v "Shared/Components" | \
            wc -l)
        
        if [ "$similar_components" -gt 2 ]; then
            echo -e "${YELLOW}⚠️  Multiple ${pattern} components found outside Shared/Components${NC}"
            VIOLATIONS=$((VIOLATIONS + 1))
        fi
    done
    echo ""
}

# Function to check design token usage
check_design_tokens() {
    echo "Checking Design Token usage..."
    
    # Check if DesignTokens exist for Views
    for view_file in $(find "$XCODE_DIR/iOS-App/Features" -name "*View.swift" -type f); do
        view_dir=$(dirname "$view_file")
        view_name=$(basename "$view_file" .swift)
        tokens_file="${view_dir}/${view_name%.swift}DesignTokens.swift"
        
        if [ ! -f "$tokens_file" ]; then
            echo -e "${YELLOW}⚠️  Missing DesignTokens for $view_name${NC}"
        fi
    done
    echo ""
}

# Function to check iOS configuration in code
check_ios_configuration() {
    echo "Checking iOS Configuration Placement..."
    
    # Check for orientation settings in code
    orientation_in_code=$(grep -r "UIInterfaceOrientation\|supportedInterfaceOrientations\|UIDevice.*orientation" \
        --include="*.swift" \
        "$XCODE_DIR" \
        2>/dev/null | \
        grep -v "// Allowed")
    
    if [ -n "$orientation_in_code" ]; then
        echo -e "${RED}❌ iOS configuration found in code (should be in Xcode settings/Info.plist):${NC}"
        echo "$orientation_in_code" | head -3
        VIOLATIONS=$((VIOLATIONS + 1))
    else
        echo -e "${GREEN}✅ No iOS configuration in code${NC}"
    fi
    
    # Check for permission requests in code (should be in Info.plist)
    permissions_in_code=$(grep -r "requestAuthorization\|NSHealthStore.*requestAuthorization" \
        --include="*.swift" \
        "$XCODE_DIR" \
        2>/dev/null | \
        grep -v "Info.plist")
    
    if [ -n "$permissions_in_code" ]; then
        echo -e "${YELLOW}⚠️  Permission requests found - ensure Info.plist has usage descriptions${NC}"
    fi
    echo ""
}

# Function to check PRD compliance
check_prd_compliance() {
    echo "Checking PRD Compliance..."
    
    # Get current sprint PRD
    if [ -f "$PROJECT_ROOT/AI/PRDs/current-sprint/"*.md ]; then
        for prd in "$PROJECT_ROOT/AI/PRDs/current-sprint/"*.md; do
            if [ -f "$prd" ]; then
                prd_name=$(basename "$prd")
                echo "  Current Sprint: $prd_name"
                
                # Check specific requirements for SMVP
                if [[ "$prd_name" == *"smvp"* ]]; then
                    echo "  Checking SMVP requirements..."
                    
                    # Check for Watch connectivity implementation
                    if find "$XCODE_DIR" -name "*WatchConnection*.swift" -type f | grep -q .; then
                        echo -e "  ${GREEN}✅ Watch connectivity implementation found${NC}"
                    else
                        echo -e "  ${RED}❌ Missing Watch connectivity implementation${NC}"
                        VIOLATIONS=$((VIOLATIONS + 1))
                    fi
                    
                    # Check for HealthKit permissions
                    if grep -r "HealthKit\|HKHealthStore" "$XCODE_DIR" --include="*.swift" | grep -q .; then
                        echo -e "  ${GREEN}✅ HealthKit integration found${NC}"
                    else
                        echo -e "  ${YELLOW}⚠️  HealthKit integration not found${NC}"
                    fi
                    
                    # Check for real-time data considerations
                    if grep -r "WCSession\|sendMessage\|transferUserInfo" "$XCODE_DIR" --include="*.swift" | grep -q .; then
                        echo -e "  ${GREEN}✅ Real-time Watch communication implemented${NC}"
                    else
                        echo -e "  ${RED}❌ Missing real-time Watch communication${NC}"
                        VIOLATIONS=$((VIOLATIONS + 1))
                    fi
                    
                    # Check for latency considerations (<50ms requirement)
                    if grep -r "latency\|performance\|throttle" "$XCODE_DIR" --include="*.swift" | grep -qi "latency\|50ms"; then
                        echo -e "  ${GREEN}✅ Latency considerations found${NC}"
                    else
                        echo -e "  ${YELLOW}⚠️  No explicit latency handling found (required: <50ms)${NC}"
                    fi
                fi
                
                # Check for components mentioned in PRD but not implemented
                echo ""
                echo "  Checking PRD-mentioned components..."
                key_components=$(grep -E "MainView|SPM.*[Gg]auge|BPM.*[Gg]auge|ConnectWearable" "$prd" | grep -v "^#" | head -5)
                if [ -n "$key_components" ]; then
                    while IFS= read -r component; do
                        component_name=$(echo "$component" | grep -oE "(MainView|SPM.*[Gg]auge|BPM.*[Gg]auge|ConnectWearable)" | head -1)
                        if [ -n "$component_name" ]; then
                            if find "$XCODE_DIR" -name "*${component_name}*.swift" -type f | grep -q .; then
                                echo -e "  ${GREEN}✅ $component_name implemented${NC}"
                            else
                                echo -e "  ${YELLOW}⚠️  $component_name mentioned in PRD but not found${NC}"
                            fi
                        fi
                    done <<< "$key_components"
                fi
            fi
        done
    else
        echo -e "  ${YELLOW}⚠️  No active sprint PRD found${NC}"
    fi
    echo ""
}

# Function to suggest existing components
suggest_components() {
    if [ -n "$1" ]; then
        echo "🔍 Looking for components similar to '$1'..."
        
        echo "Existing components you might reuse:"
        find "$XCODE_DIR/iOS-App/Shared/Components" -name "*.swift" -type f | \
            while read -r component; do
                echo "  - $(basename "$component")"
            done
        
        echo ""
        echo "Existing utilities:"
        find "$XCODE_DIR/iOS-App/Shared/Utilities" -name "*.swift" -type f | \
            while read -r util; do
                echo "  - $(basename "$util")"
            done
    fi
}

# Main execution
echo "Running architecture checks..."
echo ""

check_hardcoded_values
check_mvvm_compliance
check_coordinator_usage
check_feature_flags
check_component_reuse
check_design_tokens
check_ios_configuration
check_prd_compliance

# If component name provided, suggest existing components
if [ "$1" == "--component" ] && [ -n "$2" ]; then
    suggest_components "$2"
fi

# Summary
echo "=============================="
if [ $VIOLATIONS -eq 0 ]; then
    echo -e "${GREEN}✅ All architecture checks passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Found $VIOLATIONS architecture violations${NC}"
    echo ""
    echo "Run with --fix to see suggested fixes"
    exit 1
fi