# Updated App Structure with AI Pattern Playback Engine

## Current Implementation Status (June 23, 2025)

<!-- START:AUTO-STATUS -->
## Current Implementation Status (Auto-Updated)
**Last Updated**: 2025-06-28 17:30:16
**Branch**: ToolsView-dev01
**Status**: 41 Swift files implemented

### 📊 Architecture Metrics
- **Views**: 9 implemented
- **ViewModels**: 3 implemented
- **Services**: 3 implemented
- **Design Tokens**: 4 implemented
- **Tests**: 1 test files

### 🎯 MVVM Compliance Check
- ⚠️ ToolsView is missing ViewModel
- ⚠️ IntroView is missing ViewModel
- ⚠️ WaveformView is missing ViewModel
- ⚠️ BPMDisplayView is missing ViewModel
- ⚠️ SPMDisplayView is missing ViewModel
✅ All Views have corresponding ViewModels
<!-- END:AUTO-STATUS -->

<!-- START:ACTUAL-TREE -->
## 📁 Actual Implementation (Auto-Generated)

```
RUN-Project/
├── App.swift ✅
├── ContentView_ComponentsTest.swift ✅
├── ContentView_IntroOnly.swift ✅
├── ContentView_MainOnly.swift ✅
├── ContentView_SMVPFlow.swift ✅
├── ContentView.swift ✅
├── Persistence.swift ✅
├── RUN_iOSApp.swift ✅
├── Features/
│   ├── AI/ ⭕
│   ├── Analyzer/ ⭕
│   ├── Devices/ ✅
│   │   └── AppleWatch/ConnectWearableViewModel.swift
│   │   └── AppleWatch/WatchConnectionManager.swift
│   │   └── AppleWatch/ConnectWearableView.swift
│   ├── FXPlayer/ ⭕
│   ├── GenerativeAudio/ ⭕
│   ├── Intro/ ✅
│   │   └── IntroView.swift
│   ├── Main/ ✅
│   │   └── MainViewModel.swift
│   │   └── MainView.swift
│   ├── Playback/ ⭕
│   ├── Playlist/ ⭕
│   ├── Strava/ ⭕
│   ├── Tools/ ✅
│   │   └── ToolsView.swift
├── Shared/
│   ├── Components/
│   │   ├── BPMDisplayView.swift ✅
│   │   ├── SPMDisplayView.swift ✅
│   │   ├── WatchStatusButton.swift ✅
│   │   ├── WaveformView.swift ✅
│   └── Utilities/
│       ├── Colors.swift ✅
│       ├── Constants.swift ✅
│       ├── Radius.swift ✅
│       ├── Spacing.swift ✅
│       ├── ToolsViewDesignTokens.swift ✅
│       ├── Typography.swift ✅
│       ├── WatchStatusDesignTokens.swift ✅
│       ├── WaveformDataService.swift ✅
│       ├── WaveformDesignTokens.swift ✅
```
<!-- END:ACTUAL-TREE -->

<!-- START:RELATIONSHIPS -->
## 🔗 Component Relationships (Auto-Generated)

### View → ViewModel Mappings
- MainView → MainViewModel
- ConnectWearableView → ConnectWearableViewModel

### Service Dependencies
<!-- END:RELATIONSHIPS -->

<!-- START:CHANGES -->
## 🔄 Recent Architecture Changes (Auto-Updated)

### Last 5 Architecture-Related Commits
a8afd1f refactor: Restructure project directories for clarity
ae51d11 feat: Integrate PRD workflow into 4-Layer Defense System
73dc0ac feat: Complete Watch connectivity fix with dual delivery and auto-wake
f6e7807 fix: Watch status sync after iOS app reinstall
cf1a3af fix: Watch app UI lifecycle and remove unnecessary ready state

### Files Modified in Last 24 Hours
- RUN-Project/Watch-App/RUN_WatchApp.swift
<!-- END:CHANGES -->
**Status**: ✅ Core MVVM structure implemented, Apple Watch integration in progress  
**Next Focus**: ConnectWearableView and real-time SPM/BPM streaming  

