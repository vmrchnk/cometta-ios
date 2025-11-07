//
//  ContentView.swift
//  Cometta
//
//  Created by Vadym on 07.11.2025.
//

import SwiftUI
import Core

struct ContentView: View {
    @Environment(\.theme) var theme

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(theme.colors.primary)

            // Просто і зрозуміло - без bundle параметра!
            Text("hello_world")
                .font(theme.typography.headlineLarge)
                .foregroundStyle(theme.colors.onBackground)

            Text("theme_ready")
                .font(theme.typography.bodyMedium)
                .foregroundStyle(theme.colors.onSurface.opacity(0.7))

            // Color palette preview
            HStack(spacing: 12) {
                Circle()
                    .fill(theme.colors.primary)
                    .frame(width: 40, height: 40)

                Circle()
                    .fill(theme.colors.secondary)
                    .frame(width: 40, height: 40)

                Circle()
                    .fill(theme.colors.success)
                    .frame(width: 40, height: 40)

                Circle()
                    .fill(theme.colors.warning)
                    .frame(width: 40, height: 40)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.colors.background)
    }
}

#Preview("Light") {
    ContentView()
        .theme(.light)
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    ContentView()
        .theme(.dark)
        .preferredColorScheme(.dark)
}
