# Your First Feature

A comprehensive guide to building your first feature with Construct.

## Overview

This guide walks you through creating a complete feature using Construct's patterns. We'll build a Task List feature that demonstrates:
- MVVM architecture
- Design tokens
- Service integration
- Testing
- Accessibility

## Prerequisites

- Completed [Quick Start](quick-start.md)
- Basic SwiftUI knowledge
- Understanding of [What is Construct](../concepts/what-is-construct.md)

## Step 1: Plan Your Feature

### Update the PRD

First, document what you're building:

```bash
# Open your current sprint PRD
open Template/AI/PRDs/current-sprint/*.md
```

Add your feature requirements:
```markdown
## Task List Feature

### Requirements
- [ ] Display list of tasks
- [ ] Add new tasks
- [ ] Mark tasks complete
- [ ] Delete tasks
- [ ] Persist tasks locally

### Success Criteria
- Smooth animations
- Accessible to VoiceOver
- Responsive on all devices
- No hardcoded values
```

### Update Context

```bash
construct-update
```

Now AI knows what you're building!

## Step 2: Discovery

Before creating anything, check what exists:

```bash
construct-before TaskListView
```

This shows:
- Similar components you can reuse
- Available design tokens
- Suggested structure

## Step 3: Create the Feature

### Generate Files

```bash
construct-new TaskListView
```

This creates:
```
Template/iOS-App/Features/TaskList/
├── TaskListView.swift
├── TaskListViewModel.swift
└── TaskListTokens.swift
```

## Step 4: Define the Model

Create `Template/iOS-App/Models/Task.swift`:

```swift
//
//  Task.swift
//  YourApp
//

import Foundation

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var createdAt: Date
    var completedAt: Date?
    
    init(title: String) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
        self.createdAt = Date()
        self.completedAt = nil
    }
    
    mutating func toggleCompletion() {
        isCompleted.toggle()
        completedAt = isCompleted ? Date() : nil
    }
}
```

## Step 5: Build the ViewModel

Edit `TaskListViewModel.swift`:

```swift
import Foundation
import SwiftUI

@MainActor
final class TaskListViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published private(set) var tasks: [Task] = []
    @Published private(set) var isLoading = false
    @Published var newTaskTitle = ""
    
    // MARK: - Dependencies
    
    private let taskService: TaskServiceProtocol
    
    // MARK: - Initialization
    
    init(taskService: TaskServiceProtocol = TaskService()) {
        self.taskService = taskService
    }
    
    // MARK: - Public Methods
    
    func loadTasks() async {
        isLoading = true
        
        do {
            tasks = try await taskService.fetchTasks()
        } catch {
            // In production, handle error appropriately
            print("Failed to load tasks: \(error)")
        }
        
        isLoading = false
    }
    
    func addTask() async {
        let trimmedTitle = newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        
        let task = Task(title: trimmedTitle)
        
        do {
            try await taskService.saveTask(task)
            tasks.append(task)
            newTaskTitle = ""
        } catch {
            print("Failed to save task: \(error)")
        }
    }
    
    func toggleTask(_ task: Task) async {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        
        var updatedTask = task
        updatedTask.toggleCompletion()
        
        do {
            try await taskService.updateTask(updatedTask)
            tasks[index] = updatedTask
        } catch {
            print("Failed to update task: \(error)")
        }
    }
    
    func deleteTask(_ task: Task) async {
        do {
            try await taskService.deleteTask(task.id)
            tasks.removeAll { $0.id == task.id }
        } catch {
            print("Failed to delete task: \(error)")
        }
    }
}
```

## Step 6: Design the View

Edit `TaskListView.swift`:

