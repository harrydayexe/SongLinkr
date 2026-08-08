//
//  ResultsModel.swift
//  SongLinkr
//
//  Created by Harry Day on 19/06/2021
//

import Foundation
import SongLinkrNetworkCore

struct ResultsModel: Identifiable {
    let id = UUID()

    /// A URL to the artwork for the media
    let artworkURL: URL?

    /// The name of the media
    let mediaTitle: String

    /// The name of the artist
    let artistName: String

    /// Declares whether the result has been searched from Shazam
    let isFromShazam: Bool

    /// The actual links to display
    var response: [PlatformLinks]

    /// The song.link page URL for sharing
    let pageUrl: URL?
}

extension ResultsModel: Equatable {
    static func == (lhs: ResultsModel, rhs: ResultsModel) -> Bool {
        if
            lhs.artworkURL == rhs.artworkURL,
            lhs.mediaTitle == rhs.mediaTitle,
            lhs.artistName == rhs.artistName,
            lhs.isFromShazam == rhs.isFromShazam,
            lhs.response == rhs.response,
            lhs.pageUrl == rhs.pageUrl
        {
            return true
        }
        return false
    }
}

#if DEBUG
extension ResultsModel {
    static let previewResults = ResultsModel(
        artworkURL: URL(string: "https://m.media-amazon.com/images/I/51jNytp9pxL._AA500.jpg"),
        mediaTitle: "Humble",
        artistName: "Kendrick Lamar",
        isFromShazam: true,
        response: [
            PlatformLinks(id: Platform.yandex, url: URL(string: "https://music.yandex.ru/track/59994505")!),
            PlatformLinks(id: Platform.youtube, url: URL(string: "https://www.youtube.com/watch?v=QfnVrp2bPuE")!),
            PlatformLinks(id: Platform.spotify, url: URL(string: "https://open.spotify.com/track/3NivHilTTTs8SQwp51yG0X")!),
            PlatformLinks(id: Platform.appleMusic, url: URL(string: "https://geo.music.apple.com/us/album/_/1488452376?i=1488452377&mt=1&app=music&at=1000lHKX")!, nativeAppUriMobile: URL(string: "itmss://itunes.apple.com/us/album/_/1488452376?i=1488452377&mt=1&app=music&at=1000lHKX")!, nativeAppUriDesktop: URL(string: "music://itunes.apple.com/us/album/_/1488452376?i=1488452377&mt=1&app=music&at=1000lHKX")!)
        ].sorted(by: { $0.id.rawValue < $1.id.rawValue }),
        pageUrl: URL(string: "https://song.link/s/3NivHilTTTs8SQwp51yG0X")
    )
}
#endif
