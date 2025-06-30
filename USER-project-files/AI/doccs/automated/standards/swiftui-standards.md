# SwiftUI Production Standards v3.0

## Core Principles

**Professional DAW Quality**: Code should meet industry-standard requirements for professional audio applications with <50ms latency targets.

**Token-First Development**: Build components with design tokens from day one. Never start with hardcoded values.

**Component Independence**: Every component should work identically regardless of parent container.

**Responsive by Design**: All components must scale properly across iPhone SE to Pro Max.

## General Guidelines

1. **Use the latest SwiftUI APIs and features whenever possible**
   - Leverage native SwiftUI performance optimizations
   - Adopt new lifecycle and state management patterns
   - Utilize built-in accessibility and animation APIs

2. **Implement `async/await` for asynchronous operations**
   - Replace completion handlers with async/await
   - Use `Task` for concurrent operations
   - Handle cancellation properly with `Task.isCancelled`

3. **Write clean, readable, and well-structured code**
   - Follow MARK comment organization (see File Structure Standards below)
   - Use descriptive variable and function names
   - Maintain consistent indentation and spacing

## Critical Visual Quality Standards

### Background Flash Prevention - MANDATORY

**Context**: SwiftUI rendering race conditions cause white flash artifacts during animations, sheet presentations, and view transitions. These flashes completely undermine professional visual quality and are unacceptable for DAW-standard applications.

**Root Cause**: SwiftUI renders layout frames before background colors, causing brief white flashes when:
- Views animate or transition
- Sheets are presented or dragged
- Safe area boundaries are exposed
- Background rendering lags behind layout calculations

#### Required Pattern for ALL Full-Screen Views

```swift
// ❌ NEVER USE - Single background causes flashes
AppColors.darkBackground
    .ignoresSafeArea()

// ✅ ALWAYS USE - Multi-layer prevents flashes
ZStack {
    // Multi-layer background to prevent white flashes
    AppColors.darkBackground
        .ignoresSafeArea(.all, edges: .all)
    
    AppColors.darkBackground
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
}
```

#### Sheet Presentation Pattern - MANDATORY

```swift
// Presenting view (e.g., MainView)
.background(
    // Conditional background when sheet is presented
    showingSheet ? AppColors.darkBackground.ignoresSafeArea(.all) : nil
)
.sheet(isPresented: $showingSheet) {
    SheetContentView()
        .background(AppColors.darkBackground.ignoresSafeArea(.all))
}
```

#### Sheet Content Pattern

```swift
// Sheet content view background
private var backgroundSection: some View {
    ZStack {
        // Multi-layer background to prevent white flashes
        AppColors.darkBackground
            .ignoresSafeArea(.all, edges: .all)
        
        AppColors.darkBackground
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
        
        // Additional background for sheet presentation
        if isSheetPresentation {
            AppColors.darkBackground
                .ignoresSafeArea(.all, edges: .top)
        }
    }
}
```

#### Quality Gates

**BEFORE any commit involving UI changes:**
- [ ] Test all animations for white flashes
- [ ] Test sheet presentations and drag gestures
- [ ] Verify background coverage during view transitions
- [ ] Confirm no white artifacts on device edges

**Views requiring this pattern:**
- All full-screen views (MainView, IntroView, ToolsView, etc.)
- All sheet presentations
- All modal presentations
- All views with animation transitions

**Non-negotiable**: White flash artifacts are **critical bugs** that must be fixed immediately upon discovery.

## File Structure Standards

### MARK Comment Organization
Every SwiftUI view must follow this exact structure:

```swift
struct ConnectWearableView: View {
    // MARK: - Environment & Dependencies
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel = ConnectWearableViewModel()
    
    // MARK: - Design Tokens
    private let tokens: ConnectWearableDesignTokens
    
    // MARK: - State Properties
    @State private var selectedDevice: WearableDevice?
    @State private var showingPermissions = false
    
    // MARK: - Initializer
    init(tokens: ConnectWearableDesignTokens = .responsive) {
        self.tokens = tokens
    }
    
    // MARK: - Body
    var body: some View {
        // Primary view composition using tokens
    }
    
    // MARK: - Subviews
    private var deviceListSection: some View {
        // Decomposed view components using tokens
    }
    
    // MARK: - Actions
    private func handleDeviceSelection(_ device: WearableDevice) {
        // All user interaction handlers
    }
    
    // MARK: - Helpers
    private func formatDeviceStatus(_ status: ConnectionStatus) -> String {
        // Utility functions
    }
}
```

