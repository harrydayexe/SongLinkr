//
//  SongLinkrApp.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import SongLinkrNetworkCore
import SwiftUI

@main
struct SongLinkrApp: App {
    @State private var userSettings = UserSettings()
    @State private var searchModel: SearchModel
    @State private var shazamMatcher: ShazamMatcher
    @State private var navigation = AppNavigation()

    init() {
        let model = SearchModel()
        _searchModel = State(initialValue: model)
        _shazamMatcher = State(initialValue: ShazamMatcher(searchModel: model))
    }

    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environment(userSettings)
                .environment(searchModel)
                .environment(shazamMatcher)
                .environment(navigation)
        }
        .commands {
            // Adds "Settings…" (⌘,) to the app menu on Mac and the ⌘ shortcut list on iPad
            CommandGroup(replacing: .appSettings) {
                Button(String(localized: "Settings…", comment: "Menu command that opens the settings screen")) {
                    navigation.showSettings()
                }
                .keyboardShortcut(",", modifiers: .command)
            }
        }
    }
}
