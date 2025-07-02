import SwiftUI

extension Font {
    // MARK: - App Typography
    static let appLargeTitle = Font.largeTitle.weight(.bold)
    static let appTitle = Font.title.weight(.semibold)
    static let appTitle2 = Font.title2.weight(.semibold)
    static let appTitle3 = Font.title3.weight(.medium)
    static let appHeadline = Font.headline.weight(.medium)
    static let appSubheadline = Font.subheadline.weight(.regular)
    static let appBody = Font.body.weight(.regular)
    static let appCallout = Font.callout.weight(.regular)
    static let appFootnote = Font.footnote.weight(.regular)
    static let appCaption = Font.caption.weight(.regular)
    static let appCaption2 = Font.caption2.weight(.regular)
}

// MARK: - Text Styles
extension Text {
    func appLargeTitle() -> some View {
        self.font(.appLargeTitle)
    }
    
    func appTitle() -> some View {
        self.font(.appTitle)
    }
    
    func appTitle2() -> some View {
        self.font(.appTitle2)
    }
    
    func appTitle3() -> some View {
        self.font(.appTitle3)
    }
    
    func appHeadline() -> some View {
        self.font(.appHeadline)
    }
    
    func appSubheadline() -> some View {
        self.font(.appSubheadline)
    }
    
    func appBody() -> some View {
        self.font(.appBody)
    }
    
    func appCallout() -> some View {
        self.font(.appCallout)
    }
    
    func appFootnote() -> some View {
        self.font(.appFootnote)
    }
    
    func appCaption() -> some View {
        self.font(.appCaption)
    }
}