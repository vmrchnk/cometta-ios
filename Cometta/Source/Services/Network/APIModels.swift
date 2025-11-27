import Foundation

// MARK: - Personalization Request
struct PersonalizationRequest: Codable {
    let birthday: String
    let birthdayCoordinates: BirthdayCoordinates
    let birthdayTime: String
    let email: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case birthday
        case birthdayCoordinates = "birthday_coordinates"
        case birthdayTime = "birthday_time"
        case email
        case name
    }
}

// MARK: - Birthday Coordinates
struct BirthdayCoordinates: Codable {
    let display: String
    let latitude: Double
    let longitude: Double
}

// MARK: - Personalization Response
struct PersonalizationResponse: Codable {
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
