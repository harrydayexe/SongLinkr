//
//  SongLinkAPIResponse+MusicType.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import Foundation

extension SongLinkAPIResponse {
    public enum MusicType: String, Codable {
        case song, album
    }
}
