import SwiftUI

extension OnboardingView {
    struct GenderPage: View {
        @Environment(\.theme) var theme
        @Bindable var viewModel: OnboardingViewModel
        @Binding var currentPage: Int

        var body: some View {
            VStack(spacing: 24) {
                // Title
                Text("Gender?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(theme.colors.onBackground)
                    .padding(.top, 20)

                // Options List
                VStack(spacing: 16) {
                    ForEach(OnboardingGender.allCases, id: \.self) { gender in
                        GenderOptionRow(
                            title: gender.rawValue,
                            isSelected: viewModel.selectedGender == gender,
                             action: {
                                withAnimation {
                                    if gender == .skip {
                                        viewModel.selectedGender = nil
                                    } else {
                                        viewModel.selectedGender = gender
                                    }
                                    // Auto-advance
                                    withAnimation {
                                        currentPage += 1
                                    }
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                Spacer()
            }
        }
    }

    struct GenderOptionRow: View {
        @Environment(\.theme) var theme
        let title: String
        let isSelected: Bool
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                HStack {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(isSelected ? theme.colors.onPrimary : theme.colors.onSurface)

                    Spacer()

                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(theme.colors.onPrimary)
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? theme.colors.primary : theme.colors.surface)
                        .shadow(color: theme.colors.onSurface.opacity(0.05), radius: 10, x: 0, y: 4)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isSelected ? Color.clear : theme.colors.onSurface.opacity(0.1),
                            lineWidth: 1
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    OnboardingView.GenderPage(
        viewModel: OnboardingViewModel(),
        currentPage: .constant(2)
    )
    .theme(.default)
}
