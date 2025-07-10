# SwiftUI Framework Pattern

## Modern SwiftUI (iOS 15+)

### Navigation
```swift
// ✅ ALWAYS: NavigationStack (iOS 16+)
NavigationStack(path: $navigationPath) {
    ContentView()
}

// ✅ ALWAYS: NavigationView with stack style (iOS 15)
NavigationView {
    ContentView()
}
.navigationViewStyle(.stack)

// ❌ NEVER: Plain NavigationView (deprecated)
NavigationView {
    ContentView()
}
```

### Task Management
```swift
// ✅ ALWAYS: .task for async operations
.task {
    await loadData()
}

// ❌ NEVER: onChange with async work
.onChange(of: someValue) { _ in
    Task {
        await loadData() // Anti-pattern
    }
}
```

## Visual Quality Rules

### Critical: Background Flash Prevention
**MANDATORY**: SwiftUI rendering race conditions cause white flash artifacts that completely undermine professional visual quality.

```swift
// ❌ NEVER USE - Single background causes flashes
AppColors.darkBackground.ignoresSafeArea()

// ✅ ALWAYS USE - Multi-layer prevents flashes
ZStack {
    AppColors.darkBackground
        .ignoresSafeArea(.all, edges: .all)
    AppColors.darkBackground
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
}
```

**Quality Gates Before ANY UI Commit:**
- [ ] Test all animations for white flashes
- [ ] Test sheet presentations and drag gestures
- [ ] Verify background coverage during view transitions
- [ ] Confirm no white artifacts on device edges

## Layout Best Practices

### Token-Based Design
```swift
// ✅ ALWAYS: Design tokens
struct FeatureTokens {
    let screenHeight: CGFloat
    var elementHeight: CGFloat { screenHeight * 0.X }
}

.frame(width: tokens.elementWidth, height: tokens.buttonHeight)

// ❌ NEVER: Hardcoded dimensions
.frame(width: 200, height: 56)
```

### Performance Patterns
```swift
// ✅ ALWAYS: Lazy stacks for lists
LazyVStack {
    ForEach(items) { item in
        ItemView(item: item)
    }
}

// ❌ NEVER: Regular stacks for 50+ items
VStack {
    ForEach(largeArray) { item in
        ItemView(item: item)
    }
}
```

### ForEach Requirements
```swift
// ✅ ALWAYS: Stable identifiers
ForEach(items, id: \.id) { item in
    ItemView(item: item)
}

// ✅ ALWAYS: Identifiable conformance
struct Item: Identifiable {
    let id = UUID()
}

// ❌ NEVER: Unstable or missing IDs
ForEach(0..<items.count) { index in
    ItemView(item: items[index])
}
```

## State Management

### View State Rules
```swift
// ✅ ALWAYS: @State for UI-only state
@State private var isShowingSheet = false
@State private var animationAmount = 1.0

// ❌ NEVER: @State for business data
@State private var users: [User] = []  // Should be in ViewModel
@State private var accountBalance: Double = 0  // Business logic
```

### ViewModel Ownership
```swift
// ✅ ALWAYS: @StateObject for owned ViewModels
struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
}

// ❌ NEVER: @ObservedObject for owned ViewModels
struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel() // Will recreate
}
```

## Accessibility Requirements

### Images
```swift
// ✅ ALWAYS: Descriptive labels
Image(systemName: "star.fill")
    .accessibilityLabel("Favorite")

// ❌ NEVER: Images without labels
Image("decorative-icon") // No context for VoiceOver
```

### Interactive Elements
```swift
// ✅ ALWAYS: Clear button purposes
Button(action: submitForm) {
    Text("Submit Order")
}

// Alternative with label
Button(action: submitForm) {
    Image(systemName: "arrow.right")
}
.accessibilityLabel("Submit Order")

// ❌ NEVER: Unclear interactions
Button(action: doSomething) {
    Image(systemName: "circle")
}
```

### Dynamic Type
```swift
// ✅ ALWAYS: System font styles
.font(.body)
.font(.title)
.font(.caption)

// ❌ NEVER: Fixed sizes
.font(.system(size: 17))
```

### State Indicators
```swift
// ✅ ALWAYS: Multiple indicators
HStack {
    Circle()
        .fill(item.isActive ? Color.green : Color.red)
        .frame(width: 10, height: 10)
    Text(item.isActive ? "Active" : "Inactive")
    Image(systemName: item.isActive ? "checkmark" : "xmark")
}

// ❌ NEVER: Color only
Circle()
    .fill(item.isActive ? Color.green : Color.red)
```

## SwiftUI Truths
- `Spacer()` creates unpredictable expansion → Use `Color.clear.frame()`
- Scene phase changes affect app lifecycle
- Animation timing requires empirical testing
- Visual debugging with colored backgrounds essential for layout issues
- Component independence must be tested in different parent containers