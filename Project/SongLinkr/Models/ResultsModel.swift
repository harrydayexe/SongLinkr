//
//  ResultsModel.swift
//  SongLinkr
//
//  Created by Harry Day on 19/06/2021
//  
//
//  Twitter: https://twitter.com/realharryday
//  Github: https://github.com/harryday123
//


import Foundation
import SongLinkrNetworkCore

struct ResultsModel {
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
}
