//
//  RequestViewModel.swift
//  SongLinkr
//
//  Created by Harry Day on 19/06/2021
//  
//
//  Twitter: https://twitter.com/realharryday
//  Github: https://github.com/harryday123
//


import Foundation
import SwiftUI
import SongLinkrNetworkCore

@MainActor
class RequestViewModel: ObservableObject {
    /// The object to pass to results view
    @Published private(set) var resultsObject: ResultsModel?
    
    /// The description of an error to be shown
    @Published var errorDescription: (String, String)?
    
    /**
     The entity that the request originated from
     - Note: Used to decide if the origin platform was the default or not
     */
    @Published private(set) var originEntityID: String = ""
    
    /// The network to make requests through
    private let network: Network
    
    /**
     Declares whether to show the search results or not
        - Is true when `resultsObject` is not nil
        - When set to false, sets `resultsObject` to nil
     */
    var showResults: Binding<Bool> { Binding(
        get: {
            self.resultsObject != nil
        },
        set: { newValue in
            if !newValue {
                self.resultsObject = nil
            }
        }
        )
    }
    
    /**
     Create a `RequestViewModel` class
     - Parameter network: The network layer to use for retrieving results. Defaults to `Network()`
     */
    init(network: Network = Network()) {
        self.network = network
    }
    
    /**
     Retrieve the search results from the API, sort them and set them to the published property
     - Parameters:
        - searchString: The string the user has inputted
        - settings: The current `UserSettings` object
     */
    func getResults(for searchString: String, with settings: UserSettings) async {
        let endpoint = generateEndpoint(with: searchString)
        
        do {
            // Get response
            var results = try await makeRequest(with: endpoint)
            
            // Sort correctly
            if settings.sortOption == .popularity {
                results.response.sort(by: <)
            } else {
                results.response.sort {
                    $0.id.rawValue < $1.id.rawValue
                }
            }
            
            // Put default at top
            if settings.defaultAtTop {
                results.response.moveDefaultFirst(with: settings.defaultPlatform)
            }
            
            self.resultsObject = results
        } catch {
            // Catch errors
            // If dataloader error then decode it
            if error is Network.DataLoaderError {
                self.errorDescription = network.createErrorMessage(from: error as! Network.DataLoaderError)
            } else {
                self.errorDescription = ("Something went wrong", "Please try again. If the issue persists please send me an email from the settings page")
            }
        }
    }
    
    /**
     Generate an endpoint object for a given string input
     - Parameter input: The inputted URL (will be given as a string)
     - Returns: An `Endpoint` object to retrieve search results from
     */
    private func generateEndpoint(with input: String) -> Endpoint {
        let encodedString = Network.encodeURL(from: input)
        return .search(with: encodedString)
    }
    
    /**
     Make a request to the server with the specified endpoint
     - Parameter endpoint: The endpoint to request data from
     - Returns: A `ResultsModel` containing the response from the API
     */
    private func makeRequest(with endpoint: Endpoint) async throws -> ResultsModel {
        // Get response asynchronously from API
        let response = try await network.request(from: endpoint)
        
        // Get artwork URL and names
        let artworkURL = Network.getArtworkURL(from: response)
        let (artistName, mediaTitle) = Network.getSongNameAndArtist(from: response)
        
        // Set origin entity ID
        self.originEntityID = response.entityUniqueId
        
        // Fix Dictionaries
        let platformLinks = network.fixDictionaries(response: response)
        
        // Set the result
        return ResultsModel(
            artworkURL: artworkURL,
            mediaTitle: mediaTitle ?? "",
            artistName: artistName ?? "",
            response: platformLinks
        )
    }
}
