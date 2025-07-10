# MVVM Architecture Pattern

## Overview
Model-View-ViewModel (MVVM) architectural pattern for clean separation of concerns in applications.

## Rules

### View Layer
```
❌ NEVER: Business logic in Views
✅ ALWAYS: Views only handle presentation

❌ NEVER: Direct data manipulation in Views
✅ ALWAYS: All data changes through ViewModel

❌ NEVER: View accessing Services directly
✅ ALWAYS: View → ViewModel → Service
```

### ViewModel Layer
```
❌ NEVER: UI framework references in ViewModels
✅ ALWAYS: ViewModels are UI-framework agnostic

❌ NEVER: Direct View manipulation from ViewModel
✅ ALWAYS: ViewModels expose observable properties

❌ NEVER: ViewModels without interfaces
✅ ALWAYS: Program to interfaces for testability
```

### Model Layer
```
❌ NEVER: Business logic in Models
✅ ALWAYS: Models are pure data structures

❌ NEVER: UI concerns in Models
✅ ALWAYS: Models independent of presentation

❌ NEVER: Mutable Models without notification
✅ ALWAYS: Immutable Models or proper change notification
```

### Data Flow
```
❌ NEVER: Bidirectional dependencies
✅ ALWAYS: Unidirectional data flow

❌ NEVER: Circular references between layers
✅ ALWAYS: Clear dependency hierarchy

❌ NEVER: Skipping layers
✅ ALWAYS: Respect layer boundaries
```

## Examples

### ✅ Good: Proper MVVM Implementation

#### Model
```swift
// Pure data structure
struct User: Codable, Equatable {
    let id: String
    let name: String
    let email: String
    let isActive: Bool
}

// Domain logic in separate service
protocol UserServiceProtocol {
    func fetchUsers() async throws -> [User]
    func updateUser(_ user: User) async throws
}
```

#### ViewModel
```swift
// UI-agnostic ViewModel
@MainActor
protocol UserListViewModelProtocol: ObservableObject {
    var users: [User] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    
    func loadUsers() async
    func selectUser(_ user: User)
}

@MainActor
final class UserListViewModel: UserListViewModelProtocol {
    @Published private(set) var users: [User] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    
    private let userService: UserServiceProtocol
    private let coordinator: CoordinatorProtocol
    
    init(userService: UserServiceProtocol, coordinator: CoordinatorProtocol) {
        self.userService = userService
        self.coordinator = coordinator
    }
    
    func loadUsers() async {
        isLoading = true
        errorMessage = nil
        
        do {
            users = try await userService.fetchUsers()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func selectUser(_ user: User) {
        coordinator.navigate(to: .userDetail(user))
    }
}
```

#### View
```swift
// Pure presentation layer
struct UserListView: View {
    @StateObject private var viewModel: UserListViewModel
    
    init(viewModel: @autoclosure @escaping () -> UserListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        List(viewModel.users) { user in
            UserRow(user: user)
                .onTapGesture {
                    viewModel.selectUser(user)
                }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .task {
            await viewModel.loadUsers()
        }
    }
}
```

### ❌ Bad: MVVM Violations

```swift
// Bad: Business logic in View
struct BadUserListView: View {
    @State private var users: [User] = []
    
    var body: some View {
        List(users) { user in
            Text(user.name)
        }
        .onAppear {
            // ❌ Direct service call from View
            Task {
                users = try await NetworkService.shared.fetchUsers()
            }
        }
    }
}

// Bad: UI concerns in ViewModel
class BadViewModel: ObservableObject {
    @Published var navigationLink: NavigationLink<EmptyView, UserDetailView>?  // ❌ UI framework reference
    
    func formatDate(_ date: Date) -> String {
        // ❌ Formatting logic should be in View or separate formatter
        return DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
    }
}

// Bad: Mutable Model with logic
class BadUser {
    var name: String {
        didSet {
            // ❌ Business logic in Model
            if name.isEmpty {
                name = "Unknown"
            }
        }
    }
    
    func save() {
        // ❌ Persistence logic in Model
        DatabaseManager.shared.save(self)
    }
}
```

## Testing Strategies

### ViewModel Testing
```swift
func testLoadUsersSuccess() async {
    // Arrange
    let mockService = MockUserService()
    mockService.users = [User.fixture()]
    let viewModel = UserListViewModel(userService: mockService)
    
    // Act
    await viewModel.loadUsers()
    
    // Assert
    XCTAssertEqual(viewModel.users.count, 1)
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertNil(viewModel.errorMessage)
}
```

## Integration
This pattern ensures:
- Clear separation of concerns
- Testable architecture
- Maintainable codebase
- Platform-agnostic business logic