# Watch App Features

Add your Watch app features here following MVVM pattern.

Each feature should contain:
- `FeatureView.swift` - SwiftUI view optimized for Watch
- `FeatureViewModel.swift` - @MainActor view model
- `FeatureService.swift` - Business logic (if needed)

Example structure:
```
Features/
├── Metrics/
│   ├── MetricsView.swift
│   ├── MetricsViewModel.swift
│   └── MetricsService.swift
└── Settings/
    ├── SettingsView.swift
    └── SettingsViewModel.swift
```

Watch-specific considerations:
- Small screen sizes
- Quick interactions
- Limited battery
- Complications support

This README can be deleted once you add your first feature.