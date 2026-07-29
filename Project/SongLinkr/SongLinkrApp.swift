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

    init() {
        let model = SearchModel()
        _searchModel = State(initialValue: model)
        _shazamMatcher = State(initialValue: ShazamMatcher(searchModel: model))
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(userSettings)
                .environment(searchModel)
                .environment(shazamMatcher)
        }
    }
}
