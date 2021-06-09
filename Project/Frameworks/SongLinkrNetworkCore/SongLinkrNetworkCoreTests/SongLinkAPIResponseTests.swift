//
//  SongLinkAPIResponseTests.swift
//  SongLinkrTests
//
//  Created by Harry Day on 17/07/2020.
//

import XCTest
@testable import SongLinkrNetworkCore

class SongLinkAPIResponseTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }
    
    func testBlankInit() {
        let response = SongLinkAPIResponse()
        
        let targetPageURL: URL = URL(string: "https://song.link")!
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
                case .audius:
                    XCTAssertEqual(platform.displayName, "Audius", "Incorrect Display Name")
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
                case .audius:
                    XCTAssertEqual(platform.iconName, "AudiusLogo", "Incorrect Display Name")
            }
        }
    }
    
    func testDisplayRank() {
        for platform in Platform.allCases {
            switch platform {
                case .spotify:
                    XCTAssertEqual(platform.displayRank, 0, "Incorrect Display Rank")
                case .itunes:
                    XCTAssertEqual(platform.displayRank, 1, "Incorrect Display Rank")
                case .appleMusic:
                    XCTAssertEqual(platform.displayRank, 0, "Incorrect Display Rank")
                case .youtube:
                    XCTAssertEqual(platform.displayRank, 0, "Incorrect Display Rank")
                case .youtubeMusic:
                    XCTAssertEqual(platform.displayRank, 0, "Incorrect Display Rank")
                case .google:
                    XCTAssertEqual(platform.displayRank, 1, "Incorrect Display Rank")
                case .googleStore:
                    XCTAssertEqual(platform.displayRank, 1, "Incorrect Display Rank")
                case .pandora:
                    XCTAssertEqual(platform.displayRank, 2, "Incorrect Display Rank")
                case .deezer:
                    XCTAssertEqual(platform.displayRank, 1, "Incorrect Display Rank")
                case .tidal:
                    XCTAssertEqual(platform.displayRank, 1, "Incorrect Display Rank")
                case .amazonStore:
                    XCTAssertEqual(platform.displayRank, 2, "Incorrect Display Rank")
                case .amazonMusic:
                    XCTAssertEqual(platform.displayRank, 1, "Incorrect Display Rank")
                case .soundcloud:
                    XCTAssertEqual(platform.displayRank, 1, "Incorrect Display Rank")
                case .napster:
                    XCTAssertEqual(platform.displayRank, 2, "Incorrect Display Rank")
                case .yandex:
                    XCTAssertEqual(platform.displayRank, 2, "Incorrect Display Rank")
                case .spinrilla:
                    XCTAssertEqual(platform.displayRank, 2, "Incorrect Display Rank")
                case .audius:
                    XCTAssertEqual(platform.displayRank, 2, "Incorrect Display Rank")
            }
        }
    }
    
    func testEntityName() {
        for platform in Platform.allCases {
            switch platform {
                case .spotify:
                    XCTAssertEqual(platform.entityName, "SPOTIFY", "Incorrect Entity Name")
                case .itunes, .appleMusic:
                    XCTAssertEqual(platform.entityName, "ITUNES", "Incorrect Entity Name")
                case .youtube, .youtubeMusic:
                    XCTAssertEqual(platform.entityName, "YOUTUBE", "Incorrect Entity Name")
                case .google, .googleStore:
                    XCTAssertEqual(platform.entityName, "GOOGLE", "Incorrect Entity Name")
                case .pandora:
                    XCTAssertEqual(platform.entityName, "PANDORA", "Incorrect Entity Name")
                case .deezer:
                    XCTAssertEqual(platform.entityName, "DEEZER", "Incorrect Entity Name")
                case .tidal:
                    XCTAssertEqual(platform.entityName, "TIDAL", "Incorrect Entity Name")
                case .amazonStore, .amazonMusic:
                    XCTAssertEqual(platform.entityName, "AMAZON", "Incorrect Entity Name")
                case .soundcloud:
                    XCTAssertEqual(platform.entityName, "SOUNDCLOUD", "Incorrect Entity Name")
                case .napster:
                    XCTAssertEqual(platform.entityName, "NAPSTER", "Incorrect Entity Name")
                case .yandex:
                    XCTAssertEqual(platform.entityName, "YANDEX", "Incorrect Entity Name")
                case .spinrilla:
                    XCTAssertEqual(platform.entityName, "SPINRILLA", "Incorrect Entity Name")
                case .audius:
                    XCTAssertEqual(platform.entityName, "AUDIUS", "Incorrect Entity Name")
            }
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
