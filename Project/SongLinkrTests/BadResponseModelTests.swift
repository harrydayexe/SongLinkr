//
//  BadResponseModelTests.swift
//  SongLinkr
//
//  Created by Harry Day on 16/07/2020.
//

import XCTest
@testable import SongLinkr

class BadResponseModelTests: XCTestCase {
    
    let noItemJSON = Data("""
        {"statusCode":404,"code":"could_not_fetch_entity_data"}
    """.utf8)
    
    let noEntityJSON = Data("""
        {"statusCode":400,"code":"could_not_resolve_entity"}
    """.utf8)
    
    let invalidJSON = Data("""
            {"stasCode"400,"code":"could_not_resolve_entity"}
    """.utf8)
    
    let invalidFormat = Data("""
        {"sttCode":404,"ce":"could_not_fetch_entity_data"}
    """.utf8)

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }
    
    func testNoItemResponse() {
        if let response = BadResponse(data: noItemJSON) {
            XCTAssertEqual(response.statusCode, 404, "Wrong status code")
            XCTAssertEqual(response.code, "could not fetch entity data", "Wrong reason")
        } else {
            XCTFail("Could not decode JSON data")
        }
    }
    
    func testNoEntityResponse() {
        if let response = BadResponse(data: noEntityJSON) {
            XCTAssertEqual(response.statusCode, 400, "Wrong status code")
            XCTAssertEqual(response.code, "could not resolve entity", "Wrong reason")
        } else {
            XCTFail("Could not decode JSON data")
        }
    }
    
    func testInvalidJSON() {
        XCTAssertNil(BadResponse(data: invalidJSON), "Somehow managed to decode inavlid JSON")
    }
    
    func testInvalidFormat() {
        XCTAssertNil(BadResponse(data: invalidFormat), "Somehow managed to decode badly formatted JSON")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
