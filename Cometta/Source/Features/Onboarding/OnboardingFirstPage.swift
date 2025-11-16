import SwiftUI

extension OnboardingView {
    struct FirstPage: View {
        @Environment(\.theme) var theme
        @State private var rotation: Double = 0
        @State private var scale: CGFloat = 1.0

        var body: some View {
            VStack(alignment: .center, spacing: 24) {
                Spacer()

                // Animated zodiac circle
                ZStack {
                    // Outer glow circle
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    theme.colors.primary.opacity(0.3),
                                    theme.colors.primaryVariant.opacity(0.1),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 80,
                                endRadius: 160
                            )
                        )
                        .frame(width: 320, height: 320)
                        .scaleEffect(scale)

                    // Main zodiac image
                    Image(.Zodiac.circle)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 240, height: 240)
                        .rotationEffect(.degrees(rotation))
                        .scaleEffect(scale)
                        .foregroundStyle(theme.colors.onBackground)
                }
                .onAppear {
                    // Continuous rotation animation
                    withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }

                    // Pulse animation
                    withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                        scale = 1.1
                    }
                }

                Spacer()

                // Text content
                VStack(spacing: 16) {
                    Text("Your story begins\nin the stars")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(theme.colors.onBackground)
                        .multilineTextAlignment(.center)

                    Text("Ready to discover yours?")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(theme.colors.onSurface.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 40)

                Spacer()
            }
        }
    }
}

#Preview("Light") {
    OnboardingView.FirstPage()
        .theme(.default)
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    OnboardingView.FirstPage()
        .theme(.default)
        .preferredColorScheme(.dark)
}
