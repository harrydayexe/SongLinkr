//
//  AppNavigation.swift
//  SongLinkr
//
//  Created by Harry Day on 29/09/2026.
//

import SwiftUI

/// Screens pushed onto the home `NavigationStack`.
enum AppDestination: Hashable {
    case history
    case settings
}

/// Owns the home navigation path so app-level commands (e.g. ⌘,) can navigate.
@Observable
@MainActor
class AppNavigation {
    var path: [AppDestination] = []

    /// Replaces the stack with Settings; does nothing if Settings is already showing.
    func showSettings() {
        guard path != [.settings] else { return }
        path = [.settings]
    }
}
