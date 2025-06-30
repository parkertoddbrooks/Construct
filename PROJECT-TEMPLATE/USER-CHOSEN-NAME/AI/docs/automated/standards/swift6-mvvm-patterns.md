# Swift 6 & MVVM Patterns Guide

**Last Updated**: 2025-06-28  
**Purpose**: Prevent AI confusion and ensure correct architectural patterns

## Table of Contents
1. [Where Code Belongs](#where-code-belongs)
2. [Swift 6 Concurrency](#swift-6-concurrency)
3. [MVVM Pattern Examples](#mvvm-pattern-examples)
4. [Common Mistakes & Fixes](#common-mistakes--fixes)
5. [When @State IS Acceptable](#when-state-is-acceptable)
6. [Navigation Patterns](#navigation-patterns)
7. [Testing Patterns](#testing-patterns)

## Where Code Belongs

### Quick Reference Table

| Code Type | View | ViewModel | Service | Model |
|-----------|------|-----------|---------|-------|
| SwiftUI layout | ✅ | ❌ | ❌ | ❌ |
| Animation state | ✅ | ❌ | ❌ | ❌ |
| Sheet/Alert presentation | ✅ | ❌ | ❌ | ❌ |
| Business logic | ❌ | ✅ | ❌ | ❌ |
| Data transformation | ❌ | ✅ | ❌ | ❌ |
| API calls | ❌ | ❌ | ✅ | ❌ |
| Database access | ❌ | ❌ | ✅ | ❌ |
| Data structures | ❌ | ❌ | ❌ | ✅ |

### Detailed Guidelines

#### Views (UI Layer)
```swift
struct PaymentView: View {
    @StateObject private var viewModel = PaymentViewModel()
    
    // ✅ UI-only state
    @State private var isShowingReceipt = false
    @State private var animationAmount = 1.0
    
    // ❌ NEVER business data
    // @State private var products: [Product] = []  // WRONG!
    
    var body: some View {
        VStack {
            // ✅ Display formatted data from ViewModel
            Text(viewModel.formattedTotal)
            
            // ✅ Call ViewModel methods
            Button("Calculate") {
                Task {
                    await viewModel.calculateTotal()
                }
            }
            
            // ❌ NEVER business logic in View
            // let total = products.reduce(0) { $0 + $1.price }  // WRONG!
        }
    }
}
```

#### ViewModels (Business Logic Layer)
```swift
@MainActor  // ✅ ALWAYS use @MainActor
class PaymentViewModel: ObservableObject {
    // ✅ Business data as @Published
    @Published private(set) var total: Double = 0
    @Published private(set) var isLoading = false
    
    // ✅ Dependency injection
    private let paymentService: PaymentServiceProtocol
    
    init(paymentService: PaymentServiceProtocol = PaymentService()) {
        self.paymentService = paymentService
    }
    
    // ✅ Business logic methods
    func calculateTotal() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            total = try await paymentService.fetchTotal()
        } catch {
            // Handle error
        }
    }
    
    // ✅ Data formatting for View
    var formattedTotal: String {
        return String(format: "$%.2f", total)
    }
}
```

#### Services (External Communication)
```swift
protocol PaymentServiceProtocol {
    func fetchTotal() async throws -> Double
}

class PaymentService: PaymentServiceProtocol {
    // ✅ API calls
    func fetchTotal() async throws -> Double {
        let (data, _) = try await URLSession.shared.data(from: apiURL)
        return try JSONDecoder().decode(PaymentResponse.self, from: data).total
    }
    
    // ✅ Database operations
    func savePayment(_ payment: Payment) async throws {
        // Core Data or other persistence
    }
}
```

## Swift 6 Concurrency

### @MainActor Usage

#### ✅ Correct: ViewModel with @MainActor
```swift
@MainActor
class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    
    func loadUsers() async {
        // Automatically on MainActor
        users = await userService.fetchUsers()
    }
}
```

#### ❌ Wrong: Missing @MainActor
```swift
class UserViewModel: ObservableObject {  // ❌ Missing @MainActor
    @Published var users: [User] = []
    
    func loadUsers() async {
        // ❌ May not be on main thread
        users = await userService.fetchUsers()
    }
}
```

### Async/Await Patterns

#### ✅ Correct: Modern async/await
```swift
func fetchData() async throws -> [Item] {
    let items = try await apiService.getItems()
    return items.filter { $0.isActive }
}
```

#### ❌ Wrong: Old completion handlers
```swift
func fetchData(completion: @escaping ([Item]?, Error?) -> Void) {
    apiService.getItems { items, error in
        // Old pattern - avoid this
    }
}
```

## MVVM Pattern Examples

### Complete Feature Example

#### 1. Model
```swift
struct Product: Identifiable, Codable {
    let id: UUID
    let name: String
    let price: Double
    let category: String
}
```

#### 2. Service
```swift
protocol ProductServiceProtocol {
    func fetchProducts() async throws -> [Product]
    func purchaseProduct(_ product: Product) async throws
}

class ProductService: ProductServiceProtocol {
    func fetchProducts() async throws -> [Product] {
        // API call implementation
    }
    
    func purchaseProduct(_ product: Product) async throws {
        // Purchase implementation
    }
}
```

#### 3. ViewModel
```swift
@MainActor
class ProductListViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published var searchText = ""
    
    private let productService: ProductServiceProtocol
    
    init(productService: ProductServiceProtocol = ProductService()) {
        self.productService = productService
    }
    
    var filteredProducts: [Product] {
        guard !searchText.isEmpty else { return products }
        return products.filter { 
            $0.name.localizedCaseInsensitiveContains(searchText) 
        }
    }
    
    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            products = try await productService.fetchProducts()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func purchase(_ product: Product) async {
        do {
            try await productService.purchaseProduct(product)
            // Update UI or navigate
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
        }
    }
}
```

#### 4. View
```swift
struct ProductListView: View {
    @StateObject private var viewModel = ProductListViewModel()
    @State private var showingPurchaseAlert = false
    @State private var selectedProduct: Product?
    
    var body: some View {
        NavigationStack {
            List(viewModel.filteredProducts) { product in
                ProductRow(product: product) {
                    selectedProduct = product
                    showingPurchaseAlert = true
                }
            }
            .searchable(text: $viewModel.searchText)
            .navigationTitle("Products")
            .task {
                await viewModel.loadProducts()
            }
            .alert("Purchase", isPresented: $showingPurchaseAlert) {
                Button("Buy") {
                    if let product = selectedProduct {
                        Task {
                            await viewModel.purchase(product)
                        }
                    }
                }
                Button("Cancel", role: .cancel) { }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                }
            }
        }
    }
}
```

## Common Mistakes & Fixes

### 1. Business Logic in View

❌ **Wrong**:
```swift
struct BadView: View {
    @State private var users: [User] = []
    
    var body: some View {
        Button("Load") {
            Task {
                // ❌ API call in View
                let (data, _) = try await URLSession.shared.data(from: url)
                users = try JSONDecoder().decode([User].self, from: data)
            }
        }
    }
}
```

✅ **Correct**:
```swift
struct GoodView: View {
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        Button("Load") {
            Task {
                await viewModel.loadUsers()
            }
        }
    }
}
```

### 2. Direct Service Access

❌ **Wrong**:
```swift
struct BadView: View {
    let userService = UserService()  // ❌ Direct service reference
    
    var body: some View {
        Button("Fetch") {
            Task {
                let users = await userService.fetchUsers()
            }
        }
    }
}
```

✅ **Correct**:
```swift
struct GoodView: View {
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        Button("Fetch") {
            Task {
                await viewModel.fetchUsers()
            }
        }
    }
}
```

### 3. @State Misuse

❌ **Wrong**:
```swift
struct BadView: View {
    @State private var products: [Product] = []  // ❌ Business data
    @State private var userProfile: User?       // ❌ Model data
}
```

✅ **Correct**:
```swift
struct GoodView: View {
    @StateObject private var viewModel = ProductViewModel()
    @State private var isShowingFilter = false  // ✅ UI state only
    @State private var selectedTab = 0          // ✅ UI state only
}
```

## When @State IS Acceptable

### UI-Only State Examples

```swift
struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    // ✅ ALL of these are correct uses of @State
    @State private var isShowingEditSheet = false
    @State private var isAnimating = false
    @State private var selectedPhotoIndex = 0
    @State private var dragOffset: CGSize = .zero
    @State private var searchText = ""  // If not filtering data
    
    var body: some View {
        // View implementation
    }
}
```

### Rule of Thumb
- If it's about **how** to display → @State in View
- If it's about **what** to display → @Published in ViewModel

## Navigation Patterns

### Coordinator Pattern
```swift
@MainActor
class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(to destination: AppDestination) {
        path.append(destination)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func navigateToRoot() {
        path = NavigationPath()
    }
}

enum AppDestination: Hashable {
    case productDetail(Product)
    case settings
    case profile(userId: String)
}
```

## Testing Patterns

### ViewModel Testing
```swift
@MainActor
final class ProductViewModelTests: XCTestCase {
    func testLoadProducts() async {
        // Arrange
        let mockService = MockProductService()
        mockService.stubbedProducts = [
            Product(id: UUID(), name: "Test", price: 9.99, category: "Test")
        ]
        let viewModel = ProductListViewModel(productService: mockService)
        
        // Act
        await viewModel.loadProducts()
        
        // Assert
        XCTAssertEqual(viewModel.products.count, 1)
        XCTAssertFalse(viewModel.isLoading)
    }
}
```

### Mock Service
```swift
class MockProductService: ProductServiceProtocol {
    var stubbedProducts: [Product] = []
    var shouldThrowError = false
    
    func fetchProducts() async throws -> [Product] {
        if shouldThrowError {
            throw TestError.mock
        }
        return stubbedProducts
    }
}
```

## Summary Checklist

### Before Writing Code
- [ ] Is this UI logic? → View with @State
- [ ] Is this business logic? → ViewModel with @Published
- [ ] Is this external communication? → Service
- [ ] Is this just data? → Model

### Code Review Checklist
- [ ] All ViewModels have @MainActor
- [ ] No business logic in Views
- [ ] No direct Service access from Views
- [ ] @State only for UI state
- [ ] Using async/await (not completion handlers)
- [ ] Images have accessibility labels
- [ ] Using Dynamic Type (no fixed fonts)
- [ ] Tap targets ≥ 44pt

### Common Fixes
- Move API calls: View → ViewModel → Service
- Replace @State with @Published for business data
- Add @MainActor to ViewModels
- Replace completion handlers with async/await
- Add .accessibilityLabel to images
- Replace fixed fonts with Dynamic Type

---

Remember: The goal is clear separation of concerns. When in doubt, ask "Does this belong in the UI layer or business layer?"