//
//  URL+ExpressibleByStringLiteral.swift
//  SongLinkr
//
//  Created by Harry Day on 17/07/2020.
//

import Foundation

extension URL: ExpressibleByStringLiteral {
    // By using 'StaticString' we disable string interpolation, for safety
    public init(stringLiteral value: StaticString) {
        self = URL(string: "\(value)").require(hint: "Invalid URL string literal: \(value)")
    }
}

