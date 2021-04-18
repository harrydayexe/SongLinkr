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
    case searchSong(urlString: String)
}

// MARK: App State
/// The current state of the app
struct AppState {
    /// The search results to be displayed on the results modal
    var searchResults: [PlatformLinks] = []
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
    switch action {
        case let .searchSong(urlString):
            print(urlString)
    }
    return Empty().eraseToAnyPublisher()
}
