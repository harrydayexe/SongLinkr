//
//  Endpoint+url.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import Foundation

extension Endpoint {
    /**
     The url variable returns a `URL?` property that is built from the components of the endpoint.
     */
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.song.link"
        components.path = "/v1-alpha.1" + path
        components.queryItems = queryItems

        return components.url
    }
}
