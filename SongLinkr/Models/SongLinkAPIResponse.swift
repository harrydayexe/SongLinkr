//
//  SongLinkAPIResponse.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import Foundation


public typealias EntityUniqueId = String


public struct SongLinkAPIResponse: Codable {
    public var entityUniqueId: String
    public var userCountry: String
    public var pageUrl: URL
    public var entitiesByUniqueId: [EntityUniqueId:Entity]
    public var linksByPlatform: [Platform.RawValue:PlatformInfo]
    
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
