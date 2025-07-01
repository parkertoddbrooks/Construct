#!/bin/bash

# Accessibility Check Script
# Ensures professional UI quality and accessibility standards

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$PROJECT_ROOT"

echo "♿ Running Accessibility Checks..."
echo ""

# Check 1: Images without accessibility labels
echo "### 1. Checking for images without accessibility labels..."
check_image_accessibility() {
    # Find Image() calls without .accessibilityLabel
    IMAGES_NO_LABEL=$(grep -r "Image(" --include="*.swift" "$PROJECT_ROOT" 2>/dev/null | \
        grep -v "\.accessibilityLabel\|systemName\|// Test\|Preview" | \
        grep -v "SF Symbols")
    
    if [ -z "$IMAGES_NO_LABEL" ]; then
        echo "✅ All images have accessibility labels"
    else
        echo "❌ Images missing accessibility labels:"
        echo "$IMAGES_NO_LABEL" | head -10
        echo ""
        echo "   Fix: Add .accessibilityLabel(\"Description\") to all images"
    fi
}
check_image_accessibility
echo ""

# Check 2: Buttons without accessible text
echo "### 2. Checking button accessibility..."
check_button_accessibility() {
    # Find Button with only images or unclear labels
    BUTTONS_NO_TEXT=$(grep -r "Button.*{.*Image\|Button {" --include="*.swift" "$PROJECT_ROOT" 2>/dev/null | \
        grep -v "Text(\|\.accessibilityLabel\|label:")
    
    if [ -z "$BUTTONS_NO_TEXT" ]; then
        echo "✅ All buttons have accessible text"
    else
        echo "⚠️  Buttons may need accessibility labels:"
        echo "$BUTTONS_NO_TEXT" | head -5
        echo ""
        echo "   Fix: Add label: or .accessibilityLabel for icon-only buttons"
    fi
}
check_button_accessibility
echo ""

# Check 3: Dynamic Type support
echo "### 3. Checking Dynamic Type support..."
check_dynamic_type() {
    # Find fixed font sizes
    FIXED_FONTS=$(grep -r "\.font(\.system(size:\s*[0-9]\|\.font(\.custom.*size:\s*[0-9]" --include="*.swift" "$PROJECT_ROOT" 2>/dev/null | \
        grep -v "// Fixed intentionally\|tokens\.")
    
    if [ -z "$FIXED_FONTS" ]; then
        echo "✅ Using Dynamic Type (no fixed font sizes)"
    else
        echo "❌ Fixed font sizes found (breaks Dynamic Type):"
        echo "$FIXED_FONTS" | head -10
        echo ""
        echo "   Fix: Use .font(.title), .font(.body), etc."
        echo "   Or: Use design tokens for responsive sizing"
    fi
}
check_dynamic_type
echo ""

# Check 4: Color-only state indicators
echo "### 4. Checking for color-only state indicators..."
check_color_indicators() {
    # Look for foregroundColor without accompanying text/icon changes
    COLOR_ONLY=$(grep -r "\.foregroundColor.*?.*:" --include="*.swift" "$PROJECT_ROOT" 2>/dev/null | \
        grep -v "Text\|Image\|Icon")
    
    if [ -z "$COLOR_ONLY" ]; then
        echo "✅ No color-only state indicators found"
    else
        echo "⚠️  Potential color-only indicators:"
        echo "$COLOR_ONLY" | head -5
        echo ""
        echo "   Fix: Add icon or text changes alongside color"
    fi
}
check_color_indicators
echo ""

# Check 5: VoiceOver navigation
echo "### 5. Checking VoiceOver navigation support..."
check_voiceover() {
    # Check for accessibility modifiers
    ACCESSIBILITY_MODS=$(grep -r "\.accessibility\|\.accessibilityElement\|\.accessibilityHidden" --include="*.swift" "$PROJECT_ROOT" 2>/dev/null | wc -l | tr -d ' ')
    
    # Check for semantic grouping
    GROUPS=$(grep -r "\.accessibilityElement(children: .combine)" --include="*.swift" "$PROJECT_ROOT" 2>/dev/null | wc -l | tr -d ' ')
    
    echo "📊 Found $ACCESSIBILITY_MODS accessibility modifiers"
    echo "📊 Found $GROUPS accessibility groupings"
    
    if [ "$ACCESSIBILITY_MODS" -lt 10 ]; then
        echo "⚠️  Low accessibility modifier usage - consider adding more"
    else
        echo "✅ Good accessibility modifier coverage"
    fi
}
check_voiceover
echo ""

# Check 6: Interactive element sizes
echo "### 6. Checking tap target sizes..."
check_tap_targets() {
    # Find potentially small tap targets
    SMALL_TARGETS=$(grep -r "\.frame.*height:\s*[0-3][0-9]\|\.frame.*width:\s*[0-3][0-9]" --include="*.swift" "$PROJECT_ROOT" 2>/dev/null | \
        grep -B2 -A2 "Button\|onTapGesture" | \
        grep -v "44\|tokens\.")
    
    if [ -z "$SMALL_TARGETS" ]; then
        echo "✅ Tap targets appear appropriately sized"
    else
        echo "⚠️  Potentially small tap targets (minimum 44pt):"
        echo "$SMALL_TARGETS" | head -5
    fi
}
check_tap_targets
echo ""

