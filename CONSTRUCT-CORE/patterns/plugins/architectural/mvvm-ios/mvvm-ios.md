# MVVM Architecture Pattern for iOS

## Core MVVM Rules

### Separation of Concerns
```swift
// ✅ ALWAYS: Clear separation
View (UI only) → ViewModel (Business Logic) → Service (External Operations)

// ❌ NEVER: Mixed responsibilities  
View → Service (skipping ViewModel)
View with business logic
ViewModel with UI code
```

## State Management Rules

### Business Data Location
```swift
// ✅ ALWAYS: @Published in ViewModel
@MainActor
class UserViewModel: ObservableObject {
    @Published private(set) var users: [User] = []
    @Published private(set) var isLoading = false
}

// ❌ NEVER: @State for business data
struct UserListView: View {
    @State private var users: [User] = []  // Wrong!
}
```

### UI State vs Business State
```swift
// ✅ CORRECT: Clear separation
struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var isShowingAlert = false  // UI state only
    
    var body: some View {
        VStack {
            Text(viewModel.userName)  // Business data from VM
            Button("Edit") {
                isShowingAlert = true  // UI state in View
            }
        }
    }
}

// ❌ WRONG: Mixed concerns
struct ProfileView: View {
    @State private var userName = ""  // Business data in View!
    @State private var userAge = 0   // Business data in View!
}
```

## ViewModel Requirements

### @MainActor Requirement
```swift
// ✅ ALWAYS: ViewModels on MainActor
@MainActor
class FeatureViewModel: ObservableObject {
    @Published var data: [Item] = []
    
    func loadData() async {
        // Automatically on main thread
        data = await fetchItems()
    }
}

// ❌ NEVER: ViewModel without @MainActor
class BadViewModel: ObservableObject {
    @Published var data: [Item] = []
    
    func loadData() {
        Task {
            data = await fetchItems()  // Race condition!
        }
    }
}
```

### Dependency Injection
```swift
// ✅ ALWAYS: Inject dependencies
@MainActor
class PaymentViewModel: ObservableObject {
    private let paymentService: PaymentServiceProtocol
    
    init(paymentService: PaymentServiceProtocol = PaymentService()) {
        self.paymentService = paymentService
    }
}

// ❌ NEVER: Hard dependencies
class BadViewModel: ObservableObject {
    let service = NetworkService.shared  // Hard to test
}
```

## Complete MVVM Example

### ✅ Correct Implementation
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

## Anti-Patterns to Avoid

### ❌ Business Logic in View
```swift
// NEVER DO THIS
struct BadPaymentView: View {
    @State private var items: [Item] = []  // Business data
    @State private var total: Double = 0   // Calculated data
    
    var body: some View {
        Button("Calculate") {
            // Business logic in View!
            total = items.reduce(0) { $0 + $1.price * Double($1.quantity) }
            
            // API call in View!
            Task {
                let response = try await URLSession.shared.data(from: url)
            }
        }
    }
}
```

### ❌ View Accessing Service Directly
```swift
// NEVER DO THIS
struct BadView: View {
    let service = NetworkService.shared  // Direct service reference
    
    var body: some View {
        Button("Fetch") {
            Task {
                // View calling service directly
                let data = try await service.fetchData()
            }
        }
    }
}
```

## Navigation Pattern

### Coordinator Integration
```swift
// ✅ ALWAYS: Coordinator for navigation
Button("Open Details") {
    viewModel.coordinator.navigate(to: .details(item))
}

// ❌ NEVER: NavigationLink with destination
NavigationLink(destination: DetailsView(item: item)) {
    Text("Open Details")
}
```

## Testing Considerations

### ViewModel Testability
```swift
// ✅ Testable ViewModel
@MainActor
class TestableViewModel: ObservableObject {
    private let service: ServiceProtocol
    
    init(service: ServiceProtocol) {
        self.service = service
    }
}

// Test
func testViewModel() async {
    let mockService = MockService()
    let viewModel = TestableViewModel(service: mockService)
    await viewModel.loadData()
    XCTAssertEqual(viewModel.items.count, 3)
}
```

## AI Architectural Guidance

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