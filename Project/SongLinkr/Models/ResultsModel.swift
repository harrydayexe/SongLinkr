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
