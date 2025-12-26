import Foundation
import SwiftUI

@Observable
class HomeViewModel {
    var horoscope: DailyHoroscopeResponse?
    var isLoading: Bool = false
    var errorMessage: String?

    private let networkService = NetworkService.shared
//    private let userDefaultsService = UserDefaultsService.shared

    // MARK: - Load Horoscope
    func loadDailyHoroscope() async {
////        guard let userId = userDefaultsService.userId else {
////            errorMessage = "User ID not found"
////            return
////        }
//
//        await MainActor.run {
//            isLoading = true
//            errorMessage = nil
//        }
//
//        do {
//            let timezone = TimeZone.current.identifier
//            let response = try await networkService.getDailyHoroscope(
//                userId: userId,
//                timezone: timezone
//            )
//
//            await MainActor.run {
//                horoscope = response
//                isLoading = false
//            }
//        } catch let error as NetworkError {
//            await MainActor.run {
//                errorMessage = error.errorDescription
//                isLoading = false
//            }
//        } catch {
//            await MainActor.run {
//                errorMessage = "An unexpected error occurred"
//                isLoading = false
//            }
//        }
    }
}
