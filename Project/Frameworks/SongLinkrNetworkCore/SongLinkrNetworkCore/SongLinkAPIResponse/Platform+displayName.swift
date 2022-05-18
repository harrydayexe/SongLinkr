//
//  Platform+displayName.swift
//  SongLinkr
//
//  Created by Harry Day on 06/07/2020.
//

import Foundation

public extension SongLinkAPIResponse.Platform {
    /// The name to be displayed for a platform
    var displayName: String {
        switch self {
            case .spotify:
                return "Spotify"
            case .itunes:
                return "iTunes"
            case .appleMusic:
                return "Apple Music"
            case .youtube:
                return "YouTube"
            case .youtubeMusic:
                return "YouTube Music"
            case .google:
                return "Google"
            case .googleStore:
                return "Google Store"
            case .pandora:
                return "Pandora"
            case .deezer:
                return "Deezer"
            case .tidal:
                return "Tidal"
            case .amazonStore:
                return "Amazon Store"
            case .amazonMusic:
                return "Amazon Music"
            case .soundcloud:
                return "SoundCloud"
            case .napster:
                return "Napster"
            case .yandex:
                return "Yandex"
            case .spinrilla:
                return "Spinrilla"
            case .audius:
                return "Audius"
            case .audiomack:
                return "Audiomack"
            case .unknown:
                return ""
        }
    }
}
