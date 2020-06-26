//
//  SongLinkAPIResponse.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import Foundation


public typealias EntityUniqueId = String

/**
 The SongLinkAPIResponse struct contains support for decoding JSON objects from the Song.Link API
 */
public struct SongLinkAPIResponse: Codable {
    /**
     The unique ID for the input entity that was supplied in the request.
     */
    public var entityUniqueId: String
    /**
     The userCountry query param that was supplied in the request. It signals the country/availability we use to query the streaming platforms. Defaults to `US` if no userCountry supplied in the request.
     - Warning:
        As a fallback, our service may respond with matches that were found in a locale other than the userCountry supplied
     */
    public var userCountry: String
    /**
     A URL that will render the Songlink page for this entity
     */
    public var pageUrl: URL
    /**
     A collection of objects. Each key is a unique identifier for a streaming entity, and each value is an object that contains data for that entity, such as `title`, `artistName`, `thumbnailUrl`, etc.
     */
    public var entitiesByUniqueId: [EntityUniqueId:Entity]
    /**
     A collection of objects. Each key is a platform, and each value is an object that contains data for linking to the match
     */
    public var linksByPlatform: [Platform.RawValue:PlatformInfo]
    
    /**
     Creates a SongLinkAPIResponse struct from the Song.Link JSON data, if possible. This initialiser is simply a wrapper around a `JSONDecoder`
     - parameter data: Song.Link JSON `Data` to be converted
     - warning: This initialiser will fail if the Song.Link JSON provided to it cannot be decoded by a `JSONDecoder` into a `SongLinkAPIResponse` for whatever reason, such as an incomplete download or other badly formatted JSON.
     */
    public init?(data: Data) {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(SongLinkAPIResponse.self, from: data)
            self.entityUniqueId = response.entityUniqueId
            self.userCountry = response.userCountry
            self.pageUrl = response.pageUrl
            self.entitiesByUniqueId = response.entitiesByUniqueId
            self.linksByPlatform = response.linksByPlatform
        } catch {
            return nil
        }
    }
}
