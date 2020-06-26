//
//  Endpoint+url.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import Foundation

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.song.link"
        components.path = path
        components.queryItems = queryItems

        return components.url
    }
}
