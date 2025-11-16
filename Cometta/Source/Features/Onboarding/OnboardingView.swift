//
//  OnboardingView.swift
//  Cometta
//
//  Created on 07.11.2025.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.theme) var theme
    let onComplete: () -> Void
    @State private var currentPage = 0

    let totalPages = 5

    let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "star.fill",
            title: "Welcome to Cometta",
            description: "Your personal guide to the stars"
        ),
        OnboardingPage(
            icon: "moon.stars.fill",
            title: "Discover Your Sign",
            description: "Learn about your zodiac personality"
        ),
        OnboardingPage(
            icon: "sparkles",
            title: "Daily Horoscope",
            description: "Get personalized daily insights"
        ),
        OnboardingPage(
            icon: "heart.circle.fill",
            title: "Compatibility",
            description: "Explore your relationships with others"
        ),
        OnboardingPage(
            icon: "calendar",
            title: "Date of Birth",
            description: "The day you were born is important for the alignment of the planets"
        )
    ]

    var body: some View {
        ZStack {
            theme.colors.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress bar
                OnboardingProgressBar(
                    currentPage: currentPage,
                    totalPages: totalPages,
                    onBack: {
                        if currentPage > 0 {
                            withAnimation {
                                currentPage -= 1
                            }
                        }
                    }
                )
                .padding(.horizontal, 24)
                .padding(.top, 16)

                Spacer()

                // Pages
                TabView(selection: $currentPage) {
                    FirstPage()
                        .tag(0)

                    SecondPage()
                        .tag(1)

                    ThirdPage()
                        .tag(2)

//                    ForEach(pages.indices, id: \.self) { index in
//                        OnboardingPageView(page: pages[index])
//                            .tag(index)
//                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                Spacer()

                // Continue Button
                Button {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else {
                        onComplete()
                    }
                } label: {
                    Text("Continue")
                        .font(.system(size: 18, weight: .semibold))
                        
                        .frame(maxWidth: .infinity)
//                        .background(
//                            RoundedRectangle(cornerRadius: 16)
//                                .fill(theme.colors.primaryVariant)
//                        )
                }
                .buttonStyle(MyButtonStyle(isLoading: false))
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
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

// MARK: - Page Data Model
struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
}

// MARK: - Page View Component
struct OnboardingPageView: View {
    @Environment(\.theme) var theme
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                theme.colors.primaryVariant.opacity(0.3),
                                theme.colors.primary.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 200, height: 200)
                Image(systemName: page.icon)
                    .font(.system(size: 80, weight: .light))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [theme.colors.primaryVariant, theme.colors.primary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }

            Spacer()

            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(theme.colors.onBackground)
                    .multilineTextAlignment(.center)

                Text(page.description)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(theme.colors.onSurface.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .lineSpacing(4)
            }

            Spacer()
        }
        .padding(.vertical, 40)
    }
}

#Preview("Light") {
    OnboardingView(onComplete: {})
        .theme(.default)
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    OnboardingView(onComplete: {})
        .theme(.default)
        .preferredColorScheme(.dark)
}

#Preview("Progress Bar") {
    VStack(spacing: 40) {
        OnboardingProgressBar(currentPage: 0, totalPages: 5, onBack: {})
        OnboardingProgressBar(currentPage: 2, totalPages: 5, onBack: {})
        OnboardingProgressBar(currentPage: 4, totalPages: 5, onBack: {})
    }
    .padding()
    .theme(.default)
    .preferredColorScheme(.dark)
}


struct MyButtonStyle: ButtonStyle {
    @Environment(\.theme) var theme
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
            configuration.isPressed ? theme.colors.primaryVariant :
                theme.colors.primary 
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
        .opacity(configuration.isPressed ? 0.9 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
