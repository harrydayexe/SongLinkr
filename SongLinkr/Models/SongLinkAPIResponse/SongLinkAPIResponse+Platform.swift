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
    public enum Platform: String, Codable {
        case spotify = "Spotify"
        case itunes = "iTunes"
        case appleMusic = "Apple Music"
        case youtube = "YouTube"
        case youtubeMusic = "YouTube Music"
        case google = "Google"
        case googleStore = "Google Store"
        case pandora = "Pandora"
        case deezer = "Deezer"
        case tidal = "Tidal"
        case amazonStore = "Amazon Store"
        case amazonMusic = "Amazon Music"
        case soundcloud = "SoundCloud"
        case napster = "Napster"
        case yandex = "Yandex"
        case spinrilla = "Spinrilla"
    }
}
