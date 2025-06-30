import SwiftUI

enum WatchSpacing {
    // MARK: - Base Spacing Values (optimized for Watch)
    static let xs: CGFloat = 2
    static let sm: CGFloat = 4
    static let md: CGFloat = 8
    static let lg: CGFloat = 12
    static let xl: CGFloat = 16
    static let xxl: CGFloat = 24
    
    // MARK: - Watch-Specific Spacing
    static let padding = md
    static let margin = lg
    static let buttonHeight: CGFloat = 32
    static let minimumTouchTarget: CGFloat = 44
}

extension EdgeInsets {
    // MARK: - Watch Padding Patterns
    static let watchSmall = EdgeInsets(
        top: WatchSpacing.sm,
        leading: WatchSpacing.sm,
        bottom: WatchSpacing.sm,
        trailing: WatchSpacing.sm
    )
    
    static let watchMedium = EdgeInsets(
        top: WatchSpacing.md,
        leading: WatchSpacing.md,
        bottom: WatchSpacing.md,
        trailing: WatchSpacing.md
    )
    
    static let watchLarge = EdgeInsets(
        top: WatchSpacing.lg,
        leading: WatchSpacing.lg,
        bottom: WatchSpacing.lg,
        trailing: WatchSpacing.lg
    )
}