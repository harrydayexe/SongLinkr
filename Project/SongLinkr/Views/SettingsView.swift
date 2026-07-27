//
//  SettingsView.swift
//  SongLinkr
//
//  Created by Harry Day on 18/07/2020.
//

import SwiftUI
import SongLinkrNetworkCore

struct SettingsView: View {
    @Environment(UserSettings.self) var userSettings

    let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    var body: some View {
        @Bindable var settings = userSettings
        NavigationStack {
            Form {
                Section(
                    header: Text("Preferences", comment: "Section Header, the user preferences section"),
                    footer: Text(
                        "Auto Open External Links will automatically open your default platform if it is matched and the original link did not originate from it.",
                        comment: "Section Footer, Explains the auto open preference"
                    )
                ) {
                    Picker(selection: $settings.defaultPlatform, label: Text("Default Streaming Platform", comment: "Option Name, The user's preferred music platform")) {
                        ForEach(Platform.allCases, id: \.self) { platform in
                            Text(platform.displayName)
                        }
                    }

                    Picker(selection: $settings.sortOption, label: Text("Platform Sort Option", comment: "Option name, user's choose what order to show results in")) {
                        ForEach(UserSettings.SortOptions.allCases, id: \.self) { sortOption in
                            Text(sortOption.localisedName)
                        }
                    }

                    Toggle(isOn: $settings.defaultAtTop) {
                        Text("Default Platform at the Top of Results", comment: "Option name, decides whether the users preferred platform is at the top of the list")
                    }

                    Toggle(isOn: $settings.autoOpen) {
                        Text("Auto Open External Links", comment: "Option name, decides whether to automatically open links in the user's preferred platform")
                    }

                    Toggle(isOn: $settings.saveToShazamLibrary) {
                        Text("Save Shazam Matches to Library", comment: "Option name, decides whether to save matches made with shazam to the shazam library automatically")
                    }
                }

                Section(
                    header: Text("Help", comment: "Section Header, contains links to support online")
                ) {
                    Link(destination: URL(string: "https://harryday.dev/songlinkr/support")!, label: {
                        Text("Support", comment: "Link name, links to the support page")
                    })
                    Link(destination: URL(string: "https://harryday.dev/songlinkr/privacy")!, label: {
                        Text("Privacy Policy", comment: "Link name, links to the privacy policy")
                    })
                    Link(destination: URL(string: "http://harryday.dev/songlinkr/support")!) {
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
                        Text("\(versionNumber ?? String(localized: "Unknown", comment: "Placeholder for when the version number cannot be loaded"))")
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityLabel(Text("Version Number", comment: "The version number of the app"))
                    .accessibilityValue(Text("\(versionNumber ?? String(localized: "Unknown", comment: "Placeholder for when the version number cannot be loaded"))"))

                    NavigationLink(destination: SupportedPlatformsList()) {
                        Text("Supported Platforms")
                    }

                    NavigationLink(destination: TranslationCreditView()) {
                        Text("Thanks To")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .environment(UserSettings())
}
