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
import SongLinkrNetworkCore

@MainActor
class RequestViewModel: ObservableObject {
    /// The object to pass to results view
    @Published var resultsObject: ResultsModel?
    
    /// The description of an error to be shown
    @Published var errorDescription: (String, String)?
    
    /**
     The entity that the request originated from
     - Note: Used to decide if the origin platform was the default or not
     */
    @Published var originEntityID: String = ""
    
    /// The network to make requests through
    private let network: Network
    
    /**
     Create a `RequestViewModel` class
     - Parameter network: The network layer to use for retrieving results. Defaults to `Network()`
     */
    init(network: Network = Network()) {
        self.network = network
    }
    
    /**
     Generate an endpoint object for a given string input
     - Parameter input: The inputted URL (will be given as a string)
     - Returns: An `Endpoint` object to retrieve search results from
     */
    func generateEndpoint(with input: String) -> Endpoint {
        let encodedString = Network.encodeURL(from: input)
        return .search(with: encodedString)
    }
}
