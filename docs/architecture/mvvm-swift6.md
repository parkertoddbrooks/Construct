# MVVM with Swift 6

Modern Model-View-ViewModel architecture patterns for SwiftUI with Swift 6 concurrency.

## Overview

Construct enforces a modern MVVM architecture that leverages Swift 6's concurrency features. This creates a clean separation of concerns and predictable data flow.

## Architecture Layers

```
┌─────────────────────────────────────┐
│            View Layer               │
│         (SwiftUI Views)             │
│    - UI Definition                  │
│    - User Interaction               │
│    - Visual State (@State)          │
└────────────────┬────────────────────┘
                 │ Bindings & Actions
┌────────────────▼────────────────────┐
│         ViewModel Layer             │
│        (@MainActor class)           │
│    - Business Logic                 │
│    - Data Transformation            │
│    - State Management (@Published)  │
└────────────────┬────────────────────┘
                 │ Async Calls
┌────────────────▼────────────────────┐
│          Service Layer              │
│    (Protocols & Implementations)    │
│    - External Communication         │
│    - Data Persistence              │
│    - API Integration                │
└────────────────┬────────────────────┘
                 │ Data
┌────────────────▼────────────────────┐
│           Model Layer               │
│        (Data Structures)            │
│    - Codable Models                 │
│    - Business Entities              │
│    - No Logic                       │
└─────────────────────────────────────┘
```

## Core Principles

### 1. Unidirectional Data Flow

```swift
View → ViewModel → Service → Model
  ↑                            │
  └────────────────────────────┘
```

- Views never directly modify data
- ViewModels orchestrate all changes
- Services handle external operations
- Models are immutable value types

### 2. @MainActor for UI Safety

All ViewModels must be marked with `@MainActor`:

```swift
@MainActor
final class FeatureViewModel: ObservableObject {
    // All properties and methods run on main thread
    // No more DispatchQueue.main.async needed!
}
```

### 3. Modern Concurrency

Use async/await throughout:

```swift
// ❌ Old way with completion handlers
func loadData(completion: @escaping (Result<[Item], Error>) -> Void) {
    // Complex callback hell
}

// ✅ Modern way with async/await
func loadData() async throws -> [Item] {
    // Clean, linear code
}
```

## Layer Responsibilities

### View Layer

**Purpose**: Define UI and handle user interaction

**Contains**:
- SwiftUI view declarations
- Layout and styling
- Animation states
- UI-only state (`@State`, `@FocusState`)
- User interaction handlers

**Example**:
```swift
struct FeatureView: View {
    @StateObject private var viewModel: FeatureViewModel
    @State private var isShowingDetail = false  // UI state only
    
    var body: some View {
        Button("Load") {
            Task {
                await viewModel.loadData()  // Call ViewModel
            }
        }
    }
}
```

### ViewModel Layer

**Purpose**: Manage business logic and state

**Contains**:
- Published properties for data
- Business logic methods
- Data transformation
- Coordination between services
- Navigation decisions

**Example**:
```swift
@MainActor
final class FeatureViewModel: ObservableObject {
    @Published private(set) var items: [Item] = []
    @Published private(set) var isLoading = false
    
    private let service: FeatureServiceProtocol
    
    init(service: FeatureServiceProtocol = FeatureService()) {
        self.service = service
    }
    
    func loadData() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            items = try await service.fetchItems()
        } catch {
            // Handle error appropriately
        }
    }
}
```

### Service Layer

**Purpose**: Handle external communication

**Contains**:
- API calls
- Database operations
- File system access
- External SDK integration
- Caching logic

**Example**:
```swift
protocol FeatureServiceProtocol {
    func fetchItems() async throws -> [Item]
}

final class FeatureService: FeatureServiceProtocol {
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchItems() async throws -> [Item] {
        let response: ItemResponse = try await networkClient.get("/items")
        return response.items
    }
}
```

### Model Layer

**Purpose**: Define data structures

**Contains**:
- Data structures
- Codable conformance
- Computed properties (read-only)
- No business logic

**Example**:
```swift
struct Item: Identifiable, Codable {
    let id: UUID
    let title: String
    let createdAt: Date
    
    // Computed properties are OK
    var formattedDate: String {
        createdAt.formatted()
    }
}
```

## Swift 6 Patterns

### Actor Isolation

For thread-safe services:

```swift
actor CacheManager {
    private var cache: [String: Any] = [:]
    
    func store(_ value: Any, for key: String) {
        cache[key] = value
    }
    
    func retrieve(for key: String) -> Any? {
        cache[key]
    }
}
```

### Sendable Conformance

Ensure data can cross concurrency boundaries:

```swift
struct Item: Identifiable, Codable, Sendable {
    let id: UUID
    let title: String
}
```

### Task Groups

For parallel operations:

```swift
func loadMultipleDataSets() async throws {
    try await withThrowingTaskGroup(of: [Item].self) { group in
        group.addTask { try await self.service.fetchItems() }
        group.addTask { try await self.service.fetchArchivedItems() }
        
        for try await items in group {
            self.items.append(contentsOf: items)
        }
    }
}
```

## Common Patterns

### Loading States

