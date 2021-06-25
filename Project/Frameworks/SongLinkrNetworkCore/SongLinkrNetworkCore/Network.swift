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
    /// Singleton
    static public var shared = Network()
    
    /// The URL Session to use for the fetcher
    private let session: URLSession
    
    /**
     Initialise the Network object
     - Parameter session: The URLSession object to use. Default is `.shared`.
     */
    init(session: URLSession = .shared) {
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
    public func requestOld(
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
     Makes a request to the given `Endpoint`
     - parameter endpoint: The endpoint to access data from.
     - parameter session: The URLSession to be handed in. Default `URLSession.shared` in this case.
     - Throws: A `DataLoaderError`
     - Returns: A `SongLinkAPIResponse` with the relevant data received
     */
    public func request(
        from endpoint: Endpoint,
        with decoder: JSONDecoder = JSONDecoder()
    ) async throws -> SongLinkAPIResponse {
        // Create URL from Endpoint
        guard let url = endpoint.url else {
            throw DataLoaderError.invalidURL
        }
        
        // Create the request object
        let request = URLRequest(url: url)
        
        do {
            // Run the data task
            let data = try await self.retrieveData(with: request)
            // Decode the response
            let apiResponseObject = try decoder.decode(SongLinkAPIResponse.self, from: data)
            // Return
            return apiResponseObject
        } catch {
            // If the error has already been set
            if let error = error as? DataLoaderError {
                throw error
            } else if let error = error as? DecodingError {
                throw self.mapDecodingError(error: error)
            } else {
                // If not decoding then network
                throw DataLoaderError.network(error)
            }
        }
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
     This function is responsible for running the data task and returning the data received from the server
     - Parameter request: A `URLRequest` object which contains the URL to access the relevant API endpoint.
     - Returns: The Data downloaded from the server
     */
    private func retrieveData(with request: URLRequest) async throws -> Data {
        // Start the data task
        let (data, response) = try await URLSession.shared.data(for: request)
        
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
        
        return data
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
                
                // If same display rank or both missing
                if platformRankFirst ?? Int.max == platformRankSecond ?? Int.max {
                    return first.key < second.key
                // Else return the result of the comparison
                } else {
                    return platformRankFirst ?? Int.max < platformRankSecond ?? Int.max
                }
            }
            .map { $0.value }
        
        return entities.first?.thumbnailUrl
    }
    
    /**
     This function returns the song name and artist from a SongLinkAPIResponse.
      - Parameter response: The `SongLinkAPIResponse` to get results from
      - Returns: A tuple with the first string being the artist name and the second string being the song name
     */
    public static func getSongNameAndArtist(from response: SongLinkAPIResponse) -> (String?, String?) {
        // Get entities with song names and artists in
        let entitiesDict = response.entitiesByUniqueId.filter { entity in
            guard let _ = entity.value.artistName, let _ = entity.value.title else {
                return false
            }
            return true
        }
        
        // Get the artist names excluding any from youtube
        let artistNames = entitiesDict.values.filter { entity in
            entity.platforms.contains { !($0 == .youtube || $0 == .youtubeMusic) }
        }.reduce([APIProvider : String]()) { (dict, entity) in
            var dict = dict
            dict[entity.apiProvider] = entity.artistName
            return dict
        }
                                              
        // Get the song names and API Provider
        let songTitles = entitiesDict.values.reduce([APIProvider : String]()) { dict, entity in
            var dict = dict
            dict[entity.apiProvider] = entity.title
            return dict
        }
        
        // Remove duplicates from each dictionary
        let uniqueArtistNames = removeDuplicates(fromDict: artistNames)
        let uniquesongTitles = removeDuplicates(fromDict: songTitles)
        
        var decidedArtistName: String?
        var decidedSongName: String?

        // If both arrays only have one item (best case scenario as every platform is in agreement)
        if uniqueArtistNames.count == 1 {
            decidedArtistName = uniqueArtistNames.values.first!
        } else if uniqueArtistNames.count > 1 {
            decidedArtistName = uniqueArtistNames.sorted(by: { $0.key.informationRanking < $1.key.informationRanking }).first?.value
        }
        
        if uniquesongTitles.count == 1 {
            decidedSongName = uniquesongTitles.values.first!
        } else if uniquesongTitles.count > 1 {
            decidedSongName = uniquesongTitles.sorted(by: { $0.key.informationRanking < $1.key.informationRanking }).first?.value
        }
        
        return (decidedArtistName, decidedSongName)
    }
    
    /**
     This function removes duplicates from any dictionary
     - Parameter dict: The input dictionary to remove duplicate values from
     - Returns: The same dictionary with duplicates removed
     */
    private static func removeDuplicates(fromDict dict: Dictionary<APIProvider, String>) -> Dictionary<APIProvider, String> {
        let sourceDict = dict.sorted(by: { $0.key.informationRanking < $1.key.informationRanking })
        
        var uniqueValues = Set<String>()
        var resultDict = [APIProvider : String](minimumCapacity: dict.count)
        
        for (key, value) in sourceDict {
          if !uniqueValues.contains(value) {
            uniqueValues.insert(value)
            resultDict[key] = value
          }
        }
        
        return resultDict
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

extension Network.DataLoaderError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .network(let error):
                return String(
                    localized: "Something went wrong while communicating to the server: \(error.localizedDescription)",
                    comment: "Error message: Variable is a autogenerated description of the error"
                )
                
            case .serverSideWithReason(let code, let status):
                return String(
                    localized: "An error occurred on the server. Received status code \(code) from the server with message: \(status)",
                    comment: "Error message: First variable is the status code and second is a short message"
                )
                
            case .serverSide(let code):
                return String(
                    localized: "An error occurred on the server. Received status code \(code) from the server",
                    comment: "Error message: Variable is a status code"
                )
                
            case .decodingError(let description):
                return String(
                    localized: "An error occurred whilst decoding the server response: \(description)",
                    comment: "Error message: Variable is a description of the error"
                )

            case .invalidURL:
                return String(
                    localized: "The URL is not valid.",
                    comment: "Error message"
                )

            case .unknownEntity:
                return String(
                    localized: "Platform not recognised. Check the list of supported platforms for more information.",
                    comment: "Error message"
                )

            case .unknownItem:
                return String(
                    localized: "No match found. Please check your link and try again",
                    comment: "Error message: No matches could be found for the link to a song/album given"
                )
                
            case .unknownNetworkProblem:
                return String(
                    localized: "Sorry, an unkown network error occured.",
                    comment: "Error message"
                )
        }
    }
}
