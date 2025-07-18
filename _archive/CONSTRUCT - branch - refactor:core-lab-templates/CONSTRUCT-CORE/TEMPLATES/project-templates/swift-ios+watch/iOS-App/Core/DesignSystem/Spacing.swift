import SwiftUI

enum Spacing {
    // MARK: - Base Spacing Values
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
    
    // MARK: - Semantic Spacing
    static let padding = md
    static let margin = lg
    static let buttonHeight: CGFloat = 44
    static let minimumTouchTarget: CGFloat = 44
}

extension EdgeInsets {
    // MARK: - Common Padding Patterns
    static let small = EdgeInsets(
        top: Spacing.sm,
        leading: Spacing.sm,
        bottom: Spacing.sm,
        trailing: Spacing.sm
    )
    
    static let medium = EdgeInsets(
        top: Spacing.md,
        leading: Spacing.md,
        bottom: Spacing.md,
        trailing: Spacing.md
    )
    
    static let large = EdgeInsets(
        top: Spacing.lg,
        leading: Spacing.lg,
        bottom: Spacing.lg,
        trailing: Spacing.lg
    )
}