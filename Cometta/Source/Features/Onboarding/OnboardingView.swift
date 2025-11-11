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

    let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "star.fill",
            title: "Welcome to Cometta",
            description: "Your journey starts here"
        ),
        OnboardingPage(
            icon: "sparkles",
            title: "Discover Features",
            description: "Explore amazing possibilities"
        ),
        OnboardingPage(
            icon: "heart.fill",
            title: "Get Started",
            description: "Let's make something great"
        )
    ]

    var body: some View {
        ZStack {
            theme.colors.background
                .ignoresSafeArea()

            VStack(spacing: 40) {
                // Skip button
                HStack {
                    Spacer()
                    Button("Skip") {
                        onComplete()
                    }
                    .foregroundStyle(theme.colors.onBackground.opacity(0.6))
                    .padding()
                }

                Spacer()

                // Pages
                TabView(selection: $currentPage) {
                    ForEach(pages.indices, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 400)

                Spacer()

                // Button
                Button {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        onComplete()
                    }
                } label: {
                    Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                        .font(.headline)
                        .foregroundStyle(theme.colors.onPrimary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(theme.colors.primary)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    @Environment(\.theme) var theme
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: page.icon)
                .font(.system(size: 80))
                .foregroundStyle(theme.colors.primary)

            Text(page.title)
                .font(.title.bold())
                .foregroundStyle(theme.colors.onBackground)
                .multilineTextAlignment(.center)

            Text(page.description)
                .font(.body)
                .foregroundStyle(theme.colors.onSurface.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

#Preview("Light") {
    OnboardingView(onComplete: {})
        .theme(.light)
}

#Preview("Dark") {
    OnboardingView(onComplete: {})
        .theme(.dark)
}