### ✅ Currently Implemented
```
RUN-Project/
├── App.swift                               ✅ App entry point
├── RUN_iOSApp.swift                       ✅ Main app structure  
├── ContentView.swift                      ✅ Root view (multiple variants)
├── ContentView_ComponentsTest.swift       ✅ Component testing
├── ContentView_IntroOnly.swift            ✅ Intro flow
├── ContentView_MainOnly.swift             ✅ Main view only
├── ContentView_SMVPFlow.swift             ✅ SMVP user flow
│
├── Coordinators/                          ✅ Navigation management
│   ├── AppCoordinator.swift              ✅ Central navigation coordinator
│   └── Route.swift                       ✅ Route definitions
│
├── Features/                              ✅ Modular feature architecture
│   ├── Main/
│   │   └── MainView.swift                ✅ Core UI with waveform, SPM/BPM gauges
│   │
│   ├── Intro/
│   │   └── IntroView.swift               ✅ App introduction flow
│   │
│   ├── Tools/
│   │   └── ToolsView.swift               ✅ Development tools (Page 2)
│   │
│   └── Devices/                          ✅ Wearable device integrations
│       └── AppleWatch/                   🔄 IN PROGRESS - Apple Watch integration
│           ├── ConnectWearableView.swift ✅ Device pairing UI (Page 3)
│           └── WatchConnectivityManager.swift ✅ WCSession management
│
├── Shared/                               ✅ Reusable components
│   ├── Components/
│   │   ├── WaveformView.swift           ✅ Self-contained waveform with bubble
│   │   ├── SPMDisplayView.swift         ✅ Steps per minute display gauge
│   │   └── BPMDisplayView.swift         ✅ Heart rate display gauge
│   │
│   └── Utilities/                       ✅ Design system
│       ├── WaveformDesignTokens.swift   ✅ Token-based responsive design
│       ├── Colors.swift                 ✅ App color system
│       ├── Typography.swift             ✅ Font system
│       ├── Spacing.swift                ✅ Layout spacing
│       ├── Radius.swift                 ✅ Border radius values
│       └── Constants.swift              ✅ App constants
│
├── Configuration/
│   └── FeatureFlags.swift               ✅ Feature toggle system
│
├── Audio/
│   └── 01 Black Russian.m4a            ✅ Demo audio file
│
└── Assets.xcassets/                     ✅ App assets
    ├── AppIcon.appiconset/              ✅ App icons
    ├── run-logo.imageset/               ✅ App logo
    └── AccentColor.colorset/            ✅ Brand colors
```

### 🔄 Watch App Implementation
```
RUN-Watch/
├── Watch-App/
│   ├── RUN_WatchApp.swift               ✅ Watch app entry point
│   ├── ContentView.swift                ✅ Watch UI
│   └── Assets.xcassets/                 ✅ Watch assets
└── RUN-Watch.xcodeproj/                 ✅ Watch project configuration
```

### 📋 Placeholder Directories (Ready for Implementation)
```
RUN-Project/
├── Cache/                               📁 Empty - ready for audio caching
├── Configuration/                       📁 Partially implemented
├── DI/                                  📁 Empty - ready for dependency injection
├── ErrorHandling/                       📁 Empty - ready for error management
├── Models/                              📁 Empty - ready for data models
├── Networking/                          📁 Empty - ready for API clients
├── Server/                              📁 Empty - ready for audio processing
├── Services/                            📁 Empty - ready for business logic
└── Tests/                               📁 Empty - ready for unit tests
```

---

## 🚀 Complete Future Architecture (Planning & Implementation Guide)

