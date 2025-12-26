//
//  OnboardingView.swift
//  Cometta
//
//  Created on 07.11.2025.
//

import SwiftUI

import ComposableArchitecture

struct OnboardingView: View {
    @Environment(\.theme) var theme
    @Bindable var store: StoreOf<OnboardingFeature>
    let onComplete: (PersonalizationResponse) -> Void
    
    // Pages definition removed from here or adapted? 
    // Usually static data can stay.
    
    let totalPages = 5




    var body: some View {
        ZStack {
            theme.colors.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress bar
                OnboardingProgressBar(
                    currentPage: store.currentPage,
                    totalPages: 5,
                    onBack: {
                       store.send(.previousPage)
                    }
                )
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .opacity(store.currentPage > 0 ? 1 : 0)

                // Pages
                ZStack {
                    Group {
                        switch store.currentPage {
                        case 0:
                            FirstPage()
                        case 1:
                            SecondPage(store: store)
                        case 2:
                            ThirdPage(store: store)
                        case 3:
                            GenderPage(store: store)
                        case 4:
                            FourthPage(currentPage: $store.currentPage, store: store)
                        default:
                            EmptyView()
                        }
                    }
                    .id(store.currentPage)
                    .transition(
                        store.direction == .forward
                        ? .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
                        : .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
                    )
                }
                .animation(.easeInOut(duration: 0.3), value: store.currentPage)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Continue Button
                if store.currentPage != 3 { // Gender page has own button usually? Or logic was different.
                    Button {
                    if store.currentPage < totalPages - 1 {
                        store.send(.nextPage)
                    } else {
                        store.send(.submitPersonalization)
                    }
                } label: {
                    Text("Continue")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(MyButtonStyle(isLoading: store.isLoading))
                .sensoryFeedback(.increase, trigger: store.currentPage)
                .disabled(store.isLoading || (store.currentPage == 4 && store.selectedLocation == nil))
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                }
            }
            
            // Error message overlay
            if let errorMessage = store.errorMessage {
                VStack {
                    Spacer()
                    Text(errorMessage)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 16)
                        .background(theme.colors.background.opacity(0.9))
                        .transition(.opacity)
                }
            }
        }
        .onChange(of: store.completionResponse) { _, response in
            if let response {
                onComplete(response)
            }
        }
    }
}

// MARK: - Progress Bar Component
struct OnboardingProgressBar: View {
    @Environment(\.theme) var theme
    let currentPage: Int
    let totalPages: Int
    let onBack: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Back button
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(theme.colors.onBackground)
                .frame(width: 32, height: 32)
            }
            .opacity(currentPage > 0 ? 1 : 0)
            .disabled(currentPage == 0)

            // Progress segments
            HStack(spacing: 8) {
                ForEach(0..<totalPages, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(index <= currentPage ? theme.colors.primaryVariant : theme.colors.onBackground.opacity(0.2))
                        .frame(height: 4)
                        .animation(.easeInOut(duration: 0.3), value: currentPage)
                }
            }
        }
        .frame(height: 44)
    }
}

#Preview("Light") {
    OnboardingView(
        store: Store(initialState: OnboardingFeature.State()) {
            OnboardingFeature()
        },
        onComplete: { _ in }
    )
    .theme(.default)
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    OnboardingView(
        store: Store(initialState: OnboardingFeature.State()) {
            OnboardingFeature()
        },
        onComplete: { _ in }
    )
    .theme(.default)
    .preferredColorScheme(.dark)
}

#Preview("Progress Bar") {
    VStack(spacing: 40) {
        OnboardingProgressBar(currentPage: 0, totalPages: 4, onBack: {})
        OnboardingProgressBar(currentPage: 2, totalPages: 4, onBack: {})
        OnboardingProgressBar(currentPage: 3, totalPages: 4, onBack: {})
    }
    .padding()
    .theme(.default)
    .preferredColorScheme(.dark)
}


struct MyButtonStyle: ButtonStyle {
    @Environment(\.theme) var theme
    @Environment(\.isEnabled) private var isEnabled
    var isLoading: Bool

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .foregroundStyle(theme.colors.onPrimary)
            if isLoading {
                ProgressView()
                    .tint(theme.colors.onPrimary)
            }
        }
        .padding()
        .background(
            (configuration.isPressed ? theme.colors.primaryVariant : theme.colors.primary)
                .opacity(isEnabled ? 1.0 : 0.4)
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
        .opacity(configuration.isPressed ? 0.9 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
