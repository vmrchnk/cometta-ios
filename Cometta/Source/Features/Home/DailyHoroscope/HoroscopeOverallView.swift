import SwiftUI

struct HoroscopeOverallView: View {
    let viewModel: DailyHoroscopeViewModel
    let theme: AppTheme

    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.horoscope.overall.headline)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(theme.colors.onBackground)
                .multilineTextAlignment(.center)
                .lineSpacing(4)

            Text(viewModel.horoscope.overall.summary)
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
    }
}
