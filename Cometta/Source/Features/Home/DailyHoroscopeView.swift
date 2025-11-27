import SwiftUI

struct DailyHoroscopeView: View {
    @Environment(\.theme) var theme
    let horoscope: DailyHoroscopeResponse

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header with zodiac sign
                VStack(spacing: 12) {
                    Text(horoscope.zodiacSign.uppercased())
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .tracking(2)
                        .foregroundStyle(theme.colors.primary.opacity(0.8))

                    Text(formattedDate(horoscope.date))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(theme.colors.onSurface.opacity(0.6))
                }
                .padding(.top, 20)

                // Overall section
                VStack(spacing: 20) {
                    Text(horoscope.overall.headline)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(theme.colors.onBackground)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)

                    Text(horoscope.overall.summary)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(theme.colors.onSurface.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                }
                .padding(.horizontal, 24)

                // Dominant themes
                ThemesView(themes: horoscope.dominantThemes, theme: theme)

                Divider()
                    .padding(.horizontal, 24)

                // Life areas
                VStack(spacing: 24) {
                    AreaCardView(
                        icon: "heart.fill",
                        title: "Relationships",
                        area: horoscope.areas.relationships,
                        theme: theme
                    )

                    AreaCardView(
                        icon: "briefcase.fill",
                        title: "Work",
                        area: horoscope.areas.work,
                        theme: theme
                    )

                    AreaCardView(
                        icon: "bolt.fill",
                        title: "Energy",
                        area: horoscope.areas.energy,
                        theme: theme
                    )

                    AreaCardView(
                        icon: "message.fill",
                        title: "Communication",
                        area: horoscope.areas.communication,
                        theme: theme
                    )
                }
                .padding(.horizontal, 24)

                // Transits section
                if !horoscope.transits.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Today's Transits")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(theme.colors.onBackground)

                        VStack(spacing: 12) {
                            ForEach(horoscope.transits) { transit in
                                TransitRowView(transit: transit, theme: theme)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }

                // Footer
                Text("Generated at \(formattedTime(horoscope.meta.generatedAt))")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(theme.colors.onSurface.opacity(0.4))
                    .padding(.bottom, 40)
            }
        }
        .background(theme.colors.background)
    }

    private func formattedDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }

        formatter.dateStyle = .long
        return formatter.string(from: date)
    }

    private func formattedTime(_ isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: isoString) else { return isoString }

        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        return timeFormatter.string(from: date)
    }
}

// MARK: - Themes View
struct ThemesView: View {
    let themes: [String]
    let theme: AppTheme

    var body: some View {
        HStack(spacing: 12) {
            ForEach(themes, id: \.self) { themeText in
                Text(themeText.capitalized)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(theme.colors.primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(theme.colors.primary.opacity(0.1))
                    )
            }
        }
    }
}

// MARK: - Area Card View
struct AreaCardView: View {
    let icon: String
    let title: String
    let area: AreaDetail
    let theme: AppTheme

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(theme.colors.primary)

                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(theme.colors.onBackground)
            }

            Text(area.highlight)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(theme.colors.onBackground)
                .lineSpacing(4)

            Text(area.text)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(theme.colors.onSurface.opacity(0.7))
                .lineSpacing(5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(theme.colors.surface)
        )
    }
}

// MARK: - Transit Row View
struct TransitRowView: View {
    let transit: Transit
    let theme: AppTheme

    var body: some View {
        HStack(spacing: 12) {
            // Valence indicator
            Circle()
                .fill(transitColor)
                .frame(width: 8, height: 8)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(transit.planetA)
                        .font(.system(size: 14, weight: .bold))

                    Text(aspectSymbol)
                        .font(.system(size: 14))

                    Text(transit.planetB)
                        .font(.system(size: 14, weight: .bold))

                    Text("•")
                        .foregroundStyle(theme.colors.onSurface.opacity(0.3))

                    Text(transit.theme.replacingOccurrences(of: "_", with: " ").capitalized)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(theme.colors.onSurface.opacity(0.6))
                }
                .foregroundStyle(theme.colors.onBackground)

                Text(String(format: "Orb: %.2f°", transit.orb))
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(theme.colors.onSurface.opacity(0.5))
            }

            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.colors.surface.opacity(0.5))
        )
    }

    private var transitColor: Color {
        switch transit.valence {
        case "challenging":
            return .orange
        case "harmonious":
            return .green
        default:
            return .blue
        }
    }

    private var aspectSymbol: String {
        switch transit.aspect.lowercased() {
        case "conjunction":
            return "☌"
        case "square":
            return "□"
        case "opposition":
            return "☍"
        case "trine":
            return "△"
        case "sextile":
            return "⚹"
        default:
            return transit.aspect
        }
    }
}

// MARK: - Preview
#Preview {
    let sampleHoroscope = DailyHoroscopeResponse(
        date: "2025-11-22",
        zodiacSign: "Scorpio",
        dominantThemes: ["communication", "emotions", "work"],
        overall: OverallHoroscope(
            headline: "A focused day with emotionally charged conversations",
            summary: "Today brings heightened sensitivity and clarity in communication..."
        ),
        transits: [
            Transit(
                planetA: "Moon",
                planetB: "Saturn",
                aspect: "square",
                orb: 0.61,
                valence: "challenging",
                theme: "emotions_discipline"
            )
        ],
        areas: HoroscopeAreas(
            relationships: AreaDetail(
                highlight: "A deeper emotional tone may surface.",
                text: "Conversations with close ones may feel unusually intense..."
            ),
            work: AreaDetail(
                highlight: "Strong focus and steady progress.",
                text: "Your ability to structure tasks is strong today..."
            ),
            energy: AreaDetail(
                highlight: "Stable but sensitive emotional energy.",
                text: "You may feel a mix of calmness and inner tension..."
            ),
            communication: AreaDetail(
                highlight: "High clarity and intuitive understanding.",
                text: "Your words may carry more weight than usual..."
            )
        ),
        meta: HoroscopeMeta(
            generatedAt: "2025-11-22T05:00:00Z",
            timezone: "Europe/Kyiv",
            sourceVersion: "v1.0"
        )
    )

    DailyHoroscopeView(horoscope: sampleHoroscope)
        .theme(.default)
        .preferredColorScheme(.dark)
}
