//
//  SongLinkAPIResponse+Platform.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import Foundation
import AudioToolbox

public typealias Platform = SongLinkAPIResponse.Platform

public extension SongLinkAPIResponse {
    /**
     The `Platform` enum contains all the platforms that the Song.Link API retrieves results for.
     */
    enum Platform: String, CaseIterable {
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
        case audius
        case unknown
    }
}

extension Platform: Codable {
    public init(from decoder: Decoder) throws {
        self = try Platform(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
