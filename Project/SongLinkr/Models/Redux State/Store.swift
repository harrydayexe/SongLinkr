//
//  Store.swift
//  SongLinkr
//
//  Created by Harry Day on 18/04/2021.
//

import Foundation
import Combine

/**
 Reducer is a function that takes current state, applies Action to the state, and generates a new state.
 This should be the only thing that mutates the app's state.
 */
typealias Reducer<State, Action, Environment> = (inout State, Action, Environment) -> AnyPublisher<Action, Never>?

/**
 This object stores the entire app's state in the enviroment.
 Access directly to the state is read only and mutation can be done through the use of reducers.
 */
final class Store<State, Action, Environment>: ObservableObject {
    /// The state of the app
    @Published private(set) var state: State

    /// The environment to run actions in
    private let environment: Environment
    
    /// The reducer to use on actions
    private let reducer: Reducer<State, Action, Environment>
    
    /// The combine tokens to store
    private var effectCancellables: Set<AnyCancellable> = []

    /**
     Initialises the Store
     - Parameters:
        - initialState: The app's state
        - reducer: The reducer to use to process actions and mutate the state
        - environment: The environment to run reducers in. This could contain any API's etc.
     */
    init(
        initialState: State,
        reducer: @escaping Reducer<State, Action, Environment>,
        environment: Environment
    ) {
        self.state = initialState
        self.reducer = reducer
        self.environment = environment
    }
    
    /**
     Modify the state by calling an action on the store
     - Parameter action: The action to perform
     */
    func send(_ action: Action) {
        // Create a reducer
        guard let effect = reducer(&state, action, environment) else {
            return
        }

        effect
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: send)
            .store(in: &effectCancellables)
    }
}
