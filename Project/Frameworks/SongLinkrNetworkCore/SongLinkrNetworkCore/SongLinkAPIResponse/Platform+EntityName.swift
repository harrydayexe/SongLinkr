//
//  Platform+EntityName.swift
//  SongLinkr
//
//  Created by Harry Day on 19/07/2020.
//

import Foundation

public extension SongLinkAPIResponse.Platform {
    /// The entity name of a platform
    var entityName: String {
        switch self {
            case .spotify:
                return "SPOTIFY"
            case .itunes, .appleMusic:
                return "ITUNES"
            case .youtube, .youtubeMusic:
                return "YOUTUBE"
            case .google, .googleStore:
                return "GOOGLE"
            case .pandora:
                return "PANDORA"
            case .deezer:
                return "DEEZER"
            case .tidal:
                return "TIDAL"
            case .amazonStore, .amazonMusic:
                return "AMAZON"
            case .soundcloud:
                return "SOUNDCLOUD"
            case .napster:
                return "NAPSTER"
            case .yandex:
                return "YANDEX"
            case .spinrilla:
                return "SPINRILLA"
            case .audius:
                return "AUDIUS"
            case .audiomack:
                return "AUDIOMACK"
        }
    }
}
