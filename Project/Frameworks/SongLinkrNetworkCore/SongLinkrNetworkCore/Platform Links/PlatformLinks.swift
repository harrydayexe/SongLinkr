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

#if DEBUG
public extension Array where Element == PlatformLinks {
    static let previewPlatformLinks = [
        PlatformLinks(id: Platform.yandex, url: URL(string: "https://music.yandex.ru/track/59994505")!),
        PlatformLinks(id: Platform.youtube, url: URL(string: "https://www.youtube.com/watch?v=QfnVrp2bPuE")!),
        PlatformLinks(id: Platform.spotify, url: URL(string: "https://open.spotify.com/track/3NivHilTTTs8SQwp51yG0X")!),
        PlatformLinks(id: Platform.appleMusic, url: URL(string: "https://geo.music.apple.com/us/album/_/1488452376?i=1488452377&mt=1&app=music&at=1000lHKX")!, nativeAppUriMobile: URL(string: "itmss://itunes.apple.com/us/album/_/1488452376?i=1488452377&mt=1&app=music&at=1000lHKX")!, nativeAppUriDesktop: URL(string: "music://itunes.apple.com/us/album/_/1488452376?i=1488452377&mt=1&app=music&at=1000lHKX")!)
    ]
}
#endif
