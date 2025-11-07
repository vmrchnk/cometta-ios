//
//  Typography.swift
//  Core
//
//  Created on 07.11.2025.
//

import SwiftUI

public struct Typography: Sendable {
    // Display styles
    public let displayLarge: Font
    public let displayMedium: Font
    public let displaySmall: Font

    // Headline styles
    public let headlineLarge: Font
    public let headlineMedium: Font
    public let headlineSmall: Font

    // Title styles
    public let titleLarge: Font
    public let titleMedium: Font
    public let titleSmall: Font

    // Body styles
    public let bodyLarge: Font
    public let bodyMedium: Font
    public let bodySmall: Font

    // Label styles
    public let labelLarge: Font
    public let labelMedium: Font
    public let labelSmall: Font

    public init(
        displayLarge: Font,
        displayMedium: Font,
        displaySmall: Font,
        headlineLarge: Font,
        headlineMedium: Font,
        headlineSmall: Font,
        titleLarge: Font,
        titleMedium: Font,
        titleSmall: Font,
        bodyLarge: Font,
        bodyMedium: Font,
        bodySmall: Font,
        labelLarge: Font,
        labelMedium: Font,
        labelSmall: Font
    ) {
        self.displayLarge = displayLarge
        self.displayMedium = displayMedium
        self.displaySmall = displaySmall
        self.headlineLarge = headlineLarge
        self.headlineMedium = headlineMedium
        self.headlineSmall = headlineSmall
        self.titleLarge = titleLarge
        self.titleMedium = titleMedium
        self.titleSmall = titleSmall
        self.bodyLarge = bodyLarge
        self.bodyMedium = bodyMedium
        self.bodySmall = bodySmall
        self.labelLarge = labelLarge
        self.labelMedium = labelMedium
        self.labelSmall = labelSmall
    }
}

// MARK: - Default Typography
extension Typography {
    public static let `default` = Typography(
        displayLarge: .system(size: 57, weight: .regular),
        displayMedium: .system(size: 45, weight: .regular),
        displaySmall: .system(size: 36, weight: .regular),
        headlineLarge: .system(size: 32, weight: .semibold),
        headlineMedium: .system(size: 28, weight: .semibold),
        headlineSmall: .system(size: 24, weight: .semibold),
        titleLarge: .system(size: 22, weight: .medium),
        titleMedium: .system(size: 16, weight: .medium),
        titleSmall: .system(size: 14, weight: .medium),
        bodyLarge: .system(size: 16, weight: .regular),
        bodyMedium: .system(size: 14, weight: .regular),
        bodySmall: .system(size: 12, weight: .regular),
        labelLarge: .system(size: 14, weight: .medium),
        labelMedium: .system(size: 12, weight: .medium),
        labelSmall: .system(size: 11, weight: .medium)
    )
}
