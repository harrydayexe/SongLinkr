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
public struct SongLinkAPIResponse: Codable, Equatable {
    /**
     The unique ID for the input entity that was supplied in the request.
     */
    public var entityUniqueId: String = ""
    /**
     The userCountry query param that was supplied in the request. It signals the country/availability we use to query the streaming platforms. Defaults to `US` if no userCountry supplied in the request.
     - Warning:
        As a fallback, our service may respond with matches that were found in a locale other than the userCountry supplied
     */
    public var userCountry: String = ""
    /**
     A URL that will render the Songlink page for this entity
     */
    public var pageUrl: URL = URL(string: "https://song.link")!
    /**
     A collection of objects. Each key is a unique identifier for a streaming entity, and each value is an object that contains data for that entity, such as `title`, `artistName`, `thumbnailUrl`, etc.
     */
    public var entitiesByUniqueId: [EntityUniqueId:Entity] = ["":Entity()]
    /**
     A collection of objects. Each key is a platform, and each value is an object that contains data for linking to the match
     */
    public var linksByPlatform: [Platform.RawValue:PlatformInfo] = [Platform.amazonMusic.rawValue:PlatformInfo()]
}