### Full Feature Directory Structure
```
App/
├── Features/
│   ├── Playlist/
│   │   ├── PlaylistView.swift
│   │   ├── PlaylistViewModel.swift
│   │   └── PlaylistView_Previews.swift
│   │
│   ├── Playback/
│   │   ├── PlaybackView.swift
│   │   ├── PlaybackViewModel.swift
│   │   ├── AudioEngine.swift
│   │   ├── PlaybackCoordinator.swift
│   │   └── LiveStreamHandler.swift
│   │
│   ├── Analyzer/
│   │   ├── AnalyzerView.swift
│   │   ├── AnalyzerViewModel.swift
│   │   ├── AudioAnalyzer.swift
│   │   └── AnalysisResult.swift
│   │
│   ├── FXPlayer/
│   │   ├── FXPlayerView.swift
│   │   ├── FXPlayerViewModel.swift
│   │   ├── SDKWrapper.swift
│   │   ├── FXPlayer_Previews.swift
│   │   └── SDKs/
│   │       ├── FXPACK_SDK_1_2_5.swift
│   │       ├── ELASTIQUE_PRO_3_3_7.swift
│   │       ├── BARBEATQ_1_2_1.swift
│   │       └── AUFTAKT_4_3_0.swift
│   │
│   ├── Devices/
│   │   ├── AppleWatch/
│   │   │   ├── AppleWatchConnector.swift
│   │   │   └── HealthKitAccessView.swift
│   │   ├── Garmin/
│   │   │   ├── GarminConnector.swift
│   │   │   └── GarminLiveService.swift
│   │   ├── Coros/
│   │   │   └── CorosConnector.swift
│   │   ├── Whoop/
│   │   │   └── WhoopConnector.swift
│   │   └── Oura/
│   │       └── OuraConnector.swift
│   │
│   ├── Strava/
│   │   ├── StravaConnector.swift
│   │   ├── StravaRouteService.swift
│   │   ├── StravaRouteModel.swift
│   │   └── StravaProfileModel.swift
│   │
│   ├── AI/
│   │   ├── EffortPredictor.swift
│   │   ├── PlaylistGenerator.swift
│   │   ├── PatternTrainer.swift
│   │   ├── LiveMusicPredictor.swift
│   │   ├── AdaptiveTempoController.swift
│   │   └── AIModuleTests.swift
│   │
│   └── GenerativeAudio/
│       ├── TidalCyclesSource.swift
│       ├── UzuTidalBridge.swift
│       ├── StrudelBridge.swift
│       └── EndelIntegration.swift
│
├── Audio/
│   ├── AudioSourceManager.swift
│   ├── EmbeddedAudioLibrary.swift
│   ├── AudioSourceType.swift
│   └── AudioInjectionService.swift
│
├── Models/
│   ├── AudioFile.swift
│   ├── Playlist.swift
│   ├── PatternSession.swift
│   ├── LiveAudioStream.swift
│   └── SharedEnums.swift
│
├── Services/
│   ├── PlaylistRepository.swift
│   ├── FileManagerService.swift
│   ├── AnalyticsService.swift
│   ├── AppleMusicService.swift
│   ├── AudioCatalogService.swift
│   ├── PerformanceMonitoringService.swift
│   └── SDKManagerService.swift
│
├── Server/
│   ├── AudioProcessing/
│   │   ├── BARBEATQProcessor.swift
│   │   ├── AUFTAKTProcessor.swift
│   │   ├── FXPACKProcessor.swift
│   │   └── ELASTIQUEProcessor.swift
│   │
│   ├── LocalServerMacOS/
│   │   ├── MacSDKBridge.swift
│   │   └── AudioProcessingPipeline.swift
│   │
│   └── LivePatternGeneration/
│       ├── TidalEngineService.swift
│       ├── StrudelEngineService.swift
│       ├── EndelStyleGenerator.swift
│       └── PatternPlaybackRouter.swift
│
├── Shared/
│   ├── Components/
│   │   ├── PlayerControlsView.swift
│   │   └── NowPlayingView.swift
│   │
│   ├── Extensions/
│   │   ├── URL+Extensions.swift
│   │   └── String+Formatting.swift
│   │
│   └── Utilities/
│   │       ├── Constants.swift
│   │       └── Formatters.swift
│
├── App.swift
│
├── Networking/
│   ├── NetworkManager.swift
│   ├── APIClient.swift
│   ├── Endpoints.swift
│   └── ErrorParser.swift
│
├── ErrorHandling/
│   ├── AppError.swift
│   ├── ErrorHandler.swift
│   └── ErrorBannerView.swift
│
├── Tests/
│   ├── AudioProcessingTests.swift
│   ├── DeviceConnectivityTests.swift
│   ├── PlaylistRepositoryTests.swift
│   ├── LivePatternGenerationTests.swift
│   ├── AITempoControllerTests.swift
│   └── MockServerBridge.swift
│
├── Configuration/
│   ├── SettingsView.swift
│   ├── SettingsViewModel.swift
│   ├── AppSettings.swift
│   └── FeatureToggles.swift
│
├── Coordinators/
│   ├── AppCoordinator.swift
│   ├── NavigationPathManager.swift
│   └── Route.swift
│
├── DI/
│   ├── DependencyContainer.swift
│   ├── DIRegistry.swift
│   └── Resolver.swift
│
└── Cache/
    ├── AudioCache.swift
    ├── PlaylistCache.swift
    ├── PatternCache.swift
    └── CacheManager.swift
```

