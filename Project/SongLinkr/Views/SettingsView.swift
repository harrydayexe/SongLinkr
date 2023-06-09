//
//  SettingsView.swift
//  SongLinkr
//
//  Created by Harry Day on 18/07/2020.
//

import SwiftUI
import SongLinkrNetworkCore

struct SettingsView: View {
    @EnvironmentObject var userSettings: UserSettings
    let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        NavigationView {
            Form {
                Section(
                    header: Text("Preferences", comment: "Section Header, the user preferences section"),
                    footer: Text(
                        "Auto Open External Links will automatically open your default platform if it is matched and the original link did not originate from it.",
                        comment: "Section Footer, Explains the auto open preference"
                    )
                ) {
                    Picker(selection: self.$userSettings.defaultPlatform, label: Text("Default Streaming Platform", comment: "Option Name, The user's preferred music platform")) {
                        ForEach(Platform.allCases, id: \.self) { platform in
                            Text(verbatim: platform.displayName)
                        }
                    }
                    
                    Picker(selection: self.$userSettings.sortOption, label: Text("Platform Sort Option", comment: "Option name, user's choose what order to show results in")) {
                        ForEach(UserSettings.SortOptions.allCases, id: \.self) { sortOption in
                            Text(verbatim: sortOption.localisedName)
                        }
                    }
                    
                    Toggle(isOn: self.$userSettings.defaultAtTop) {
                        Text("Default Platform at the Top of Results", comment: "Option name, decides whether the users preferred platform is at the top of the list")
                    }
                    
                    Toggle(isOn: self.$userSettings.autoOpen) {
                        Text("Auto Open External Links", comment: "Option name, decides whether to automatically open links in the user's preferred platform")
                    }
                    
                    Toggle(isOn: self.$userSettings.saveToShazamLibrary) {
                        Text("Save Shazam Matches to Library", comment: "Option name, decides whether to save matches made with shazam to the shazam library automatically")
                    }
                }
                
                Section(
                    header: Text("Help", comment: "Section Header, contains links to support online")
                ) {
                    Link(destination: URL(string: "https://songlinkr.harryday.xyz/support.html")!, label: {
                        Text("Support", comment: "Link name, links to the support page")
                    })
                    Link(destination: URL(string: "https://songlinkr.harryday.xyz/privacy.html")!, label: {
                        Text("Privacy Policy", comment: "Link name, links to the privacy policy")
                    })
                    Link(destination: URL(string: "http://songlinkr.harryday.xyz/translations.html")!) {
                        Text("Improve Translations", comment: "Link name, Links to a page about improving translations")
                    }
                }
                
                Section(
                    header: Text("About", comment: "Section Header, section contains information about the app"),
                    footer: Text("SongLinkr is developed by Harry Day from England", comment: "Section footer")
                ) {
                    HStack {
                        Text("Version Number", comment: "The version number of the app")
                        Spacer()
                        Text(verbatim: "\(versionNumber ?? String(localized: "Unknown", comment: "Placeholder for when the version number cannot be loaded"))")
                            .foregroundColor(.secondary)
                    }
                    .accessibility(
                        label: Text("Version Number", comment: "The version number of the app")
                    )
                    .accessibility(
                        value: Text(verbatim: "\(versionNumber ?? String(localized: "Unknown", comment: "Placeholder for when the version number cannot be loaded"))")
                    )
                    
                    NavigationLink(destination: SupportedPlatformsList()) {
                        Text("Supported Platforms", comment: "Navigation Link to a list of supported platforms")
                    }
                    
                    NavigationLink(destination: TranslationCreditView()) {
                        Text("Thanks To", comment: "A navigation link to a list of people that are credited with thanks")
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
        Group {
            SettingsView()
        }
            .environmentObject(userSettings)
    }
}
