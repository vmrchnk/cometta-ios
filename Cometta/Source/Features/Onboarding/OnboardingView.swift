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
    
    var body: some View {
        ZStack {
            theme.colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress bar
                OnboardingProgressBar(
                    currentStep: store.currentStep,
                    totalSteps: OnboardingStep.allCases.count,
                    onBack: {
                        store.send(.previousPage)
                    }
                )
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .opacity(store.currentStep != .intro ? 1 : 0)
                
                // Pages
                ZStack {
                    Group {
                        switch store.currentStep {
                        case .intro:
                            FirstPage()
                        case .date:
                            SecondPage(store: store)
                        case .time:
                            ThirdPage(store: store)
                        case .gender:
                            GenderPage(store: store)
                        case .location:
                            FourthPage(store: store)
                        }
                    }
                    .id(store.currentStep)
                    .transition(
                        store.direction == .forward
                        ? .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
                        : .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
                    )
                }
                .animation(.easeInOut(duration: 0.3), value: store.currentStep)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Continue Button
                if store.currentStep != .gender {
                    Button {
                        if store.currentStep != .location {
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
                    .sensoryFeedback(.increase, trigger: store.currentStep)
                    .disabled(store.isLoading || (store.currentStep == .location && store.selectedLocation == nil))
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
    }
}

// MARK: - Progress Bar Component
struct OnboardingProgressBar: View {
    @Environment(\.theme) var theme
    let currentStep: OnboardingStep
    let totalSteps: Int
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
            .opacity(currentStep != .intro ? 1 : 0)
            .disabled(currentStep == .intro)
            
            // Progress segments
            HStack(spacing: 8) {
                ForEach(0..<totalSteps, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(index <= currentStep.rawValue ? theme.colors.primaryVariant : theme.colors.onBackground.opacity(0.2))
                        .frame(height: 4)
                        .animation(.easeInOut(duration: 0.3), value: currentStep)
                }
            }
        }
        .frame(height: 44)
    }
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
