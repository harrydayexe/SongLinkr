//
//  SettingsView.swift
//  SongLinkr
//
//  Created by Harry Day on 18/07/2020.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userSettings: UserSettings
    let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        NavigationView {
            Form {
                Section(
                    header: Text("Preferences"),
                    footer: Text("If Auto open external links is on, SongLinkr will, where available, automatically open any links that are not from your default streaming platform straight away without presenting the selection screen.")
                ) {
                    DefaultPlatformsPickerView(defaultPlatform: self.$userSettings.defaultPlatform)
                    Toggle(isOn: self.$userSettings.autoOpen) {
                        Text("Auto open external links")
                    }
                }
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(versionNumber ?? "Unknown")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var userSettings = UserSettings()
    
    static var previews: some View {
        SettingsView()
            .environmentObject(userSettings)
    }
}
