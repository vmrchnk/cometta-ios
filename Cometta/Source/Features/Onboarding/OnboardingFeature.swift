
import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct OnboardingFeature {
    @ObservableState
    struct State: Equatable {
        var currentPage = 0
        var direction: NavigationDirection = .forward
        
        // User Data
        var birthday: Date = Date()
        var birthdayTime: Date = Date()
        var selectedLocation: SearchLocation?
        var selectedGender: GenderOption?
        
        var completionResponse: PersonalizationResponse?
        
        // Search State
        var searchText = ""
        var searchResults: [SearchLocation] = []
        var isSearchingLocally = false // renamed to avoid conflict or clear distinction
        
        var isLoading = false
        var errorMessage: String?
        
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case nextPage
        case previousPage
        case setGender(GenderOption)
        case submitPersonalization
        case personalizationResponse(Result<PersonalizationResponse, NetworkError>)
        case delegate(Delegate)
        case searchTextChanged(String)
        case searchResponse(Result<[SearchLocation], NetworkError>)
        
        enum Delegate: Equatable {
            case completed(PersonalizationResponse)
        }
    }
    
    @Dependency(\.continuousClock) var clock
    


    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .nextPage:
                if state.currentPage < 4 { // 5 pages total (0-4)
                    state.direction = .forward
                    state.currentPage += 1
                }
                return .none
                
            case .previousPage:
                if state.currentPage > 0 {
                    state.direction = .backward
                    state.currentPage -= 1
                }
                return .none
                
            case let .setGender(gender):
                state.selectedGender = gender
                return .none

            case let .searchTextChanged(query):
                state.searchText = query
                if query.count < 2 {
                    state.searchResults = []
                    state.selectedLocation = nil
                    return .cancel(id: "search")
                }
                
                return .run { send in
                    do {
                        try await Task.sleep(nanoseconds: 500_000_000)
                        let results = try await LocationSearchService().searchLocations(query: query)
                        await send(.searchResponse(.success(results)))
                    } catch {
                        await send(.searchResponse(.failure(.networkError(error))))
                    }
                }
                .cancellable(id: "search", cancelInFlight: true)

            case let .searchResponse(.success(results)):
                state.searchResults = results
                return .none
                
            case .searchResponse(.failure):
                state.searchResults = []
                return .none
                
            case .submitPersonalization:
                guard let location = state.selectedLocation else {
                    state.errorMessage = "Please select your place of birth"
                    return .none
                }
                state.isLoading = true
                state.errorMessage = nil
                
                let birthday = state.birthday
                let time = state.birthdayTime
                
                return .run { send in
                    do {
                        let response = try await NetworkService.shared.submitPersonalization(
                            birthday: birthday,
                            birthdayTime: time,
                            location: location
                        )
                        // Persist via side-effect if needed, or let parent handle it. 
                        // Copied logic:
                        await MainActor.run {
                            UserDefaultsService.shared.userId = response.id
                            UserDefaultsService.shared.hasSeenOnboarding = true
                        }
                        
                        await send(.personalizationResponse(.success(response)))
                    } catch let error as NetworkError {
                         await send(.personalizationResponse(.failure(error)))
                    } catch {
                         await send(.personalizationResponse(.failure(.networkError(error))))
                    }
                }
                
            case let .personalizationResponse(.success(response)):
                state.isLoading = false
                state.completionResponse = response
                return .send(.delegate(.completed(response)))
                
            case let .personalizationResponse(.failure(error)):
                state.isLoading = false
                if let netError = error as? NetworkError {
                    state.errorMessage = netError.errorDescription
                } else {
                    state.errorMessage = "An unexpected error occurred"
                }
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}

// Move Enum here
// Move Enum here
enum GenderOption: String, CaseIterable, Codable, Equatable {
    case male = "Male"
    case female = "Female"
    case notSpecified = "Prefer not to say"
}

enum NavigationDirection: Equatable {
    case forward
    case backward
}


