//
//  SongLinkAPIResponse+PlatformInfo.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import Foundation

extension SongLinkAPIResponse {
    public struct PlatformInfo: Codable {
        public var entityUniqueId: String
        public var url: URL
        public var nativeAppUriMobile: URL?
        public var nativeAppUriDesktop: URL?
    }
}
