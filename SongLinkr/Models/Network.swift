//
//  Network.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import Foundation

class Network {
    private enum DataLoaderError: Error {
        case invalidURL
        case network(Error?)
    }

    enum Result<Value> {
        case success(Value)
        case failure(Error)
    }

    static func encodeURL(from url: String) -> String {
        if let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
            return encodedURL
        } else {
            preconditionFailure("Failed to percent encode shared url")
        }
    }
    
    static func request(_ endpoint: Endpoint, then handler: @escaping (Result<Data>) -> Void) {
        guard let url = endpoint.url else {
            return handler(.failure(DataLoaderError.invalidURL))
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            let result = data.map(Result.success) ?? .failure(DataLoaderError.network(error))
            handler(result)
        }
        
        task.resume()
    }

}
