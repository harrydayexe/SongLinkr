//
//  PlatformLinksTests.swift
//  SongLinkrNetworkCore
//
//  Created by Harry Day on 09/06/2021
//  
//
//  Twitter: https://twitter.com/realharryday
//  Github: https://github.com/harryday123
//


import XCTest
@testable import SongLinkrNetworkCore

class PlatformLinksTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testComparison() {
        // Given
        let amazon = PlatformLinks(id: .amazonMusic, url: "https://amazon.com")
        let apple = PlatformLinks(id: .appleMusic, url: "https://music.apple.com")
        let yandex = PlatformLinks(id: .yandex, url: "https://yandex.com")
        let google = PlatformLinks(id: .google, url: "https://music.google.com")
        
        XCTAssertTrue(apple < amazon)
        XCTAssertFalse(yandex < amazon)
        XCTAssertTrue(amazon < google)
        XCTAssertFalse(google < amazon)
    }
    
    func testMoveDefaultFirst() {
        let arrayOfPlatforms = [
            PlatformLinks(id: .amazonMusic, url: "https://amazon.com"),
            PlatformLinks(id: .appleMusic, url: "https://music.apple.com"),
            PlatformLinks(id: .yandex, url: "https://yandex.com"),
            PlatformLinks(id: .google, url: "https://music.google.com")
        ]
        
        let fixedArray = [
            PlatformLinks(id: .appleMusic, url: "https://music.apple.com"),
            PlatformLinks(id: .amazonMusic, url: "https://amazon.com"),
            PlatformLinks(id: .yandex, url: "https://yandex.com"),
            PlatformLinks(id: .google, url: "https://music.google.com")
        ]
        
        XCTAssertEqual(fixedArray, arrayOfPlatforms.moveDefaultFirst(with: .appleMusic))
    }
    
    func testMoveDefaultFirstEmpty() {
        let arrayOfPlatforms = [
            PlatformLinks(id: .amazonMusic, url: "https://amazon.com"),
            PlatformLinks(id: .appleMusic, url: "https://music.apple.com"),
            PlatformLinks(id: .yandex, url: "https://yandex.com"),
            PlatformLinks(id: .google, url: "https://music.google.com")
        ]
        
        XCTAssertEqual(arrayOfPlatforms, arrayOfPlatforms.moveDefaultFirst(with: .audius))
    }
}
