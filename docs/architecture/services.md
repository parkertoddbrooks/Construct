# Service Layer

A comprehensive guide to building robust, testable service layers in Construct apps.

## Overview

The Service Layer handles all external communication and data operations. It sits between your ViewModels and external systems, providing a clean interface for data access.

## Service Layer Responsibilities

### What Services Handle
- API communication
- Database operations
- File system access
- Cache management
- External SDK integration
- Device capabilities (Camera, Location, etc.)

### What Services DON'T Handle
- UI logic
- State management
- Business rules (beyond data validation)
- Navigation
- View-specific transformations

## Protocol-Driven Design

### Always Start with a Protocol

```swift
protocol UserServiceProtocol {
    func fetchUser(id: String) async throws -> User
    func updateUser(_ user: User) async throws -> User
    func deleteUser(id: String) async throws
    func searchUsers(query: String) async throws -> [User]
}
```

### Benefits
- Easy testing with mocks
- Dependency injection
- Multiple implementations
- Clear contracts
- Loose coupling

## Service Implementation Patterns

### Basic Service Structure

```swift
final class UserService: UserServiceProtocol {
    // MARK: - Dependencies
    
    private let networkClient: NetworkClientProtocol
    private let cacheManager: CacheManagerProtocol
    private let logger: LoggerProtocol
    
    // MARK: - Configuration
    
    private let baseURL: URL
    private let timeout: TimeInterval
    
    // MARK: - Initialization
    
    init(
        networkClient: NetworkClientProtocol = NetworkClient(),
        cacheManager: CacheManagerProtocol = CacheManager.shared,
        logger: LoggerProtocol = Logger.shared,
        baseURL: URL = Config.apiBaseURL,
        timeout: TimeInterval = 30
    ) {
        self.networkClient = networkClient
        self.cacheManager = cacheManager
        self.logger = logger
        self.baseURL = baseURL
        self.timeout = timeout
    }
    
    // MARK: - Public Methods
    
    func fetchUser(id: String) async throws -> User {
        // Check cache first
        let cacheKey = "user_\(id)"
        if let cachedUser = await cacheManager.get(cacheKey, type: User.self) {
            logger.debug("User \(id) found in cache")
            return cachedUser
        }
        
        // Fetch from network
        logger.debug("Fetching user \(id) from network")
        let endpoint = baseURL.appendingPathComponent("users/\(id)")
        let user: User = try await networkClient.get(endpoint, timeout: timeout)
        
        // Cache the result
        await cacheManager.set(user, for: cacheKey, expiry: .minutes(5))
        
        return user
    }
}
```

## Network Layer Integration

### Network Client Protocol

```swift
protocol NetworkClientProtocol {
    func get<T: Decodable>(_ url: URL, timeout: TimeInterval) async throws -> T
    func post<T: Decodable, U: Encodable>(_ url: URL, body: U, timeout: TimeInterval) async throws -> T
    func put<T: Decodable, U: Encodable>(_ url: URL, body: U, timeout: TimeInterval) async throws -> T
    func delete(_ url: URL, timeout: TimeInterval) async throws
}
```

### Implementation with URLSession

```swift
final class NetworkClient: NetworkClientProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
        
        // Configure decoder
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Configure encoder
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = .convertToSnakeCase
    }
    
    func get<T: Decodable>(_ url: URL, timeout: TimeInterval) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = timeout
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await session.data(for: request)
        
        try validateResponse(response)
        
        return try decoder.decode(T.self, from: data)
    }
    
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 401:
            throw NetworkError.unauthorized
        case 404:
            throw NetworkError.notFound
        case 500...599:
            throw NetworkError.serverError(httpResponse.statusCode)
        default:
            throw NetworkError.httpError(httpResponse.statusCode)
        }
    }
}
```

## Error Handling

### Service-Specific Errors

```swift
enum UserServiceError: LocalizedError {
    case userNotFound
    case invalidUserData
    case duplicateEmail
    case weakPassword
    case accountLocked
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "User not found"
        case .invalidUserData:
            return "Invalid user data provided"
        case .duplicateEmail:
            return "Email address already in use"
        case .weakPassword:
            return "Password doesn't meet security requirements"
        case .accountLocked:
            return "Account has been locked"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .userNotFound:
            return "Check the user ID and try again"
        case .invalidUserData:
            return "Verify all required fields are filled"
        case .duplicateEmail:
            return "Try a different email address"
        case .weakPassword:
            return "Use at least 8 characters with numbers and symbols"
        case .accountLocked:
            return "Contact support to unlock your account"
        }
    }
}
```

### Error Transformation

