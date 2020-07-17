//
//  SongLinkAPIResponse+Platform.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import Foundation

extension SongLinkAPIResponse {
    /**
     The `Platform` enum contains all the platforms that the Song.Link API retrieves results for.
     */
    public enum Platform: String, Codable, CaseIterable {
        case spotify
        case itunes
        case appleMusic
        case youtube
        case youtubeMusic
        case google
        case googleStore
        case pandora
        case deezer
        case tidal
        case amazonStore
        case amazonMusic
        case soundcloud
        case napster
        case yandex
        case spinrilla
    }
}
