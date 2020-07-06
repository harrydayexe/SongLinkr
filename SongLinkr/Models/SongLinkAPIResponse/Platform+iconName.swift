//
//  Platform+iconName.swift
//  SongLinkr
//
//  Created by Harry Day on 06/07/2020.
//

import Foundation

extension SongLinkAPIResponse.Platform {
    var iconName: String {
        switch self {
            case .spotify:
                return "SpotifyLogoWhite"
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
        }
    }
}
