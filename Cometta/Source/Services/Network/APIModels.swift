import Foundation

// MARK: - Personalization Request
struct PersonalizationRequest: Codable {
    let birthday: String
    let birthdayCoordinates: BirthdayCoordinates
    let birthdayTime: String
    let email: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case birthday
        case birthdayCoordinates = "birthday_coordinates"
        case birthdayTime = "birthday_time"
        case email
        case name
    }
}

// MARK: - Birthday Coordinates
struct BirthdayCoordinates: Codable, Equatable, Sendable {
    let display: String
    let latitude: Double
    let longitude: Double
}

// MARK: - Personalization Response
struct PersonalizationResponse: Codable, Equatable, Sendable {
    let id: String
    let name: String
    let email: String
    let isAnonymous: Bool
    let birthday: String
    let birthdayTime: String
    let birthdayCoordinates: BirthdayCoordinates
    let focus: String?
    let createdAt: String
    let updatedAt: String
    let claimedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case isAnonymous = "is_anonymous"
        case birthday
        case birthdayTime = "birthday_time"
        case birthdayCoordinates = "birthday_coordinates"
        case focus
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case claimedAt = "claimed_at"
    }
}

// MARK: - Search Location
struct SearchLocation: Identifiable, Codable, Equatable, Sendable {
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

    nonisolated static func == (lhs: SearchLocation, rhs: SearchLocation) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.displayName == rhs.displayName &&
               lhs.lat == rhs.lat &&
               lhs.lon == rhs.lon &&
               lhs.type == rhs.type &&
               lhs.importance == rhs.importance
    }
}

// MARK: - User Alias
typealias User = PersonalizationResponse