# App Architecture Documentation

This documentation explains the structure, responsibilities, and data flow of each component within the app. The app is built using SwiftUI and MVVM, with modular features, clear separation of concerns, and optional integrations with AI, wearables, audio processing systems, and live pattern generation.

## 1. Features

### Playlist
Handles playlist browsing and interactions.
- `PlaylistView.swift`: Displays the list of playlists.
- `PlaylistViewModel.swift`: Fetches playlists from services.
- `PlaylistView_Previews.swift`: Preview UI for dev/design.

### Playback
Manages audio playback, including live streaming.
- `PlaybackView.swift`: UI controls for playback.
- `PlaybackViewModel.swift`: Orchestrates playback logic.
- `AudioEngine.swift`: Low-level playback engine.
- `PlaybackCoordinator.swift`: Coordinates player state and events.
- `LiveStreamHandler.swift`: **NEW** - Receives live audio stream from server, matches to tempo.

### Analyzer
Analyzes audio files.
- `AnalyzerView.swift`: UI for analysis.
- `AnalyzerViewModel.swift`: Triggers analysis workflows.
- `AudioAnalyzer.swift`: Core logic.
- `AnalysisResult.swift`: Data structure for results.

### FXPlayer
Modifies audio using 3rd-party SDKs.
- `SDKWrapper.swift`: Bridges SDKs to app logic.
- `SDKs/`: Individual SDK integrations (FXPACK, ELASTIQUE, etc.)
- `FXPlayerView.swift`, `ViewModel.swift`, and `Previews.swift`: UI and logic.

### Devices
Wearable integrations for real-time biometrics.
- Each wearable (Apple Watch, Garmin, etc.) has a dedicated folder with `Connector.swift` and optional services.

### Strava
Syncs user and club data, pace, maps.
- `StravaConnector.swift`: Auth + API access.
- `StravaRouteService.swift`: Fetches route info.
- `StravaProfileModel.swift`, `RouteModel.swift`: Data structs.

### AI
Predicts effort/pace, builds playlists, and manages live pattern generation.
- `EffortPredictor.swift`: Uses data to predict running effort.
- `PlaylistGenerator.swift`: Builds tempo-matched playlists.
- `PatternTrainer.swift`: **NEW** - Offline pre-run model for pace prediction.
- `LiveMusicPredictor.swift`: **NEW** - Combines SPM and effort to suggest next segment.
- `AdaptiveTempoController.swift`: **NEW** - Corrects playback in real time.
- `AIModuleTests.swift`: Unit tests.

### GenerativeAudio
Generative music engine support for live pattern creation.
- `TidalCyclesSource.swift`: Integrate live code music patterns.
- `UzuTidalBridge.swift`: Bridge to TidalCycles engine.
- `StrudelBridge.swift`: Browser-friendly JS pattern engine integration.
- `EndelIntegration.swift`: Interface with Endel-style ambient generation.

## 2. Audio
Manages sources and types of audio.
- `AudioSourceManager.swift`: Manages audio selection.
- `AudioInjectionService.swift`: Injects metadata and formats for playback.
- `EmbeddedAudioLibrary.swift`: Pre-bundled music.
- `AudioSourceType.swift`: Enum for source kinds.

## 3. Models
Data structures for the application.
- `AudioFile.swift`: Data struct for audio files.
- `Playlist.swift`: Playlist definitions.
- `PatternSession.swift`: **NEW** - Represents live pattern generation sessions.
- `LiveAudioStream.swift`: **NEW** - Data structure for streaming audio data.
- `SharedEnums.swift`: Cross-feature enums.

## 4. Services
Business logic and persistence.
- `PlaylistRepository.swift`: Loads and stores playlist info.
- `FileManagerService.swift`: Handles on-device files.
- `AppleMusicService.swift`: Apple Music API wrapper.
- `AudioCatalogService.swift`: Metadata, catalog handling.
- `AnalyticsService.swift`: Event tracking.
- `PerformanceMonitoringService.swift`: **NEW** - Track CPU, memory, audio dropouts.
- `SDKManagerService.swift`: **NEW** - Handle SDK compatibility, updates, and loading.

