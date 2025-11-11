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
    let secondaryVariant: Color

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
    static let light = ColorTokens(
        primary: Color(red: 0.48, green: 0.37, blue: 1.00),         // #7A5FFF
        primaryVariant: Color(red: 0.35, green: 0.26, blue: 0.82),  // #5A42D1
        secondary: Color(red: 0.99, green: 0.64, blue: 0.07),       // #FCA311
        secondaryVariant: Color(red: 0.95, green: 0.44, blue: 0.05),// #F3700D
        background: Color(red: 0.97, green: 0.97, blue: 0.98),      // #F7F7FA
        surface: Color.white,                                       // #FFFFFF
        onPrimary: Color.white,                                     // #FFFFFF
        onSecondary: Color.black,                                   // #000000
        onBackground: Color(red: 0.12, green: 0.12, blue: 0.15),    // #1F1F26
        onSurface: Color(red: 0.15, green: 0.15, blue: 0.18),       // #26262E
        error: Color(red: 0.95, green: 0.30, blue: 0.30),           // #F24D4D
        success: Color(red: 0.26, green: 0.71, blue: 0.28),         // #43B746
        warning: Color(red: 1.00, green: 0.69, blue: 0.16)          // #FFB028
    )

    static let dark = ColorTokens(
        primary: Color(red: 0.48, green: 0.37, blue: 1.00),         // #7A5FFF
        primaryVariant: Color(red: 0.35, green: 0.26, blue: 0.82),  // #5A42D1
        secondary: Color(red: 0.99, green: 0.64, blue: 0.07),       // #FCA311
        secondaryVariant: Color(red: 0.95, green: 0.44, blue: 0.05),// #F3700D
        background: Color(red: 0.05, green: 0.05, blue: 0.07),      // #0E0E12
        surface: Color(red: 0.11, green: 0.11, blue: 0.13),         // #1C1C22
        onPrimary: Color.white,                                     // #FFFFFF
        onSecondary: Color.black,                                   // #000000
        onBackground: Color(red: 0.95, green: 0.95, blue: 0.95),    // #F2F2F2
        onSurface: Color(red: 0.90, green: 0.90, blue: 0.90),       // #E5E5E5
        error: Color(red: 1.0, green: 0.29, blue: 0.29),            // #FF4B4B
        success: Color(red: 0.30, green: 0.69, blue: 0.31),         // #4CAF50
        warning: Color(red: 1.00, green: 0.76, blue: 0.03)          // #FFC107
    )

    // Автоматична тема на основі системного режиму
    static let `default` = light
}
