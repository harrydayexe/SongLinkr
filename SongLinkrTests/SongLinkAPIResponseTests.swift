//
//  SongLinkAPIResponseTests.swift
//  SongLinkrTests
//
//  Created by Harry Day on 17/07/2020.
//

import XCTest
@testable import SongLinkr

class SongLinkAPIResponseTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }
    
    func testBlankInit() {
        let response = SongLinkAPIResponse()
        
        let targetPageURL: URL = "https://song.link"
        let entityCount = response.entitiesByUniqueId.count
        let platformCount = response.linksByPlatform.count
        let targetEntity = ["":SongLinkAPIResponse.Entity()]
        let targetPlatform = [Platform.amazonMusic.rawValue:PlatformInfo()]
        
        XCTAssertEqual(response.entityUniqueId, "", "Unexpected non empty string init")
        XCTAssertEqual(response.userCountry, "", "Unexpected non empty string init")
        XCTAssertEqual(response.pageUrl, targetPageURL, "Incorrect default URL")
        XCTAssertEqual(entityCount, 1, "Incorrect defualt number of Entities by unique ID")
        XCTAssertEqual(platformCount, 1, "Incorrect defualt number of Links By Platforms")
        XCTAssertEqual(response.entitiesByUniqueId, targetEntity, "Incorrect default EntityByUniqueID")
        XCTAssertEqual(response.linksByPlatform, targetPlatform, "Incorrect default Links by Platform")
    }
    
    func testDisplayName() {
        for platform in Platform.allCases {
            switch platform {
                case .spotify:
                    XCTAssertEqual(platform.displayName, "Spotify", "Incorrect Display Name")
                case .itunes:
                    XCTAssertEqual(platform.displayName, "iTunes", "Incorrect Display Name")
                case .appleMusic:
                    XCTAssertEqual(platform.displayName, "Apple Music", "Incorrect Display Name")
                case .youtube:
                    XCTAssertEqual(platform.displayName, "YouTube", "Incorrect Display Name")
                case .youtubeMusic:
                    XCTAssertEqual(platform.displayName, "YouTube Music", "Incorrect Display Name")
                case .google:
                    XCTAssertEqual(platform.displayName, "Google", "Incorrect Display Name")
                case .googleStore:
                    XCTAssertEqual(platform.displayName, "Google Store", "Incorrect Display Name")
                case .pandora:
                    XCTAssertEqual(platform.displayName, "Pandora", "Incorrect Display Name")
                case .deezer:
                    XCTAssertEqual(platform.displayName, "Deezer", "Incorrect Display Name")
                case .tidal:
                    XCTAssertEqual(platform.displayName, "Tidal", "Incorrect Display Name")
                case .amazonStore:
                    XCTAssertEqual(platform.displayName, "Amazon Store", "Incorrect Display Name")
                case .amazonMusic:
                    XCTAssertEqual(platform.displayName, "Amazon Music", "Incorrect Display Name")
                case .soundcloud:
                    XCTAssertEqual(platform.displayName, "SoundCloud", "Incorrect Display Name")
                case .napster:
                    XCTAssertEqual(platform.displayName, "Napster", "Incorrect Display Name")
                case .yandex:
                    XCTAssertEqual(platform.displayName, "Yandex", "Incorrect Display Name")
                case .spinrilla:
                    XCTAssertEqual(platform.displayName, "Spinrilla", "Incorrect Display Name")
            }
        }
    }
    
    func testIconName() {
        for platform in Platform.allCases {
            switch platform {
                case .spotify:
                    XCTAssertEqual(platform.iconName, "SpotifyLogoWhite", "Incorrect Display Name")
                case .itunes:
                    XCTAssertEqual(platform.iconName, "iTunesLogoWhite", "Incorrect Display Name")
                case .appleMusic:
                    XCTAssertEqual(platform.iconName, "AppleMusicLogoWhite", "Incorrect Display Name")
                case .youtube:
                    XCTAssertEqual(platform.iconName, "YouTubeLogoWhite", "Incorrect Display Name")
                case .youtubeMusic:
                    XCTAssertEqual(platform.iconName, "YouTubeLogoWhite", "Incorrect Display Name")
                case .google:
                    XCTAssertEqual(platform.iconName, "PlayMusicLogo", "Incorrect Display Name")
                case .googleStore:
                    XCTAssertEqual(platform.iconName, "PlayStoreLogo", "Incorrect Display Name")
                case .pandora:
                    XCTAssertEqual(platform.iconName, "PandoraLogoWhite", "Incorrect Display Name")
                case .deezer:
                    XCTAssertEqual(platform.iconName, "DeezerLogoWhite", "Incorrect Display Name")
                case .tidal:
                    XCTAssertEqual(platform.iconName, "TidalLogoWhite", "Incorrect Display Name")
                case .amazonStore:
                    XCTAssertEqual(platform.iconName, "AmazonLogoWhite", "Incorrect Display Name")
                case .amazonMusic:
                    XCTAssertEqual(platform.iconName, "PrimeLogoWhite", "Incorrect Display Name")
                case .soundcloud:
                    XCTAssertEqual(platform.iconName, "SoundcloudLogoWhite", "Incorrect Display Name")
                case .napster:
                    XCTAssertEqual(platform.iconName, "NapsterLogoWhite", "Incorrect Display Name")
                case .yandex:
                    XCTAssertEqual(platform.iconName, "YandexLogoColor", "Incorrect Display Name")
                case .spinrilla:
                    XCTAssertEqual(platform.iconName, "SpinrillaLogoWhite", "Incorrect Display Name")
            }
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
