import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var currentScreen: AppScreen = .splash
        var onboarding: OnboardingFeature.State?
    }
    
    enum Action {
        case onAppear
        case setScreen(AppScreen)
        case onboarding(OnboardingFeature.Action)
        case logout
    }
    
    enum AppScreen: Equatable {
        case splash
        case onboarding
        case main
    }
    
    @Dependency(\.userClient) var userClient
    @Dependency(\.continuousClock) var clock
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    if let _ = await userClient.loadUser() {
                        await send(.setScreen(.main))
                    } else {
                        await send(.setScreen(.onboarding))
                    }
                }
            case let .setScreen(screen):
                state.currentScreen = screen
                switch screen {
                case .onboarding:
                    state.onboarding = OnboardingFeature.State()
                case .main, .splash:
                    state.onboarding = nil
                }
                return .none
                
            case .onboarding(.delegate(.completed)):
                return .send(.setScreen(.main))
                
            case .onboarding:
                return .none
                
            case .logout:
                return .run { send in
                    try? await userClient.deleteUser()
                    await send(.setScreen(.onboarding))
                }
            }
        }
        .ifLet(\.onboarding, action: \.onboarding) {
            OnboardingFeature()
        }
    }
}
