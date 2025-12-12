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

            ZStack {
                Text(viewModel.formattedDate)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(theme.colors.onSurface.opacity(0.6))
                    .frame(maxWidth: .infinity)
                
                /*
                HStack {
                    Spacer()
                    Button {
                        viewModel.showPremiumAlert = true
                    } label: {
                        HStack(spacing: 4) {
                            Text("See future")
                                .font(.system(size: 12, weight: .semibold))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 10, weight: .bold))
                        }
                        .foregroundStyle(theme.colors.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(theme.colors.primary.opacity(0.1))
                        )
                    }
                    .padding(.trailing, 16)
                }
                */
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 16)
        .background(theme.colors.background)
    }
}
