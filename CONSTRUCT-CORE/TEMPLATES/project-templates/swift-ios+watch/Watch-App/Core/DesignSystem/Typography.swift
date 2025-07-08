import SwiftUI

extension Font {
    // MARK: - Watch App Typography
    static let watchLargeTitle = Font.largeTitle.weight(.bold)
    static let watchTitle = Font.title.weight(.semibold)
    static let watchTitle2 = Font.title2.weight(.semibold)
    static let watchTitle3 = Font.title3.weight(.medium)
    static let watchHeadline = Font.headline.weight(.medium)
    static let watchSubheadline = Font.subheadline.weight(.regular)
    static let watchBody = Font.body.weight(.regular)
    static let watchCallout = Font.callout.weight(.regular)
    static let watchFootnote = Font.footnote.weight(.regular)
    static let watchCaption = Font.caption.weight(.regular)
    static let watchCaption2 = Font.caption2.weight(.regular)
}

// MARK: - Watch Text Styles
extension Text {
    func watchLargeTitle() -> some View {
        self.font(.watchLargeTitle)
    }
    
    func watchTitle() -> some View {
        self.font(.watchTitle)
    }
    
    func watchTitle2() -> some View {
        self.font(.watchTitle2)
    }
    
    func watchTitle3() -> some View {
        self.font(.watchTitle3)
    }
    
    func watchHeadline() -> some View {
        self.font(.watchHeadline)
    }
    
    func watchSubheadline() -> some View {
        self.font(.watchSubheadline)
    }
    
    func watchBody() -> some View {
        self.font(.watchBody)
    }
    
    func watchCallout() -> some View {
        self.font(.watchCallout)
    }
    
    func watchFootnote() -> some View {
        self.font(.watchFootnote)
    }
    
    func watchCaption() -> some View {
        self.font(.watchCaption)
    }
}