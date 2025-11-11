//
//  ColorTokens.swift
//  Cometta
//
//  Created on 07.11.2025.
//

import SwiftUI

struct ColorTokens: Sendable {
    // Primary colors
    let primary: Color
    let primaryVariant: Color

    // Secondary colors
    let secondary: Color
//    let secondaryVariant: Color

    // Background colors
    let background: Color
    let surface: Color

    // Text colors
    let onPrimary: Color
    let onSecondary: Color
    let onBackground: Color
    let onSurface: Color

    // Utility colors
    let error: Color
    let success: Color
    let warning: Color

    init(
        primary: Color,
        primaryVariant: Color,
        secondary: Color,
//        secondaryVariant: Color,
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
//        self.secondaryVariant = secondaryVariant
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
    
    static let `default` = ColorTokens(
        primary: Color("Colors/Primary"),
        primaryVariant: Color("Colors/PrimaryVariant"),
        secondary: Color("Colors/Secondary"),
//        secondaryVariant: Color("SecondaryVariant"),
        background: Color("Colors/Background"),
        surface: Color("Colors/Surface"),
        onPrimary: Color("Colors/OnPrimary"),
        onSecondary: Color("Colors/OnSecondary"),
        onBackground: Color("Colors/OnBackground"),
        onSurface: Color("Colors/OnSurface"),
        error: Color("Colors/Error"),
        success: Color("Colors/Success"),
        warning: Color("Colors/Warning")
    )
}
