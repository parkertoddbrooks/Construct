# [SWIFT] Swift/SwiftUI Development Patterns

## When to Use
- When working with Swift source files (*.swift)
- When developing iOS, macOS, watchOS, or tvOS applications
- When implementing SwiftUI views and ViewModels

## Core Swift/SwiftUI Rules

### ✅ DO: Foundation Rules
```swift
// Never use hardcoded values
❌ NEVER: .frame(width: 200, height: 56)
✅ ALWAYS: .frame(width: tokens.elementWidth, height: tokens.buttonHeight)

// Business logic belongs in ViewModels
❌ NEVER: Business logic in Views
✅ ALWAYS: Business logic in ViewModels

// Use coordinator pattern for navigation
❌ NEVER: NavigationLink(destination: SomeView())
✅ ALWAYS: coordinator.navigate(to: .someFeature)
```

### ✅ DO: iOS Configuration Rules
```swift
// Configuration belongs in configuration files, not code
❌ NEVER: Device orientation in code (App.swift, View.onAppear, etc.)
✅ ALWAYS: Device orientation in Xcode project settings or Info.plist

❌ NEVER: App permissions configured in code
✅ ALWAYS: App permissions in Info.plist with proper descriptions

❌ NEVER: Build settings or capabilities in code
✅ ALWAYS: Build settings in Xcode configuration

❌ NEVER: Launch screen setup in code
✅ ALWAYS: Launch screen via Storyboard or Info.plist
```

### ✅ DO: Swift 6 Concurrency Rules
```swift
// All UI updates must be on MainActor
❌ NEVER: Update UI from background thread
✅ ALWAYS: Use @MainActor for all UI updates

❌ NEVER: DispatchQueue.main.async in ViewModels
✅ ALWAYS: async/await with @MainActor

❌ NEVER: Completion handlers for async operations
✅ ALWAYS: async throws patterns
```

## MVVM Architecture

### ✅ DO: State Management
```swift
// Use @Published in ViewModels for business state
❌ NEVER: @State for business data (users, products, etc.)
✅ ALWAYS: @Published properties in ViewModels for business state

// Keep business logic in ViewModel
❌ NEVER: Business logic in View (calculations, API calls, data transformation)
✅ ALWAYS: Business logic in ViewModel or Service

// Follow proper dependency flow
❌ NEVER: View directly accessing Services/Managers
✅ ALWAYS: View → ViewModel → Service

// Use correct property wrappers
❌ NEVER: @ObservedObject for owned ViewModels
✅ ALWAYS: @StateObject for ViewModels created by the View
```

### ✅ DO: Correct MVVM Pattern
```swift
// View (UI only - no business logic)
struct PaymentView: View {
    @StateObject private var viewModel = PaymentViewModel()
    @State private var isShowingError = false  // UI state only
    
    var body: some View {
        VStack {
            Text("Total: \(viewModel.formattedTotal)")
            
            Button("Calculate Total") {
                Task {
                    await viewModel.calculateTotal()
                }
            }
            .disabled(viewModel.isCalculating)
            
            if viewModel.isCalculating {
                ProgressView()
            }
        }
        .alert("Error", isPresented: $isShowingError) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage)
        }
        .onReceive(viewModel.$hasError) { hasError in
            isShowingError = hasError
        }
    }
}

// ViewModel (Business Logic)
@MainActor
class PaymentViewModel: ObservableObject {
    @Published private(set) var formattedTotal = "$0.00"
    @Published private(set) var isCalculating = false
    @Published private(set) var hasError = false
    @Published private(set) var errorMessage = ""
    
    private let paymentService: PaymentServiceProtocol
    
    init(paymentService: PaymentServiceProtocol = PaymentService()) {
        self.paymentService = paymentService
    }
    
    func calculateTotal() async {
        isCalculating = true
        hasError = false
        
        do {
            let total = try await paymentService.calculateTotal()
            formattedTotal = formatCurrency(total)
        } catch {
            errorMessage = error.localizedDescription
            hasError = true
        }
        
        isCalculating = false
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        return String(format: "$%.2f", amount)
    }
}
```

## Modern SwiftUI Patterns

