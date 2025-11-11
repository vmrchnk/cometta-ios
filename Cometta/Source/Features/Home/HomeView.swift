//
//  HomeView.swift
//  Cometta
//
//  Created by Vadym on 07.11.2025.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.theme) var theme
    let params: Params

    // MARK: - Params with Action-based approach
    struct Params {
        let onAction: (Action) -> Void
    }

    // MARK: - Actions
    enum Action {
        case profileTapped
        case settingsTapped
        case detailTapped(id: String)
    }

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(theme.colors.primary)

            Text("hello_world")
                .font(.largeTitle)
                .foregroundStyle(theme.colors.onBackground)

            Text("theme_ready")
                .font(.body)
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

            // Navigation examples
            VStack(spacing: 16) {
                Button("Push to Profile") {
                    params.onAction(.profileTapped)
                }
                .buttonStyle(.borderedProminent)

                Button("Show Settings as Sheet") {
                    params.onAction(.settingsTapped)
                }
                .buttonStyle(.bordered)

                Button("Push to Detail") {
                    params.onAction(.detailTapped(id: "123"))
                }
                .buttonStyle(.bordered)
            }
            .padding(.top, 20)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.colors.background)
        .navigationTitle("Home")
    }
}

#Preview("Light") {
    NavigationStack {
        HomeView(params: .init(
            onAction: { action in
                print("Action: \(action)")
            }
        ))
    }
    .theme(.light)
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    NavigationStack {
        HomeView(params: .init(
            onAction: { action in
                print("Action: \(action)")
            }
        ))
    }
    .theme(.dark)
    .preferredColorScheme(.dark)
}
