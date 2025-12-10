import SwiftUI

extension OnboardingView {
    struct ThirdPage: View {
        @Environment(\.theme) var theme
        @Bindable var viewModel: OnboardingViewModel
        @State private var selectedTime = Date()
        @State private var hours: Int = 12
        @State private var minutes: Int = 0

        var body: some View {
                VStack(spacing: 24) {
                    // Title
                    Text("Time of birth?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(theme.colors.onBackground)
                        .padding(.top, 20)



                    // Large animated time display
                    VStack(spacing: 16) {
                        HStack(spacing: 8) {
                            // Hours
                            AnimatedNumberView(
                                value: hours,
                                textColor: theme.colors.primary
                            )

                            // Separator
                            Text(":")
                                .font(.system(size: 80, weight: .bold))
                                .foregroundStyle(theme.colors.primary)
                                .opacity(0.8)

                            // Minutes
                            AnimatedNumberView(
                                value: minutes,
                                textColor: theme.colors.primary
                            )
                        }

                        // AM/PM indicator (optional)
                        Text(hours >= 12 ? "PM" : "AM")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(theme.colors.primaryVariant)
                            .opacity(0.7)
                    }
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        theme.colors.primary.opacity(0.1),
                                        theme.colors.primaryVariant.opacity(0.05)
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
                                    colors: [
                                        theme.colors.primary.opacity(0.3),
                                        theme.colors.primaryVariant.opacity(0.2)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8)
                    
                    // Description
                    Text("The exact time helps create a more accurate birth chart")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(theme.colors.onSurface.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 32)

                    Spacer()

                    // Time Picker
                    DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .onChange(of: selectedTime) { _, newTime in
                            updateTime(from: newTime)
                            viewModel.birthdayTime = newTime
                        }
                        .frame(maxWidth: .infinity)

                    Spacer()
                }
            .onAppear {
                updateTime(from: selectedTime)
            }
        }

        private func updateTime(from date: Date) {
            let calendar = Calendar.current
            let newHours = calendar.component(.hour, from: date)
            let newMinutes = calendar.component(.minute, from: date)

            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                hours = newHours
                minutes = newMinutes
            }
        }
    }
}

// MARK: - Animated Number View
struct AnimatedNumberView: View {
    let value: Int
    let textColor: Color

    var body: some View {
        Text(String(format: "%02d", value))
            .font(.system(size: 80, weight: .bold, design: .rounded))
            .foregroundStyle(textColor)
            .contentTransition(.numericText(value: Double(value)))
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: value)
    }
}

// MARK: - Animated Clock Icon (Optional decorative element)
struct AnimatedClockIcon: View {
    @Environment(\.theme) var theme
    @State private var rotationDegrees: Double = 0

    var body: some View {
        ZStack {
            // Clock face
            Circle()
                .stroke(theme.colors.primary.opacity(0.3), lineWidth: 3)
                .frame(width: 100, height: 100)

            // Hour hand
            Rectangle()
                .fill(theme.colors.primary)
                .frame(width: 3, height: 25)
                .offset(y: -12.5)
                .rotationEffect(.degrees(rotationDegrees))

            // Minute hand
            Rectangle()
                .fill(theme.colors.primaryVariant)
                .frame(width: 2, height: 35)
                .offset(y: -17.5)
                .rotationEffect(.degrees(rotationDegrees * 12))

            // Center dot
            Circle()
                .fill(theme.colors.primary)
                .frame(width: 8, height: 8)
        }
        .onAppear {
            withAnimation(.linear(duration: 60).repeatForever(autoreverses: false)) {
                rotationDegrees = 360
            }
        }
    }
}

// MARK: - Previews
#Preview("Light") {
    OnboardingView.ThirdPage(viewModel: OnboardingViewModel())
        .theme(.default)
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    OnboardingView.ThirdPage(viewModel: OnboardingViewModel())
        .theme(.default)
        .preferredColorScheme(.dark)
}

#Preview("Animated Number") {
    VStack(spacing: 20) {
        AnimatedNumberView(value: 12, textColor: .blue)
        AnimatedNumberView(value: 45, textColor: .purple)
    }
}
