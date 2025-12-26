
import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var currentScreen: RootScreen = .splash
    }

    enum Action: Equatable {
        case onAppear
        case splashFinished(hasSeenOnboarding: Bool)
        case onboardingCompleted(PersonalizationResponse)
        case logout
    }

    @Dependency(\.continuousClock) var clock

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    try? await self.clock.sleep(for: .seconds(2))
                    let hasSeenOnboarding = UserDefaultsService.shared.hasSeenOnboarding
                    await send(.splashFinished(hasSeenOnboarding: hasSeenOnboarding))
                }

            case let .splashFinished(hasSeenOnboarding):
                state.currentScreen = hasSeenOnboarding ? .main : .onboarding
                return .none

            case let .onboardingCompleted(response):
                // In a real app, we might persist response here or via another dependency
                UserDefaultsService.shared.hasSeenOnboarding = true
                state.currentScreen = .main
                print("🔄 Completing onboarding with user ID: \(response.id)")
                return .none

            case .logout:
                UserDefaultsService.shared.hasSeenOnboarding = false
                state.currentScreen = .onboarding
                return .none
            }
        }
    }
}
