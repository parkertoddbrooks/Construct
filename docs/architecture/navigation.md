# Navigation Patterns

Modern navigation architecture for SwiftUI apps using the Coordinator pattern.

## Overview

Construct uses a Coordinator pattern for navigation, separating navigation logic from views and view models. This creates a clean, testable, and scalable navigation architecture.

## The Problem with Direct Navigation

### ❌ Without Coordinators

```swift
struct ProfileView: View {
    var body: some View {
        NavigationLink("Settings") {
            SettingsView()  // ❌ Direct coupling
        }
        
        Button("Logout") {
            // ❌ View handles navigation logic
            dismiss()
            showLogin = true
        }
    }
}
```

Problems:
- Views know about other views
- Hard to test navigation
- Deep linking is complex
- Reuse is difficult

### ✅ With Coordinators

```swift
struct ProfileView: View {
    let coordinator: ProfileCoordinator
    
    var body: some View {
        Button("Settings") {
            coordinator.showSettings()  // ✅ Decoupled
        }
        
        Button("Logout") {
            coordinator.logout()  // ✅ Coordinator handles flow
        }
    }
}
```

Benefits:
- Views don't know about navigation
- Easy to test
- Deep linking simplified
- Reusable views

## Coordinator Architecture

### Base Coordinator Protocol

```swift
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func finish()
}

extension Coordinator {
    func finish() {
        parentCoordinator?.removeChild(self)
    }
    
    func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
```

### SwiftUI Integration

For pure SwiftUI apps, use NavigationStack:

```swift
@MainActor
protocol SwiftUICoordinator: ObservableObject {
    associatedtype Route: Hashable
    
    var path: NavigationPath { get set }
    
    func navigate(to route: Route)
    func pop()
    func popToRoot()
}
```

## Implementation Examples

### App Coordinator

The root coordinator that manages app-level navigation:

```swift
@MainActor
final class AppCoordinator: ObservableObject {
    @Published var isAuthenticated = false
    @Published var selectedTab = 0
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
        checkAuthentication()
    }
    
    private func checkAuthentication() {
        isAuthenticated = authService.isAuthenticated
    }
    
    func logout() {
        authService.logout()
        isAuthenticated = false
    }
}

// Root view
struct ContentView: View {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        if coordinator.isAuthenticated {
            MainTabView()
                .environmentObject(coordinator)
        } else {
            LoginView()
                .environmentObject(coordinator)
        }
    }
}
```

### Feature Coordinator

Each feature has its own coordinator:

```swift
@MainActor
final class ProfileCoordinator: ObservableObject {
    enum Route: Hashable {
        case profile
        case settings
        case editProfile
        case changePassword
    }
    
    @Published var path = NavigationPath()
    
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func showSettings() {
        navigate(to: .settings)
    }
    
    func showEditProfile() {
        navigate(to: .editProfile)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
}

// Feature root view
struct ProfileRootView: View {
    @StateObject private var coordinator = ProfileCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ProfileView(coordinator: coordinator)
                .navigationDestination(for: ProfileCoordinator.Route.self) { route in
                    switch route {
                    case .profile:
                        ProfileView(coordinator: coordinator)
                    case .settings:
                        SettingsView(coordinator: coordinator)
                    case .editProfile:
                        EditProfileView(coordinator: coordinator)
                    case .changePassword:
                        ChangePasswordView(coordinator: coordinator)
                    }
                }
        }
    }
}
```

## Navigation Patterns

### Tab-Based Navigation

```swift
struct MainTabView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeRootView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            SearchRootView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            ProfileRootView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(2)
        }
    }
}
```

### Modal Presentation

