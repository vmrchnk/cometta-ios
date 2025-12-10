//
//  HomeCoordinatorView.swift
//  Cometta
//
//  Created on 07.11.2025.
//

import SwiftUI

struct HomeCoordinatorView: View {
    @Environment(\.theme) var theme
    @State private var coordinator = Coordinator<HomeScreen>()
    @State private var homeViewModel = HomeViewModel()

    var body: some View {
        ZStack {
            NavigationStack(path: $coordinator.path) {
                build(screen: .home)
                    .navigationDestination(for: HomeScreen.self) { screen in
                        build(screen: screen)
                    }
            }
            .sheet(item: $coordinator.sheet) { screen in
                NavigationStack {
                    build(screen: screen)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Close") {
                                    coordinator.dismissSheet()
                                }
                            }
                        }
                }
            }
            .fullScreenCover(item: $coordinator.fullScreenCover) { screen in
                NavigationStack {
                    build(screen: screen)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Close") {
                                    coordinator.dismissCover()
                                }
                            }
                        }
                }
            }
            
            // Full Screen Loading Overlay
            if homeViewModel.isLoading {
                Color.black.opacity(0.5) // Dim background
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                LoadingView(theme: theme)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(theme.colors.background)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: homeViewModel.isLoading)
    }

    // MARK: - View Builder
    @ViewBuilder
    func build(screen: HomeScreen) -> some View {
        switch screen {
        case .home:
            HomeView(params: .init(onAction: handleHomeAction), viewModel: homeViewModel)

        case .profile:
            Text("Profile")

        case .settings:
            SettingsView()

        case .detail(let id):
            Text("Detail: \(id)")
        }
    }

    // MARK: - Reducer
    /// Centralized action handler for HomeView
    /// This reducer pattern provides:
    /// - Single source of truth for navigation logic
    /// - Easy debugging (all actions flow through one place)
    /// - Testable navigation flows
    private func handleHomeAction(_ action: HomeView.Action) {
        switch action {
        case .profileTapped:
            coordinator.push(screen: .profile)

        case .settingsTapped:
            coordinator.push(screen: .settings)

        case .detailTapped(let id):
            coordinator.push(screen: .detail(id: id))
        }
    }
}
