//
//  Network.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import Foundation
import Combine

/**
 The Network class contains networking utilities needed to make a request to the Song.Link API
 */
public final class Network {
    /// The URL Session to use for the fetcher
    private let session: URLSession
    
    /**
     Initialise the Network object
     - Parameter session: The URLSession object to use. Default is `.shared`.
     */
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    /**
     The DataLoaderError enum contains the possible error cases for errors that may be encountered when making a request
     */
    public enum DataLoaderError: Error {
        /**
         This error signifies that the URL failed to construct from the `Endpoint` struct
         */
        case invalidURL
        /**
         This error signifies that an unkown problem occured with no description
         */
        case unknownNetworkProblem
        /**
         This error signifies that something went wrong when making the request. This could mean the API is down, there is no connection or something else. Read the `Error` associated value to find out more.
         */
        case network(Error)
        /**
         This error signifies that something went wrong when trying to use the JSONDecoder to decode the received JSON into an object. The `String` associated type is the generated description of the error.
         */
        case decodingError(description: String)
        /**
         This error is thrown when the HTTPS Status Code is not in the `2xx` range. The `Int` value is the status code receieved and the `String` is the server supplied reason for failure
         */
        case serverSideWithReason(Int, String)
        /**
         This error is thrown when the HTTPS Status Code is not in the `2xx` range. The INT value is the status code receieved.
         */
        case serverSide(Int)
        /**
         This means the server understood the entity/platform of the link but could not find the actual item. This could be because of a missing character on an ID of a song for example.
         */
        case unknownItem
        /**
         This happens when the API cannot identify the platform or entity of the link.
         */
        case unknownEntity
    }

    /**
     This is used in the completion handler when making a request.
     */
    public enum Result<Value> {
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
    static public func encodeURL(from url: String) -> String {
        if let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
            return encodedURL
        } else {
            preconditionFailure("Failed to percent encode shared url. Check: https://stackoverflow.com/a/33558934/9682666 for more info")
        }
    }
    
