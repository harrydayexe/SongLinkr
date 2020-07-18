//
//  MainTabView.swift
//  SongLinkr
//
//  Created by Harry Day on 18/07/2020.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Image(systemName: "textbox")
                    Text("SongLinkr")
                }.tag(0)
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }.tag(1)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
