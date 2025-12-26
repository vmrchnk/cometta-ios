import Foundation

// MARK: - Network Error
enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case unauthorized
    case forbidden
    case notFound
    case serverError(statusCode: Int)
    case decodingError(Error)
    case networkError(Error)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .unauthorized:
            return "Unauthorized access"
        case .forbidden:
            return "Access forbidden"
        case .notFound:
            return "Resource not found"
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unknown:
            return "Unknown error occurred"
        }
    }

    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.invalidResponse, .invalidResponse),
             (.unauthorized, .unauthorized),
             (.forbidden, .forbidden),
             (.notFound, .notFound),
             (.unknown, .unknown):
            return true
        case (.serverError(let l), .serverError(let r)):
            return l == r
        case (.decodingError(let l), .decodingError(let r)):
            return l.localizedDescription == r.localizedDescription
        case (.networkError(let l), .networkError(let r)):
            return l.localizedDescription == r.localizedDescription
        default:
            return false
        }
    }
}
