//
//  RootCoordinatorView.swift
//  Cometta
//
//  Created on 07.11.2025.
//

import SwiftUI

import ComposableArchitecture

struct RootCoordinatorView: View {
    let store: StoreOf<AppFeature>
    // Assuming PersonalizationResponse is needed locally or handled by logic?
    // For now we'll trigger actions.
    
    var body: some View {
        ZStack {
            switch store.currentScreen {
            case .splash:
                Color.black // Placeholder
                    .onAppear {
                        store.send(.onAppear)
                    }
            case .onboarding:
                OnboardingView(
                    store: Store(initialState: OnboardingFeature.State()) {
                        OnboardingFeature()
                    },
                    onComplete: { response in
                        store.send(.onboardingCompleted(response))
                    }
                )
                .transition(.opacity)
            case .main:
                HomeCoordinatorView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: store.currentScreen)
        .onReceive(NotificationCenter.default.publisher(for: .logout)) { _ in
            store.send(.logout)
        }
    }
}

extension Notification.Name {
    static let logout = Notification.Name("logout")
}
