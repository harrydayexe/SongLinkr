//
//  EndpointModelTests.swift
//  SongLinkr
//
//  Created by Harry Day on 16/07/2020.
//

import XCTest
@testable import SongLinkrNetworkCore

class EndpointModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }
    
    func testSearchFunction() {
        let endpoint = Endpoint.search(with: "test.url.string")
        XCTAssertEqual(endpoint.url!, "https://api.song.link/v1-alpha.1/links?url=test.url.string", "URL not correct")
        XCTAssertEqual(endpoint.queryItems, [URLQueryItem(name: "url", value: "test.url.string")])
    }
    
    func testURLGeneration() {
        let endpoint = Endpoint.search(with: "test.url.string")
        if let endpointURL = endpoint.url {
            XCTAssertEqual(
                endpointURL,
                URL(string: "https://api.song.link/v1-alpha.1/links?url=test.url.string")!,
                "Did not form the URL correctly"
            )
        } else {
            XCTFail("URL is nil")
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
