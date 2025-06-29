# {{PROJECT_NAME}} - Single Source of Truth

## 🚨 ENFORCE THESE RULES (Never Deprecated)
```swift
// These rules are architectural constants - they don't change with discoveries

❌ NEVER: .frame(width: 200, height: 56)
✅ ALWAYS: .frame(width: tokens.elementWidth, height: tokens.buttonHeight)

❌ NEVER: Business logic in Views
✅ ALWAYS: Business logic in ViewModels

❌ NEVER: NavigationLink(destination: SomeView())
✅ ALWAYS: coordinator.navigate(to: .someFeature)
```

### iOS Configuration Rules
```
❌ NEVER: Device orientation in code (App.swift, View.onAppear, etc.)
✅ ALWAYS: Device orientation in Xcode project settings or Info.plist

❌ NEVER: App permissions configured in code
✅ ALWAYS: App permissions in Info.plist with proper descriptions

❌ NEVER: Build settings or capabilities in code
✅ ALWAYS: Build settings in Xcode configuration

❌ NEVER: Launch screen setup in code
✅ ALWAYS: Launch screen via Storyboard or Info.plist

Configuration belongs in configuration files, not in code!
```

### Swift 6 Concurrency Rules
```
❌ NEVER: Update UI from background thread
✅ ALWAYS: Use @MainActor for all UI updates

❌ NEVER: DispatchQueue.main.async in ViewModels
✅ ALWAYS: async/await with @MainActor

❌ NEVER: Completion handlers for async operations
✅ ALWAYS: async throws patterns
```

### State Management (MVVM)
```
❌ NEVER: @State for business data (users, products, etc.)
✅ ALWAYS: @Published properties in ViewModels for business state

❌ NEVER: Business logic in View (calculations, API calls, data transformation)
✅ ALWAYS: Business logic in ViewModel or Service

❌ NEVER: View directly accessing Services/Managers
✅ ALWAYS: View → ViewModel → Service

❌ NEVER: @ObservedObject for owned ViewModels
✅ ALWAYS: @StateObject for ViewModels created by the View
```

### Modern SwiftUI (iOS 15+)
```
❌ NEVER: NavigationView (iOS 16+)
✅ ALWAYS: NavigationStack or NavigationView with .navigationViewStyle(.stack)

❌ NEVER: onChange with async work
✅ ALWAYS: .task modifier for async operations
```

### Performance Patterns
```
❌ NEVER: VStack/HStack with 50+ static items
✅ ALWAYS: LazyVStack/LazyHStack for lists

❌ NEVER: ForEach without id parameter or unstable IDs
✅ ALWAYS: ForEach with Identifiable or stable id: \.property
```

### Accessibility Requirements
```
❌ NEVER: Image without .accessibilityLabel
✅ ALWAYS: Descriptive labels for all images

❌ NEVER: Button without accessible text or label
✅ ALWAYS: Clear button purposes with text or accessibilityLabel

❌ NEVER: Fixed font sizes (.font(.system(size: 17)))
✅ ALWAYS: Dynamic Type support (.font(.body), .font(.title))

❌ NEVER: Color as only indicator of state
✅ ALWAYS: Multiple indicators (color + icon + text)
```

### Before Writing ANY Code:
```bash
construct-before ComponentName    # Shows what exists
construct-check                   # Validates patterns
```

<!-- START:CURRENT-STRUCTURE -->
## 📊 Current Project State (Auto-Updated)
Last updated: [Auto-generated]

### Active Components
- ViewModels: 0
- Services: 0  
- Design Tokens: 0
- Shared Components: 0

### Available Resources

#### 🎨 Design System
- ✅ AppColors available
- ✅ Spacing.small/medium/large
- ✅ Font system available

#### 🧩 Shared Components
[Will be populated as components are added]
<!-- END:CURRENT-STRUCTURE -->

<!-- START:SPRINT-CONTEXT -->
## 🎯 Current Sprint Context (Auto-Updated)
**Date**: [Auto-generated]
**Time**: [Auto-generated]
**Branch**: main
**Last Commit**: Initial setup

