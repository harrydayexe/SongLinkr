//
//  SongLinkAPIResponse+APIProvider.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import Foundation

public typealias APIProvider = SongLinkAPIResponse.APIProvider

public extension SongLinkAPIResponse {
    /**
     The `APIProvider` enum contains all the API Providers the data has been collected from.
     */
    enum APIProvider: String, Codable {
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
        case audius
    }
}

public extension APIProvider {
    /// Determines the order of which to trust api providers for providing the name and artist of each song
    var informationRanking: Int {
        switch self {
            case .spotify:
                return 1
            case .itunes:
                return 1
            case .google:
                return 2
            case .tidal:
                return 3
            case .amazon:
                return 2
            default:
                return Int.max
        }
    }
}
