import Foundation

// MARK: - Network Service
@Observable
class NetworkService {
    static let shared = NetworkService()

    private let baseURL = "https://api.cometta.app"
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 300
        configuration.waitsForConnectivity = true

        self.session = URLSession(configuration: configuration)

        // Configure JSON decoder
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601

        // Configure JSON encoder
        self.encoder = JSONEncoder()
        self.encoder.dateEncodingStrategy = .iso8601
    }

    // MARK: - Generic Request Method
    private func request<T: Decodable>(
        endpoint: APIEndpoint,
        body: Encodable? = nil
    ) async throws -> T {
        // Build URL
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }

        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // Add body if present
        if let body = body {
            do {
                request.httpBody = try encoder.encode(body)
            } catch {
                throw NetworkError.decodingError(error)
            }
        }

        // Perform request
        let (data, response) = try await session.data(for: request)

        // Validate response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        // Handle status codes
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 500...599:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        default:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }

        // Decode response
        do {
            let decodedResponse = try decoder.decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.decodingError(error)
        }
    }

    // MARK: - API Methods

    /// Submit user personalization data
    func submitPersonalization(
        name: String,
        email: String,
        birthday: Date,
        birthdayTime: Date,
        location: Location
    ) async throws -> PersonalizationResponse {
        // Format dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let birthdayString = dateFormatter.string(from: birthday)

        dateFormatter.dateFormat = "HH:mm:ss"
        let timeString = dateFormatter.string(from: birthdayTime)

        // Create coordinates
        guard let latitude = location.latitude,
              let longitude = location.longitude else {
            throw NetworkError.invalidURL
        }

        let coordinates = BirthdayCoordinates(
            display: location.displayName,
            latitude: latitude,
            longitude: longitude
        )

        // Create request
        let requestBody = PersonalizationRequest(
            birthday: birthdayString,
            birthdayCoordinates: coordinates,
            birthdayTime: timeString,
            email: email,
            name: name
        )

        // Send request
        return try await request(endpoint: .personalization, body: requestBody)
    }
}
