import SwiftUI

import ComposableArchitecture

extension OnboardingView {
    struct GenderPage: View {
        @Environment(\.theme) var theme
        @Bindable var store: StoreOf<OnboardingFeature>
        // derived binding or just use store.currentPage
        
        var body: some View {
            VStack(spacing: 24) {
                // Title
                Text("Gender?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(theme.colors.onBackground)
                    .padding(.top, 20)

                // Options List
                Spacer()
                
                VStack(spacing: 16) {
                    ForEach(GenderOption.allCases, id: \.self) { gender in
                        GenderOptionRow(
                            title: gender.rawValue,
                            isSelected: store.selectedGender == gender,
                             action: {
                                withAnimation {
                                    // Update state immediately to show highlight
                                    store.send(.setGender(gender))
                                }
                                
                                // Auto-advance after 0.5s delay
                                Task {
                                    try? await Task.sleep(nanoseconds: 500_000_000)
                                    await MainActor.run {
                                        withAnimation {
                                            store.send(.nextPage)
                                        }
                                    }
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
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
                .frame(maxWidth: .infinity)
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
        store: Store(initialState: OnboardingFeature.State()) {
            OnboardingFeature()
        }
    )
    .theme(.default)
}
