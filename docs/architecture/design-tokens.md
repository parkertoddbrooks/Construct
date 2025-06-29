# Design Token System

A comprehensive guide to Construct's responsive, maintainable design token system.

## What Are Design Tokens?

Design tokens are the visual design atoms of your app - spacing, sizing, colors, and typography expressed as data. They ensure consistency and enable responsive design without hardcoded values.

## Why Design Tokens?

### Without Tokens (❌ Problems)
```swift
// Hardcoded values everywhere
.padding(16)
.frame(width: 200, height: 56)
.font(.system(size: 17))
```

Problems:
- Inconsistent spacing across views
- Doesn't adapt to screen sizes
- Hard to maintain
- Accessibility issues

### With Tokens (✅ Solutions)
```swift
// Responsive, consistent, maintainable
.padding(tokens.contentPadding)
.frame(width: tokens.cardWidth, height: tokens.buttonHeight)
.font(tokens.bodyFont)
```

Benefits:
- Consistent design language
- Automatically responsive
- Single source of truth
- Easy to update globally

## Token Structure

### Base Token File

Each feature has its own tokens:

```swift
struct FeatureTokens {
    // MARK: - Screen Metrics
    private let screenWidth: CGFloat
    private let screenHeight: CGFloat
    
    // MARK: - Spacing
    var spacing: CGFloat { screenWidth * 0.05 }
    var padding: CGFloat { screenWidth * 0.04 }
    
    // MARK: - Sizing
    var buttonHeight: CGFloat { max(44, screenHeight * 0.06) }
    
    // MARK: - Typography
    var titleSize: CGFloat { screenWidth * 0.08 }
    
    // MARK: - Colors
    let primaryColor = Color.accentColor
    
    // MARK: - Initialization
    init(screenSize: CGSize = UIScreen.main.bounds.size) {
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height
    }
    
    static let `default` = FeatureTokens()
}
```

## Token Categories

### 1. Spacing Tokens

Define consistent spacing throughout your app:

```swift
// Relative to screen size
var spacingXS: CGFloat { screenWidth * 0.02 }  // ~8pt on iPhone 14
var spacingS: CGFloat { screenWidth * 0.04 }   // ~16pt
var spacingM: CGFloat { screenWidth * 0.06 }   // ~24pt
var spacingL: CGFloat { screenWidth * 0.08 }   // ~32pt
var spacingXL: CGFloat { screenWidth * 0.12 }  // ~48pt

// Usage
VStack(spacing: tokens.spacingM) {
    // Content
}
.padding(tokens.spacingL)
```

### 2. Sizing Tokens

Responsive sizing that works across devices:

```swift
// Component sizes
var buttonHeight: CGFloat { max(44, screenHeight * 0.06) }
var inputHeight: CGFloat { max(44, screenHeight * 0.055) }
var cardWidth: CGFloat { screenWidth * 0.9 }
var iconSize: CGFloat { screenWidth * 0.06 }

// Grid dimensions
var gridColumns: Int { screenWidth > 500 ? 3 : 2 }
var gridSpacing: CGFloat { screenWidth * 0.03 }
```

### 3. Typography Tokens

Scale typography based on screen size:

```swift
// Font sizes
var fontSizeXS: CGFloat { max(12, screenWidth * 0.03) }
var fontSizeS: CGFloat { max(14, screenWidth * 0.035) }
var fontSizeM: CGFloat { max(16, screenWidth * 0.04) }
var fontSizeL: CGFloat { max(20, screenWidth * 0.05) }
var fontSizeXL: CGFloat { max(28, screenWidth * 0.07) }

// Line heights
var lineHeightTight: CGFloat { 1.2 }
var lineHeightNormal: CGFloat { 1.5 }
var lineHeightLoose: CGFloat { 1.8 }

// Usage
Text("Title")
    .font(.system(size: tokens.fontSizeL))
    .lineSpacing(tokens.lineHeightNormal)
```

### 4. Radius Tokens

Consistent corner radii:

```swift
var radiusS: CGFloat { 4 }
var radiusM: CGFloat { 8 }
var radiusL: CGFloat { 16 }
var radiusXL: CGFloat { 24 }
var radiusRound: CGFloat { 9999 }  // Fully rounded

// Usage
.cornerRadius(tokens.radiusM)
.clipShape(RoundedRectangle(cornerRadius: tokens.radiusL))
```

### 5. Animation Tokens

Consistent animation timing:

```swift
var animationFast: Double { 0.2 }
var animationNormal: Double { 0.3 }
var animationSlow: Double { 0.5 }
var animationSpring: Animation {
    .spring(response: 0.4, dampingFraction: 0.8)
}

// Usage
.animation(.easeInOut(duration: tokens.animationNormal), value: isExpanded)
```

