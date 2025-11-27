import Foundation

// MARK: - Network Service
@Observable
class NetworkService {
    static let shared = NetworkService()

    private let baseURL = "https://api.cometta.app"
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let logger = NetworkLogger()

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
        queryItems: [URLQueryItem]? = nil,
        body: Encodable? = nil
    ) async throws -> T {
        // Build URL
        var components = URLComponents(string: baseURL + endpoint.path)
        components?.queryItems = queryItems

        guard let url = components?.url else {
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
                logger.logError(.decodingError(error))
                throw NetworkError.decodingError(error)
            }
        }

        // Log request
        logger.logRequest(request)

        // Perform request
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
            logger.logResponse(response, data: data, error: nil)
        } catch {
            logger.logResponse(nil, data: nil, error: error)
            throw NetworkError.networkError(error)
        }

        // Validate response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        // Handle status codes
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            let error = NetworkError.unauthorized
            logger.logError(error)
            throw error
        case 403:
            let error = NetworkError.forbidden
            logger.logError(error)
            throw error
        case 404:
            let error = NetworkError.notFound
            logger.logError(error)
            throw error
        case 500...599:
            let error = NetworkError.serverError(statusCode: httpResponse.statusCode)
            logger.logError(error)
            throw error
        default:
            let error = NetworkError.serverError(statusCode: httpResponse.statusCode)
            logger.logError(error)
            throw error
        }

        // Decode response
        do {
            let decodedResponse = try decoder.decode(T.self, from: data)
            return decodedResponse
        } catch {
            logger.logError(.decodingError(error))
            throw NetworkError.decodingError(error)
        }
    }

    // MARK: - API Methods

    /// Submit user personalization data
    func submitPersonalization(
        birthday: Date,
        birthdayTime: Date,
        location: Location,
        name: String? = nil,
        email: String? = nil
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

    /// Get daily horoscope for user
    func getDailyHoroscope(
        userId: String,
        date: String? = nil,
        timezone: String? = nil
    ) async throws -> DailyHoroscopeResponse {
        var queryItems = [URLQueryItem(name: "user_id", value: userId)]

        if let date = date {
            queryItems.append(URLQueryItem(name: "date", value: date))
        }

        if let timezone = timezone {
            queryItems.append(URLQueryItem(name: "X-Timezone", value: timezone))
        }

        return try await request(
            endpoint: .dailyHoroscope(userId: userId, date: date),
            queryItems: queryItems
        )
    }
}
