//
//  SongLinkAPIResponse+PlatformInfo.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import Foundation

extension SongLinkAPIResponse {
    /**
     The `PlatformInfo` struct contains information about each platform that has been matched by the API.
     - important:
     A Platform will exist here only if there is a match found. E.g. if there is no YouTube match found, then neither `youtube` or `youtubeMusic` properties will exist here
     */
    public struct PlatformInfo: Codable, Equatable {
        /**
         The unique ID for this entity. Use it to look up data about this entity at `entitiesByUniqueId[entityUniqueId]`
         */
        public var entityUniqueId: String = ""
        /**
         The URL for this match
         */
        public var url: URL = URL(string: "")!
        /**
         The native app URI that can be used on mobile devices to open this entity directly in the native app
         */
        public var nativeAppUriMobile: URL?
        /**
         The native app URI that can be used on desktop devices to open this entity directly in the native app
         */
        public var nativeAppUriDesktop: URL?
    }
}