### Token-First Architecture
Replace ALL magic numbers, strings, and configuration values with design tokens:

```swift
// ✅ CORRECT - Token-based from day one
struct ConnectWearableDesignTokens {
    let screenHeight: CGFloat
    
    // Proportional calculations
    var deviceListHeight: CGFloat { screenHeight * 0.55 }
    var connectionButtonHeight: CGFloat { max(50, screenHeight * 0.065) }
    var sectionSpacing: CGFloat { screenHeight * 0.03 }
    
    // Typography scaling
    var headerFontSize: CGFloat { max(28, screenHeight * 0.04) }
    var deviceNameFontSize: CGFloat { max(18, screenHeight * 0.024) }
    
    // Interactive elements
    var minimumTapArea: CGFloat { 44 } // Accessibility requirement
    var cornerRadius: CGFloat { connectionButtonHeight * 0.2 }
    
    // Animation timing
    var connectionAnimation: Animation { .spring(response: 0.4, dampingFraction: 0.8) }
}

// ❌ NEVER DO THIS - Hardcoded values
private enum Constants {
    static let buttonHeight: CGFloat = 56  // Violates token-first principle
    static let spacing: CGFloat = 20       // Breaks responsive design
}
```

## State Management (MVVM Pattern)

### ViewModels
1. **Use `@Published` properties in ViewModels** to manage and update state
2. **Use `@StateObject` for ViewModels**, `@State` for local UI state only
3. **Pass dependencies via initializers** to ensure clear and testable code

```swift
// ✅ CORRECT ViewModel pattern
final class ConnectWearableViewModel: ObservableObject {
    @Published private(set) var devices: [WearableDevice] = []
    @Published private(set) var connectionState: ConnectionState = .disconnected
    @Published private(set) var isLoading = false
    
    private let deviceService: DeviceServiceProtocol
    private let healthKitService: HealthKitServiceProtocol
    
    init(
        deviceService: DeviceServiceProtocol = DeviceService(),
        healthKitService: HealthKitServiceProtocol = HealthKitService()
    ) {
        self.deviceService = deviceService
        self.healthKitService = healthKitService
    }
    
    @MainActor
    func loadDevices() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            devices = try await deviceService.scanForDevices()
        } catch {
            handleError(error)
        }
    }
    
    @MainActor
    func connectToDevice(_ device: WearableDevice) async {
        // Connection logic with proper error handling
    }
}
```

### View State Management
```swift
// ✅ CORRECT View pattern
struct ConnectWearableView: View {
    @StateObject private var viewModel = ConnectWearableViewModel()
    @State private var showingPermissionAlert = false  // Local UI state only
    
    private let tokens: ConnectWearableDesignTokens
    
    var body: some View {
        VStack(spacing: tokens.sectionSpacing) {
            deviceListSection
            connectionStatusSection
            actionButtonsSection
        }
        .task {
            await viewModel.loadDevices()  // async/await for data loading
        }
        .alert("Permissions Required", isPresented: $showingPermissionAlert) {
            // Permission handling
        }
    }
}
```

## Performance Optimization

### For Professional DAW Requirements (<50ms latency)
1. **Use `LazyVStack`, `LazyHStack`, or `LazyVGrid`** for large lists or grids to improve performance
2. **Optimize `ForEach` loops** by providing stable and unique identifiers
3. **Throttle real-time updates** to maintain smooth UI performance

```swift
// ✅ CORRECT - Performance optimized
private var deviceList: some View {
    LazyVStack(spacing: tokens.deviceSpacing) {
        ForEach(viewModel.devices, id: \.id) { device in  // Stable ID
            DeviceRowView(
                device: device,
                tokens: DeviceRowDesignTokens.scaled(from: tokens)
            )
            .onTapGesture {
                Task { await viewModel.connectToDevice(device) }
            }
        }
    }
    .onReceive(viewModel.scanTimer.throttle(for: 0.5, scheduler: RunLoop.main, latest: true)) { _ in
        // Throttled updates for smooth performance
        Task { await viewModel.refreshDeviceStatus() }
    }
}
```

