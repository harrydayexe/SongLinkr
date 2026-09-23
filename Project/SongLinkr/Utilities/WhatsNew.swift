//
//  WhatsNew.swift
//  SongLinkr
//
//  Created by Harry Day on 23/09/2026.
//

import Foundation

/// Release notes shown once after updating to a version that has them.
struct WhatsNew: Identifiable {
    /// Marketing version as major.minor, so patch releases don't show the notes again.
    let version: String
    /// Whether fresh installs see these notes too, rather than only people updating.
    let showsOnFreshInstall: Bool
    let features: [Feature]

    var id: String {
        version
    }

    struct Feature: Identifiable {
        let symbol: String
        let title: LocalizedStringResource
        let description: LocalizedStringResource

        var id: String {
            symbol
        }
    }

    /// Add an entry here for each release worth announcing.
    static let releases: [WhatsNew] = [
        WhatsNew(
            version: "3.0",
            // The redesign doubles as a welcome, and earlier versions never recorded a
            // last seen version, so upgraders can't be told apart from fresh installs
            showsOnFreshInstall: true,
            features: [
                Feature(
                    symbol: "sparkles",
                    title: LocalizedStringResource("A Fresh New Look", comment: "What's New feature title"),
                    description: LocalizedStringResource("Rebuilt from the ground up for iOS 27, with Liquid Glass throughout.", comment: "What's New feature description")
                ),
                Feature(
                    symbol: "shazam.logo.fill",
                    title: LocalizedStringResource("Shazam, Front and Centre", comment: "What's New feature title"),
                    description: LocalizedStringResource("Tap the Shazam button to identify what's playing and get links straight away.", comment: "What's New feature description")
                ),
                Feature(
                    symbol: "link",
                    title: LocalizedStringResource("Share song.link", comment: "What's New feature title"),
                    description: LocalizedStringResource("Share a universal link to your friends.", comment: "What's New feature description")
                ),
                Feature(
                    symbol: "square.and.arrow.up",
                    title: LocalizedStringResource("Redesigned Share Extension", comment: "What's New feature title"),
                    description: LocalizedStringResource("Share a song from any app and get links without leaving it.", comment: "What's New feature description")
                )
            ]
        )
    ]

    /// The running app's marketing version as major.minor, e.g. "3.0" for 3.0.1.
    static var currentVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        return version.split(separator: ".").prefix(2).joined(separator: ".")
    }

    /// The notes to show for this version, if any.
    /// - Parameter lastSeen: The version last recorded; empty on a fresh install.
    static func pending(lastSeen: String) -> WhatsNew? {
        guard lastSeen != currentVersion,
              let release = releases.first(where: { $0.version == currentVersion })
        else { return nil }
        guard !lastSeen.isEmpty || release.showsOnFreshInstall else { return nil }
        return release
    }
}