```swift
@MainActor
final class HomeCoordinator: ObservableObject {
    @Published var showingCreatePost = false
    @Published var showingPostDetail: Post?
    
    func presentCreatePost() {
        showingCreatePost = true
    }
    
    func presentPostDetail(_ post: Post) {
        showingPostDetail = post
    }
    
    func dismissModal() {
        showingCreatePost = false
        showingPostDetail = nil
    }
}

struct HomeView: View {
    @ObservedObject var coordinator: HomeCoordinator
    
    var body: some View {
        ScrollView {
            // Content
        }
        .sheet(isPresented: $coordinator.showingCreatePost) {
            CreatePostView(coordinator: CreatePostCoordinator(
                parent: coordinator
            ))
        }
        .sheet(item: $coordinator.showingPostDetail) { post in
            PostDetailView(
                post: post,
                coordinator: PostDetailCoordinator(parent: coordinator)
            )
        }
    }
}
```

### Deep Linking

```swift
@MainActor
final class DeepLinkHandler: ObservableObject {
    private weak var appCoordinator: AppCoordinator?
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    func handle(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host else { return }
        
        switch host {
        case "profile":
            handleProfileDeepLink(components)
        case "post":
            handlePostDeepLink(components)
        default:
            break
        }
    }
    
    private func handleProfileDeepLink(_ components: URLComponents) {
        // Navigate to profile
        appCoordinator?.selectedTab = 2  // Profile tab
        
        if let userId = components.queryItems?.first(where: { $0.name == "id" })?.value {
            // Navigate to specific profile
            // profileCoordinator.showProfile(userId: userId)
        }
    }
}
```

## Advanced Patterns

### Coordinator Communication

```swift
protocol ProfileCoordinatorDelegate: AnyObject {
    func profileCoordinatorDidLogout(_ coordinator: ProfileCoordinator)
    func profileCoordinator(_ coordinator: ProfileCoordinator, didUpdateProfile: Profile)
}

@MainActor
final class ProfileCoordinator: ObservableObject {
    weak var delegate: ProfileCoordinatorDelegate?
    
    func logout() {
        // Perform logout
        delegate?.profileCoordinatorDidLogout(self)
    }
    
    func saveProfile(_ profile: Profile) {
        // Save profile
        delegate?.profileCoordinator(self, didUpdateProfile: profile)
    }
}
```

### Flow Coordinators

For multi-step flows:

```swift
@MainActor
final class OnboardingCoordinator: ObservableObject {
    enum Step: CaseIterable {
        case welcome
        case permissions
        case profile
        case complete
    }
    
    @Published private(set) var currentStep: Step = .welcome
    @Published var path = NavigationPath()
    
    var progress: Double {
        let currentIndex = Step.allCases.firstIndex(of: currentStep) ?? 0
        return Double(currentIndex + 1) / Double(Step.allCases.count)
    }
    
    func next() {
        guard let currentIndex = Step.allCases.firstIndex(of: currentStep),
              currentIndex < Step.allCases.count - 1 else {
            complete()
            return
        }
        
        currentStep = Step.allCases[currentIndex + 1]
        path.append(currentStep)
    }
    
    func back() {
        guard let currentIndex = Step.allCases.firstIndex(of: currentStep),
              currentIndex > 0 else { return }
        
        currentStep = Step.allCases[currentIndex - 1]
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func complete() {
        // Notify app coordinator that onboarding is complete
    }
}
```

### Conditional Navigation

```swift
@MainActor
final class PurchaseCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    private let purchaseService: PurchaseServiceProtocol
    
    func startPurchase(for product: Product) {
        Task {
            do {
                if try await purchaseService.requiresPaymentMethod() {
                    navigate(to: .addPaymentMethod)
                } else {
                    navigate(to: .confirmPurchase(product))
                }
            } catch {
                navigate(to: .error(error))
            }
        }
    }
}
```

## Testing Navigation

### Coordinator Tests

```swift
@MainActor
final class ProfileCoordinatorTests: XCTestCase {
    func testShowSettings() {
        let coordinator = ProfileCoordinator()
        
        coordinator.showSettings()
        
        XCTAssertEqual(coordinator.path.count, 1)
    }
    
    func testPopToRoot() {
        let coordinator = ProfileCoordinator()
        
        coordinator.showSettings()
        coordinator.showEditProfile()
        coordinator.popToRoot()
        
        XCTAssertEqual(coordinator.path.count, 0)
    }
}
```

### Mock Coordinators

