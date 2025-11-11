//
//  SplashView.swift
//  Cometta
//
//  Created on 07.11.2025.
//

import SwiftUI

struct SplashView: View {
    @Environment(\.theme) var theme
    let onComplete: () -> Void

    var body: some View {
        ZStack {
            theme.colors.primary
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // Logo/Icon
                Image(systemName: "star.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(theme.colors.onPrimary)

                Text("Cometta")
                    .font(.largeTitle.bold())
                    .foregroundStyle(theme.colors.onPrimary)
            }
        }
    }
}

#Preview("Light") {
    SplashView(onComplete: {})
        .theme(.light)
}

#Preview("Dark") {
    SplashView(onComplete: {})
        .theme(.dark)
}