# Check 7: Text contrast
echo "### 7. Checking for potential contrast issues..."
check_contrast() {
    # Look for light colors on light backgrounds or dark on dark
    CONTRAST_ISSUES=$(grep -r "\.foregroundColor.*gray\|\.foregroundColor.*opacity(0\.[0-6]" --include="*.swift" "$PROJECT_ROOT" 2>/dev/null)
    
    if [ -z "$CONTRAST_ISSUES" ]; then
        echo "✅ No obvious contrast issues found"
    else
        echo "⚠️  Potential contrast issues:"
        echo "$CONTRAST_ISSUES" | head -5
        echo ""
        echo "   Note: Ensure WCAG AA compliance (4.5:1 for normal text)"
    fi
}
check_contrast
echo ""

# Check 8: Loading states
echo "### 8. Checking loading state accessibility..."
check_loading_states() {
    # Find ProgressView without labels
    PROGRESS_NO_LABEL=$(grep -r "ProgressView()" --include="*.swift" "$PROJECT_ROOT" 2>/dev/null | \
        grep -v "accessibilityLabel\|label:")
    
    if [ -z "$PROGRESS_NO_LABEL" ]; then
        echo "✅ Loading states have labels"
    else
        echo "⚠️  ProgressViews without labels:"
        echo "$PROGRESS_NO_LABEL" | head -5
        echo ""
        echo "   Fix: ProgressView(\"Loading...\")"
    fi
}
check_loading_states
echo ""

# Check 9: Form accessibility
echo "### 9. Checking form accessibility..."
check_forms() {
    # Check TextFields have labels
    TEXTFIELD_NO_LABEL=$(grep -r "TextField(" --include="*.swift" "$PROJECT_ROOT" 2>/dev/null | \
        grep -v "\".*\",\|text:\|prompt:")
    
    if [ -z "$TEXTFIELD_NO_LABEL" ]; then
        echo "✅ TextFields have labels"
    else
        echo "⚠️  TextFields may need labels:"
        echo "$TEXTFIELD_NO_LABEL" | head -5
    fi
}
check_forms
echo ""

# Check 10: Accessibility hints
echo "### 10. Checking accessibility hints for complex interactions..."
check_hints() {
    # Count accessibility hints
    HINT_COUNT=$(grep -r "\.accessibilityHint" --include="*.swift" "$PROJECT_ROOT" 2>/dev/null | wc -l | tr -d ' ')
    
    echo "📊 Found $HINT_COUNT accessibility hints"
    
    if [ "$HINT_COUNT" -lt 5 ]; then
        echo "⚠️  Consider adding accessibility hints for complex interactions"
        echo "   Example: .accessibilityHint(\"Double tap to expand\")"
    else
        echo "✅ Good use of accessibility hints"
    fi
}
check_hints
echo ""

# Professional UI checks
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "### Professional UI Quality Checks"
echo ""

# Check 11: Empty states
echo "### 11. Checking for empty state handling..."
check_empty_states() {
    # Look for ForEach without empty state handling
    FOREACH_FILES=$(grep -l "ForEach" --include="*.swift" "$PROJECT_ROOT" 2>/dev/null)
    NO_EMPTY_STATE=0
    
    for file in $FOREACH_FILES; do
        if ! grep -q "\.isEmpty\|empty\|No \|None" "$file" 2>/dev/null; then
            ((NO_EMPTY_STATE++))
        fi
    done
    
    if [ "$NO_EMPTY_STATE" -eq 0 ]; then
        echo "✅ Empty states appear to be handled"
    else
        echo "⚠️  $NO_EMPTY_STATE files with lists may need empty states"
        echo "   Fix: Add helpful messages when lists are empty"
    fi
}
check_empty_states
echo ""

# Check 12: Animation consistency
echo "### 12. Checking animation consistency..."
check_animations() {
    # Count different animation types
    SPRING=$(grep -r "\.spring()" --include="*.swift" "$PROJECT_ROOT" 2>/dev/null | wc -l | tr -d ' ')
    EASEINOUT=$(grep -r "\.easeInOut" --include="*.swift" "$PROJECT_ROOT" 2>/dev/null | wc -l | tr -d ' ')
    LINEAR=$(grep -r "\.linear" --include="*.swift" "$PROJECT_ROOT" 2>/dev/null | wc -l | tr -d ' ')
    
    echo "📊 Animation usage: Spring($SPRING) EaseInOut($EASEINOUT) Linear($LINEAR)"
    
    if [ "$LINEAR" -gt "$EASEINOUT" ]; then
        echo "⚠️  Consider using .easeInOut for smoother animations"
    else
        echo "✅ Animation patterns look good"
    fi
}
check_animations
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Accessibility check complete."
echo ""
echo "Key Requirements:"
echo "• All images need accessibility labels"
echo "• Buttons must have clear purposes"
echo "• Support Dynamic Type (no fixed sizes)"
echo "• Minimum tap targets: 44x44pt"
echo "• Provide multiple indicators (not just color)"
echo ""
echo "For detailed guidelines, see CLAUDE.md"