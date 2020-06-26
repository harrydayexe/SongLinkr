//
//  Endpoint.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import Foundation

/**
    The `Endpoint` struct contains the necessary code to create a URL to access the Song.Link API
 */
public struct Endpoint {
    /**
     The path of a URL. For example the path of `https://github.com/harryday123/` is `/harryday123/`
     */
    let path: String
    /**
     These items appear after the path and are automatically formatted by `URLComponents`
     */
    let queryItems: [URLQueryItem]
}
