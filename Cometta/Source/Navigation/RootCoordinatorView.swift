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
        build(screen: currentScreen)
            .id(currentScreen)
    }

    @ViewBuilder
    func build(screen: RootScreen) -> some View {
        switch screen {
        case .splash:
            SplashView()

        case .onboarding:
            OnboardingView(onComplete: { response in
                Task { @MainActor in
                    completeOnboarding(with: response)
                }
            })
        case .main:
            HomeCoordinatorView()
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
}