### ✅ DO: Modern SwiftUI (iOS 15+)
```swift
// Use modern navigation
❌ NEVER: NavigationView (iOS 16+)
✅ ALWAYS: NavigationStack or NavigationView with .navigationViewStyle(.stack)

// Use modern async patterns
❌ NEVER: onChange with async work
✅ ALWAYS: .task modifier for async operations
```

### ✅ DO: Performance Patterns
```swift
// Use lazy containers for large lists
❌ NEVER: VStack/HStack with 50+ static items
✅ ALWAYS: LazyVStack/LazyHStack for lists

// Ensure stable identifiers
❌ NEVER: ForEach without id parameter or unstable IDs
✅ ALWAYS: ForEach with Identifiable or stable id: \.property
```

## Critical Visual Quality

### ✅ DO: Background Flash Prevention
```swift
// MANDATORY: Prevent white flash artifacts
❌ NEVER: Single background causes flashes
AppColors.darkBackground.ignoresSafeArea()

✅ ALWAYS: Multi-layer prevents flashes
ZStack {
    AppColors.darkBackground
        .ignoresSafeArea(.all, edges: .all)
    AppColors.darkBackground
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
}
```

### ✅ DO: Quality Gates Before UI Commits
- [ ] Test all animations for white flashes
- [ ] Test sheet presentations and drag gestures
- [ ] Verify background coverage during view transitions
- [ ] Confirm no white artifacts on device edges

## Accessibility Requirements

### ✅ DO: Accessibility Standards
```swift
// All images need descriptive labels
❌ NEVER: Image without .accessibilityLabel
✅ ALWAYS: Descriptive labels for all images

// Clear button purposes
❌ NEVER: Button without accessible text or label
✅ ALWAYS: Clear button purposes with text or accessibilityLabel

// Support Dynamic Type
❌ NEVER: Fixed font sizes (.font(.system(size: 17)))
✅ ALWAYS: Dynamic Type support (.font(.body), .font(.title))

// Multiple indicators for state
❌ NEVER: Color as only indicator of state
✅ ALWAYS: Multiple indicators (color + icon + text)
```

## Anti-Patterns to Avoid

### ❌ DON'T: Common Mistakes
```swift
// Business logic in View
struct BadPaymentView: View {
    @State private var items: [Item] = []  // ❌ Business data in View
    @State private var total: Double = 0   // ❌ Calculated data in View
    
    var body: some View {
        Button("Calculate") {
            // ❌ Business logic in View
            total = items.reduce(0) { $0 + $1.price * Double($1.quantity) }
        }
    }
}

// Direct service access from View
struct BadView: View {
    let service = NetworkService.shared  // ❌ Direct service reference
    
    var body: some View {
        Button("Fetch") {
            Task {
                // ❌ View calling service directly
                let data = try await service.fetchData()
            }
        }
    }
}

// ViewModel without @MainActor
class BadViewModel: ObservableObject {
    @Published var data: [Item] = []
    
    func loadData() {
        Task {
            data = await fetchItems()  // ❌ UI update not on MainActor
        }
    }
}
```

## Component Templates

### ✅ DO: New Feature Template
```swift
// 1. Token System First
struct FeatureTokens {
    let screenHeight: CGFloat
    var elementHeight: CGFloat { screenHeight * 0.X }
}

// 2. ViewModel
@MainActor
class FeatureViewModel: ObservableObject {
    @Published var state: State = .initial
}

// 3. View
struct FeatureView: View {
    @StateObject private var viewModel: FeatureViewModel
    private let tokens: FeatureTokens
}
```

### ✅ DO: Service Pattern
```swift
protocol FeatureServiceProtocol {
    func fetchData() async throws -> [Model]
}

class FeatureService: FeatureServiceProtocol {
    // Implementation
}
```

## State Guidelines

### ✅ DO: When @State IS Acceptable (UI-Only)
```swift
// UI-only state
@State private var isShowingSheet = false
@State private var animationAmount = 1.0
@State private var selectedTab = 0

// ❌ WRONG: Business data
@State private var userProfile: User?  // Should be in ViewModel
@State private var products: [Product] = []  // Should be in ViewModel
```

## Integration
This pattern activates when:
- Working with .swift files
- Developing iOS, macOS, watchOS, or tvOS applications
- Creating SwiftUI views and ViewModels
- Implementing Swift-specific functionality