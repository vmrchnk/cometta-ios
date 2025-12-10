import SwiftUI
import Foundation

@Observable
class DailyHoroscopeViewModel {
    let horoscope: DailyHoroscopeResponse
    var selectedTab: LifeArea = .overall
    var scrollOffset: CGFloat = 0
    var isUserScrolling = false
    var showPremiumAlert = false
    var isTabTap = false

    enum LifeArea: String, CaseIterable {
        case overall = "Overall"
        case relationships = "Relationships"
        case work = "Work"
        case energy = "Energy"
        case communication = "Communication"
    }

    init(horoscope: DailyHoroscopeResponse) {
        self.horoscope = horoscope
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: horoscope.date) else { return horoscope.date }

        formatter.dateStyle = .long
        return formatter.string(from: date)
    }

    var formattedTime: String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: horoscope.meta.generatedAt) else { return horoscope.meta.generatedAt }

        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        return timeFormatter.string(from: date)
    }

    var zodiacName: String {
        horoscope.zodiacSign.rawValue.uppercased()
    }

    var zodiacIcon: String {
        horoscope.zodiacSign.icon
    }
}