### Memory Management for Audio Apps
```swift
// ✅ CORRECT - Resource cleanup
.onDisappear {
    viewModel.stopScanning()  // Clean up background operations
    audioBuffers.removeAll()  // Release audio resources
}
.onReceive(NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)) { _ in
    handleMemoryWarning()
}
```

## Reusable Components

### Custom View Modifiers with Tokens
1. **Implement custom view modifiers** for shared styling and behavior
2. **Use extensions** to add reusable functionality to existing types
3. **Always use design tokens** in modifiers

```swift
// ✅ CORRECT - Token-based view modifier
struct DeviceRowStyle: ViewModifier {
    let tokens: ConnectWearableDesignTokens
    let isSelected: Bool
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, tokens.horizontalPadding)
            .padding(.vertical, tokens.verticalPadding)
            .background(
                RoundedRectangle(cornerRadius: tokens.cornerRadius)
                    .fill(isSelected ? .blue.opacity(0.2) : .clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: tokens.cornerRadius)
                    .stroke(isSelected ? .blue : .gray.opacity(0.3), lineWidth: 1)
            )
            .animation(tokens.selectionAnimation, value: isSelected)
    }
}

extension View {
    func deviceRowStyle(tokens: ConnectWearableDesignTokens, isSelected: Bool = false) -> some View {
        modifier(DeviceRowStyle(tokens: tokens, isSelected: isSelected))
    }
}
```

### Component Scaling Pattern
```swift
// ✅ CORRECT - Scalable component design
struct DeviceRowDesignTokens {
    let parentTokens: ConnectWearableDesignTokens
    
    var rowHeight: CGFloat { parentTokens.deviceRowHeight }
    var iconSize: CGFloat { parentTokens.iconSize }
    var fontSize: CGFloat { parentTokens.deviceNameFontSize }
    var horizontalPadding: CGFloat { parentTokens.horizontalPadding }
    
    static func scaled(from parent: ConnectWearableDesignTokens) -> DeviceRowDesignTokens {
        DeviceRowDesignTokens(parentTokens: parent)
    }
}
```

## Accessibility (Professional Standards)

### Comprehensive Accessibility Support
1. **Add accessibility modifiers to all UI elements**
2. **Support Dynamic Type** for text scaling
3. **Provide clear accessibility labels and hints**
4. **Include device status in accessibility information**

```swift
// ✅ CORRECT - Complete accessibility implementation
private var deviceConnectionButton: some View {
    Button(action: { Task { await connectToSelectedDevice() } }) {
        HStack(spacing: tokens.iconSpacing) {
            connectionIcon
            Text("Connect Device")
                .font(.system(size: tokens.buttonFontSize))
                .dynamicTypeSize(...DynamicTypeSize.accessibility3)  // Limit scaling
        }
        .frame(height: tokens.connectionButtonHeight)
        .frame(minWidth: tokens.minimumTapArea)  // Accessibility minimum
    }
    .disabled(!canConnect)
    .accessibilityLabel("Connect to \(selectedDevice?.name ?? "selected device")")
    .accessibilityHint("Double tap to establish connection with the selected wearable device")
    .accessibilityValue("Connection status: \(connectionStatus.localizedDescription)")
    .accessibilityAddTraits(canConnect ? [] : .notEnabled)
}

private var connectionStatus: ConnectionStatus {
    viewModel.connectionState
}

extension ConnectionStatus {
    var localizedDescription: String {
        switch self {
        case .disconnected: return "Disconnected"
        case .connecting: return "Connecting"
        case .connected: return "Connected"
        case .error(let message): return "Error: \(message)"
        }
    }
}
```

## SwiftUI Lifecycle

### Modern App Structure
1. **Use the `App` protocol and `@main`** for the app entry point
2. **Implement `Scene`** for managing app structure
3. **Use appropriate lifecycle methods** like `onAppear` and `onDisappear`

