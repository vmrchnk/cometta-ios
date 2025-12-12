import SwiftUI

extension OnboardingView {
    struct SecondPage: View {
        @Environment(\.theme) var theme
        @Bindable var viewModel: OnboardingViewModel
        @State private var selectedDate = Date()
        @State private var selectedZodiacIndex = 0

        // Zodiac signs in order with their date ranges
        let zodiacSigns: [OnboardingZodiacSign] = [
            OnboardingZodiacSign(name: "Capricorn", image: .Zodiac.capricorn, startMonth: 12, startDay: 22, endMonth: 1, endDay: 19),
            OnboardingZodiacSign(name: "Aquarius", image: .Zodiac.aquarius, startMonth: 1, startDay: 20, endMonth: 2, endDay: 18),
            OnboardingZodiacSign(name: "Pisces", image: .Zodiac.pisces, startMonth: 2, startDay: 19, endMonth: 3, endDay: 20),
            OnboardingZodiacSign(name: "Aries", image: .Zodiac.aries, startMonth: 3, startDay: 21, endMonth: 4, endDay: 19),
            OnboardingZodiacSign(name: "Taurus", image: .Zodiac.taurus, startMonth: 4, startDay: 20, endMonth: 5, endDay: 20),
            OnboardingZodiacSign(name: "Gemini", image: .Zodiac.gemini, startMonth: 5, startDay: 21, endMonth: 6, endDay: 20),
            OnboardingZodiacSign(name: "Cancer", image: .Zodiac.cancer, startMonth: 6, startDay: 21, endMonth: 7, endDay: 22),
            OnboardingZodiacSign(name: "Leo", image: .Zodiac.leo, startMonth: 7, startDay: 23, endMonth: 8, endDay: 22),
            OnboardingZodiacSign(name: "Virgo", image: .Zodiac.virgo, startMonth: 8, startDay: 23, endMonth: 9, endDay: 22),
            OnboardingZodiacSign(name: "Libra", image: .Zodiac.libra, startMonth: 9, startDay: 23, endMonth: 10, endDay: 22),
            OnboardingZodiacSign(name: "Scorpio", image: .Zodiac.scorpio, startMonth: 10, startDay: 23, endMonth: 11, endDay: 21),
            OnboardingZodiacSign(name: "Sagittarius", image: .Zodiac.sagittarius, startMonth: 11, startDay: 22, endMonth: 12, endDay: 21)
        ]

        var body: some View {
            VStack(spacing: 24) {
                // Title
                Text("Date of birth?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(theme.colors.onBackground)
                    .padding(.top, 20)

                // Zodiac carousel
                ZodiacCarousel(
                    zodiacSigns: zodiacSigns,
                    selectedIndex: $selectedZodiacIndex
                )
                .foregroundStyle(theme.colors.onBackground)
                .frame(height: 120)
                .padding(.bottom, 8)
                .onChange(of: selectedZodiacIndex) { _, newIndex in
                    updateDate(for: zodiacSigns[newIndex])
                }
                
                // Description
                Text("The day you were born is important for the alignment of the planets")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(theme.colors.onSurface.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                // Date Picker
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .onChange(of: selectedDate) { _, newDate in
                        updateZodiacSign(for: newDate)
                        viewModel.birthday = newDate
                    }
                    .frame(maxWidth: .infinity)

                Spacer()
            }
            .onAppear {
                updateZodiacSign(for: selectedDate)
            }
        }

        private func updateDate(for sign: OnboardingZodiacSign) {
            // Avoid loop: if current date is already in the target sign, don't force update.
            if isDate(selectedDate, matches: sign) { return }

            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: selectedDate)
            
            var components = DateComponents()
            components.year = currentYear
            components.month = sign.startMonth
            components.day = sign.startDay
            
            // Set date to the START of the selected sign
            if let newDate = calendar.date(from: components) {
                withAnimation {
                    selectedDate = newDate
                }
            }
        }
        
        private func isDate(_ date: Date, matches sign: OnboardingZodiacSign) -> Bool {
            let calendar = Calendar.current
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)

            if sign.startMonth == sign.endMonth {
                return month == sign.startMonth && day >= sign.startDay && day <= sign.endDay
            } else if sign.startMonth > sign.endMonth {
                // Capricorn (Dec -> Jan)
                return (month == sign.startMonth && day >= sign.startDay) ||
                       (month == sign.endMonth && day <= sign.endDay)
            } else {
                return (month == sign.startMonth && day >= sign.startDay) ||
                       (month == sign.endMonth && day <= sign.endDay) ||
                       (month > sign.startMonth && month < sign.endMonth)
            }
        }

        private func updateZodiacSign(for date: Date) {
            // Find matching zodiac sign index
            if let index = zodiacSigns.firstIndex(where: { isDate(date, matches: $0) }) {
                if selectedZodiacIndex != index {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        selectedZodiacIndex = index
                    }
                }
            }
        }
    }
}

// MARK: - Zodiac Sign Model
struct OnboardingZodiacSign: Identifiable {
    let id = UUID()
    let name: String
    let image: ImageResource
    let startMonth: Int
    let startDay: Int
    let endMonth: Int
    let endDay: Int
}

// MARK: - Zodiac Carousel Component
struct ZodiacCarousel: View {
    @Environment(\.theme) var theme
    let zodiacSigns: [OnboardingZodiacSign]
    @Binding var selectedIndex: Int

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(Array(zodiacSigns.enumerated()), id: \.element.id) { index, sign in
                    ZodiacSignView(
                        sign: sign,
                        isSelected: index == selectedIndex
                    )
                    .id(index)
                    .containerRelativeFrame(.horizontal, count: 3, spacing: 20)
                    .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1.0 : 0.5)
                            .scaleEffect(phase.isIdentity ? 1.0 : 0.8)
                    }
                    .onTapGesture {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            selectedIndex = index
                        }
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: Binding(
            get: { selectedIndex },
            set: { if let val = $0 { selectedIndex = val } }
        ))
        .contentMargins(.horizontal, 40, for: .scrollContent)
    }
}

// MARK: - Individual Zodiac Sign View
struct ZodiacSignView: View {
    @Environment(\.theme) var theme
    let sign: OnboardingZodiacSign
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                // Background circle
                Circle()
                    .fill(
                        isSelected ?
                        LinearGradient(
                            colors: [
                                theme.colors.primary.opacity(0.3),
                                theme.colors.primaryVariant.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [
                                theme.colors.surface.opacity(0.3),
                                theme.colors.surface.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100) // Fixed size, scale handled by transition

                // Zodiac icon
                Image(sign.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundStyle(
                        isSelected ?
                        theme.colors.primary :
                        theme.colors.onSurface.opacity(0.5)
                    )
            }

            // Sign name
            Text(sign.name)
                .font(.system(size: isSelected ? 14 : 12, weight: isSelected ? .semibold : .regular))
                .foregroundStyle(
                    isSelected ?
                    theme.colors.onBackground :
                    theme.colors.onSurface.opacity(0.6)
                )
        }
    }
}

// MARK: - Previews
#Preview("Light") {
    OnboardingView.SecondPage(viewModel: OnboardingViewModel())
        .theme(.default)
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    OnboardingView.SecondPage(viewModel: OnboardingViewModel())
        .theme(.default)
        .preferredColorScheme(.dark)
}
