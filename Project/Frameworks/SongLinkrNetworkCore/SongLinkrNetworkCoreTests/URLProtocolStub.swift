//
//  URLProtocolStub.swift
//  SongLinkrNetworkCore
//
//  Created by Harry Day on 09/06/2021
//  
//
//  Twitter: https://twitter.com/realharryday
//  Github: https://github.com/harryday123
//


import Foundation

/// A Stub for use with unit testing URLSession
class URLProtocolStub: URLProtocol {
    // this dictionary maps URLs to test data
    static var testURLs = [URL?: Data]()
    
    static var response = HTTPURLResponse(url: "https://songlinkr.harryday.xyz", statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
    
    // say we want to handle all types of request
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    // ignore this method; just send back what we were given
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        // if we have a valid URL…
        if let url = request.url {
            // …and if we have test data for that URL…
            if let data = URLProtocolStub.testURLs[url] {
                self.client?.urlProtocol(self, didReceive: URLProtocolStub.response!, cacheStoragePolicy: .notAllowed)
                // …load it immediately.
                self.client?.urlProtocol(self, didLoad: data)
            }
        }
        
        // mark that we've finished
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    // this method is required but doesn't need to do anything
    override func stopLoading() { }
}