```swift
import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel: TaskListViewModel
    @FocusState private var isInputFocused: Bool
    
    private let tokens: TaskListTokens
    
    init(tokens: TaskListTokens = .default) {
        self.tokens = tokens
        self._viewModel = StateObject(wrappedValue: TaskListViewModel())
    }
    
    var body: some View {
        ZStack {
            backgroundLayer
            
            VStack(spacing: 0) {
                headerSection
                taskInputSection
                taskListSection
            }
        }
        .task {
            await viewModel.loadTasks()
        }
    }
    
    // MARK: - View Components
    
    private var backgroundLayer: some View {
        ZStack {
            Color.background
                .ignoresSafeArea(.all, edges: .all)
            Color.background
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
        }
    }
    
    private var headerSection: some View {
        Text("Tasks")
            .font(.largeTitle)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(tokens.headerPadding)
            .accessibilityAddTraits(.isHeader)
    }
    
    private var taskInputSection: some View {
        HStack(spacing: tokens.inputSpacing) {
            TextField("Add a task", text: $viewModel.newTaskTitle)
                .textFieldStyle(.roundedBorder)
                .focused($isInputFocused)
                .onSubmit {
                    Task {
                        await viewModel.addTask()
                    }
                }
                .accessibilityLabel("New task title")
            
            Button("Add") {
                Task {
                    await viewModel.addTask()
                    isInputFocused = false
                }
            }
            .buttonStyle(PrimaryButtonStyle(tokens: tokens))
            .disabled(viewModel.newTaskTitle.isEmpty)
        }
        .padding(.horizontal, tokens.contentPadding)
        .padding(.bottom, tokens.sectionSpacing)
    }
    
    private var taskListSection: some View {
        ScrollView {
            LazyVStack(spacing: tokens.itemSpacing) {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(tokens.loadingPadding)
                        .accessibilityLabel("Loading tasks")
                } else if viewModel.tasks.isEmpty {
                    emptyStateView
                } else {
                    ForEach(viewModel.tasks) { task in
                        TaskRow(
                            task: task,
                            tokens: tokens,
                            onToggle: {
                                Task {
                                    await viewModel.toggleTask(task)
                                }
                            },
                            onDelete: {
                                Task {
                                    await viewModel.deleteTask(task)
                                }
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, tokens.contentPadding)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: tokens.emptyStateSpacing) {
            Image(systemName: "checklist")
                .font(.system(size: tokens.emptyStateIconSize))
                .foregroundColor(.secondary)
                .accessibilityHidden(true)
            
            Text("No tasks yet")
                .font(.headline)
            
            Text("Add your first task above")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(tokens.emptyStatePadding)
    }
}

// MARK: - Task Row Component

private struct TaskRow: View {
    let task: Task
    let tokens: TaskListTokens
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: tokens.rowSpacing) {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .accentColor : .secondary)
                    .font(.title3)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(task.isCompleted ? "Mark incomplete" : "Mark complete")
            
            Text(task.title)
                .strikethrough(task.isCompleted)
                .foregroundColor(task.isCompleted ? .secondary : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Delete task")
        }
        .padding(tokens.rowPadding)
        .background(Color.secondaryBackground)
        .cornerRadius(tokens.rowCornerRadius)
    }
}

// MARK: - Button Style

private struct PrimaryButtonStyle: ButtonStyle {
    let tokens: TaskListTokens
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, tokens.buttonPaddingH)
            .padding(.vertical, tokens.buttonPaddingV)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(tokens.buttonCornerRadius)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
```

## Step 7: Create the Service

Create `Template/iOS-App/Services/TaskService.swift`:

```swift
import Foundation

protocol TaskServiceProtocol {
    func fetchTasks() async throws -> [Task]
    func saveTask(_ task: Task) async throws
    func updateTask(_ task: Task) async throws
    func deleteTask(_ id: UUID) async throws
}

final class TaskService: TaskServiceProtocol {
    private let userDefaults = UserDefaults.standard
    private let tasksKey = "com.yourapp.tasks"
    
    func fetchTasks() async throws -> [Task] {
        guard let data = userDefaults.data(forKey: tasksKey) else {
            return []
        }
        
        return try JSONDecoder().decode([Task].self, from: data)
    }
    
    func saveTask(_ task: Task) async throws {
        var tasks = try await fetchTasks()
        tasks.append(task)
        try await saveTasks(tasks)
    }
    
    func updateTask(_ task: Task) async throws {
        var tasks = try await fetchTasks()
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
            throw TaskServiceError.taskNotFound
        }
        tasks[index] = task
        try await saveTasks(tasks)
    }
    
    func deleteTask(_ id: UUID) async throws {
        var tasks = try await fetchTasks()
        tasks.removeAll { $0.id == id }
        try await saveTasks(tasks)
    }
    
    private func saveTasks(_ tasks: [Task]) async throws {
        let data = try JSONEncoder().encode(tasks)
        userDefaults.set(data, forKey: tasksKey)
    }
}

enum TaskServiceError: LocalizedError {
    case taskNotFound
    
    var errorDescription: String? {
        switch self {
        case .taskNotFound:
            return "Task not found"
        }
    }
}
```

