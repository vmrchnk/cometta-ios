//
//  ComettaApp.swift
//  Cometta
//
//  Created by Vadym on 07.11.2025.
//

import SwiftUI

@main
struct ComettaApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        RootCoordinatorView()
            .theme(colorScheme == .dark ? .dark : .light)
    }
}