```swift
extension UserService {
    private func transformError(_ error: Error) -> Error {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .notFound:
                return UserServiceError.userNotFound
            case .httpError(409):
                return UserServiceError.duplicateEmail
            default:
                return error
            }
        }
        return error
    }
    
    func updateUser(_ user: User) async throws -> User {
        do {
            let url = baseURL.appendingPathComponent("users/\(user.id)")
            return try await networkClient.put(url, body: user, timeout: timeout)
        } catch {
            throw transformError(error)
        }
    }
}
```

## Caching Strategies

### Cache Manager Protocol

```swift
protocol CacheManagerProtocol {
    func get<T: Decodable>(_ key: String, type: T.Type) async -> T?
    func set<T: Encodable>(_ value: T, for key: String, expiry: CacheExpiry) async
    func remove(_ key: String) async
    func removeAll() async
    func removeExpired() async
}

enum CacheExpiry {
    case never
    case seconds(TimeInterval)
    case minutes(Int)
    case hours(Int)
    case days(Int)
    case date(Date)
    
    var expiryDate: Date? {
        switch self {
        case .never:
            return nil
        case .seconds(let seconds):
            return Date().addingTimeInterval(seconds)
        case .minutes(let minutes):
            return Date().addingTimeInterval(TimeInterval(minutes * 60))
        case .hours(let hours):
            return Date().addingTimeInterval(TimeInterval(hours * 3600))
        case .days(let days):
            return Date().addingTimeInterval(TimeInterval(days * 86400))
        case .date(let date):
            return date
        }
    }
}
```

### Memory + Disk Cache Implementation

```swift
actor CacheManager: CacheManagerProtocol {
    private var memoryCache: [String: CacheEntry] = [:]
    private let diskCache: DiskCache
    private let maxMemorySize: Int
    private var currentMemorySize: Int = 0
    
    init(maxMemorySize: Int = 50_000_000) { // 50MB
        self.maxMemorySize = maxMemorySize
        self.diskCache = DiskCache()
    }
    
    func get<T: Decodable>(_ key: String, type: T.Type) async -> T? {
        // Check memory cache
        if let entry = memoryCache[key], !entry.isExpired {
            return entry.value as? T
        }
        
        // Check disk cache
        if let data = await diskCache.get(key),
           let value = try? JSONDecoder().decode(T.self, from: data) {
            // Add to memory cache
            await set(value, for: key, expiry: .minutes(5))
            return value
        }
        
        return nil
    }
}
```

## Database Integration

### Repository Pattern

```swift
protocol UserRepositoryProtocol {
    func save(_ user: User) async throws
    func find(id: String) async throws -> User?
    func findAll() async throws -> [User]
    func delete(id: String) async throws
    func query(predicate: NSPredicate) async throws -> [User]
}

final class CoreDataUserRepository: UserRepositoryProtocol {
    private let container: NSPersistentContainer
    
    init(container: NSPersistentContainer = PersistenceController.shared.container) {
        self.container = container
    }
    
    func save(_ user: User) async throws {
        let context = container.viewContext
        
        try await context.perform {
            let entity = UserEntity(context: context)
            entity.id = user.id
            entity.name = user.name
            entity.email = user.email
            entity.updatedAt = Date()
            
            try context.save()
        }
    }
}
```

## External SDK Integration

### Location Service Example

```swift
import CoreLocation

protocol LocationServiceProtocol {
    func requestPermission() async -> Bool
    func getCurrentLocation() async throws -> CLLocation
    func startMonitoring()
    func stopMonitoring()
    var locationPublisher: AnyPublisher<CLLocation, Never> { get }
}

final class LocationService: NSObject, LocationServiceProtocol {
    private let locationManager = CLLocationManager()
    private let locationSubject = PassthroughSubject<CLLocation, Never>()
    
    var locationPublisher: AnyPublisher<CLLocation, Never> {
        locationSubject.eraseToAnyPublisher()
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermission() async -> Bool {
        await withCheckedContinuation { continuation in
            locationManager.requestWhenInUseAuthorization()
            
            // Check authorization status
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let status = self.locationManager.authorizationStatus
                continuation.resume(returning: status == .authorizedWhenInUse || status == .authorizedAlways)
            }
        }
    }
}
```

## Testing Services

### Mock Services

```swift
final class MockUserService: UserServiceProtocol {
    // Control behavior
    var shouldFail = false
    var errorToThrow: Error = UserServiceError.userNotFound
    var delay: TimeInterval = 0
    
    // Track calls
    var fetchUserCalled = false
    var lastFetchedUserId: String?
    
    // Mock data
    var users: [String: User] = [:]
    
    init() {
        // Setup default users
        users["1"] = User(id: "1", name: "Test User", email: "test@example.com")
    }
    
    func fetchUser(id: String) async throws -> User {
        fetchUserCalled = true
        lastFetchedUserId = id
        
        // Simulate delay
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        
        // Simulate failure
        if shouldFail {
            throw errorToThrow
        }
        
        // Return mock data
        guard let user = users[id] else {
            throw UserServiceError.userNotFound
        }
        
        return user
    }
}
```

