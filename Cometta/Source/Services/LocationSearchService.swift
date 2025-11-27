import Foundation

// MARK: - Location Model
struct Location: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let displayName: String
    let lat: String
    let lon: String
    let type: String
    let importance: Double

    enum CodingKeys: String, CodingKey {
        case id = "place_id"
        case name
        case displayName = "display_name"
        case lat
        case lon
        case type
        case importance
    }

    var latitude: Double? {
        Double(lat)
    }

    var longitude: Double? {
        Double(lon)
    }
}

// MARK: - Location Search Service
@Observable
class LocationSearchService {
    private let baseURL = "https://nominatim.openstreetmap.org/search"
    private var searchTask: Task<Void, Never>?

    func searchLocations(query: String) async throws -> [Location] {
        // Cancel previous search task
        searchTask?.cancel()

        // Validate query
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return []
        }

        // Build URL
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "city", value: query),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "limit", value: "10"),
            URLQueryItem(name: "addressdetails", value: "1")
        ]

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        // Make request
        var request = URLRequest(url: url)
        request.setValue("ComettaApp/1.0", forHTTPHeaderField: "User-Agent")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        // Decode response
        let locations = try JSONDecoder().decode([Location].self, from: data)
        return locations.sorted { $0.importance > $1.importance }
    }

    func cancelSearch() {
        searchTask?.cancel()
    }
}
