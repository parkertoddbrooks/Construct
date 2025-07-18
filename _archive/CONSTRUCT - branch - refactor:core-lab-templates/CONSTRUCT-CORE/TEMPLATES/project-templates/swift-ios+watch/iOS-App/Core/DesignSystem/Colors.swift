import SwiftUI

extension Color {
    // MARK: - App Colors
    static let primaryBackground = Color(
        light: Color(.systemBackground),
        dark: Color(.systemBackground)
    )
    
    static let secondaryBackground = Color(
        light: Color(.secondarySystemBackground),
        dark: Color(.secondarySystemBackground)
    )
    
    static let accent = Color.accentColor
    
    static let text = Color(
        light: Color(.label),
        dark: Color(.label)
    )
    
    static let secondaryText = Color(
        light: Color(.secondaryLabel),
        dark: Color(.secondaryLabel)
    )
}

extension Color {
    init(light: Color, dark: Color) {
        self.init(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
    }
}