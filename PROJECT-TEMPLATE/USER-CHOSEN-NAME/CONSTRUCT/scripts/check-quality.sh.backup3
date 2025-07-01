#!/bin/bash

# Quality Check Script
# Based on SwiftUI Standards v3.0 quality gates

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$PROJECT_ROOT"

echo "🔍 Running Quality Checks..."
echo ""

# Check 1: Hardcoded values
echo "### 1. Checking for hardcoded values (should use tokens instead)..."
HARDCODED=$(grep -r "CGFloat.*= [0-9]" . --include="*.swift" | grep -v "tokens" | grep -v "test" | grep -v "Test")
if [ -z "$HARDCODED" ]; then
    echo "✅ No hardcoded CGFloat values found"
else
    echo "❌ Found hardcoded values:"
    echo "$HARDCODED" | head -10
    echo ""
fi

# Check 2: Constants enums (forbidden pattern)
echo "### 2. Checking for Constants enums (forbidden pattern)..."
CONSTANTS=$(grep -r "private enum Constants" . --include="*.swift")
if [ -z "$CONSTANTS" ]; then
    echo "✅ No Constants enums found"
else
    echo "❌ Found Constants enums (should use tokens):"
    echo "$CONSTANTS"
    echo ""
fi

# Check 3: Token usage verification
echo "### 3. Verifying token usage..."
TOKEN_COUNT=$(grep -r "tokens\." . --include="*.swift" | wc -l | tr -d ' ')
echo "📊 Found $TOKEN_COUNT token usages"
if [ "$TOKEN_COUNT" -lt 10 ]; then
    echo "⚠️  Low token usage - ensure new components use design tokens"
fi
echo ""

# Check 4: MARK organization
echo "### 4. Checking MARK comment organization..."
FILES_WITHOUT_MARKS=$(find . -name "*View.swift" -o -name "*ViewModel.swift" | while read -r file; do
    if ! grep -q "// MARK: -" "$file"; then
        echo "$file"
    fi
done)

if [ -z "$FILES_WITHOUT_MARKS" ]; then
    echo "✅ All View/ViewModel files have MARK organization"
else
    echo "⚠️  Files missing MARK organization:"
    echo "$FILES_WITHOUT_MARKS"
fi
echo ""

# Check 5: Background flash prevention
echo "### 5. Checking for background flash prevention patterns..."
SINGLE_BG=$(grep -r "\.ignoresSafeArea()" . --include="*.swift" | grep -v "ZStack")
if [ -z "$SINGLE_BG" ]; then
    echo "✅ No single-layer backgrounds found"
else
    echo "⚠️  Potential flash-prone backgrounds (need ZStack multi-layer):"
    echo "$SINGLE_BG" | head -5
fi
echo ""

# Check 6: Async/await usage
echo "### 6. Checking modern async/await patterns..."
COMPLETION_HANDLERS=$(grep -r "completion:" . --include="*.swift" | grep -v "test" | grep -v "Test")
if [ -z "$COMPLETION_HANDLERS" ]; then
    echo "✅ No completion handlers found (using async/await)"
else
    echo "⚠️  Found completion handlers (should use async/await):"
    echo "$COMPLETION_HANDLERS" | head -5
fi
echo ""

# Check 7: @MainActor usage for UI updates
echo "### 7. Checking @MainActor usage..."
check_mainactor_usage() {
    # Find ViewModels without @MainActor
    NO_MAINACTOR=$(grep -L "@MainActor" $(find . -name "*ViewModel.swift" 2>/dev/null) 2>/dev/null)
    
    # Find UI updates without MainActor context
    UI_WITHOUT_MAINACTOR=$(grep -r "DispatchQueue\.main\|\.sink.*\$\|\.assign.*\$" \
        --include="*ViewModel.swift" \
        "$PROJECT_ROOT" 2>/dev/null | grep -v "@MainActor")
    
    if [ -z "$NO_MAINACTOR" ] && [ -z "$UI_WITHOUT_MAINACTOR" ]; then
        echo "✅ All ViewModels properly use @MainActor"
    else
        if [ -n "$NO_MAINACTOR" ]; then
            echo "❌ ViewModels missing @MainActor annotation:"
            echo "$NO_MAINACTOR" | head -5
        fi
        if [ -n "$UI_WITHOUT_MAINACTOR" ]; then
            echo "❌ UI updates without @MainActor context:"
            echo "$UI_WITHOUT_MAINACTOR" | head -5
        fi
    fi
}
check_mainactor_usage
echo ""

