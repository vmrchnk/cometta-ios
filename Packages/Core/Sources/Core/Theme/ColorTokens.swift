//
//  ColorTokens.swift
//  Core
//
//  Created on 07.11.2025.
//

import SwiftUI

public struct ColorTokens: Sendable {
    // Primary colors
    public let primary: Color
    public let primaryVariant: Color

    // Secondary colors
    public let secondary: Color
    public let secondaryVariant: Color

    // Background colors
    public let background: Color
    public let surface: Color

    // Text colors
    public let onPrimary: Color
    public let onSecondary: Color
    public let onBackground: Color
    public let onSurface: Color

    // Utility colors
    public let error: Color
    public let success: Color
    public let warning: Color

    public init(
        primary: Color,
        primaryVariant: Color,
        secondary: Color,
        secondaryVariant: Color,
        background: Color,
        surface: Color,
        onPrimary: Color,
        onSecondary: Color,
        onBackground: Color,
        onSurface: Color,
        error: Color,
        success: Color,
        warning: Color
    ) {
        self.primary = primary
        self.primaryVariant = primaryVariant
        self.secondary = secondary
        self.secondaryVariant = secondaryVariant
        self.background = background
        self.surface = surface
        self.onPrimary = onPrimary
        self.onSecondary = onSecondary
        self.onBackground = onBackground
        self.onSurface = onSurface
        self.error = error
        self.success = success
        self.warning = warning
    }
}

// MARK: - Predefined Themes
extension ColorTokens {
    // Використовуємо кольори з Asset Catalog, які автоматично підтримують Dark/Light mode
    public static let `default` = ColorTokens(
        primary: Color("Colors/Primary", bundle: .module),
        primaryVariant: Color(red: 0.20, green: 0.31, blue: 0.85), // #334FD9
        secondary: Color("Colors/Secondary", bundle: .module),
        secondaryVariant: Color(red: 0.85, green: 0.31, blue: 0.49),// #D94F7D
        background: Color("Colors/Background", bundle: .module),
        surface: Color.white,
        onPrimary: Color.white,
        onSecondary: Color.white,
        onBackground: Color("Colors/TextPrimary", bundle: .module),
        onSurface: Color("Colors/TextPrimary", bundle: .module),
        error: Color(red: 0.96, green: 0.26, blue: 0.21),          // #F54336
        success: Color(red: 0.30, green: 0.69, blue: 0.31),        // #4DB04F
        warning: Color(red: 1.00, green: 0.60, blue: 0.00)         // #FF9900
    )

    // Для зворотної сумісності
    public static let light = `default`
    public static let dark = `default`
}
