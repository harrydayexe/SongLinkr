//
//  SongLinkrApp.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import SwiftUI
import SongLinkrNetworkCore

@main
struct SongLinkrApp: App {
    var userSettings = UserSettings()
    var store = AppStore(initialState: .init(), reducer: appReducer, environment: World())
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(userSettings)
                .environmentObject(store)
        }
    }
}
