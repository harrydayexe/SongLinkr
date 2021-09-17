//
//  PlatformLinks.swift
//  SongLinkr
//
//  Created by Harry Day on 05/07/2020.
//

import Foundation

/**
 The `PlatformLinks` struct is used to hold the links to each platform after a request has been made. This is used to replace the dictionary from the JSON response to easily create buttons dynamically using SwiftUI
 */
public struct PlatformLinks: Identifiable, Equatable, Comparable {
    public init(id: SongLinkAPIResponse.Platform, url: URL, nativeAppUriMobile: URL? = nil, nativeAppUriDesktop: URL? = nil) {
        self.id = id
        self.url = url
        self.nativeAppUriMobile = nativeAppUriMobile
        self.nativeAppUriDesktop = nativeAppUriDesktop
    }
    
    public static func < (lhs: PlatformLinks, rhs: PlatformLinks) -> Bool {
        if lhs.id.displayRank < rhs.id.displayRank {
            return true
        } else if lhs.id.displayRank > rhs.id.displayRank {
            return false
        } else {
            if lhs.id.rawValue < rhs.id.rawValue {
                return true
            } else {
                return false
            }
        }
    }
    
    /**
     The unique ID for the song/album on the platform
     */
    public var id: SongLinkAPIResponse.Platform
    /**
     The main URL for the platform
     */
    public var url: URL
    /**
     The native app URI that can be used on mobile devices to open this entity directly in the native app
     */
    public var nativeAppUriMobile: URL?
    /**
     The native app URI that can be used on desktop devices to open this entity directly in the native app
     */
    public var nativeAppUriDesktop: URL?
}

public extension Array where Element == PlatformLinks {
    /**
     This functon takes the default platform of the user and moves it to the first position in the array in place
     - Parameter defaultPlatform: The default `Platform` of the user
     */
    mutating func moveDefaultFirst(with defaultPlatform: Platform) {
        // Search for default in array
        guard let index = self.firstIndex(where: { $0.id == defaultPlatform }) else {
            return
        }
        
        let element = self.remove(at: index)
        self.insert(element, at: 0)
    }
}
