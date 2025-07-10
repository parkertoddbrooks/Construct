# Swift Language Pattern

## Swift 6 Concurrency Rules

### ✅ DO: Modern Concurrency
- **Use @MainActor for UI updates** - All UI operations must be on main thread
- **async/await patterns** - Modern concurrency for all async operations
- **async throws** - Proper error propagation in async contexts
- **Task groups** - For concurrent operations that need coordination
- **Actors for thread safety** - Isolate mutable state

### ❌ DON'T: Legacy Patterns
- **DispatchQueue.main.async** - Use @MainActor instead
- **Completion handlers** - Replace with async/await
- **UI updates from background** - Always use @MainActor
- **Unstructured concurrency** - Use structured Task hierarchies

## Swift Best Practices

### Type Safety
```swift
// ✅ ALWAYS: Use strong typing
struct UserID: Hashable {
    let value: String
}

// ❌ NEVER: String-typed IDs everywhere
let userId: String = "123"
```

### Protocol-Oriented Design
```swift
// ✅ ALWAYS: Define protocols for dependencies
protocol DataServiceProtocol {
    func fetchData() async throws -> [Model]
}

// ❌ NEVER: Concrete dependencies
class ViewModel {
    let service = DataService() // Hard dependency
}
```

### Error Handling
```swift
// ✅ ALWAYS: Typed errors
enum NetworkError: Error {
    case noConnection
    case invalidResponse
    case serverError(code: Int)
}

// ❌ NEVER: Generic error strings
throw NSError(domain: "error", code: 0)
```

## Memory Management

### ✅ DO: Proper Reference Cycles
- **[weak self] in closures** - Prevent retain cycles
- **unowned for guaranteed references** - When you know it won't be nil
- **Combine cancellables** - Store and clean up properly

### ❌ DON'T: Memory Leaks
- **Strong self in closures** - Creates retain cycles
- **Forgetting to cancel tasks** - Leads to memory leaks
- **Circular references** - Between objects without weak refs

## Performance Patterns

### Value Types
```swift
// ✅ ALWAYS: Prefer structs for data
struct UserData {
    let id: String
    let name: String
}

// ❌ AVOID: Classes for simple data
class UserData {
    var id: String
    var name: String
}
```

### Collection Operations
```swift
// ✅ ALWAYS: Use lazy for large collections
let processed = largeArray
    .lazy
    .map { transform($0) }
    .filter { $0.isValid }

// ❌ NEVER: Process entire array unnecessarily
let processed = largeArray
    .map { transform($0) }  // Processes all items
    .filter { $0.isValid }  // Then filters
```

## Code Organization

### Access Control
- **private** for implementation details
- **internal** for module-wide access
- **public** only for true API surface
- **fileprivate** sparingly, prefer private

### Extensions
```swift
// ✅ ALWAYS: Group functionality
extension UserViewModel {
    // MARK: - Data Loading
    func loadUser() async { }
    
    // MARK: - User Actions  
    func updateProfile() async { }
}

// ❌ NEVER: Everything in main declaration
class UserViewModel {
    // 500 lines of mixed concerns
}
```