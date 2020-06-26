//
//  SongLinkAPIResponse+Entity.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import Foundation

extension SongLinkAPIResponse {
    public struct Entity: Codable {
        public var id: String
        public var type: MusicType
        public var title: String?
        public var artistName: String?
        public var thumbnailUrl: URL?
        public var thumbnailWidth: Int?
        public var thumbnailHeight: Int?
        public var apiProvider: APIProvider
        public var platforms: [Platform]
    }
}
