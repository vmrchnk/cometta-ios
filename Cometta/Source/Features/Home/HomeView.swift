//
//  HomeView.swift
//  Cometta
//
//  Created by Vadym on 07.11.2025.
//

import SwiftUI
import Lottie

struct HomeView: View {
    @Environment(\.theme) var theme
    let params: Params
    var viewModel: HomeViewModel

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
        Group {
            if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage, theme: theme) {
                    Task {
                        await viewModel.loadDailyHoroscope()
                    }
                }
            } else if let horoscope = viewModel.horoscope {
                DailyHoroscopeView(horoscope: horoscope)
            } else {
                EmptyStateView(theme: theme)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.colors.background)
        .navigationTitle("Daily Horoscope")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadDailyHoroscope()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    params.onAction(.settingsTapped)
                } label: {
                    Image(systemName: "gearshape")
                        .foregroundStyle(theme.colors.primary)
                }
            }
        }
    }
}

// MARK: - Loading View
struct LoadingView: View {
    @Environment(\.colorScheme) var colorScheme
    let theme: AppTheme

    var body: some View {
        VStack(spacing: 20) {
            LottieView(animation: .named(colorScheme == .light ? "loader_light" : "loader"))
                .looping()
                .padding(.horizontal)
            Text("Loading your horoscope...")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(theme.colors.onSurface.opacity(0.6))
                .offset(y: -20)
        }
    }
}

// MARK: - Error View
struct ErrorView: View {
    let message: String
    let theme: AppTheme
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundStyle(theme.colors.onSurface.opacity(0.3))

            Text(message)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(theme.colors.onSurface.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button("Try Again") {
                onRetry()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let theme: AppTheme

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "star.circle")
                .font(.system(size: 60))
                .foregroundStyle(theme.colors.primary.opacity(0.5))

            Text("No horoscope available")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(theme.colors.onSurface.opacity(0.6))
        }
    }
}
//
//#Preview("Light") {
//    NavigationStack {
//        HomeView(params: .init(
//            onAction: { action in
//                print("Action: \(action)")
//            }
//        ))
//    }
//    .theme(.default)
//    .preferredColorScheme(.light)
//}
//
//#Preview("Dark") {
//    NavigationStack {
//        HomeView(params: .init(
//            onAction: { action in
//                print("Action: \(action)")
//            }
//        ))
//    }
//    .theme(.default)
//    .preferredColorScheme(.dark)
//}

#Preview {
    LoadingView(theme: .default)
}