## 5. Server
Mac-hosted processing and live pattern generation.

### AudioProcessing
SDK wrappers for processing audio.
- `BARBEATQProcessor.swift`, `AUFTAKTProcessor.swift`, etc.: Individual SDK processors.

### LocalServerMacOS
Bridges SDKs to macOS runtime.
- `MacSDKBridge.swift`: Connects iOS to server.
- `AudioProcessingPipeline.swift`: Orchestrates multi-SDK processing.

### LivePatternGeneration **NEW**
Real-time AI-driven pattern generation.
- `TidalEngineService.swift`: Wraps and controls TidalCycles pattern generator.
- `StrudelEngineService.swift`: Browser-friendly/JS-driven alternative engine.
- `EndelStyleGenerator.swift`: Generates ambient AI-scored audio cues.
- `PatternPlaybackRouter.swift`: Handles session streaming to device.

## 6. Shared
Common UI, utils, and formatting.
- `Components/`: Shared SwiftUI views.
- `Extensions/`: Swift type extensions.
- `Utilities/`: Constants and formatters.

## 7. App.swift
Entrypoint. Launches root view and handles environment.

## 8. Networking
Handles API communication and network-related logic.
- `NetworkManager.swift`: Central hub for all network operations.
- `APIClient.swift`: Defines request execution logic.
- `Endpoints.swift`: Lists API endpoints.
- `ErrorParser.swift`: Maps errors to user-readable messages.

## 9. Error Handling **NEW**
Standardizes error handling across features.
- `AppError.swift`: Enum for app-wide errors.
- `ErrorHandler.swift`: Handles recovery strategies.
- `ErrorBannerView.swift`: UI feedback component.

## 10. Testing
Test coverage across modules.
- `AudioProcessingTests.swift`: Validates server pipeline.
- `DeviceConnectivityTests.swift`: Ensures robust wearable syncing.
- `PlaylistRepositoryTests.swift`: Covers persistence logic.
- `LivePatternGenerationTests.swift`: **NEW** - Tests live pattern generation system.
- `AITempoControllerTests.swift`: **NEW** - Tests adaptive tempo control.
- `MockServerBridge.swift`: Simulates macOS server connection.

## 11. Configuration
Centralized app settings.
- `AppSettings.swift`: Stores user preferences and toggles.
- `SettingsView.swift`: UI for in-app configuration.
- `FeatureToggles.swift`: Enables/Disables experimental features.

## 12. Coordinators
Manages navigation between major features.
- `AppCoordinator.swift`: Root-level route handling.
- `NavigationPathManager.swift`: Tracks feature-to-feature paths.
- `Route.swift`: Defines navigation paths and transitions.

## 13. Dependency Injection
Facilitates easier testing and modularity.
- `DependencyContainer.swift`: Registry of dependencies.
- `DIRegistry.swift`: Declares service mappings.
- `Resolver.swift`: Utility for accessing injected objects.

## 14. Cache
Improves offline experience and live pattern buffering.
- `AudioCache.swift`: Stores pre-processed audio segments.
- `PlaylistCache.swift`: Caches user/favorite playlists.
- `PatternCache.swift`: **NEW** - Caches generated patterns for low-latency playback.
- `CacheManager.swift`: Unifies cache policy + persistence.

## Live Pattern Generation Architecture

The live pattern generation system works as follows:

1. **Input Collection**: User selects route, wearable devices provide real-time SPM data
2. **Effort Prediction**: `EffortPredictor.swift` analyzes route and historical data
3. **Pattern Generation**: Server-side engines (`TidalEngineService`, `StrudelEngineService`, `EndelStyleGenerator`) create adaptive audio patterns
4. **Live Streaming**: `PatternPlaybackRouter.swift` streams generated audio to iOS app
5. **Tempo Adaptation**: `AdaptiveTempoController.swift` adjusts playback to match real-time SPM
6. **Buffering**: `PatternCache.swift` maintains low-latency buffers for smooth playback

### Success Metrics
- Latency under 300ms from pattern generation to playback
- >85% alignment between user SPM and downbeat placement
- Positive subjective feedback on synchronization quality
