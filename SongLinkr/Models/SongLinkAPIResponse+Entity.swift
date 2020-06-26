//
//  SongLinkAPIResponse+Entity.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import Foundation

extension SongLinkAPIResponse {
    /**
     `Entity` is a struct that contains data for that entity, such as `title`, `artistName`, `thumbnailUrl`, etc.
     */
    public struct Entity: Codable {
        /**
         This is the unique identifier on the streaming platform/API provider
         */
        public var id: String
        /**
         The type of the media
         */
        public var type: MusicType
        /**
         The title of the media
         */
        public var title: String?
        /**
         The name of the artist of the media
         */
        public var artistName: String?
        /**
         A URL to access the thumbnail for the media
         */
        public var thumbnailUrl: URL?
        /**
         The width of the thumbnail
         */
        public var thumbnailWidth: Int?
        /**
         The height of the thumbnail
         */
        public var thumbnailHeight: Int?
        /**
         The  API provider that powered this match. Useful if you'd like to use this entity's data to query the API directly
         */
        public var apiProvider: APIProvider
        /**
         An array of platforms that are "powered" by this entity. E.g. an entity from Apple Music will generally have a `platforms` array of `["appleMusic", "itunes"]` since both those platforms/links are derived from this single entity
         */
        public var platforms: [Platform]
    }
}
