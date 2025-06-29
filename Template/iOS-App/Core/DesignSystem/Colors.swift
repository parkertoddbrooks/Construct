//
//  Colors.swift
//  Construct Template
//
//  Created by Construct
//

import SwiftUI

// MARK: - Color Extensions

extension Color {
    // MARK: - Background Colors
    
    static let background = Color("Background")
    static let secondaryBackground = Color("SecondaryBackground")
    static let tertiaryBackground = Color("TertiaryBackground")
    
    // MARK: - Text Colors
    
    static let primaryText = Color("PrimaryText")
    static let secondaryText = Color("SecondaryText")
    static let tertiaryText = Color("TertiaryText")
    
    // MARK: - Brand Colors
    
    static let brandPrimary = Color("BrandPrimary")
    static let brandSecondary = Color("BrandSecondary")
    
    // MARK: - Semantic Colors
    
    static let success = Color("Success")
    static let warning = Color("Warning")
    static let error = Color("Error")
    static let info = Color("Info")
    
    // MARK: - Interactive Colors
    
    static let buttonPrimary = Color("ButtonPrimary")
    static let buttonSecondary = Color("ButtonSecondary")
    static let buttonDisabled = Color("ButtonDisabled")
}

// MARK: - Color Tokens

struct ColorTokens {
    // MARK: - Surface Colors
    
    let surface: Color
    let surfaceSecondary: Color
    let surfaceTertiary: Color
    
    // MARK: - Content Colors
    
    let contentPrimary: Color
    let contentSecondary: Color
    let contentTertiary: Color
    
    // MARK: - Interactive Colors
    
    let interactive: Color
    let interactiveSecondary: Color
    let interactiveDisabled: Color
    
    // MARK: - Semantic Colors
    
    let positive: Color
    let negative: Color
    let warning: Color
    let info: Color
    
    // MARK: - Default Tokens
    
    static let light = ColorTokens(
        surface: .white,
        surfaceSecondary: Color(UIColor.systemGray6),
        surfaceTertiary: Color(UIColor.systemGray5),
        contentPrimary: .black,
        contentSecondary: Color(UIColor.systemGray),
        contentTertiary: Color(UIColor.systemGray2),
        interactive: .accentColor,
        interactiveSecondary: .accentColor.opacity(0.8),
        interactiveDisabled: Color(UIColor.systemGray3),
        positive: .green,
        negative: .red,
        warning: .orange,
        info: .blue
    )
    
    static let dark = ColorTokens(
        surface: Color(UIColor.systemGray6),
        surfaceSecondary: Color(UIColor.systemGray5),
        surfaceTertiary: Color(UIColor.systemGray4),
        contentPrimary: .white,
        contentSecondary: Color(UIColor.systemGray2),
        contentTertiary: Color(UIColor.systemGray3),
        interactive: .accentColor,
        interactiveSecondary: .accentColor.opacity(0.8),
        interactiveDisabled: Color(UIColor.systemGray4),
        positive: .green,
        negative: .red,
        warning: .orange,
        info: .blue
    )
}

// MARK: - Adaptive Colors

struct AdaptiveColor: View {
    @Environment(\.colorScheme) var colorScheme
    
    let light: Color
    let dark: Color
    
    var body: some View {
        colorScheme == .dark ? dark : light
    }
}

// MARK: - Gradient Tokens

struct GradientTokens {
    static let primary = LinearGradient(
        colors: [.brandPrimary, .brandSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let secondary = LinearGradient(
        colors: [.accentColor, .accentColor.opacity(0.7)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let surface = LinearGradient(
        colors: [.background, .secondaryBackground],
        startPoint: .top,
        endPoint: .bottom
    )
}