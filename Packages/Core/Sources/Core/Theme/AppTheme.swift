//
//  AppTheme.swift
//  Core
//
//  Created on 07.11.2025.
//

import SwiftUI

public struct AppTheme: Sendable {
    public let colors: ColorTokens
    public let typography: Typography

    public init(colors: ColorTokens, typography: Typography) {
        self.colors = colors
        self.typography = typography
    }

    public static let light = AppTheme(
        colors: .light,
        typography: .default
    )

    public static let dark = AppTheme(
        colors: .dark,
        typography: .default
    )
}

// MARK: - Environment Key
private struct ThemeKey: EnvironmentKey {
    static let defaultValue = AppTheme.light
}

extension EnvironmentValues {
    public var theme: AppTheme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

// MARK: - View Extension
extension View {
    public func theme(_ theme: AppTheme) -> some View {
        environment(\.theme, theme)
    }
}
