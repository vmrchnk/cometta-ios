//
//  Route.swift
//  Cometta
//
//  Created on 07.11.2025.
//

import Foundation

// MARK: - Root Screen
enum RootScreen: Destination {
    case splash
    case onboarding
    case main

    var id: String {
        switch self {
        case .splash: return "splash"
        case .onboarding: return "onboarding"
        case .main: return "main"
        }
    }
}

// MARK: - Home Screen
enum HomeScreen: Destination {
    case home
    case profile
    case settings
    case detail(id: String)

    var id: String {
        switch self {
        case .home: return "home"
        case .profile: return "profile"
        case .settings: return "settings"
        case .detail(let id): return "detail-\(id)"
        }
    }
}
