import Foundation

// MARK: - Daily Horoscope Response
struct DailyHoroscopeResponse: Codable {
    let date: String
    let zodiacSign: String
    let dominantThemes: [String]
    let overall: OverallHoroscope
    let transits: [Transit]
    let areas: HoroscopeAreas
    let meta: HoroscopeMeta

    enum CodingKeys: String, CodingKey {
        case date
        case zodiacSign = "zodiac_sign"
        case dominantThemes = "dominant_themes"
        case overall
        case transits
        case areas
        case meta
    }
}

// MARK: - Overall Horoscope
struct OverallHoroscope: Codable {
    let headline: String
    let summary: String
}

// MARK: - Transit
struct Transit: Codable, Identifiable {
    var id: String { "\(planetA)-\(planetB)-\(aspect)" }
    let planetA: String
    let planetB: String
    let aspect: String
    let orb: Double
    let valence: String
    let theme: String

    enum CodingKeys: String, CodingKey {
        case planetA = "planet_a"
        case planetB = "planet_b"
        case aspect
        case orb
        case valence
        case theme
    }
}

// MARK: - Horoscope Areas
struct HoroscopeAreas: Codable {
    let relationships: AreaDetail
    let work: AreaDetail
    let energy: AreaDetail
    let communication: AreaDetail
}

// MARK: - Area Detail
struct AreaDetail: Codable {
    let highlight: String
    let text: String
}

// MARK: - Horoscope Meta
struct HoroscopeMeta: Codable {
    let generatedAt: String
    let timezone: String
    let sourceVersion: String

    enum CodingKeys: String, CodingKey {
        case generatedAt = "generated_at"
        case timezone
        case sourceVersion = "source_version"
    }
}