```swift
// ✅ CORRECT - Modern app structure
@main
struct RUNApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(coordinator)
        }
    }
}

// ✅ CORRECT - Lifecycle management
struct ConnectWearableView: View {
    @StateObject private var viewModel = ConnectWearableViewModel()
    
    var body: some View {
        content
            .onAppear {
                Task { await viewModel.startScanning() }
            }
            .onDisappear {
                viewModel.stopScanning()
            }
            .task {
                // Async initialization
                await viewModel.requestPermissions()
            }
            .refreshable {
                // Pull-to-refresh support
                await viewModel.refreshDevices()
            }
    }
}
```

## Data Flow (MVVM Pattern)

### Communication Between Layers
1. **Use protocols** to define communication between MVVM layers
2. **Implement proper error handling** in ViewModels and Services
3. **Maintain clear data flow** from Services → ViewModels → Views

```swift
// ✅ CORRECT - Protocol-based architecture
protocol DeviceServiceProtocol {
    func scanForDevices() async throws -> [WearableDevice]
    func connect(to device: WearableDevice) async throws
    func disconnect(from device: WearableDevice) async throws
}

protocol HealthKitServiceProtocol {
    func requestPermissions() async throws
    func startMonitoring() async throws -> AsyncStream<HealthData>
}

// ✅ CORRECT - Error handling in ViewModel
final class ConnectWearableViewModel: ObservableObject {
    @Published private(set) var error: AppError?
    
    @MainActor
    private func handleError(_ error: Error) {
        if let appError = error as? AppError {
            self.error = appError
        } else {
            self.error = .unexpected(error.localizedDescription)
        }
    }
}

enum AppError: LocalizedError {
    case permissionDenied
    case deviceNotFound
    case connectionFailed(String)
    case unexpected(String)
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Permission to access health data was denied"
        case .deviceNotFound:
            return "No compatible devices found"
        case .connectionFailed(let message):
            return "Connection failed: \(message)"
        case .unexpected(let message):
            return "An unexpected error occurred: \(message)"
        }
    }
}
```

## Testing

### Comprehensive Testing Strategy
1. **Write unit tests** for ViewModel and Service logic
2. **Implement UI tests** for critical user flows
3. **Use `PreviewProvider`** for rapid UI iteration and visual validation

```swift
// ✅ CORRECT - Unit testing pattern
@testable import RUN_iOS
import XCTest

final class ConnectWearableViewModelTests: XCTestCase {
    private var viewModel: ConnectWearableViewModel!
    private var mockDeviceService: MockDeviceService!
    private var mockHealthKitService: MockHealthKitService!
    
    override func setUp() {
        super.setUp()
        mockDeviceService = MockDeviceService()
        mockHealthKitService = MockHealthKitService()
        viewModel = ConnectWearableViewModel(
            deviceService: mockDeviceService,
            healthKitService: mockHealthKitService
        )
    }
    
    func testLoadDevicesSuccess() async {
        // Given
        let expectedDevices = [WearableDevice.mock]
        mockDeviceService.devicesResult = .success(expectedDevices)
        
        // When
        await viewModel.loadDevices()
        
        // Then
        XCTAssertEqual(viewModel.devices, expectedDevices)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
    }
}

// ✅ CORRECT - Preview provider with multiple configurations
struct ConnectWearableView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // iPhone SE - compact
            ConnectWearableView(tokens: .compact)
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE - No devices")
            
            // iPhone Standard - with devices
            ConnectWearableView(tokens: .standard)
                .environmentObject(MockConnectWearableViewModel.withDevices)
                .previewDevice("iPhone 14")
                .previewDisplayName("iPhone 14 - With devices")
            
            // iPhone Pro Max - error state
            ConnectWearableView(tokens: .large)
                .environmentObject(MockConnectWearableViewModel.withError)
                .previewDevice("iPhone 14 Pro Max")
                .previewDisplayName("iPhone Pro Max - Error state")
                
            // Dark mode
            ConnectWearableView(tokens: .standard)
                .environmentObject(MockConnectWearableViewModel.withDevices)
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
                
            // Accessibility - Large text
            ConnectWearableView(tokens: .standard)
                .environmentObject(MockConnectWearableViewModel.withDevices)
                .environment(\.dynamicTypeSize, .accessibility3)
                .previewDisplayName("Large text")
        }
    }
}
```

## SwiftUI-Specific Patterns

