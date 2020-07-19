//
//  MainTabView.swift
//  SongLinkr
//
//  Created by Harry Day on 18/07/2020.
//

import SwiftUI

struct MainTabView: View {
    @State var selectedView = 0
    
    var body: some View {
        TabView(selection: $selectedView) {
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
        Group {
            MainTabView()
            MainTabView(selectedView: 1)
        }
        Group {
            MainTabView()
            MainTabView(selectedView: 1)
        }
        .preferredColorScheme(.dark)
    }
}
