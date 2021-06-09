//
//  Endpoint+search.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import Foundation

public extension Endpoint {
    /**
     The search function sets the endpoint path and adds the url query item to the query item array
     
     - Parameter encodedSongURL: The URL of the song being sent to the API
     - Returns: An Endpoint object to allow chaining
     - Important: The URL passed into the function must be percent encoded as it will be used in the API request. Use the `Network.encodeURL(from:)` function to percent encode the URL correctly
     */
    static func search(with encodedSongURL: String) -> Endpoint {
        return Endpoint(
            path: "/links",
            queryItems: [
                URLQueryItem(name: "url", value: encodedSongURL)
            ]
        )
    }
}
