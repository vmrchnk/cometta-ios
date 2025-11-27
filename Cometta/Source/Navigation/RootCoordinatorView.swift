//
//  RootCoordinatorView.swift
//  Cometta
//
//  Created on 07.11.2025.
//

import SwiftUI

struct RootCoordinatorView: View {
    @State private var coordinator = Coordinator<RootScreen>()
    @State private var currentScreen: RootScreen = .onboarding
    @State private var personalizationResponse: PersonalizationResponse?

    private let userDefaultsService = UserDefaultsService.shared

    var body: some View {
        build(screen: currentScreen)
    }

    @ViewBuilder
    func build(screen: RootScreen) -> some View {
        switch screen {
        case .splash:
            SplashView()

        case .onboarding:
            OnboardingView(onComplete: { response in
                completeOnboarding(with: response)
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
        personalizationResponse = response
        currentScreen = .main
    }
}