## Responsive Design Patterns

### Screen Size Adaptation

```swift
extension FeatureTokens {
    var isCompact: Bool { screenWidth < 375 }
    var isRegular: Bool { screenWidth >= 375 && screenWidth < 500 }
    var isLarge: Bool { screenWidth >= 500 }
    
    // Adaptive layouts
    var columns: Int {
        if isLarge { return 3 }
        if isRegular { return 2 }
        return 1
    }
    
    // Adaptive spacing
    var adaptivePadding: CGFloat {
        if isLarge { return spacingXL }
        if isRegular { return spacingL }
        return spacingM
    }
}
```

### Device-Specific Tokens

```swift
extension FeatureTokens {
    static let iPhone14 = FeatureTokens(screenSize: CGSize(width: 390, height: 844))
    static let iPhone14ProMax = FeatureTokens(screenSize: CGSize(width: 430, height: 932))
    static let iPhoneSE = FeatureTokens(screenSize: CGSize(width: 375, height: 667))
    static let iPadPro11 = FeatureTokens(screenSize: CGSize(width: 834, height: 1194))
    
    // For previews
    static func forDevice(_ device: PreviewDevice) -> FeatureTokens {
        switch device.rawValue {
        case "iPhone 14":
            return .iPhone14
        case "iPad Pro (11-inch)":
            return .iPadPro11
        default:
            return .default
        }
    }
}
```

## Color Tokens

### Semantic Colors

```swift
extension FeatureTokens {
    // Surface colors
    var backgroundColor: Color { Color("Background") }
    var surfaceColor: Color { Color("Surface") }
    var cardColor: Color { Color("Card") }
    
    // Text colors
    var textPrimary: Color { Color("TextPrimary") }
    var textSecondary: Color { Color("TextSecondary") }
    var textTertiary: Color { Color("TextTertiary") }
    
    // Semantic colors
    var successColor: Color { Color.green }
    var warningColor: Color { Color.orange }
    var errorColor: Color { Color.red }
    var infoColor: Color { Color.blue }
    
    // Interactive colors
    var accentColor: Color { Color.accentColor }
    var disabledColor: Color { Color.gray.opacity(0.5) }
}
```

### Dark Mode Support

```swift
// In Assets.xcassets, define colors with Any/Dark appearances
// Then use semantic names in tokens

var cardBackground: Color {
    colorScheme == .dark ? Color("CardDark") : Color("CardLight")
}
```

## Complex Token Calculations

### Proportional Sizing

```swift
extension FeatureTokens {
    // Hero section takes 40% of screen
    var heroHeight: CGFloat { screenHeight * 0.4 }
    
    // Content area is remaining space minus tab bar
    var contentHeight: CGFloat {
        screenHeight - heroHeight - tabBarHeight - safeAreaBottom
    }
    
    // Dynamic card heights based on content
    var cardHeight: CGFloat {
        let baseHeight = screenHeight * 0.15
        let minHeight: CGFloat = 120
        let maxHeight: CGFloat = 200
        return min(max(baseHeight, minHeight), maxHeight)
    }
}
```

### Aspect Ratios

```swift
extension FeatureTokens {
    // 16:9 video player
    var videoWidth: CGFloat { screenWidth * 0.9 }
    var videoHeight: CGFloat { videoWidth * (9.0 / 16.0) }
    
    // Square profile images
    var profileImageSize: CGFloat { screenWidth * 0.25 }
    
    // Golden ratio card
    var goldenRatioHeight: CGFloat { cardWidth / 1.618 }
}
```

## Using Tokens in Views

### Basic Usage

```swift
struct FeatureView: View {
    private let tokens: FeatureTokens
    
    init(tokens: FeatureTokens = .default) {
        self.tokens = tokens
    }
    
    var body: some View {
        VStack(spacing: tokens.spacingM) {
            Text("Title")
                .font(.system(size: tokens.fontSizeL))
                .foregroundColor(tokens.textPrimary)
            
            Button("Action") {
                // Action
            }
            .frame(height: tokens.buttonHeight)
            .padding(.horizontal, tokens.spacingL)
        }
        .padding(tokens.padding)
    }
}
```

### Passing Tokens to Subviews

```swift
struct ParentView: View {
    private let tokens = ParentTokens.default
    
    var body: some View {
        VStack {
            ChildView(tokens: tokens.childTokens)
        }
    }
}

extension ParentTokens {
    var childTokens: ChildTokens {
        ChildTokens(
            spacing: self.spacingM,
            padding: self.paddingS
        )
    }
}
```

## Testing with Tokens

### Preview with Different Sizes

