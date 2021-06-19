//
//  NetworkTests.swift
//  SongLinkrTests
//
//  Created by Harry Day on 04/07/2020.
//

import XCTest
@testable import SongLinkrNetworkCore

class NetworkTests: XCTestCase {
    var sut: Network!

    override func setUp() {
        // Config for the session
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        
        let session = URLSession(configuration: config)
        
        sut = Network(session: session)
        
        super.setUp()
    }
    
    func testURLEncodeCorrectly() {
        // Given
        let queryURL1 = "https://youtu.be/QfnVrp2bPuE"
        let encoded1 = "https%3A//youtu.be/QfnVrp2bPuE"
        
        // When
        let testURL1 = Network.encodeURL(from: queryURL1)
        
        // Then
        XCTAssertEqual(testURL1, encoded1, "Percent Encoded Wrong")
    }
    
    func testFixDictionariesWithGoodResponse() {
        // Given
        let platforms: [Platform.RawValue : PlatformInfo] = [Platform.amazonMusic.rawValue : PlatformInfo(entityUniqueId: "amazonMusic", url: "https://song.link/testURL")]
        
        let response = SongLinkAPIResponse(entityUniqueId: "testID", userCountry: "US", pageUrl: "https://song.link", entitiesByUniqueId: ["":SongLinkAPIResponse.Entity()], linksByPlatform: platforms)
        
        // When
        let fixedArray = sut.fixDictionaries(response: response).sorted(by: { $0.id.rawValue < $1.id.rawValue })
        let targetArray = [PlatformLinks(id: Platform.amazonMusic, url: "https://song.link/testURL")]
        
        XCTAssertEqual(fixedArray, targetArray, "Array did not decode correctly")
    }
    
    func testFixDictionariesWithNilResponse() {
        // When
        let fixedArray = sut.fixDictionaries(response: nil).sorted(by: { $0.id.rawValue < $1.id.rawValue })
        let targetArray: [PlatformLinks] = []
        
        XCTAssertEqual(fixedArray, targetArray, "Array did not decode correctly")
    }
    
    func testFixDictionariesWithUnknownPlatform() {
        // Given
        let platforms: [Platform.RawValue : PlatformInfo] = [
            Platform.amazonMusic.rawValue : PlatformInfo(entityUniqueId: "amazonMusic", url: "https://song.link/testURL"),
            "Unknown Platform" : PlatformInfo(entityUniqueId: "unKnownEntityID", url: "https://song.link/testURL")
        ]
        
        let response = SongLinkAPIResponse(entityUniqueId: "testID", userCountry: "US", pageUrl: "https://song.link", entitiesByUniqueId: ["":SongLinkAPIResponse.Entity()], linksByPlatform: platforms)
        
        // When
        let fixedArray = sut.fixDictionaries(response: response).sorted(by: { $0.id.rawValue < $1.id.rawValue })
        let targetArray = [PlatformLinks(id: Platform.amazonMusic, url: "https://song.link/testURL")]
        
        XCTAssertEqual(fixedArray, targetArray, "Array did not decode correctly")
    }
    
    func testCreateErrorMessage() {
        typealias DLError = Network.DataLoaderError
        let errors: [DLError] = [
            DLError.invalidURL,
            DLError.network(DLError.invalidURL),
            DLError.decodingError(description: "Decoding Error"),
            DLError.serverSideWithReason(400, "Test Status"),
            DLError.serverSide(200),
            DLError.unknownItem,
            DLError.unknownEntity,
            DLError.unknownNetworkProblem
        ]
        
        for error in errors {
            let errorMessage = sut.createErrorMessage(from: error)
            switch error {
                case .invalidURL:
                    XCTAssertEqual(errorMessage.0, "Invalid URL", "Sorry that URL is not valid.")
                    XCTAssertEqual(errorMessage.1, "Sorry that URL is not valid.", "Incorrect body for error message")
                case .network(_):
                    XCTAssertEqual(errorMessage.0, "Network Error", "Sorry something went wrong whilst talking to the server. Please try again.")
                    XCTAssertEqual(errorMessage.1, "Sorry something went wrong whilst talking to the server. Please try again.", "Incorrect body for error message")
                case .decodingError(_):
                    XCTAssertEqual(errorMessage.0, "Decoding Error", "Sorry something went wrong whilst decoding the data received from the server. Please try again.")
                    XCTAssertEqual(errorMessage.1, "Sorry something went wrong whilst decoding the data received from the server. Please try again.", "Incorrect body for error message")
                case .serverSideWithReason(let code, let status):
                    XCTAssertEqual(errorMessage.0, "Something went wrong", "Incorrect title for error message")
                    XCTAssertEqual(errorMessage.1, "Sorry we're not quite sure what happened here. Received status code \(code) from the server with message: \(status)", "Incorrect body for error message")
                case .serverSide(let code):
                    XCTAssertEqual(errorMessage.0, "Something went wrong", "Incorrect title for error message")
                    XCTAssertEqual(errorMessage.1, "Sorry we're not quite sure what happened here. Received status code \(code) from the server", "Incorrect body for error message")
                case .unknownItem:
                    XCTAssertEqual(errorMessage.0, "Unknown Item", "Incorrect title for error message")
                    XCTAssertEqual(errorMessage.1, "Sorry the server couldn't find a song or album with that link. Please check your link and try again", "Incorrect body for error message")
                case .unknownEntity:
                    XCTAssertEqual(errorMessage.0, "Unknown Platform", "Incorrect title for error message")
                    XCTAssertEqual(errorMessage.1, "Sorry we couldn't recognise that platform. Check the supported list for more information on what platforms are supported and try again.", "Incorrect body for error message")
                case .unknownNetworkProblem:
                    XCTAssertEqual(errorMessage.0, "Unknown Network Problem", "Incorrect title for error message")
                    XCTAssertEqual(errorMessage.1, "Sorry an unkown network error occured. Please try again later.", "Incorrect body for error message")
            }
        }
    }
    
