//
//  ExampleViewModel.swift
//  Construct Template
//
//  Created by Construct
//

import Foundation
import SwiftUI

// MARK: - View State

enum ExampleViewState {
    case idle
    case loading
    case loaded([ExampleItem])
    case error(Error)
}

// MARK: - View Model

@MainActor
final class ExampleViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published private(set) var items: [ExampleItem] = []
    @Published private(set) var isLoading = false
    @Published private(set) var hasError = false
    @Published private(set) var errorMessage = ""
    
    // MARK: - Dependencies
    
    private let service: ExampleServiceProtocol
    
    // MARK: - Initialization
    
    init(service: ExampleServiceProtocol = ExampleService()) {
        self.service = service
    }
    
    // MARK: - Public Methods
    
    func loadData() async {
        guard !isLoading else { return }
        
        isLoading = true
        hasError = false
        
        do {
            let fetchedItems = try await service.fetchItems()
            self.items = fetchedItems
        } catch {
            self.errorMessage = error.localizedDescription
            self.hasError = true
        }
        
        isLoading = false
    }
    
    func refresh() async {
        // Clear existing data for visual feedback
        items.removeAll()
        await loadData()
    }
    
    func clear() {
        items.removeAll()
        hasError = false
        errorMessage = ""
    }
    
    // MARK: - Private Methods
    
    private func processItems(_ items: [ExampleItem]) -> [ExampleItem] {
        // Business logic for processing items
        items.sorted { $0.title < $1.title }
    }
}

// MARK: - Models

struct ExampleItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let value: String
    let icon: String
}

// Example data for previews
extension ExampleItem {
    static let mockItems: [ExampleItem] = [
        ExampleItem(
            title: "Architecture",
            subtitle: "MVVM with Swift 6",
            value: "✅",
            icon: "building.2"
        ),
        ExampleItem(
            title: "Design Tokens",
            subtitle: "No hardcoded values",
            value: "✅",
            icon: "paintbrush"
        ),
        ExampleItem(
            title: "AI Integration",
            subtitle: "Claude understands",
            value: "✅",
            icon: "brain"
        ),
        ExampleItem(
            title: "Quality Gates",
            subtitle: "Automated enforcement",
            value: "✅",
            icon: "checkmark.shield"
        )
    ]
}