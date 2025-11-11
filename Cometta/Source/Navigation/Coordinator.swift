//
//  Coordinator.swift
//  Cometta
//
//  Created on 07.11.2025.
//

import SwiftUI

// MARK: - Destination Protocol
protocol Destination: Hashable, Codable, Identifiable { }

// MARK: - Generic Coordinator
@Observable
class Coordinator<Screen: Destination> {
    // Type-safe path instead of type-erased NavigationPath
    var path: [Screen] = []
    var sheet: Screen?
    var fullScreenCover: Screen?

    func push(screen: Screen) {
        path.append(screen)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    func pop(count: Int) {
        let removeCount = min(count, path.count)
        path.removeLast(removeCount)
    }

    func presentSheet(_ sheet: Screen) {
        self.sheet = sheet
    }

    func presentFullScreenCover(_ cover: Screen) {
        self.fullScreenCover = cover
    }

    func dismissSheet() {
        self.sheet = nil
    }

    func dismissCover() {
        self.fullScreenCover = nil
    }

    // MARK: - Deep Linking Support

    /// Set navigation path from array of screens
    func setPath(_ screens: [Screen]) {
        path = screens
    }

    /// Get current navigation path
    func currentPath() -> [Screen] {
        return path
    }

    /// Navigate to specific screen, replacing current path
    func navigate(to screen: Screen) {
        path = [screen]
    }
}
