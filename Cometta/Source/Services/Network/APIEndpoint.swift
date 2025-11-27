import Foundation

// MARK: - API Endpoint
enum APIEndpoint {
    case personalization

    var path: String {
        switch self {
        case .personalization:
            return "/api/v1/user/personalization"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .personalization:
            return .post
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