### Current Focus (from recent changes)
- Setting up project structure
<!-- END:SPRINT-CONTEXT -->

<!-- START:RECENT-DECISIONS -->
## 📋 Recent Architectural Decisions (Auto-Updated)

### From Commit Messages
- Initial project setup with Construct

### From Dev Logs
- No dev logs yet
<!-- END:RECENT-DECISIONS -->

<!-- START:PATTERN-LIBRARY -->
## 📚 Active Patterns (Auto-Generated)

### Common @Published Properties
```swift
// Will be populated as patterns emerge
```
<!-- END:PATTERN-LIBRARY -->

<!-- START:ACTIVE-PRDS -->
## 📋 Active Product Requirements (Auto-Updated)

### Current Sprint
**Active PRD**: initial-setup-prd.md
**Location**: AI/PRDs/current-sprint/initial-setup-prd.md

**Key Goals**:
- Configure project structure
- Implement first feature
- Setup CI/CD pipeline
- Create documentation

### North Star Vision
**Document**: [To be created]

### Upcoming Features
- [To be defined]
<!-- END:ACTIVE-PRDS -->

<!-- START:VIOLATIONS -->
## ⚠️ Active Violations (Auto-Updated)

### Hardcoded Values
✅ None found
<!-- END:VIOLATIONS -->

<!-- START:WORKING-LOCATION -->
## 📍 Current Working Location (Auto-Updated)

### Recently Modified Files
- Initial setup files

### Git Status
```
Initial commit pending
```
<!-- END:WORKING-LOCATION -->

## 🧪 Validated Discoveries (Won't Change)
These are empirically proven and remain true:

### Critical Visual Quality - Background Flash Prevention
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

### Swift/SwiftUI Truths
- `Spacer()` creates unpredictable expansion → Use `Color.clear.frame()`
- Scene phase changes affect app lifecycle
- `@StateObject` for owned ViewModels, `@ObservedObject` for passed
- Animation timing requires empirical testing

### Development Process Discoveries
- Visual debugging with colored backgrounds essential for layout issues
- Component independence must be tested in different parent containers
- Empirical testing beats theoretical calculations for UI positioning
- Performance monitoring required during all layout changes

## 📚 Pattern Library (Copy These)

### New Feature Template
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

### Service Pattern
```swift
protocol FeatureServiceProtocol {
    func fetchData() async throws -> [Model]
}

class FeatureService: FeatureServiceProtocol {
    // Implementation
}
```

### ✅ Correct MVVM Pattern Example

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
        // Business logic for formatting
        return String(format: "$%.2f", amount)
    }
}

// Service (External Operations)
protocol PaymentServiceProtocol {
    func calculateTotal() async throws -> Double
}

class PaymentService: PaymentServiceProtocol {
    func calculateTotal() async throws -> Double {
        // API call or complex calculation
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return 99.99
    }
}
```

### ❌ Anti-Pattern Examples (Never Do This)

```swift
// ❌ BAD: Business logic in View
struct BadPaymentView: View {
    @State private var items: [Item] = []  // ❌ Business data in View
    @State private var total: Double = 0   // ❌ Calculated data in View
    
    var body: some View {
        Button("Calculate") {
            // ❌ Business logic in View
            total = items.reduce(0) { $0 + $1.price * Double($1.quantity) }
            
            // ❌ API call in View
            Task {
                let response = try await URLSession.shared.data(from: url)
                // Processing data in View
            }
        }
    }
}

// ❌ BAD: View accessing Service directly
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

// ❌ BAD: ViewModel without @MainActor
class BadViewModel: ObservableObject {
    @Published var data: [Item] = []
    
