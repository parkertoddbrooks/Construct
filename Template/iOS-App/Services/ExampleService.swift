//
//  ExampleService.swift
//  Construct Template
//
//  Created by Construct
//

import Foundation

// MARK: - Service Protocol

protocol ExampleServiceProtocol {
    func fetchItems() async throws -> [ExampleItem]
    func saveItem(_ item: ExampleItem) async throws
    func deleteItem(id: UUID) async throws
}

// MARK: - Service Implementation

final class ExampleService: ExampleServiceProtocol {
    
    // MARK: - Properties
    
    private let networkClient: NetworkClientProtocol
    private let cacheManager: CacheManagerProtocol
    
    // MARK: - Initialization
    
    init(
        networkClient: NetworkClientProtocol = NetworkClient(),
        cacheManager: CacheManagerProtocol = CacheManager()
    ) {
        self.networkClient = networkClient
        self.cacheManager = cacheManager
    }
    
    // MARK: - Public Methods
    
    func fetchItems() async throws -> [ExampleItem] {
        // Check cache first
        if let cachedItems = await cacheManager.retrieve(key: "example_items") as? [ExampleItem] {
            return cachedItems
        }
        
        // Fetch from network
        let items = try await fetchFromNetwork()
        
        // Cache the results
        await cacheManager.store(items, key: "example_items")
        
        return items
    }
    
    func saveItem(_ item: ExampleItem) async throws {
        // In a real app, this would save to a backend
        try await Task.sleep(nanoseconds: 500_000_000) // Simulate network delay
        
        // Update cache
        var items = try await fetchItems()
        items.append(item)
        await cacheManager.store(items, key: "example_items")
    }
    
    func deleteItem(id: UUID) async throws {
        // In a real app, this would delete from backend
        try await Task.sleep(nanoseconds: 500_000_000) // Simulate network delay
        
        // Update cache
        var items = try await fetchItems()
        items.removeAll { $0.id == id }
        await cacheManager.store(items, key: "example_items")
    }
    
    // MARK: - Private Methods
    
    private func fetchFromNetwork() async throws -> [ExampleItem] {
        // Simulate network request
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
        
        // Return mock data
        return ExampleItem.mockItems
    }
}

// MARK: - Mock Service for Testing

final class MockExampleService: ExampleServiceProtocol {
    
    var shouldFail = false
    var delay: TimeInterval = 0
    var items: [ExampleItem] = ExampleItem.mockItems
    
    func fetchItems() async throws -> [ExampleItem] {
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        
        if shouldFail {
            throw ExampleError.networkError
        }
        
        return items
    }
    
    func saveItem(_ item: ExampleItem) async throws {
        if shouldFail {
            throw ExampleError.saveFailed
        }
        items.append(item)
    }
    
    func deleteItem(id: UUID) async throws {
        if shouldFail {
            throw ExampleError.deleteFailed
        }
        items.removeAll { $0.id == id }
    }
}

// MARK: - Errors

enum ExampleError: LocalizedError {
    case networkError
    case saveFailed
    case deleteFailed
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Unable to connect to the server"
        case .saveFailed:
            return "Failed to save the item"
        case .deleteFailed:
            return "Failed to delete the item"
        case .invalidData:
            return "The data received was invalid"
        }
    }
}

// MARK: - Supporting Protocols (would be in separate files in real project)

protocol NetworkClientProtocol {
    func request<T: Decodable>(_ endpoint: String) async throws -> T
}

protocol CacheManagerProtocol {
    func store<T: Encodable>(_ object: T, key: String) async
    func retrieve(key: String) async -> Any?
    func remove(key: String) async
}

// MARK: - Basic Implementations

struct NetworkClient: NetworkClientProtocol {
    func request<T: Decodable>(_ endpoint: String) async throws -> T {
        // Basic implementation
        throw ExampleError.networkError
    }
}

actor CacheManager: CacheManagerProtocol {
    private var cache: [String: Any] = [:]
    
    func store<T: Encodable>(_ object: T, key: String) async {
        cache[key] = object
    }
    
    func retrieve(key: String) async -> Any? {
        return cache[key]
    }
    
    func remove(key: String) async {
        cache.removeValue(forKey: key)
    }
}