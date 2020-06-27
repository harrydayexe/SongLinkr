//
//  SongLinkAPIResponseTests.swift
//  SongLinkrTests
//
//  Created by Harry Day on 27/06/2020.
//

import XCTest
@testable import SongLinkr

class SongLinkAPIResponseTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }
    
    func testDecodeGoodData() {
        // Given
        let amazon = SongLinkAPIResponse.Entity(id: "B081QMVJ42", type: SongLinkAPIResponse.MusicType.song, title: "Angst", artistName: "Inzo", thumbnailUrl: URL(string: "https://m.media-amazon.com/images/I/51aEjxYscCL._AA500.jpg"), thumbnailWidth: 500, thumbnailHeight: 500, apiProvider: SongLinkAPIResponse.APIProvider.amazon, platforms: [SongLinkAPIResponse.Platform.amazonMusic, SongLinkAPIResponse.Platform.amazonStore])
        
        let youtube = SongLinkAPIResponse.Entity(id: "QfnVrp2bPuE", type: SongLinkAPIResponse.MusicType.song, title: "INZO - Angst", artistName: "Lowly.", thumbnailUrl: URL(string: "https://i.ytimg.com/vi/QfnVrp2bPuE/hqdefault.jpg"), thumbnailWidth: 480, thumbnailHeight: 360, apiProvider: SongLinkAPIResponse.APIProvider.youtube, platforms: [SongLinkAPIResponse.Platform.youtube, SongLinkAPIResponse.Platform.youtubeMusic])
        
        let amazonMusic = SongLinkAPIResponse.PlatformInfo(entityUniqueId: "AMAZON_SONG::B081QMVJ42", url: URL(string: "https://music.amazon.com/albums/B081QNFXHB?trackAsin=B081QMVJ42&do=play")!)
        
        let amazonStore = SongLinkAPIResponse.PlatformInfo(entityUniqueId: "AMAZON_SONG::B081QMVJ42", url: URL(string: "https://amazon.com/dp/B081QMVJ42?tag=songlink0d-20")!)
        
        let youtubePlatform = SongLinkAPIResponse.PlatformInfo(entityUniqueId: "YOUTUBE_VIDEO::QfnVrp2bPuE", url: URL(string: "https://www.youtube.com/watch?v=QfnVrp2bPuE")!)
        
        let youtubeMusic = SongLinkAPIResponse.PlatformInfo(entityUniqueId: "YOUTUBE_VIDEO::QfnVrp2bPuE", url: URL(string: "https://music.youtube.com/watch?v=QfnVrp2bPuE")!)
        
        let target = SongLinkAPIResponse(entityUniqueId: "YOUTUBE_VIDEO::QfnVrp2bPuE", userCountry: "US", pageUrl: URL(string: "https://song.link/y/QfnVrp2bPuE")!, entitiesByUniqueId: ["AMAZON_SONG::B081QMVJ42":amazon, "YOUTUBE_VIDEO::QfnVrp2bPuE":youtube], linksByPlatform: [SongLinkAPIResponse.Platform.amazonMusic.rawValue:amazonMusic, SongLinkAPIResponse.Platform.amazonStore.rawValue:amazonStore, SongLinkAPIResponse.Platform.youtube.rawValue:youtubePlatform, SongLinkAPIResponse.Platform.youtubeMusic.rawValue:youtubeMusic])


        do {
            let response = try SongLinkAPIResponse(data: goodJSON)
            XCTAssertEqual(response, target, "Did not decode correctly")
        } catch {
            XCTFail("Should not fail with this JSON input")
        }
    }
    
    func testDecodeGoodJSONBadData() {
        XCTAssertThrowsError(try SongLinkAPIResponse(data: goodJSONbadData)) { error in
            XCTAssertTrue(error is Network.DataLoaderError, "Unexpected error type")
        }
    }
    
    func testDecodeBadJSON() {
        XCTAssertThrowsError(try SongLinkAPIResponse(data: goodJSONbadData)) { error in
            XCTAssertTrue(error is Network.DataLoaderError, "Unexpected error type")
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}

private let goodJSON = Data("""
                {
                  "entityUniqueId": "YOUTUBE_VIDEO::QfnVrp2bPuE",
                  "userCountry": "US",
                  "pageUrl": "https://song.link/y/QfnVrp2bPuE",
                  "entitiesByUniqueId": {
                    "AMAZON_SONG::B081QMVJ42": {
                      "id": "B081QMVJ42",
                      "type": "song",
                      "title": "Angst",
                      "artistName": "Inzo",
                      "thumbnailUrl": "https://m.media-amazon.com/images/I/51aEjxYscCL._AA500.jpg",
                      "thumbnailWidth": 500,
                      "thumbnailHeight": 500,
                      "apiProvider": "amazon",
                      "platforms": [
                        "amazonMusic",
                        "amazonStore"
                      ]
                    },
                    "YOUTUBE_VIDEO::QfnVrp2bPuE": {
                      "id": "QfnVrp2bPuE",
                      "type": "song",
                      "title": "INZO - Angst",
                      "artistName": "Lowly.",
                      "thumbnailUrl": "https://i.ytimg.com/vi/QfnVrp2bPuE/hqdefault.jpg",
                      "thumbnailWidth": 480,
                      "thumbnailHeight": 360,
                      "apiProvider": "youtube",
                      "platforms": [
                        "youtube",
                        "youtubeMusic"
                      ]
                    }
                  },
                  "linksByPlatform": {
                    "amazonMusic": {
                      "url": "https://music.amazon.com/albums/B081QNFXHB?trackAsin=B081QMVJ42&do=play",
                      "entityUniqueId": "AMAZON_SONG::B081QMVJ42"
                    },
                    "amazonStore": {
                      "url": "https://amazon.com/dp/B081QMVJ42?tag=songlink0d-20",
                      "entityUniqueId": "AMAZON_SONG::B081QMVJ42"
                    },
                    "youtube": {
                      "url": "https://www.youtube.com/watch?v=QfnVrp2bPuE",
                      "entityUniqueId": "YOUTUBE_VIDEO::QfnVrp2bPuE"
                    },
                    "youtubeMusic": {
                      "url": "https://music.youtube.com/watch?v=QfnVrp2bPuE",
                      "entityUniqueId": "YOUTUBE_VIDEO::QfnVrp2bPuE"
                    }
                  }
                }
""".utf8)
private let goodJSONbadData = Data("""
                {
                  "entityUniqueId": "YOUTUBE_VIDEO::QfnVrp2bPuE",
                  "userCountry": "US",
                  "pageUrl": "https://song.link/y/QfnVrp2bPuE",
                  "entitiesByUniqueId": {
                    "AMAZON_SONG::B081QMVJ42": {
                      "id": "B081QMVJ42",
                      "type": "song",
                      "title": "Angst",
                      "artistName": "Inzo",
                      "thumbnailUrl": "https://m.media-amazon.com/images/I/51aEjxYscCL._AA500.jpg",
                      "thumbnailWidth": 500,
                      "thumbnailHeight": 500,
                      "apiProvider": "amazon",
                      "platforms": [
                        "amazonMusic",
                        "amazonStore"
                      ]
                    },
                    "YOUTUBE_VIDEO::QfnVrp2bPuE": {
                      "id": "QfnVrp2bPuE",
                      "title": "INZO - Angst",
                      "artistName": "Lowly.",
                      "thumbnailUrl": "https://i.ytimg.com/vi/QfnVrp2bPuE/hqdefault.jpg",
                      "thumbnailWidth": 480,
                      "thumbnailHeight": 360,
                      "apiProvider": "youtube",
                      "platforms": [
                        "youtube",
                        "youtubeMusic"
                      ]
                    }
                  },
                  "linksByPlatform": {
                    "amazonMusic": {
                      "url": "https://music.amazon.com/albums/B081QNFXHB?trackAsin=B081QMVJ42&do=play"
                    },
                    "amazonStore": {
                      "url": "https://amazon.com/dp/B081QMVJ42?tag=songlink0d-20",
                      "entityUniqueId": "AMAZON_SONG::B081QMVJ42"
                    },
                    "youtube": {
                      "url": "https://www.youtube.com/watch?v=QfnVrp2bPuE",
                      "entityUniqueId": "YOUTUBE_VIDEO::QfnVrp2bPuE"
                    },
                    "youtubeMusic": {
                      "url": "https://music.youtube.com/watch?v=QfnVrp2bPuE",
                      "entityUniqueId": "YOUTUBE_VIDEO::QfnVrp2bPuE"
                    }
                  }
                }
""".utf8)
private let badJSON = Data("""
                {
                  "entityUniqueId": "YOUTUBE_VIDEO::QfnVrp2bPuE",
                  "userCountry": "US",
                  "pageUrl": "https://song.link/y/QfnVrp2bPuE",
                  "entitiesByUniqueId": {
                    "AMAZON_SONG::B081QMVJ42": {
                      "id": "B081QMVJ42",
                      "type": "song",
                      "title": "Angst",
                      "artistName": "Inzo",
                      "thumbnailUrl": "https://m.media-amazon.com/images/I/51aEjxYscCL._AA500.jpg",
                      "thumbnailWidth": 500,
                      "thumbnailHeight": 500,
                      "apiProvider": "amazon",
                      "platforms": [
                        "amazonMusic",
                        "amazonStore"
                      ]
                    },
                    "YOUTUBE_VIDEO::QfnVrp2bPuE": {
                      "id": "QfnVrp2bPuE",
                      "type": "song",
                      "title": "INZO - Angst",
                      "artistName": "Lowly.",
                      "thumbnailUrl": "https://i.ytimg.com/vi/QfnVrp2bPuE/hqdefault.jpg",
                      "thumbnailWidth": 480,
                      "thumbnailHeight": 360,
                      "apiProvider": "youtube",
                      "platforms": [
                        "youtube",
                        "youtubeMusic"
                      ]
                    },
                 
                  "linksByPlatform": {
                    "amazonMusic": {
                      "url": "https://music.amazon.com/albums/B081QNFXHB?trackAsin=B081QMVJ42&do=play"
                    },
                    "amazonStore": {
                      "url": "https://amazon.com/dp/B081QMVJ42?tag=songlink0d-20",
                      "entityUniqueId": "AMAZON_SONG::B081QMVJ42"
                    },
                    "youtube": {
                      "url": "https://www.youtube.com/watch?v=QfnVrp2bPuE",
                      "entityUniqueId": "YOUTUBE_VIDEO::QfnVrp2bPuE"
                    },
                    "youtubeMusic": {
                      "url": "https://music.youtube.com/watch?v=QfnVrp2bPuE",
                      "entityUniqueId": "YOUTUBE_VIDEO::QfnVrp2bPuE"
                    }
                }
""".utf8)


