//
//  ComettaApp.swift
//  Cometta
//
//  Created by Vadym on 07.11.2025.
//

import SwiftUI

import ComposableArchitecture

@main
struct ComettaApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(store: Store(initialState: AppFeature.State()) {
                AppFeature()
            })
        }
    }
}

struct RootView: View {
    @Environment(\.colorScheme) var colorScheme
    let store: StoreOf<AppFeature>

    var body: some View {
        RootCoordinatorView(store: store)
            .theme(.default)
    }
}