### Service Tests

```swift
final class UserServiceTests: XCTestCase {
    var sut: UserService!
    var mockNetworkClient: MockNetworkClient!
    var mockCacheManager: MockCacheManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkClient = MockNetworkClient()
        mockCacheManager = MockCacheManager()
        sut = UserService(
            networkClient: mockNetworkClient,
            cacheManager: mockCacheManager
        )
    }
    
    func testFetchUserFromCache() async throws {
        // Given
        let cachedUser = User(id: "1", name: "Cached", email: "cached@test.com")
        mockCacheManager.cache["user_1"] = cachedUser
        
        // When
        let user = try await sut.fetchUser(id: "1")
        
        // Then
        XCTAssertEqual(user.name, "Cached")
        XCTAssertFalse(mockNetworkClient.getCalled)
    }
    
    func testFetchUserFromNetwork() async throws {
        // Given
        let networkUser = User(id: "1", name: "Network", email: "network@test.com")
        mockNetworkClient.mockResponse = networkUser
        
        // When
        let user = try await sut.fetchUser(id: "1")
        
        // Then
        XCTAssertEqual(user.name, "Network")
        XCTAssertTrue(mockNetworkClient.getCalled)
        XCTAssertNotNil(mockCacheManager.cache["user_1"])
    }
}
```

## Advanced Patterns

### Retry Logic

```swift
extension Service {
    func withRetry<T>(
        maxAttempts: Int = 3,
        delay: TimeInterval = 1.0,
        operation: () async throws -> T
    ) async throws -> T {
        var lastError: Error?
        
        for attempt in 1...maxAttempts {
            do {
                return try await operation()
            } catch {
                lastError = error
                
                // Don't retry certain errors
                if case NetworkError.unauthorized = error {
                    throw error
                }
                
                // Wait before retry (exponential backoff)
                if attempt < maxAttempts {
                    let backoff = delay * pow(2.0, Double(attempt - 1))
                    try await Task.sleep(nanoseconds: UInt64(backoff * 1_000_000_000))
                }
            }
        }
        
        throw lastError ?? NetworkError.unknown
    }
}
```

### Request Queuing

```swift
actor RequestQueue {
    private var pendingRequests: [UUID: CheckedContinuation<Data, Error>] = [:]
    private var activeRequests: Set<String> = []
    
    func enqueue<T: Decodable>(
        for key: String,
        operation: () async throws -> T
    ) async throws -> T {
        // If request already in progress, wait for it
        if activeRequests.contains(key) {
            return try await waitForExisting(key: key)
        }
        
        // Mark as active
        activeRequests.insert(key)
        
        do {
            let result = try await operation()
            
            // Notify waiting requests
            notifyWaiters(for: key, with: .success(result))
            
            activeRequests.remove(key)
            return result
        } catch {
            notifyWaiters(for: key, with: .failure(error))
            activeRequests.remove(key)
            throw error
        }
    }
}
```

### Service Composition

```swift
final class CompositeUserService: UserServiceProtocol {
    private let localService: UserServiceProtocol
    private let remoteService: UserServiceProtocol
    private let syncService: SyncServiceProtocol
    
    func fetchUser(id: String) async throws -> User {
        // Try local first
        if let localUser = try? await localService.fetchUser(id: id) {
            // Sync in background
            Task {
                try? await syncService.syncUser(id: id)
            }
            return localUser
        }
        
        // Fetch from remote
        let remoteUser = try await remoteService.fetchUser(id: id)
        
        // Save locally
        try? await localService.save(remoteUser)
        
        return remoteUser
    }
}
```

## Best Practices

### 1. Always Use Protocols

```swift
// ✅ Good
let service: UserServiceProtocol

// ❌ Bad
let service: UserService
```

### 2. Inject Dependencies

```swift
// ✅ Good
init(service: UserServiceProtocol = UserService()) {
    self.service = service
}

// ❌ Bad
init() {
    self.service = UserService()
}
```

### 3. Handle Cancellation

```swift
func longRunningOperation() async throws {
    for item in items {
        try Task.checkCancellation()
        try await process(item)
    }
}
```

### 4. Use Appropriate Concurrency

```swift
// Parallel processing
try await withThrowingTaskGroup(of: User.self) { group in
    for userId in userIds {
        group.addTask {
            try await self.fetchUser(id: userId)
        }
    }
    
    // Collect results
    for try await user in group {
        users.append(user)
    }
}
```

## Conclusion

The Service Layer provides:
- Clean separation from UI
- Testable external communication
- Flexible data strategies
- Robust error handling
- Performance optimization

Follow these patterns to build services that are maintainable, testable, and scalable.

**Trust The Process** - let services handle the complexity of external systems.