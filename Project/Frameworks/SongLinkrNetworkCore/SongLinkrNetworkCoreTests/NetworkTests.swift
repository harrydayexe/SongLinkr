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
        sut = Network()
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
    
    func testFixDictionaries() {
//        Given
        let platforms: [Platform.RawValue : PlatformInfo] = [Platform.amazonMusic.rawValue : PlatformInfo(entityUniqueId: "amazonMusic", url: "https://song.link/testURL")]
        
        let response = SongLinkAPIResponse(entityUniqueId: "testID", userCountry: "US", pageUrl: "https://song.link", entitiesByUniqueId: ["":SongLinkAPIResponse.Entity()], linksByPlatform: platforms)
        
//        When
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
            DLError.unknownEntity
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

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
