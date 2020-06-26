//
//  Endpoint+search.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import Foundation

extension Endpoint {
    static func search(with songURL: String) -> Endpoint {
        return Endpoint(
            path: "/v1-alpha.1/links",
            queryItems: [
                URLQueryItem(name: "url", value: songURL)
            ]
        )
    }
}
