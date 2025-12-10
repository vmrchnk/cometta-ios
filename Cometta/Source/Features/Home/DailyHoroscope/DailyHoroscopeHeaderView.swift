import SwiftUI

struct DailyHoroscopeHeaderView: View {
    let viewModel: DailyHoroscopeViewModel
    let theme: AppTheme

    var body: some View {
        VStack(spacing: 12) {
            Image(viewModel.zodiacIcon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 48, height: 48)
                .foregroundStyle(theme.colors.primary)

            Text(viewModel.zodiacName)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .tracking(2)
                .foregroundStyle(theme.colors.primary.opacity(0.8))

            Text(viewModel.formattedDate)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(theme.colors.onSurface.opacity(0.6))
        }
        .padding(.top, 20)
        .padding(.bottom, 16)
        .background(theme.colors.background)
    }
}
