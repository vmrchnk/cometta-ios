import SwiftUI

struct DailyHoroscopeView: View {
    @Environment(\.theme) var theme
    let horoscope: DailyHoroscopeResponse

    @State private var selectedTab: LifeArea = .overall
    @State private var scrollOffset: CGFloat = 0
    @State private var isUserScrolling = false
    @State private var showPremiumAlert = false

    enum LifeArea: String, CaseIterable {
        case overall = "Overall"
        case relationships = "Relationships"
        case work = "Work"
        case energy = "Energy"
        case communication = "Communication"
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header with zodiac sign
            VStack(spacing: 12) {
                Image(horoscope.zodiacSign.icon)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .foregroundStyle(theme.colors.primary)

                Text(horoscope.zodiacSign.rawValue.uppercased())
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .tracking(2)
                    .foregroundStyle(theme.colors.primary.opacity(0.8))

                Text(formattedDate(horoscope.date))
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(theme.colors.onSurface.opacity(0.6))
            }
            .padding(.top, 20)
            .padding(.bottom, 16)
            .background(theme.colors.background)

            // Tabs
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(LifeArea.allCases, id: \.self) { area in
                        TabButton(
                            title: area.rawValue,
                            isSelected: selectedTab == area,
                            theme: theme
                        ) {
                            withAnimation {
                                selectedTab = area
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.vertical, 12)
            .background(theme.colors.background)

            Divider()

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 0, pinnedViews: []) {
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
                        .padding(.top, 20)
                        .padding(.bottom, 32)
                        .background(
                            GeometryReader { geo in
                                Color.clear.preference(
                                    key: VisibleSectionPreferenceKey.self,
                                    value: geo.frame(in: .named("scroll")).minY < 200 ? 0 : nil
                                )
                            }
                        )
                        .id(0)

                        // Dominant themes
                        ThemesView(themes: horoscope.dominantThemes, theme: theme)
                            .padding(.bottom, 32)

                        Divider()
                            .padding(.horizontal, 24)
                            .padding(.bottom, 32)

                        // Relationships
                        AreaCardView(
                            icon: "heart.fill",
                            title: "Relationships",
                            area: horoscope.areas.relationships,
                            theme: theme
                        )
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                        .background(
                            GeometryReader { geo in
                                Color.clear.preference(
                                    key: VisibleSectionPreferenceKey.self,
                                    value: geo.frame(in: .named("scroll")).minY < 200 ? 1 : nil
                                )
                            }
                        )
                        .id(1)

                        // Work
                        AreaCardView(
                            icon: "briefcase.fill",
                            title: "Work",
                            area: horoscope.areas.work,
                            theme: theme
                        )
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                        .background(
                            GeometryReader { geo in
                                Color.clear.preference(
                                    key: VisibleSectionPreferenceKey.self,
                                    value: geo.frame(in: .named("scroll")).minY < 200 ? 2 : nil
                                )
                            }
                        )
                        .id(2)

                        // Energy
                        AreaCardView(
                            icon: "bolt.fill",
                            title: "Energy",
                            area: horoscope.areas.energy,
                            theme: theme
                        )
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                        .background(
                            GeometryReader { geo in
                                Color.clear.preference(
                                    key: VisibleSectionPreferenceKey.self,
                                    value: geo.frame(in: .named("scroll")).minY < 200 ? 3 : nil
                                )
                            }
                        )
                        .id(3)

                        // Communication
                        AreaCardView(
                            icon: "message.fill",
                            title: "Communication",
                            area: horoscope.areas.communication,
                            theme: theme
                        )
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                        .background(
                            GeometryReader { geo in
                                Color.clear.preference(
                                    key: VisibleSectionPreferenceKey.self,
                                    value: geo.frame(in: .named("scroll")).minY < 200 ? 4 : nil
                                )
                            }
                        )
                        .id(4)

                        // Footer
                        Text("Generated at \(formattedTime(horoscope.meta.generatedAt))")
                            .font(.system(size: 11, weight: .regular))
                            .foregroundStyle(theme.colors.onSurface.opacity(0.4))
                            .padding(.top, 40)
                            .padding(.bottom, 16)

                        // Tomorrow's horoscope CTA
                        Button {
                            showPremiumAlert = true
                        } label: {
                            VStack(spacing: 16) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 32, weight: .medium))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [theme.colors.primaryVariant, theme.colors.primary],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )

                                Text("Discover What Tomorrow Holds")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(theme.colors.onBackground)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 32)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                theme.colors.primary.opacity(0.15),
                                                theme.colors.primaryVariant.opacity(0.1)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(
                                        LinearGradient(
                                            colors: [theme.colors.primary.opacity(0.5), theme.colors.primaryVariant.opacity(0.5)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                            .shadow(color: theme.colors.primary.opacity(0.2), radius: 12, x: 0, y: 4)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    }
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(VisibleSectionPreferenceKey.self) { visibleIndex in
                    if !isUserScrolling, let index = visibleIndex {
                        selectedTab = LifeArea.allCases[index]
                    }
                }
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { _ in
                            isUserScrolling = true
                        }
                        .onEnded { _ in
                            isUserScrolling = false
                        }
                )
                .onChange(of: selectedTab) { _, newTab in
                    if let index = LifeArea.allCases.firstIndex(of: newTab) {
                        withAnimation {
                            proxy.scrollTo(index, anchor: .top)
                        }
                    }
                }
            }
        }
        .background(theme.colors.background)
        .alert("Unlock Premium", isPresented: $showPremiumAlert) {
            Button("Get Premium", role: .none) {
                // TODO: Navigate to premium purchase
                print("🔮 Navigate to premium purchase")
            }
            Button("Maybe Later", role: .cancel) {}
        } message: {
            Text("Unlock tomorrow's horoscope and get access to exclusive features with Cometta Premium.")
        }
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

// MARK: - Preference Key
struct VisibleSectionPreferenceKey: PreferenceKey {
    static var defaultValue: Int?

    static func reduce(value: inout Int?, nextValue: () -> Int?) {
        value = nextValue() ?? value
    }
}

// MARK: - Tab Button
struct TabButton: View {
    let title: String
    let isSelected: Bool
    let theme: AppTheme
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                .foregroundStyle(isSelected ? theme.colors.primary : theme.colors.onSurface.opacity(0.6))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? theme.colors.primary.opacity(0.15) : Color.clear)
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? theme.colors.primary.opacity(0.3) : Color.clear, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
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
        zodiacSign: .scorpio,
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
