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
                    Picker(selection: self.$userSettings.defaultPlatform, label: Text("default-streaming-platform")) {
                        ForEach(Platform.allCases, id: \.self) { platform in
                            Text(platform.displayName)
                        }
                    }
                    
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
                
                Section(
                    header: Text("Help")
                ) {
                    Link(destination: URL(string: "https://songlinkr.harryday.xyz/support.html")!, label: {
                        Text("Support")
                    })
                    Link(destination: URL(string: "https://songlinkr.harryday.xyz/privacy.html")!, label: {
                        Text("Privacy Policy")
                    })
                    Link(destination: URL(string: "http://songlinkr.harryday.xyz/translations.html")!) {
                        Text("Improve Translations")
                    }
                }
                
                Section(
                    header: Text("About"),
                    footer: Text("SongLinkr is developed by Harry Day from England")) {
                    HStack {
                        Text(LocalizedStringKey("version-number"))
                        Spacer()
                        Text(versionNumber ?? "Unknown")
                            .foregroundColor(.secondary)
                    }
                    .accessibility(label: Text("version-number"))
                    .accessibility(value: Text(versionNumber ?? "Unknown"))
                }
            }
            .navigationTitle(LocalizedStringKey("settings-name"))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var userSettings = UserSettings()
    
    static var previews: some View {
        Group {
            SettingsView()
            SettingsView()
                .environment(\.locale, .init(identifier: "de"))
        }
            .environmentObject(userSettings)
    }
}