    func testRequestWith200Code() throws {
        // Expected response
        let expected = SongLinkAPIResponse(
            entityUniqueId: "TestEntity",
            userCountry: "US",
            pageUrl: "https://song.link/testURL",
            entitiesByUniqueId: [:],
            linksByPlatform: [:]
        )
        
        // json for stub
        let jsonData = Data("""
            {
              "entityUniqueId": "TestEntity",
              "userCountry": "US",
              "pageUrl": "https://song.link/testURL",
              "entitiesByUniqueId": {},
              "linksByPlatform": {}
            }
            """.utf8)
        

        URLProtocolStub.testURLs = [Endpoint.search(with: "Test-String").url : jsonData]
        URLProtocolStub.response = HTTPURLResponse(url: "https://song.link/testURL", statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
        
        let endpoint: Endpoint = .search(with: "Test-String")
        
        let response = try awaitOutput(sut.requestOld(from: endpoint))
        
        XCTAssertEqual(response, expected)
    }
    
    func testRequestWith404Code() throws {
        // json for stub
        let jsonData = Data("""
            {
              "statusCode": 404,
              "code": "could_not_fetch_entity_data"
            }
            """.utf8)
        

        URLProtocolStub.testURLs = [Endpoint.search(with: "Test-String").url : jsonData]
        URLProtocolStub.response = HTTPURLResponse(url: "https://song.link/testURL", statusCode: 404, httpVersion: "HTTP/1.1", headerFields: nil)
        
        let endpoint: Endpoint = .search(with: "Test-String")
        
        XCTAssertThrowsError(try awaitOutput(sut.requestOld(from: endpoint)))
    }
    
    func testRequestWith400Code() throws {
        // json for stub
        let jsonData = Data("""
            {
              "statusCode": 400,
              "code": "could_not_resolve_entity"
            }
            """.utf8)
        

        URLProtocolStub.testURLs = [Endpoint.search(with: "Test-String").url : jsonData]
        URLProtocolStub.response = HTTPURLResponse(url: "https://song.link/testURL", statusCode: 400, httpVersion: "HTTP/1.1", headerFields: nil)
        
        let endpoint: Endpoint = .search(with: "Test-String")
        
        XCTAssertThrowsError(try awaitOutput(sut.requestOld(from: endpoint)))
    }
    
    func testRequestWithRandomCode() throws {
        // json for stub
        let jsonData = Data("""
            {
              "statusCode": 407,
              "code": "random_test_reason"
            }
            """.utf8)
        

        URLProtocolStub.testURLs = [Endpoint.search(with: "Test-String").url : jsonData]
        URLProtocolStub.response = HTTPURLResponse(url: "https://song.link/testURL", statusCode: 407, httpVersion: "HTTP/1.1", headerFields: nil)
        
        let endpoint: Endpoint = .search(with: "Test-String")
        
        XCTAssertThrowsError(try awaitOutput(sut.requestOld(from: endpoint)))
    }
    
    func testRequestWithUndecodabeErrorResponse() throws {
        // json for stub
        let jsonData = Data("""
            {
              "testKey": 4828,
              "testKey2": "random_test_reason"
            }
            """.utf8)
        

        URLProtocolStub.testURLs = [Endpoint.search(with: "Test-String").url : jsonData]
        URLProtocolStub.response = HTTPURLResponse(url: "https://song.link/testURL", statusCode: 404, httpVersion: "HTTP/1.1", headerFields: nil)
        
        let endpoint: Endpoint = .search(with: "Test-String")
        
        XCTAssertThrowsError(try awaitOutput(sut.requestOld(from: endpoint)))
    }
    
    func testRequestWith500StatusCode() throws {
        // json for stub
        let jsonData = Data("""
            {
              "statusCode": 500,
              "code": "random_test_reason"
            }
            """.utf8)
        

        URLProtocolStub.testURLs = [Endpoint.search(with: "Test-String").url : jsonData]
        URLProtocolStub.response = HTTPURLResponse(url: "https://song.link/testURL", statusCode: 500, httpVersion: "HTTP/1.1", headerFields: nil)
        
        let endpoint: Endpoint = .search(with: "Test-String")
        
        XCTAssertThrowsError(try awaitOutput(sut.requestOld(from: endpoint)))
    }
    
    func testRequestWithUnknownStatusCode() throws {
        // json for stub
        let jsonData = Data("""
            {
              "statusCode": 700,
              "code": "random_test_reason"
            }
            """.utf8)
        

        URLProtocolStub.testURLs = [Endpoint.search(with: "Test-String").url : jsonData]
        URLProtocolStub.response = HTTPURLResponse(url: "https://song.link/testURL", statusCode: 700, httpVersion: "HTTP/1.1", headerFields: nil)
        
        let endpoint: Endpoint = .search(with: "Test-String")
        
        XCTAssertThrowsError(try awaitOutput(sut.requestOld(from: endpoint)))
    }
    
    func testRequestWithBadJSON() throws {
        // json for stub
        let jsonData = Data("""
            {
              "entityUniqueId": "SPOTIFY_SONG::0Jcij1eWd5bDMU5iPbxe2i",
              "usountry": "US",
              "pageUrl": "https://song.link/s/0Jcij1eWd5bDMU5iPbxe2i",
              "entitiesByUniqueId": {
                "YOUTUBE_VIDEO::w3LJ2bDvDJs": {
                  "id": "w3LJ2bDvDJs",
                  "type": "song",
                  "title": "Kitchen",
                  "artistName": "Kid Cudi - Topic",
                  "thumbnailUrl": "https://i.ytimg.com/vi/w3LJ2bDvDJs/hqdefault.jpg",
                  "thumbnailWidth": 480,
                  "thumbnailHeight": 360,
                  "apiProvider": "youtube",
                  "platforms": [
                    "youtube",
                    "youtubeMusic"
                  ]
                }
              },
              "linPlatform": {
                "youtube": {
                  "url": "https://www.youtube.com/watch?v=w3LJ2bDvDJs",
                  "entityUniqueId": "YOUTUBE_VIDEO::w3LJ2bDvDJs"
                },
                "youtubeMusic": {
                  "url": "https://music.youtube.com/watch?v=w3LJ2bDvDJs",
                  "entityUniqueId": "YOUTUBE_VIDEO::w3LJ2bDvDJs"
                }
              }
            }
            """.utf8)
        

        URLProtocolStub.testURLs = [Endpoint.search(with: "Test-String").url : jsonData]
        URLProtocolStub.response = HTTPURLResponse(url: "https://song.link/testURL", statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
        
        let endpoint: Endpoint = .search(with: "Test-String")
        
        XCTAssertThrowsError(try awaitOutput(sut.requestOld(from: endpoint)))
    }
    
    func testGetArtworkURL() {
        // Given
        let response = SongLinkAPIResponse(
            entityUniqueId: "TestID",
            userCountry: "US",
            pageUrl: "https://example.link/test",
            entitiesByUniqueId: [
                "Entity1" : Entity(
                    id: "Entity1",
                    title: "Song Name",
                    artistName: "Artist Name",
                    thumbnailUrl: "https://thumbnail.com/1",
                    thumbnailWidth: 500,
                    thumbnailHeight: 500,
                    apiProvider: .amazon,
                    platforms: [.amazonStore, .amazonMusic]
                ),
                "Entity3" : Entity(
                    id: "Entity3",
                    title: "Song Name",
                    artistName: "Artist Name",
                    thumbnailUrl: "https://thumbnail.com/3",
                    thumbnailWidth: 500,
                    thumbnailHeight: 500,
                    apiProvider: .pandora,
                    platforms: [.pandora]
                )
            ],
            linksByPlatform: [:]
        )
        
        // Expected
        let expectedURL: URL = "https://thumbnail.com/1"
        
        // Actual
        let actualResult = Network.getArtworkURL(from: response)!
        
        XCTAssertEqual(expectedURL, actualResult)
    }
    
    func testGetArtworkURLSameRank() {
        // Given
        let response = SongLinkAPIResponse(
            entityUniqueId: "TestID",
            userCountry: "US",
            pageUrl: "https://example.link/test",
            entitiesByUniqueId: [
                "SPOTIFY_SONG::0Jcij1eWd5bDMU5iPbxe2i" : Entity(
                    id: "0Jcij1eWd5bDMU5iPbxe2i",
                    title: "Song Name",
                    artistName: "Artist Name",
                    thumbnailUrl: "https://thumbnail.com/1",
                    thumbnailWidth: 500,
                    thumbnailHeight: 500,
                    apiProvider: .spotify,
                    platforms: [.spotify]
                ),
                "ITUNES_SONG::1440867832" : Entity(
                    id: "1440867832",
                    title: "Song Name",
                    artistName: "Artist Name",
                    thumbnailUrl: "https://thumbnail.com/2",
                    thumbnailWidth: 500,
                    thumbnailHeight: 500,
                    apiProvider: .itunes,
                    platforms: [.appleMusic, .itunes]
                )
            ],
            linksByPlatform: [:]
        )
        
        // Expected
        let expectedURL: URL = "https://thumbnail.com/2"
        
        // Actual
        let actualResult = Network.getArtworkURL(from: response)!
        
        XCTAssertEqual(expectedURL, actualResult)
    }
    
    func testGetArtworkURLisNil() {
        // Given
        let response = SongLinkAPIResponse(
            entityUniqueId: "TestID",
            userCountry: "US",
            pageUrl: "https://example.link/test",
            entitiesByUniqueId: [:],
            linksByPlatform: [:]
        )
        
        // Actual
        let actualResult = Network.getArtworkURL(from: response)
        
        XCTAssertNil(actualResult)
    }
    
    func testGetSongNameAndArtist() {
        // Given
        let response = SongLinkAPIResponse(
            entityUniqueId: "TestID",
            userCountry: "US",
            pageUrl: "https://example.link/test",
            entitiesByUniqueId: [
                "SPOTIFY_SONG::0Jcij1eWd5bDMU5iPbxe2i" : Entity(
                    id: "0Jcij1eWd5bDMU5iPbxe2i",
                    title: "Song Name",
                    artistName: "Artist Name",
                    thumbnailUrl: "https://thumbnail.com/1",
                    thumbnailWidth: 500,
                    thumbnailHeight: 500,
                    apiProvider: .spotify,
                    platforms: [.spotify]
                ),
                "ITUNES_SONG::1440867832" : Entity(
                    id: "1440867832",
                    title: "Song Name",
                    artistName: "Artist Name",
                    thumbnailUrl: "https://thumbnail.com/2",
                    thumbnailWidth: 500,
                    thumbnailHeight: 500,
                    apiProvider: .itunes,
                    platforms: [.appleMusic, .itunes]
                )
            ],
            linksByPlatform: [:]
        )
        
        XCTAssertEqual("Artist Name", Network.getSongNameAndArtist(from: response).0)
        XCTAssertEqual("Song Name", Network.getSongNameAndArtist(from: response).1)
    }
    
    func testGetSongNameAndArtistNil() {
        // Given
        let response = SongLinkAPIResponse(
            entityUniqueId: "TestID",
            userCountry: "US",
            pageUrl: "https://example.link/test",
            entitiesByUniqueId: [
                "SPOTIFY_SONG::0Jcij1eWd5bDMU5iPbxe2i" : Entity(
                    id: "0Jcij1eWd5bDMU5iPbxe2i",
                    thumbnailUrl: "https://thumbnail.com/1",
                    thumbnailWidth: 500,
                    thumbnailHeight: 500,
                    apiProvider: .spotify,
                    platforms: [.spotify]
                ),
                "ITUNES_SONG::1440867832" : Entity(
                    id: "1440867832",
                    thumbnailUrl: "https://thumbnail.com/2",
                    thumbnailWidth: 500,
                    thumbnailHeight: 500,
                    apiProvider: .itunes,
                    platforms: [.appleMusic, .itunes]
                )
            ],
            linksByPlatform: [:]
        )
        
        XCTAssertEqual(nil, Network.getSongNameAndArtist(from: response).0)
        XCTAssertEqual(nil, Network.getSongNameAndArtist(from: response).1)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
