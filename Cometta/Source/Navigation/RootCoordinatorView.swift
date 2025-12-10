//
//  RootCoordinatorView.swift
//  Cometta
//
//  Created on 07.11.2025.
//

import SwiftUI

struct RootCoordinatorView: View {
    @State private var coordinator = Coordinator<RootScreen>()
    @State private var personalizationResponse: PersonalizationResponse?

    private let userDefaultsService = UserDefaultsService.shared

    @State private var currentScreen: RootScreen

    init() {
        let hasSeenOnboarding = UserDefaultsService.shared.hasSeenOnboarding
        let userId = UserDefaultsService.shared.userId
        print("🚀 RootCoordinator init - hasSeenOnboarding: \(hasSeenOnboarding), userId: \(userId ?? "nil")")
        _currentScreen = State(initialValue: hasSeenOnboarding ? .main : .onboarding)
    }

    var body: some View {
        ZStack {
            switch currentScreen {
            case .splash:
                SplashView()
                    .transition(.opacity)
            case .onboarding:
                OnboardingView(onComplete: { response in
                    Task { @MainActor in
                        completeOnboarding(with: response)
                    }
                })
                .transition(.opacity)
            case .main:
                HomeCoordinatorView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: currentScreen)
        .onReceive(NotificationCenter.default.publisher(for: .logout)) { _ in
            handleLogout()
        }
    }

    // Flow logic
    private func completeSplash() {
        currentScreen = userDefaultsService.hasSeenOnboarding ? .main : .onboarding
    }

    private func completeOnboarding(with response: PersonalizationResponse) {
        print("🔄 Completing onboarding with user ID: \(response.id)")
        personalizationResponse = response
        withAnimation {
            currentScreen = .main
        }
        print("🔄 Current screen changed to: \(currentScreen)")
    }

    private func handleLogout() {
        print("🚪 Logging out...")
        // Reset onboarding state
        userDefaultsService.hasSeenOnboarding = false
        // Update screen
        withAnimation(.easeInOut(duration: 0.5)) {
            currentScreen = .onboarding
        }
    }
}

extension Notification.Name {
    static let logout = Notification.Name("logout")
}
