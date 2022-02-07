//
//  Platform+ShortcutIndex.swift
//  SongLinkrNetworkCore
//
//  Created by Harry Day on 10/06/2021
//  
//
//  Twitter: https://twitter.com/realharryday
//  Github: https://github.com/harryday123
//


import Foundation

public extension SongLinkAPIResponse.Platform {
    /// Determines the order of platforms when displayed
    var shortcutIndex: Int {
        switch self {
            case .spotify:
                return 1
            case .itunes:
                return 2
            case .appleMusic:
                return 3
            case .youtube:
                return 4
            case .youtubeMusic:
                return 5
            case .google:
                return 6
            case .googleStore:
                return 7
            case .pandora:
                return 8
            case .deezer:
                return 9
            case .tidal:
                return 10
            case .amazonStore:
                return 11
            case .amazonMusic:
                return 12
            case .soundcloud:
                return 13
            case .napster:
                return 14
            case .yandex:
                return 15
            case .spinrilla:
                return 16
            case .audius:
                return 17
            case .audiomack:
                return 18
        }
    }
}
