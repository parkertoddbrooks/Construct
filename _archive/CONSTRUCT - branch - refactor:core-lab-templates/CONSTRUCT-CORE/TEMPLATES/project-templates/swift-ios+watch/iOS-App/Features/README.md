# Features

Add your app features here following MVVM pattern.

Each feature should contain:
- `FeatureView.swift` - SwiftUI view
- `FeatureViewModel.swift` - @MainActor view model
- `FeatureService.swift` - Business logic (if needed)

Example structure:
```
Features/
├── Login/
│   ├── LoginView.swift
│   ├── LoginViewModel.swift
│   └── LoginService.swift
└── Settings/
    ├── SettingsView.swift
    └── SettingsViewModel.swift
```

This README can be deleted once you add your first feature.