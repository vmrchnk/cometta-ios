import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var currentScreen: AppScreen = .splash
    }
    
    enum Action {
        case onAppear
        case setScreen(AppScreen)
        case onboardingCompleted(PersonalizationResponse)
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
                return .none
                
            case let .onboardingCompleted(response):
                return .run { send in
                    await try? userClient.saveUser(response)
                    await send(.setScreen(.main))
                }
                
            case .logout:
                return .run { send in
                    try? await userClient.deleteUser()
                    await send(.setScreen(.onboarding))
                }
            }
        }
    }
}
