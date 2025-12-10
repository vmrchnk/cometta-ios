import SwiftUI

struct HoroscopePremiumCTA: View {
    @Bindable var viewModel: DailyHoroscopeViewModel
    let theme: AppTheme

    var body: some View {
        Button {
            viewModel.showPremiumAlert = true
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
