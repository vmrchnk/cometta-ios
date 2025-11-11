//
//  RootCoordinatorView.swift
//  Cometta
//
//  Created on 07.11.2025.
//

import SwiftUI

struct RootCoordinatorView: View {
    @State private var coordinator = Coordinator<RootScreen>()
    @State private var currentScreen: RootScreen = .splash

    var body: some View {
        build(screen: currentScreen)
            .task {
                // Initial delay then check onboarding
                try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
                completeSplash()
            }
    }

    @ViewBuilder
    func build(screen: RootScreen) -> some View {
        switch screen {
        case .splash:
            EmptyView()

        case .onboarding:
            EmptyView()
        case .main:
            HomeCoordinatorView()
        }
    }

    // Flow logic
    private func completeSplash() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        currentScreen = hasSeenOnboarding ? .main : .onboarding
    }

    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        currentScreen = .main
    }
}
