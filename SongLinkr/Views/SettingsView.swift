//
//  SettingsView.swift
//  SongLinkr
//
//  Created by Harry Day on 18/07/2020.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var userSettings = UserSettings()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Preferences")) {
                    Picker(selection: $userSettings.defaultPlatform, label: Text("Default Streaming Platform")) {
                        ForEach(Platform.allCases, id: \.self) { platform in
                            Text(platform.displayName)
                        }
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
