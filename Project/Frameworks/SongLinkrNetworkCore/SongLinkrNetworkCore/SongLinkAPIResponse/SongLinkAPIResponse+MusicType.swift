//
//  SongLinkAPIResponse+MusicType.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import Foundation

public typealias MusicType = SongLinkAPIResponse.MusicType

public extension SongLinkAPIResponse {
    /**
     The `MusicType` enum contains the two types of media currently available to be accessed by the Song.Link API, Song and Album.
     */
    enum MusicType: String, Codable {
        case song, album
    }
}
