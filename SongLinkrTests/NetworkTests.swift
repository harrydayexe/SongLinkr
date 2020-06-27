//
//  SongLinkrTests.swift
//  SongLinkrTests
//
//  Created by Harry Day on 26/06/2020.
//

import XCTest
@testable import SongLinkr

class NetworkTests: XCTestCase {
    
    private var session: URLSessionMock!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        session = URLSessionMock()
    }
    
    func testInvalidURLReturnsNil() {
        // Given
        let endpoint: Endpoint = Endpoint(
            path: "v1-alpha.1/links",
            queryItems: [
                URLQueryItem(name: "url", value: "https%3A//youtu.be/QfnVrp2bPuE")
            ]
        )
        let error = Network.DataLoaderError.invalidURL
        self.session.error = error
        
        // When
        Network.request(endpoint, session: session) { result in
            switch result {
                case .success(_):
                    XCTFail("Should not be able to perform a data task with an incorrect url")
                case .failure(let error):
                    XCTAssertTrue(error is Network.DataLoaderError, "Unexpected error type")
            }
        }
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
    
    func testURLReceived() {
        // Create data and tell session to always return it
        let data = Data([0, 1, 0, 1])
        self.session.data = data
        
        let testURLString = "testurlstring"
        
        Network.request(.search(with: testURLString), session: session) { result in
            XCTAssert(self.session.url == URL(string: "https://api.song.link/v1-alpha.1/links?url=\(testURLString)"))
        }
    }
    
    func testSuccessfulResponse() {
        // Create data and tell session to always return it
        let data = Data([0, 1, 0, 1])
        self.session.data = data
        let testURLString = "testurlstring"
        
        Network.request(.search(with: testURLString), session: session) { result in
            switch result {
                case .success(let data):
                    XCTAssertEqual(data, Data([0, 1, 0, 1]))
                case .failure(_):
                    XCTFail("Should not reach this point")
            }
        }
    }
    
    func testBadResponse() {
        let error = Network.DataLoaderError.invalidURL
        self.session.error = error
        let testURLString = "testurlstring"
        
        Network.request(.search(with: testURLString), session: session) { result in
            switch result {
                case .success(_):
                    XCTFail("Should not reach this point")
                case .failure(let error):
                    XCTAssertTrue(error is Network.DataLoaderError, "Unexpected error type")
            }
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        session = nil
        super.tearDown()
    }
}


// We create a partial mock by subclassing the original class
class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    // We override the 'resume' method and simply call our closure
    // instead of actually resuming any task.
    override func resume() {
        closure()
    }
}


class URLSessionMock: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    // Properties that enable us to set exactly what data or error we want our mocked URLSession to return for any request.
    var data: Data?
    var error: Error?
    var url: URL?
    
    
    override func dataTask(with url: URL, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        self.url = url
        
        return URLSessionDataTaskMock {
            completionHandler(data, nil, error)
        }
    }
}
