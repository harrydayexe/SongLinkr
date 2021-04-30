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
                    header: Text("preferences-name"),
                    footer: Text("auto-open-hint")
                ) {
                    DefaultPlatformsPickerView(defaultPlatform: self.$userSettings.defaultPlatform)
                    
                    Picker(selection: self.$userSettings.sortOption, label: Text("platform-sort-option")) {
                        ForEach(UserSettings.SortOptions.allCases, id: \.self) { sortOption in
                            Text(sortOption.localisedName)
                        }
                    }
                    
                    Toggle(isOn: self.$userSettings.defaultAtTop) {
                        Text("default-platform-at-top")
                    }
                    
                    Toggle(isOn: self.$userSettings.autoOpen) {
                        Text("auto-open-external-links")
                    }
                }
                Section(header: Text("About")) {
                    HStack {
                        Text(LocalizedStringKey("version-number"))
                        Spacer()
                        Text(versionNumber ?? "Unknown")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle(LocalizedStringKey("settings-name"))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var userSettings = UserSettings()
    
    static var previews: some View {
        SettingsView()
            .environmentObject(userSettings)
            .environment(\.locale, .init(identifier: "de"))
    }
}