```swift
enum ViewState<T> {
    case idle
    case loading
    case loaded(T)
    case error(Error)
}

@MainActor
final class ViewModel: ObservableObject {
    @Published private(set) var state: ViewState<[Item]> = .idle
    
    func load() async {
        state = .loading
        
        do {
            let items = try await service.fetchItems()
            state = .loaded(items)
        } catch {
            state = .error(error)
        }
    }
}
```

### Dependency Injection

Always use protocol-based dependencies:

```swift
@MainActor
final class ViewModel: ObservableObject {
    private let service: ServiceProtocol
    
    // Default to real implementation
    init(service: ServiceProtocol = RealService()) {
        self.service = service
    }
}

// Easy testing
let testVM = ViewModel(service: MockService())
```

### Cancellable Operations

```swift
@MainActor
final class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    private var searchTask: Task<Void, Never>?
    
    init() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] text in
                self?.search(for: text)
            }
            .store(in: &cancellables)
    }
    
    private func search(for text: String) {
        searchTask?.cancel()
        
        searchTask = Task {
            do {
                let results = try await service.search(text)
                if !Task.isCancelled {
                    self.results = results
                }
            } catch {
                // Handle error
            }
        }
    }
}
```

## Testing Strategies

### ViewModel Testing

```swift
@MainActor
final class FeatureViewModelTests: XCTestCase {
    func testLoadData() async throws {
        // Given
        let mockService = MockService()
        mockService.itemsToReturn = [.mock1, .mock2]
        let viewModel = FeatureViewModel(service: mockService)
        
        // When
        await viewModel.loadData()
        
        // Then
        XCTAssertEqual(viewModel.items.count, 2)
        XCTAssertFalse(viewModel.isLoading)
    }
}
```

### Service Testing

```swift
final class FeatureServiceTests: XCTestCase {
    func testFetchItems() async throws {
        // Given
        let mockClient = MockNetworkClient()
        mockClient.responseToReturn = ItemResponse.mock
        let service = FeatureService(networkClient: mockClient)
        
        // When
        let items = try await service.fetchItems()
        
        // Then
        XCTAssertEqual(items.count, 3)
    }
}
```

## Anti-Patterns to Avoid

### ❌ Business Logic in Views

```swift
// BAD
struct BadView: View {
    @State private var items: [Item] = []
    
    var body: some View {
        Button("Load") {
            Task {
                // ❌ API call in View
                let data = try await URLSession.shared.data(from: url)
                items = try JSONDecoder().decode([Item].self, from: data)
            }
        }
    }
}
```

### ❌ Direct Service Access

```swift
// BAD
struct BadView: View {
    let service = FeatureService()  // ❌ Direct dependency
    
    var body: some View {
        Button("Load") {
            Task {
                // ❌ View calling service directly
                let items = try await service.fetchItems()
            }
        }
    }
}
```

### ❌ Missing @MainActor

```swift
// BAD
class BadViewModel: ObservableObject {  // ❌ Missing @MainActor
    @Published var items: [Item] = []
    
    func load() async {
        items = await fetchItems()  // ⚠️ Potential race condition
    }
}
```

## Migration Guide

### From Old Patterns

```swift
// Old: Completion handlers
func loadData(completion: @escaping ([Item]) -> Void) {
    service.fetch { result in
        DispatchQueue.main.async {
            switch result {
            case .success(let items):
                self.items = items
                completion(items)
            case .failure(let error):
                self.handleError(error)
                completion([])
            }
        }
    }
}

// New: Async/await with @MainActor
@MainActor
func loadData() async {
    do {
        items = try await service.fetchItems()
    } catch {
        handleError(error)
    }
}
```

## Best Practices

### 1. Keep ViewModels Focused

One ViewModel per feature, not per app:
```swift
// ✅ Good
LoginViewModel
ProfileViewModel
SettingsViewModel

// ❌ Bad
AppViewModel  // Too broad
```

### 2. Use Computed Properties

For derived state:
```swift
@Published private(set) var items: [Item] = []

var hasItems: Bool {
    !items.isEmpty
}

var itemCount: Int {
    items.count
}
```

### 3. Handle Errors Gracefully

```swift
@Published private(set) var errorMessage = ""
@Published private(set) var showError = false

func handleError(_ error: Error) {
    errorMessage = error.localizedDescription
    showError = true
}
```

### 4. Keep Models Simple

```swift
// ✅ Good - Simple data
struct User: Codable {
    let id: UUID
    let name: String
    let email: String
}

// ❌ Bad - Business logic in model
struct User {
    let id: UUID
    let name: String
    
    func fetchPosts() async { }  // ❌ Don't do this
}
```

## Construct Enforcement

Construct automatically enforces these patterns:

1. **Git hooks** prevent commits with:
   - Business logic in Views
   - Missing @MainActor on ViewModels
   - Direct service access from Views

2. **Architecture checks** validate:
   - Proper layer separation
   - Protocol-based dependencies
   - Async/await usage

3. **Templates** generate:
   - Correct ViewModel structure
   - Proper service protocols
   - Test stubs

## Conclusion

MVVM with Swift 6 provides:
- Clean architecture
- Type-safe concurrency
- Testable code
- Predictable data flow

Construct ensures you follow these patterns consistently, making great architecture inevitable rather than aspirational.

**Trust The Process** - it's been proven at scale.