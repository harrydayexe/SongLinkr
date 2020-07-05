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
public struct PlatformLinks: Identifiable {
    /**
     The unique ID for the song/album on the platform
     */
    public var id: String
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