# Check 8: Business logic in Views
echo "### 8. Checking for business logic in Views..."
check_business_logic_in_views() {
    # Look for API calls, calculations, data processing in Views
    LOGIC_IN_VIEWS=$(grep -r "URLSession\|\.map{\|\.filter{\|\.reduce\|Task {.*await\|\.calculate\|\.process\|Service\(\)" \
        --include="*View.swift" \
        "$PROJECT_ROOT" 2>/dev/null | \
        grep -v "// UI Only\|viewModel\.\|vm\.")
    
    if [ -z "$LOGIC_IN_VIEWS" ]; then
        echo "✅ No business logic found in Views"
    else
        echo "❌ Business logic found in Views (should be in ViewModel):"
        echo "$LOGIC_IN_VIEWS" | head -10
        echo ""
        echo "   Fix: Move business logic to ViewModels"
        echo "   Pattern: View → ViewModel → Service"
    fi
}
check_business_logic_in_views
echo ""

# Check 9: @State misuse
echo "### 9. Checking @State usage..."
check_state_usage() {
    # Find @State used for business data
    BAD_STATE=$(grep -r "@State.*:.*\[\]\|@State.*:.*Service\|@State.*:.*Model\|@State.*users\|@State.*products\|@State.*data" \
        --include="*View.swift" \
        "$PROJECT_ROOT" 2>/dev/null | \
        grep -v "isShowing\|isPresented\|isAnimating\|selectedTab\|animation")
    
    if [ -z "$BAD_STATE" ]; then
        echo "✅ @State used correctly (UI-only state)"
    else
        echo "❌ @State used for business data (should be @Published in ViewModel):"
        echo "$BAD_STATE" | head -5
        echo ""
        echo "   Fix: Move business data to ViewModel with @Published"
        echo "   OK: @State for isShowingSheet, selectedTab, animationAmount"
        echo "   NOT OK: @State for users, products, business data"
    fi
}
check_state_usage
echo ""

# Check 10: Modern SwiftUI patterns
echo "### 10. Checking modern SwiftUI patterns..."
check_modern_patterns() {
    # Check for NavigationView usage (deprecated in iOS 16+)
    NAV_VIEW=$(grep -r "NavigationView\s*{" --include="*.swift" "$PROJECT_ROOT" 2>/dev/null | grep -v "navigationViewStyle")
    
    # Check for onChange with async work
    ONCHANGE_ASYNC=$(grep -r "\.onChange.*{.*Task\|\.onChange.*{.*async" --include="*.swift" "$PROJECT_ROOT" 2>/dev/null)
    
    # Check for @ObservedObject misuse
    OBSERVED_MISUSE=$(grep -r "@ObservedObject.*=.*ViewModel()" --include="*.swift" "$PROJECT_ROOT" 2>/dev/null)
    
    if [ -z "$NAV_VIEW" ] && [ -z "$ONCHANGE_ASYNC" ] && [ -z "$OBSERVED_MISUSE" ]; then
        echo "✅ Using modern SwiftUI patterns"
    else
        if [ -n "$NAV_VIEW" ]; then
            echo "⚠️  NavigationView usage (use NavigationStack for iOS 16+):"
            echo "$NAV_VIEW" | head -3
        fi
        if [ -n "$ONCHANGE_ASYNC" ]; then
            echo "⚠️  onChange with async work (use .task instead):"
            echo "$ONCHANGE_ASYNC" | head -3
        fi
        if [ -n "$OBSERVED_MISUSE" ]; then
            echo "❌ @ObservedObject creating ViewModels (use @StateObject):"
            echo "$OBSERVED_MISUSE" | head -3
        fi
    fi
}
check_modern_patterns
echo ""

# Check 11: Performance patterns
echo "### 11. Checking performance patterns..."
check_performance() {
    # Check for non-lazy stacks with many items
    LARGE_STACKS=$(grep -r "ForEach.*\.indices\|ForEach.*0\.\.<[0-9][0-9]" --include="*.swift" "$PROJECT_ROOT" 2>/dev/null | \
        grep -B2 -A2 "VStack\|HStack" | grep -v "Lazy")
    
    # Check for ForEach without stable IDs
    UNSTABLE_IDS=$(grep -r "ForEach.*\.indices\|ForEach.*id:.*\\.self" --include="*.swift" "$PROJECT_ROOT" 2>/dev/null | \
        grep -v "\.id\|Identifiable")
    
    if [ -z "$LARGE_STACKS" ] && [ -z "$UNSTABLE_IDS" ]; then
        echo "✅ Performance patterns look good"
    else
        if [ -n "$LARGE_STACKS" ]; then
            echo "⚠️  Large non-lazy stacks found (use LazyVStack/LazyHStack):"
            echo "$LARGE_STACKS" | head -5
        fi
        if [ -n "$UNSTABLE_IDS" ]; then
            echo "⚠️  ForEach with potentially unstable IDs:"
            echo "$UNSTABLE_IDS" | head -5
        fi
    fi
}
check_performance
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Quality check complete. Fix any ❌ issues before committing."
echo ""
echo "For detailed standards, see: ./AI/docs/standards/swiftui-standards.md"
echo "For MVVM patterns, see: CLAUDE.md"