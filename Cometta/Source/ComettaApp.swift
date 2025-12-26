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
            AppView(store: Store(initialState: AppFeature.State()) {
                AppFeature()
            })
            .theme(.default)
        }
    }
}
