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
    enum DataLoaderError: Error {
        /**
         This error signifies that the URL failed to construct from the `Endpoint` struct
         */
        case invalidURL
        /**
         This error signifies that something went wrong when making the request. This could mean the API is down, there is no connection or something else. Read the `Error` associated value to find out more.
         */
        case network(Error)
        /**
         This error signifies that something went wrong when trying to use the JSONDecoder to decode the received JSON into an object. The `Error` associated type is from the JSONDecoder and is normally of type `DecodingError`
         */
        case decodingError(Error)
        /**
         This error is thrown when the HTTPS Status Code is not in the `2xx` range. The `Int` value is the status code receieved and the `String` is the server supplied reason for failure
         */
        case serverSideWithReason(Int, String)
        /**
         This error is thrown when the HTTPS Status Code is not in the `2xx` range. The INT value is the status code receieved.
         */
        case serverSide(Int)
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
        case failure(DataLoaderError)
    }

    /**
     Percent Encodes a given URL ready to be used inside of an API request
     
     - parameter url: A string containing the URL to be percent encoded
     - returns: The percent encoded URL as a string
     */
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
     - parameter session: The URLSession to be handed in. Default `URLSession.shared` in this case.
     - parameter handler: The completion handler. This is an `@escaping` closure to deal with when you call the function.
     */
    static func request(_ endpoint: Endpoint, session: URLSession = .shared, then handler: @escaping (Result<Data>) -> Void) {
        guard let url = endpoint.url else {
            handler(Result.failure(DataLoaderError.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            let response = response as! HTTPURLResponse
            let status = response.statusCode
            
            
//            No Response, timeout etc etc.
            if let error = error {
                handler(Result.failure(DataLoaderError.network(error)))
                return
            }
//            Status code not in the 2xx range and therefore a 4xx or 5xx indicating bad URL or server problems etc.
            guard (200...299).contains(status) else {
                if let detailedResponse = BadResponse(data: data!) {
                    handler(Result.failure(DataLoaderError.serverSideWithReason(detailedResponse.statusCode, detailedResponse.code)))
                    return
                } else {
                    handler(Result.failure(DataLoaderError.serverSide(status)))
                    return
                }
            }
            
//            Getting to this point means the data is there and correct
            handler(Result.success(data!))
            return
        }
        
        task.resume()
    }
    
    static func fixDictionaries(response: SongLinkAPIResponse) -> [PlatformLinks] {
        var returnValue: [PlatformLinks] = []
        
        for platform in response.linksByPlatform {
            let platformValue = platform.value
            returnValue.append(
                PlatformLinks(
                    id: platform.key,
                    url: platformValue.url,
                    nativeAppUriMobile: platformValue.nativeAppUriMobile,
                    nativeAppUriDesktop: platformValue.nativeAppUriDesktop
                )
            )
        }
        
        return returnValue
    }
}