### Advanced SwiftUI Techniques
1. **Use `@Binding`** for two-way data flow when needed
2. **Implement custom `PreferenceKey`** for child-to-parent communication
3. **Utilize `@Environment`** for dependencies shared across multiple views

```swift
// ✅ CORRECT - Custom PreferenceKey for dynamic sizing
struct DeviceRowHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

// ✅ CORRECT - Environment for shared dependencies
extension EnvironmentValues {
    var deviceManager: DeviceManager {
        get { self[DeviceManagerKey.self] }
        set { self[DeviceManagerKey.self] = newValue }
    }
}

private struct DeviceManagerKey: EnvironmentKey {
    static let defaultValue = DeviceManager()
}

// ✅ CORRECT - Binding for child component communication
struct DeviceSelectionView: View {
    @Binding var selectedDevice: WearableDevice?
    let devices: [WearableDevice]
    let tokens: ConnectWearableDesignTokens
    
    var body: some View {
        LazyVStack(spacing: tokens.deviceSpacing) {
            ForEach(devices, id: \.id) { device in
                DeviceRowView(
                    device: device,
                    isSelected: selectedDevice?.id == device.id,
                    tokens: tokens
                )
                .onTapGesture {
                    selectedDevice = device
                }
            }
        }
    }
}
```

## Code Style and Formatting

### Swift Standards Integration
1. **Follow Swift naming conventions** and style guidelines
2. **Use tools like SwiftLint** to enforce consistent code style
3. **Maintain consistency** with existing codebase patterns

```swift
// ✅ CORRECT - Naming conventions
private func handleDeviceConnectionStateChanged(_ state: ConnectionState) {
    // Clear, descriptive function names
}

private var isConnectedToAppleWatch: Bool {
    // Boolean properties with 'is' prefix
}

// ✅ CORRECT - SwiftLint configuration alignment
// - No force unwrapping
// - Proper access control
// - Descriptive variable names
// - Consistent indentation
```

## Quality Verification

### Code Quality Checklist
Before considering any component "done":

#### **Token-First Compliance**
- [ ] Zero hardcoded UI values (verified with grep search)
- [ ] All measurements use design tokens
- [ ] Component scales properly across device sizes
- [ ] Works independently in different parent containers

#### **Performance Standards**
- [ ] Uses LazyVStack/LazyHStack for lists
- [ ] Proper ForEach identifiers
- [ ] Real-time updates don't block UI
- [ ] Memory cleanup implemented

#### **Professional DAW Quality**
- [ ] <50ms latency requirements considered
- [ ] Smooth 60fps animations
- [ ] Professional haptic feedback patterns
- [ ] Error handling and recovery

#### **Accessibility Compliance**
- [ ] All interactive elements have accessibility labels
- [ ] Dynamic Type support implemented
- [ ] Minimum tap areas respected (44pt)
- [ ] VoiceOver navigation logical

#### **Code Quality**
- [ ] MARK comments organize all sections
- [ ] async/await used for asynchronous operations
- [ ] Proper error handling throughout
- [ ] Unit tests for ViewModel logic
- [ ] Preview configurations for all states

### Automated Verification Commands
```bash
# Verify zero hardcoded values
grep -r "CGFloat.*= [0-9]" . --include="*.swift" | grep -v "tokens"

# Check for Constants enums (should be none in new components)
grep -r "private enum Constants" . --include="*.swift"

# Verify token usage
grep -r "tokens\." . --include="*.swift"

# Check for proper MARK organization
grep -r "// MARK: -" . --include="*.swift"
```

---

## Integration with Existing Standards

This document **extends** the comprehensive standards in `swiftui_code_standards_prompt-v2--2025-06-20--08-43-10.md` with:

- **Token-first development methodology** integration
- **MVVM pattern** specifics (vs VIPER)
- **Professional DAW quality** requirements
- **Modern async/await** patterns
- **Component independence** verification

**For complete standards coverage**, refer to both documents:
- **v2.0**: Comprehensive SwiftUI patterns, animations, performance
- **v3.0**: Modern patterns, MVVM specifics, token-first integration

---

**Key Principle**: Build professional DAW-quality components with design tokens from the first line of code. Every measurement, animation, and interaction should meet industry standards for professional audio applications.