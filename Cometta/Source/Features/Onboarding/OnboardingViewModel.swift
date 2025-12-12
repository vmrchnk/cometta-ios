import Foundation
import SwiftUI

@Observable
class OnboardingViewModel {
    // User data
    var birthday: Date = Date()
    var birthdayTime: Date = Date()
    var selectedLocation: Location?
    var selectedGender: OnboardingGender?

    // UI State
    var isLoading: Bool = false
    var errorMessage: String?
    var personalizationResponse: PersonalizationResponse?

    private let networkService = NetworkService.shared
    private let userDefaultsService = UserDefaultsService.shared

    // MARK: - Submit Personalization
    func submitPersonalization() async {
        // Validate data
        guard let location = selectedLocation else {
            errorMessage = "Please select your place of birth"
            return
        }

        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        do {
            let response = try await networkService.submitPersonalization(
                birthday: birthday,
                birthdayTime: birthdayTime,
                location: location
            )

            await MainActor.run {
                // Save user ID
                userDefaultsService.userId = response.id
                userDefaultsService.hasSeenOnboarding = true

                personalizationResponse = response
                isLoading = false
            }
        } catch let error as NetworkError {
            await MainActor.run {
                errorMessage = error.errorDescription
                isLoading = false
            }
        } catch {
            await MainActor.run {
                errorMessage = "An unexpected error occurred"
                isLoading = false
            }
        }
    }

    // MARK: - Validation
    var canSubmit: Bool {
        selectedLocation != nil
    }
}

enum OnboardingGender: String, CaseIterable, Codable {
    case male = "Male"
    case female = "Female"
    case notSpecified = "Prefer not to say"
    case skip = "Skip"
}
