import Foundation

// MARK: - API Endpoint
enum APIEndpoint {
    case personalization
    case dailyHoroscope(userId: String, date: String?)

    var path: String {
        switch self {
        case .personalization:
            return "/api/v1/user/personalization"
        case .dailyHoroscope:
            return "/api/v1/daily-horoscope"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .personalization:
            return .post
        case .dailyHoroscope:
            return .get
        }
    }
}

// MARK: - HTTP Method
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}
