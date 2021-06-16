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
        NavigationView {
            TabView(selection: $selectedView) {
                ContentView(selectedTab: $selectedView)
                    .tabItem {
                        Image(systemName: "textbox")
                        Text("SongLinkr")
                    }.tag(0)
                SettingsView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text(LocalizedStringKey("settings-name"))
                    }.tag(1)
            }
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
        .environmentObject(AppStore(initialState: .init(), reducer: appReducer, environment: World()))
    }
}