    func loadData() {
        Task {
            data = await fetchItems()  // ❌ UI update not on MainActor
        }
    }
}
```

## 🤖 AI Architectural Guidance

### Where Code Belongs - Quick Reference

**Views** (UI Only):
- SwiftUI layout code
- Animation states (@State for isAnimating)
- Sheet/Alert presentation (@State for isShowingSheet)
- Visual formatting
- User interaction handlers that call ViewModel methods

**ViewModels** (Business Logic):
- @Published properties for data
- Business logic and calculations
- Coordination between Services
- Data transformation for Views
- Navigation decisions (tell Coordinator what to do)

**Services** (External Communication):
- API calls
- Database access
- File system operations
- External SDK integration (HealthKit, etc.)
- Shared business logic

**Models** (Data):
- Data structures
- Codable conformance
- No logic, just data

### Common AI Mistakes to Avoid

1. **Putting API calls in Views**
   - ❌ AI suggestion: "Add URLSession in View"
   - ✅ Correct: API calls go in Service, called by ViewModel

2. **Using @State for data**
   - ❌ AI suggestion: "@State var users: [User] = []"
   - ✅ Correct: @Published var users in ViewModel

3. **Direct Service access from View**
   - ❌ AI suggestion: "NetworkService.shared.fetchData()"
   - ✅ Correct: View calls viewModel.fetchData()

4. **Configuration in code**
   - ❌ AI suggestion: "Set orientation in App.swift"
   - ✅ Correct: Use Info.plist or Xcode settings

### When @State IS Acceptable (UI-Only)
```swift
// ✅ CORRECT: UI-only state
@State private var isShowingSheet = false
@State private var animationAmount = 1.0
@State private var selectedTab = 0

// ❌ WRONG: Business data
@State private var userProfile: User?  // Should be in ViewModel
@State private var products: [Product] = []  // Should be in ViewModel
```

## 🔧 Quick Commands

### 🛠️ Construct Tools

1. **`construct-update`**
   - Updates CLAUDE.md with current project state
   - Run before starting a Claude session
   - Shows what components exist, violations, recent work

2. **`construct-check`**
   - Checks for architecture violations
   - Verifies PRD compliance automatically
   - Shows hardcoded values, MVVM issues, navigation problems

3. **`construct-before ComponentName`**
   - Run before creating any new component
   - Shows what already exists
   - Prevents duplicates
   - Checks PRD alignment

4. **`construct-scan`**
   - Documents current MVVM structure
   - Creates timestamped snapshots
   - Archives old scans

5. **`construct-protect`**
   - Checks SwiftUI quality standards
   - Looks for background flash issues
   - Validates accessibility

6. **`construct-session`**
   - Creates session summary when context is ~90%
   - Preserves work for next session

### 📍 Quick Reference
```bash
construct-update      # Update CLAUDE.md before starting
construct-check       # Check violations & PRD compliance
construct-before      # Before creating new components
construct-scan        # Document MVVM structure
construct-protect     # Check quality standards
construct-session     # Create session summary

# Navigation
construct-cd          # Go to project root
construct-ios         # Go to iOS app
construct-watch       # Go to Watch app
```

## 🤖 Claude Instructions

### On Session Start:
1. Run `construct-update` to refresh auto-sections
2. Check "Current Sprint Context" for immediate goals
3. Review "Active Violations" for issues to avoid

### When Context Remaining Falls to 10% or Below:
1. **Alert user at EVERY response when ≤10% remains**: 
   - At 10%: "⚠️ Context at 90% used (10% remaining) - prepare to wrap up"
   - At 8%: "⚠️ Context at 92% used (8% remaining) - time to generate session summary"
   - At 5%: "🚨 URGENT: Only 5% context remaining - run session summary NOW"
   - At 3%: "🚨 CRITICAL: 3% context left - this may be the last full response"
2. **Tell user to run**: `construct-session`
3. **After summary generates**: Remind user to start fresh Claude session
4. **Key message**: "Session summary saved. Please start a new Claude session to continue with full context."
5. **Also remind**: "Consider creating a dev-log if you've completed significant work:
   - Template: `AI/dev-logs/_devupdate-prompt.md`
   - Create as: `AI/dev-logs/devupdate-XX.md`"

### When Creating Code:
1. Check "Available Resources" section first
2. Use "Pattern Library" templates
3. Never violate "ENFORCE THESE RULES" section
4. Run architecture check before finalizing

### When Discovering New Truths:
1. Add to "Validated Discoveries" if universally true
2. Update "Current Sprint Context" if project-specific
3. Move old truths to "Historical Context" if deprecated

---
Remember: The auto-updated sections show reality. The manual sections show wisdom.