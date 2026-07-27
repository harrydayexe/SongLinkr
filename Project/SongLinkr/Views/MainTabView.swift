//
//  MainTabView.swift
//  SongLinkr
//
//  Created by Harry Day on 18/07/2020.
//

import SwiftUI

enum AppTab: Hashable {
    case search
    case history
    case settings
}

struct MainTabView: View {
    @State var selectedView: AppTab = .search

    var body: some View {
        TabView(selection: $selectedView) {
            Tab("SongLinkr", systemImage: "textbox", value: AppTab.search) {
                ContentView(selectedTab: $selectedView)
            }
            Tab("History", systemImage: "clock", value: AppTab.history) {
                HistoryView(selectedTab: $selectedView)
            }
            Tab("Settings", systemImage: "gear", value: AppTab.settings) {
                SettingsView()
            }
        }
    }
}

#Preview("Default Tab") {
    let model = SearchModel()
    MainTabView()
        .environment(UserSettings())
        .environment(model)
        .environment(ShazamMatcher(searchModel: model))
}

#Preview("History Tab") {
    let model = SearchModel()
    MainTabView(selectedView: .history)
        .environment(UserSettings())
        .environment(model)
        .environment(ShazamMatcher(searchModel: model))
}