## Step 8: Define Tokens

Edit `TaskListTokens.swift`:

```swift
import SwiftUI

struct TaskListTokens {
    // MARK: - Screen Metrics
    
    private let screenWidth: CGFloat
    private let screenHeight: CGFloat
    
    // MARK: - Spacing
    
    var headerPadding: CGFloat { screenWidth * 0.05 }
    var contentPadding: CGFloat { screenWidth * 0.05 }
    var sectionSpacing: CGFloat { screenHeight * 0.02 }
    var itemSpacing: CGFloat { screenHeight * 0.015 }
    var inputSpacing: CGFloat { screenWidth * 0.03 }
    var rowSpacing: CGFloat { screenWidth * 0.03 }
    var emptyStateSpacing: CGFloat { screenHeight * 0.02 }
    
    // MARK: - Sizing
    
    var rowPadding: CGFloat { screenWidth * 0.04 }
    var buttonPaddingH: CGFloat { screenWidth * 0.05 }
    var buttonPaddingV: CGFloat { screenHeight * 0.015 }
    var loadingPadding: CGFloat { screenHeight * 0.1 }
    var emptyStatePadding: CGFloat { screenHeight * 0.1 }
    var emptyStateIconSize: CGFloat { screenWidth * 0.15 }
    
    // MARK: - Radii
    
    var rowCornerRadius: CGFloat { 12 }
    var buttonCornerRadius: CGFloat { 8 }
    
    // MARK: - Initialization
    
    init(screenSize: CGSize = UIScreen.main.bounds.size) {
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height
    }
    
    static let `default` = TaskListTokens()
}
```

## Step 9: Test Your Feature

### Check Architecture

```bash
construct-check
```

This ensures:
- No hardcoded values
- Proper MVVM separation
- All patterns followed

### Check Quality

```bash
construct-protect
```

This validates:
- Accessibility
- Performance patterns
- Swift 6 compliance

## Step 10: Integrate

Add your feature to the app navigation:

```swift
// In your ContentView or AppCoordinator
TaskListView()
```

## Key Learnings

### What You've Built
- Complete MVVM feature
- Service layer with protocols
- Persistent storage
- Accessible UI
- Responsive design with tokens

### Patterns Demonstrated
1. **View**: UI only, no business logic
2. **ViewModel**: @MainActor, async/await
3. **Service**: Protocol-driven, testable
4. **Tokens**: No hardcoded values
5. **Accessibility**: Labels and traits

### What Construct Enforced
- Git hooks prevented hardcoded values
- Architecture checks ensured MVVM
- Quality checks validated accessibility
- Token system made it responsive

## Next Steps

1. **Add Tests**: Create unit tests for ViewModel
2. **Enhance UI**: Add animations and transitions
3. **Add Features**: Search, filtering, categories
4. **Share Code**: Components can be reused

## Common Mistakes to Avoid

### ❌ Don't Put Logic in Views
```swift
// BAD - Logic in View
Button("Save") {
    let task = Task(title: title)
    tasks.append(task)  // ❌ Direct manipulation
}

// GOOD - Call ViewModel
Button("Save") {
    await viewModel.addTask()  // ✅ ViewModel handles it
}
```

### ❌ Don't Use Hardcoded Values
```swift
// BAD
.padding(16)  // ❌ Hardcoded

// GOOD  
.padding(tokens.contentPadding)  // ✅ Token-based
```

### ❌ Don't Skip Accessibility
```swift
// BAD
Image(systemName: "trash")  // ❌ No label

// GOOD
Image(systemName: "trash")
    .accessibilityLabel("Delete task")  // ✅ Accessible
```

## Conclusion

You've built a complete feature following Construct patterns. The system:
- Guided you to the right patterns
- Prevented common mistakes
- Ensured quality and accessibility
- Made your code maintainable

**Trust The Process** - it works!

---

Next: [Working with AI](ai-integration.md) to see how AI assistants understand your patterns.