    /**
     Makes a request to the given `Endpoint`
     
     - parameter endpoint: The endpoint to access data from.
     - parameter session: The URLSession to be handed in. Default `URLSession.shared` in this case.
     - parameter handler: The completion handler. This is an `@escaping` closure to deal with when you call the function.
     */
    public func request(
        from endpoint: Endpoint,
        with decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<SongLinkAPIResponse, DataLoaderError> {
        // Create URL from Endpoint
        guard let url = endpoint.url else {
            return Fail(error: DataLoaderError.invalidURL).eraseToAnyPublisher()
        }
        
        // Create the request object
        let request = URLRequest(url: url)
        
        // Get the publisher data from the server using the retrieveData function
        return self.retrieveData(with: request)
            // Try to decode into SongLinkAPIResponse
            .decode(type: SongLinkAPIResponse.self, decoder: decoder)
            // If there is an error, map it
            .mapError { error -> DataLoaderError in
                // If the error has already been set
                if let error = error as? DataLoaderError {
                    return error
                } else if let error = error as? DecodingError {
                    return self.mapDecodingError(error: error)
                } else {
                    // If not decoding then network
                    return DataLoaderError.network(error)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /**
     This function is responsible for running the data task and returning the data received from the server
     - Parameter endpoint: An `Endpoint` object which contains the URL to access the relevant API endpoint.
     - Returns: An `AnyPublisher` with output of data and a failure of DataloaderError
     */
    private func retrieveData(with request: URLRequest) -> AnyPublisher<Data, DataLoaderError> {
        // Start the data task publisher
        return URLSession.DataTaskPublisher(request: request, session: session)
            .tryMap { data, response in
                // Check the HTTP Response Code is 2xx
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    // Now find out what kind of error it is
                    // Check for 4xx first
                    if let httpResponse = response as? HTTPURLResponse, 400..<500 ~= httpResponse.statusCode {
                        if let detailedResponse = BadResponse(data: data) {
                            // Start to match against known responses and reasons
                            if (detailedResponse.code == "could not resolve entity") {
                                throw DataLoaderError.unknownEntity
                            } else if (detailedResponse.code == "could not fetch entity data") {
                                throw DataLoaderError.unknownItem
                            } else {
                                // Default for unknown error
                                throw DataLoaderError.serverSideWithReason(detailedResponse.statusCode, detailedResponse.code)
                            }
                        }
                        // If can't decode then just throw the status code
                        throw DataLoaderError.serverSide(httpResponse.statusCode)
                    // Now check for 5xx
                    } else if let httpResponse = response as? HTTPURLResponse, 500..<600 ~= httpResponse.statusCode {
                        throw DataLoaderError.serverSide(httpResponse.statusCode)
                    // Catch all if everything else fails
                    } else {
                        throw DataLoaderError.unknownNetworkProblem
                    }
                }
                
                // Everything is all good
                return data
            }
            // Map to a dataloader error if not already
            .mapError { error in
                if let error = error as? DataLoaderError {
                    return error
                } else {
                    return DataLoaderError.network(error)
                }
            }
            .eraseToAnyPublisher()
        
    }
    
    /**
     This function unpacks the data in a dictionary in `SongLinkAPIResponse` and returns an array of that data in the form of `[PlatformLinks]`. This is useful for when arrays are needed to dynamically generate UI.
     */
    public func fixDictionaries(response: SongLinkAPIResponse?) -> [PlatformLinks] {
        guard let response = response else {
            return []
        }
        
        var returnValue: [PlatformLinks] = []
        
        for platform in response.linksByPlatform {
            guard let platformType = Platform(rawValue: platform.key) else {
                continue
            }
            let platformValue = platform.value
            returnValue.append(
                PlatformLinks(
                    id: platformType,
                    url: platformValue.url,
                    nativeAppUriMobile: platformValue.nativeAppUriMobile,
                    nativeAppUriDesktop: platformValue.nativeAppUriDesktop
                )
            )
        }
        
        return returnValue
    }
    
    /**
     This function returns the best URL to the album artwork from a SongLinkAPIResponse.
     Each response object can have many different thumbnails based on the platform therefore this functions pulls the best fit
      - Parameter response: The `SongLinkAPIResponse` to get results from
      - Returns: An optional `URL` which directs to the artwork location
     */
    public static func getArtworkURL(from response: SongLinkAPIResponse) -> URL? {
        let entities = response.entitiesByUniqueId
            .sorted { first, second in
//                $0.platforms.map { $0.displayRank }.sorted(by: >) > $1.platforms.map { $0.displayRank }.sorted(by: >)
                let platformRankFirst = first.value.platforms.map { platform in
                    platform.displayRank
                }.min()
                
                let platformRankSecond = second.value.platforms.map { platform in
                    platform.displayRank
                }.min()
                
                print(platformRankFirst, platformRankSecond)
                
                // If same display rank or both missing
                if platformRankFirst ?? Int.max == platformRankSecond ?? Int.max {
                    return first.key < second.key
                // Else return the result of the comparison
                } else {
                    print("here")
                    return platformRankFirst ?? Int.max < platformRankSecond ?? Int.max
                }
            }
            .map { $0.value }
        
        return entities.first?.thumbnailUrl
    }
    
    /**
     This function takes a `DataLoaderError` as an input and returns the error message dictionary for an alert as an output
     - parameter dataLoaderError: The Error to generate a response for.
     - Returns: A tuple of two strings, the first being the title of the error and the second being the main description
     */
    public func createErrorMessage(from dataLoaderError: DataLoaderError) -> (String, String) {
        switch dataLoaderError {
            case .network(let error):
                print("Network Error")
                print(error.localizedDescription)
                return ("Network Error", "Sorry something went wrong whilst talking to the server. Please try again.")
                
            case .serverSideWithReason(let code, let status):
                print("Status Code: \(code), \(status)")
                return ("Something went wrong", "Sorry we're not quite sure what happened here. Received status code \(code) from the server with message: \(status)")
                
            case .serverSide(let code):
                print("Status Code: \(code)")
                return ("Something went wrong", "Sorry we're not quite sure what happened here. Received status code \(code) from the server")
                
            case .decodingError(let description):
                print("Decoding Error")
                print(description)
                return ("Decoding Error", "Sorry something went wrong whilst decoding the data received from the server. Please try again.")

            case .invalidURL:
                print("Invalid URL")
                return ("Invalid URL", "Sorry that URL is not valid.")

            case .unknownEntity:
                print("Unknown Entity")
                return ("Unknown Platform", "Sorry we couldn't recognise that platform. Check the supported list for more information on what platforms are supported and try again.")

            case .unknownItem:
                print("Unknown Item")
                return ("Unknown Item", "Sorry the server couldn't find a song or album with that link. Please check your link and try again")
                
            case .unknownNetworkProblem:
                print("Unknown Network Problem")
                return ("Unknown Network Problem", "Sorry an unkown network error occured. Please try again later.")
        }
    }
    
    /**
     Converts a `DecodingError` into a human readable string which describes the error.
     - parameter error: The `DecodingError` of which to convert
     - returns: A DatabaseError of type parsing with the relevant description
     */
    private func mapDecodingError(error: DecodingError) -> DataLoaderError {
        var errorToReport = error.localizedDescription
        switch error {
            case .dataCorrupted(let context):
                let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                errorToReport = "\(context.debugDescription) - (\(details))"
            case .keyNotFound(let key, let context):
                let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                errorToReport = "\(context.debugDescription) (key: \(key), \(details))"
            case .typeMismatch(let type, let context), .valueNotFound(let type, let context):
                let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                errorToReport = "\(context.debugDescription) (type: \(type), \(details))"
            @unknown default:
                break
        }
        // Return the formatted error as a parsing error
        print(errorToReport)
        return DataLoaderError.decodingError(description: errorToReport)
    }
}
