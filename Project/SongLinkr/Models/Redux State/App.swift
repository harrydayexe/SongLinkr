//
//  App.swift
//  SongLinkr
//
//  Created by Harry Day on 18/04/2021.
//

import Foundation
import Combine

/// A typealias for the Store Observable Object
typealias AppStore = Store<AppState, AppAction, World>

/// Any extra services and API's needed
struct World {
    /// The networking layer
    var network = Network()
}

// MARK: App Action
/// Actions that affect the app state
enum AppAction {
    case setSearchResults(with: [PlatformLinks])
    case getSearchResults(from: Endpoint)
    case fixDictionary(on: NilWrapper<SongLinkAPIResponse>)
    case setErrorDescription(withErrorDescription: (String, String))
}

// MARK: App State
/// The current state of the app
struct AppState {
    /// The search results to be displayed on the results modal
    var searchResults: [PlatformLinks] = []
    
    /// The description of an error to be shown
    var errorDescription: (String, String)?
}

// MARK: App Reducer
/**
 Reduce AppActions into mutations of state
 - Parameters:
     - state: The current state of the app. This is an inout variable to mutate the state in place
     - action: The action to reduce
     - environment: The environment to run the action in. This will normally include services like an API
 */
func appReducer(
    state: inout AppState,
    action: AppAction,
    environment: World
) -> AnyPublisher<AppAction, Never> {
    var errorTemp: (String, String) = ("", "")
    
    switch action {
        case .setSearchResults(with: let platformLinks):
            state.searchResults = platformLinks
        
        case .fixDictionary(on: let apiResponse):
            guard apiResponse.isNil == false, let response = apiResponse.object else {
                return Just(AppAction.setSearchResults(with: [])).eraseToAnyPublisher()
            }
            return Just(AppAction.setSearchResults(with: environment.network.fixDictionaries(response: response))).eraseToAnyPublisher()
            
        case .setErrorDescription(withErrorDescription: let errorDescription):
            state.errorDescription = errorDescription
            
        case .getSearchResults(from: let endpoint):
            return environment.network
                .request(from: endpoint)
                .map({ (response) in
                    return AppAction.fixDictionary(on: NilWrapper<SongLinkAPIResponse>(object: response))
                })
                .mapError({ (error) -> Error in
                    errorTemp = environment.network.createErrorMessage(from: error)
                    return error
                })
                .replaceError(with: AppAction.setErrorDescription(withErrorDescription: errorTemp))
                .eraseToAnyPublisher()
                
    }
    return Empty().eraseToAnyPublisher()
}

/// A Wrapper
struct NilWrapper<Object> {
    var isNil: Bool
    var object: Object? = nil
    
    init(object: Object) {
        self.isNil = false
        self.object = object
    }
    
    init() {
        self.isNil = true
    }
}
