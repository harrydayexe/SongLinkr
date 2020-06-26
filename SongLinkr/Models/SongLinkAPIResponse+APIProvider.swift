//
//  SongLinkAPIResponse+APIProvider.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import Foundation

extension SongLinkAPIResponse {
    public enum APIProvider: String, Codable {
        case spotify
        case itunes
        case youtube
        case google
        case pandora
        case deezer
        case tidal
        case amazon
        case soundcloud
        case napster
        case yandex
        case spinrilla
    }
}
