//
//  Platform+DisplayRank.swift
//  SongLinkr
//
//  Created by Harry Day on 25/04/2021.
//

import Foundation

public extension SongLinkAPIResponse.Platform {
    /// Determines the order of platforms when displayed
    var displayRank: Int {
        switch self {
            case .spotify:
                return 0
            case .itunes:
                return 1
            case .appleMusic:
                return 0
            case .youtube:
                return 0
            case .youtubeMusic:
                return 0
            case .google:
                return 1
            case .googleStore:
                return 1
            case .deezer:
                return 1
            case .tidal:
                return 1
            case .amazonMusic:
                return 1
            case .soundcloud:
                return 1
            case .unknown:
                return 2
            default:
                return 2
        }
    }
}
