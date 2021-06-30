//
//  MainTabView.swift
//  SongLinkr
//
//  Created by Harry Day on 18/07/2020.
//

import SwiftUI

struct MainTabView: View {
    /// The tab that is selected
    @State var selectedView = 0
    
    var body: some View {
        TabView(selection: $selectedView) {
            ContentView(selectedTab: $selectedView)
                .tabItem {
                    Image(systemName: "textbox")
                    Text(verbatim: "SongLinkr")
                }.tag(0)
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings", comment: "Tab Bar name for the settings page")
                }.tag(2)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainTabView()
            MainTabView(selectedView: 1)
        }
        .environmentObject(UserSettings())
    }
}
