//
//  AppTheme.swift
//  Cometta
//
//  Created on 07.11.2025.
//

import SwiftUI

struct AppTheme: Sendable {
    let colors: ColorTokens

    init(colors: ColorTokens) {
        self.colors = colors
    }

    static let light = AppTheme(colors: .light)
    static let dark = AppTheme(colors: .dark)
}

// MARK: - Environment Key
private struct ThemeKey: EnvironmentKey {
    static let defaultValue = AppTheme.light
}

extension EnvironmentValues {
    var theme: AppTheme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

// MARK: - View Extension
extension View {
    func theme(_ theme: AppTheme) -> some View {
        environment(\.theme, theme)
    }
}
