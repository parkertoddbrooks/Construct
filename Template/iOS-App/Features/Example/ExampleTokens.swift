//
//  ExampleTokens.swift
//  Construct Template
//
//  Created by Construct
//

import SwiftUI

struct ExampleTokens {
    // MARK: - Screen Metrics
    
    private let screenWidth: CGFloat
    private let screenHeight: CGFloat
    
    // MARK: - Spacing
    
    var spacing: CGFloat { screenWidth * 0.05 }
    var padding: CGFloat { screenWidth * 0.04 }
    var headerSpacing: CGFloat { screenHeight * 0.02 }
    var contentSpacing: CGFloat { screenHeight * 0.03 }
    var itemSpacing: CGFloat { screenHeight * 0.01 }
    var itemPadding: CGFloat { screenWidth * 0.04 }
    var buttonSpacing: CGFloat { screenWidth * 0.04 }
    
    // MARK: - Sizing
    
    var buttonPaddingH: CGFloat { screenWidth * 0.06 }
    var buttonPaddingV: CGFloat { screenHeight * 0.02 }
    var buttonHeight: CGFloat { max(44, screenHeight * 0.06) } // Minimum 44pt for accessibility
    
    // MARK: - Radii
    
    var cornerRadius: CGFloat { 12 }
    var buttonCornerRadius: CGFloat { 8 }
    
    // MARK: - Initialization
    
    init(screenSize: CGSize = UIScreen.main.bounds.size) {
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height
    }
    
    // MARK: - Default Instance
    
    static let `default` = ExampleTokens()
    
    // MARK: - Preview Instances
    
    static let iPhone14 = ExampleTokens(screenSize: CGSize(width: 390, height: 844))
    static let iPhone14Pro = ExampleTokens(screenSize: CGSize(width: 393, height: 852))
    static let iPhone14ProMax = ExampleTokens(screenSize: CGSize(width: 430, height: 932))
    static let iPhoneSE = ExampleTokens(screenSize: CGSize(width: 375, height: 667))
    static let iPad = ExampleTokens(screenSize: CGSize(width: 820, height: 1180))
}

// MARK: - Token Extensions

extension ExampleTokens {
    // Computed properties for complex calculations
    
    var contentHeight: CGFloat {
        screenHeight - (headerHeight + actionHeight + padding * 2)
    }
    
    var headerHeight: CGFloat {
        screenHeight * 0.15
    }
    
    var actionHeight: CGFloat {
        buttonHeight + padding * 2
    }
}

// MARK: - Preview Helpers

extension ExampleTokens {
    static func previewTokens(for device: PreviewDevice) -> ExampleTokens {
        switch device.rawValue {
        case "iPhone 14":
            return .iPhone14
        case "iPhone 14 Pro":
            return .iPhone14Pro
        case "iPhone 14 Pro Max":
            return .iPhone14ProMax
        case "iPhone SE (3rd generation)":
            return .iPhoneSE
        case "iPad Pro (11-inch) (4th generation)":
            return .iPad
        default:
            return .default
        }
    }
}