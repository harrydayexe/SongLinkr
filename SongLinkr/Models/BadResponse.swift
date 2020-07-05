//
//  BadResponse.swift
//  SongLinkr
//
//  Created by Harry Day on 05/07/2020.
//

import Foundation

/**
 The `BadResponse` struct is used when a `4xx` or `5xx` error is received from the server and is used to decode the readable response from the server as the reason to why it failed.
 */
public struct BadResponse: Codable {
    /**
     The HTTPS Status Code
     */
    public var statusCode: Int
    
    /**
     The response from the server as to why the request failed.
     */
    public var code: String
    
    public init?(data: Data) {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(BadResponse.self, from: data)
            self.statusCode = response.statusCode
            self.code = response.code.replacingOccurrences(of: "_", with: " ")
        } catch {
            return nil
        }
    }
}