```swift
final class MockProfileCoordinator: ProfileCoordinating {
    var showSettingsCalled = false
    var showEditProfileCalled = false
    
    func showSettings() {
        showSettingsCalled = true
    }
    
    func showEditProfile() {
        showEditProfileCalled = true
    }
}

// Test view interactions
func testSettingsButton() {
    let coordinator = MockProfileCoordinator()
    let view = ProfileView(coordinator: coordinator)
    
    // Trigger button tap
    view.settingsButton.tap()
    
    XCTAssertTrue(coordinator.showSettingsCalled)
}
```

## Best Practices

### 1. Keep Coordinators Focused

```swift
// ✅ Good - Feature-specific
ProfileCoordinator
SettingsCoordinator
OnboardingCoordinator

// ❌ Bad - Too broad
NavigationCoordinator
AppNavigationManager
```

### 2. Use Dependency Injection

```swift
struct SettingsView: View {
    let coordinator: SettingsCoordinating  // Protocol, not concrete type
    
    var body: some View {
        // View implementation
    }
}
```

### 3. Handle Memory Management

```swift
// Weak references to prevent cycles
weak var parentCoordinator: Coordinator?
weak var delegate: CoordinatorDelegate?

// Clean up when done
deinit {
    print("Coordinator deallocated: \(self)")
}
```

### 4. Centralize Route Definitions

```swift
enum AppRoute: Hashable {
    case home
    case profile(userId: String?)
    case settings
    case post(id: String)
    
    var deepLink: URL? {
        switch self {
        case .home:
            return URL(string: "app://home")
        case .profile(let userId):
            if let id = userId {
                return URL(string: "app://profile?id=\(id)")
            }
            return URL(string: "app://profile")
        case .settings:
            return URL(string: "app://settings")
        case .post(let id):
            return URL(string: "app://post?id=\(id)")
        }
    }
}
```

## SwiftUI-Specific Considerations

### NavigationStack vs NavigationView

```swift
// ✅ Modern approach (iOS 16+)
NavigationStack(path: $coordinator.path) {
    RootView()
        .navigationDestination(for: Route.self) { route in
            // Return view for route
        }
}

// ⚠️ Legacy approach (iOS 15 and below)
NavigationView {
    RootView()
}
.navigationViewStyle(.stack)
```

### Environment Objects

Pass coordinators through environment:

```swift
struct MyApp: App {
    @StateObject private var appCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appCoordinator)
        }
    }
}

// Access in any child view
struct ChildView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
}
```

## Common Patterns

### Authentication Flow

```swift
@MainActor
final class AuthCoordinator: ObservableObject {
    @Published var isAuthenticated = false
    @Published var showingLogin = false
    @Published var showingSignup = false
    
    func startAuthFlow() {
        showingLogin = true
    }
    
    func switchToSignup() {
        showingLogin = false
        showingSignup = true
    }
    
    func completeAuth() {
        showingLogin = false
        showingSignup = false
        isAuthenticated = true
    }
}
```

### Tab Coordination

```swift
@MainActor
final class TabCoordinator: ObservableObject {
    @Published var selectedTab = 0
    @Published var homePath = NavigationPath()
    @Published var searchPath = NavigationPath()
    @Published var profilePath = NavigationPath()
    
    func resetCurrentTab() {
        switch selectedTab {
        case 0: homePath = NavigationPath()
        case 1: searchPath = NavigationPath()
        case 2: profilePath = NavigationPath()
        default: break
        }
    }
    
    func switchToTabAndNavigate(tab: Int, route: Any) {
        selectedTab = tab
        
        // Give time for tab switch
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            switch tab {
            case 0: self.homePath.append(route)
            case 1: self.searchPath.append(route)
            case 2: self.profilePath.append(route)
            default: break
            }
        }
    }
}
```

## Conclusion

The Coordinator pattern provides:
- Clean separation of concerns
- Testable navigation logic
- Flexible flow management
- Easy deep linking
- Reusable views

Construct's architecture ensures your navigation stays organized and maintainable as your app grows.

**Trust The Process** - let coordinators handle your navigation complexity.