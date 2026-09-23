//
//  SettingsView.swift
//  SongLinkr
//
//  Created by Harry Day on 18/07/2020.
//

import SongLinkrNetworkCore
import SwiftUI

struct SettingsView: View {
    @Environment(UserSettings.self) var userSettings

    let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    var body: some View {
        @Bindable var settings = userSettings
        Form {
            Section(
                header: Text("Preferences", comment: "Section Header, the user preferences section"),
                footer: Text(
                    "Auto Open External Links will automatically open your default platform if it is matched and the original link did not originate from it.",
                    comment: "Section Footer, Explains the auto open preference"
                )
            ) {
                Picker(selection: $settings.defaultPlatform) {
                    ForEach(Platform.allCases, id: \.self) { platform in
                        Text(platform.displayName)
                    }
                } label: {
                    SettingsRowLabel(color: .orange, systemImage: "music.note") {
                        Text("Default Streaming Platform", comment: "Option Name, The user's preferred music platform")
                    }
                }
                // Long label plus the platform list wraps onto a second line inline, so push
                // the choice onto its own page with a disclosure arrow instead.
                .pickerStyle(.navigationLink)

                Picker(selection: $settings.sortOption) {
                    ForEach(UserSettings.SortOptions.allCases, id: \.self) { sortOption in
                        Text(sortOption.localisedName)
                    }
                } label: {
                    SettingsRowLabel(color: .indigo, systemImage: "arrow.up.arrow.down") {
                        Text("Platform Sort Option", comment: "Option name, user's choose what order to show results in")
                    }
                }

                Toggle(isOn: $settings.defaultAtTop) {
                    SettingsRowLabel(color: .purple, systemImage: "arrow.up.to.line") {
                        Text("Default Platform at the Top of Results", comment: "Option name, decides whether the users preferred platform is at the top of the list")
                    }
                }

                Toggle(isOn: $settings.autoOpen) {
                    SettingsRowLabel(color: .green, systemImage: "arrow.up.right") {
                        Text("Auto Open External Links", comment: "Option name, decides whether to automatically open links in the user's preferred platform")
                    }
                }

                Toggle(isOn: $settings.saveToShazamLibrary) {
                    SettingsRowLabel(color: .blue, systemImage: "waveform") {
                        Text("Save Shazam Matches to Library", comment: "Option name, decides whether to save matches made with shazam to the shazam library automatically")
                    }
                }
            }

            Section(
                header: Text("Help", comment: "Section Header, contains links to support online")
            ) {
                Link(destination: URL(string: "https://harryday.dev/songlinkr/support")!) {
                    SettingsRowLabel(color: .teal, systemImage: "questionmark") {
                        Text("Support", comment: "Link name, links to the support page")
                    }
                }

                Link(destination: URL(string: "https://harryday.dev/songlinkr/privacy")!) {
                    SettingsRowLabel(color: .gray, systemImage: "hand.raised") {
                        Text("Privacy Policy", comment: "Link name, links to the privacy policy")
                    }
                }

                Link(destination: URL(string: "http://harryday.dev/songlinkr/support")!) {
                    SettingsRowLabel(color: .cyan, systemImage: "globe") {
                        Text("Improve Translations", comment: "Link name, Links to a page about improving translations")
                    }
                }
            }

            Section(
                header: Text("About", comment: "Section Header, section contains information about the app"),
                footer: Text("SongLinkr is developed by Harry Day from England", comment: "Section footer")
            ) {
                HStack {
                    SettingsRowLabel(color: Color(.systemGray), systemImage: "info") {
                        Text("Version Number", comment: "The version number of the app")
                    }
                    Spacer()
                    Text("\(versionNumber ?? String(localized: "Unknown", comment: "Placeholder for when the version number cannot be loaded"))")
                        .foregroundStyle(.secondary)
                }
                .accessibilityLabel(Text("Version Number", comment: "The version number of the app"))
                .accessibilityValue(Text("\(versionNumber ?? String(localized: "Unknown", comment: "Placeholder for when the version number cannot be loaded"))"))

                NavigationLink(destination: SupportedPlatformsList()) {
                    SettingsRowLabel(color: .orange, systemImage: "music.note.list") {
                        Text("Supported Platforms")
                    }
                }

                NavigationLink(destination: TranslationCreditView()) {
                    SettingsRowLabel(color: .pink, systemImage: "heart") {
                        Text("Thanks To")
                    }
                }
            }
        }
        .tint(.accentColor)
        .foregroundStyle(.primary)
        .scrollContentBackground(.hidden)
        .background { GradientBackground() }
        .navigationTitle(Text("Settings"))
    }
}

/// Grouped-list row label with a small coloured icon tile, matching the redesign language.
struct SettingsRowLabel<Title: View>: View {
    let color: Color
    let systemImage: String
    @ViewBuilder let title: Title

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 30, height: 30)
                .overlay {
                    Image(systemName: systemImage)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white)
                }
            title
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environment(UserSettings())
    }
}
