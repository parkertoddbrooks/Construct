import SwiftUI

extension Color {
    // MARK: - Watch App Colors
    static let watchPrimaryBackground = Color(
        light: Color(.systemBackground),
        dark: Color(.systemBackground)
    )
    
    static let watchSecondaryBackground = Color(
        light: Color(.secondarySystemBackground),
        dark: Color(.secondarySystemBackground)
    )
    
    static let watchAccent = Color.accentColor
    
    static let watchText = Color(
        light: Color(.label),
        dark: Color(.label)
    )
    
    static let watchSecondaryText = Color(
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