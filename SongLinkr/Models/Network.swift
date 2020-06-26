//
//  Network.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import Foundation

/**
 The Network class contains networking utilities needed to make a request to the Song.Link API
 */
public final class Network {
    /**
     The DataLoaderError enum contains the possible error cases for errors that may be encountered when making a request
     */
    private enum DataLoaderError: Error {
        /**
         This error signifies that the URL failed to construct from the `Endpoint` struct
         */
        case invalidURL
        /**
         This error signifies that something went wrong when making the request. This could mean the API is down, there is no connection or something else. Read the `Error` associated value to find out more.
         */
        case network(Error)
    }

    /**
     This is used in the completion handler when making a request.
     */
    enum Result<Value> {
        /**
         This indicates the API was successfully accessed and contains the data inside the `Value` associated type.
         */
        case success(Value)
        /**
         This indicates a failure when making a request. Access the `Error` associated type to find out more.
         */
        case failure(Error)
    }

    static func encodeURL(from url: String) -> String {
        if let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
            return encodedURL
        } else {
            preconditionFailure("Failed to percent encode shared url")
        }
    }
    
    /**
     Makes a request to the given `Endpoint`
     
     - parameter endpoint: The endpoint to access data from.
     - parameter handler: The completion handler. This is an `@escaping` closure to deal with when you call the function.
     */
    static func request(_ endpoint: Endpoint, then handler: @escaping (Result<Data>) -> Void) {
        guard let url = endpoint.url else {
            return handler(.failure(DataLoaderError.invalidURL))
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            let result = data.map(Result.success) ?? .failure(DataLoaderError.network(error!))
            handler(result)
        }
        
        task.resume()
    }

}
