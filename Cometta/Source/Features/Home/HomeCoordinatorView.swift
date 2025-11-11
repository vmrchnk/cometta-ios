//
//  HomeCoordinatorView.swift
//  Cometta
//
//  Created on 07.11.2025.
//

import SwiftUI

struct HomeCoordinatorView: View {
    @State private var coordinator = Coordinator<HomeScreen>()

    var body: some View {
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
    }

    // MARK: - View Builder
    @ViewBuilder
    func build(screen: HomeScreen) -> some View {
        EmptyView()
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
            coordinator.presentSheet(.settings)

        case .detailTapped(let id):
            coordinator.push(screen: .detail(id: id))
        }
    }
}