```swift
struct FeatureView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FeatureView(tokens: .iPhone14)
                .previewDevice("iPhone 14")
            
            FeatureView(tokens: .iPhoneSE)
                .previewDevice("iPhone SE")
            
            FeatureView(tokens: .iPadPro11)
                .previewDevice("iPad Pro (11-inch)")
        }
    }
}
```

### Unit Testing Tokens

```swift
final class TokenTests: XCTestCase {
    func testButtonHeightAccessibility() {
        let tokens = FeatureTokens(screenSize: CGSize(width: 320, height: 568))
        
        // Ensure minimum 44pt for touch targets
        XCTAssertGreaterThanOrEqual(tokens.buttonHeight, 44)
    }
    
    func testResponsiveColumns() {
        let phoneTokens = FeatureTokens(screenSize: CGSize(width: 375, height: 812))
        XCTAssertEqual(phoneTokens.columns, 2)
        
        let iPadTokens = FeatureTokens(screenSize: CGSize(width: 768, height: 1024))
        XCTAssertEqual(iPadTokens.columns, 4)
    }
}
```

## Best Practices

### 1. Never Hardcode Values

```swift
// ❌ Bad
.padding(16)
.frame(width: 200, height: 56)

// ✅ Good
.padding(tokens.contentPadding)
.frame(width: tokens.cardWidth, height: tokens.buttonHeight)
```

### 2. Use Semantic Names

```swift
// ❌ Bad
var spacing1: CGFloat { 8 }
var spacing2: CGFloat { 16 }

// ✅ Good
var spacingSmall: CGFloat { 8 }
var spacingMedium: CGFloat { 16 }
```

### 3. Consider Accessibility

```swift
// Always respect minimum sizes
var buttonHeight: CGFloat {
    max(44, screenHeight * 0.06)  // Never less than 44pt
}

// Support Dynamic Type
var fontSize: CGFloat {
    UIFontMetrics.default.scaledValue(for: baseSize)
}
```

### 4. Document Relationships

```swift
// Document why these values relate
var headerHeight: CGFloat { screenHeight * 0.15 }  // 15% of screen
var contentHeight: CGFloat { 
    // Remaining space after header and tab bar
    screenHeight - headerHeight - tabBarHeight 
}
```

## Common Patterns

### Card-Based Layouts

```swift
struct CardTokens {
    let screenSize: CGSize
    
    var cardWidth: CGFloat { screenWidth * 0.9 }
    var cardPadding: CGFloat { screenWidth * 0.05 }
    var cardSpacing: CGFloat { screenHeight * 0.02 }
    var cardRadius: CGFloat { 16 }
    var cardShadowRadius: CGFloat { 8 }
}
```

### Form Layouts

```swift
struct FormTokens {
    var labelWidth: CGFloat { screenWidth * 0.35 }
    var inputHeight: CGFloat { 44 }
    var sectionSpacing: CGFloat { screenHeight * 0.03 }
    var fieldSpacing: CGFloat { screenHeight * 0.02 }
}
```

### Grid Layouts

```swift
struct GridTokens {
    var columns: Int {
        switch screenWidth {
        case 0..<400: return 2
        case 400..<600: return 3
        case 600..<900: return 4
        default: return 5
        }
    }
    
    var itemSpacing: CGFloat { screenWidth * 0.02 }
    var itemSize: CGFloat {
        (screenWidth - (itemSpacing * CGFloat(columns + 1))) / CGFloat(columns)
    }
}
```

## Migrating to Tokens

### Step 1: Audit Hardcoded Values

```bash
# Find hardcoded values
construct-check

# Output shows:
# ❌ Found hardcoded values:
#   ProfileView.swift: .padding(20)
#   ProfileView.swift: .frame(width: 150, height: 150)
```

### Step 2: Create Token File

```swift
struct ProfileTokens {
    private let screenWidth: CGFloat
    private let screenHeight: CGFloat
    
    var profilePadding: CGFloat { screenWidth * 0.05 }  // ~20 on iPhone
    var profileImageSize: CGFloat { screenWidth * 0.38 }  // ~150 on iPhone
    
    init(screenSize: CGSize = UIScreen.main.bounds.size) {
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height
    }
    
    static let `default` = ProfileTokens()
}
```

### Step 3: Replace Values

```swift
// Before
.padding(20)
.frame(width: 150, height: 150)

// After
.padding(tokens.profilePadding)
.frame(width: tokens.profileImageSize, height: tokens.profileImageSize)
```

## Conclusion

Design tokens are the foundation of maintainable, responsive SwiftUI apps. They:
- Eliminate hardcoded values
- Ensure consistency
- Enable responsive design
- Support accessibility
- Simplify maintenance

Construct enforces token usage, making it impossible to ship hardcoded values. **Trust The Process** - tokens make your app better.