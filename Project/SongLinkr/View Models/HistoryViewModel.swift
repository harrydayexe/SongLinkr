//
//  HistoryViewModel.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2021
//  
//
//  Twitter: https://twitter.com/realharryday
//  Github: https://github.com/harryday123
//


import Foundation
import Combine

class HistoryViewModel: ObservableObject {
    /// The MatchItems found in CoreData
    @Published var pastMatchedItems: [MatchedItem] = []
    
    /// Store Combine tokens
    private var cancellable: AnyCancellable?
    
    /**
     Initialise a HistoryViewModel with an AnyPublisher for [MatchedItem]
     - Parameter matchedItemPublisher: The AnyPublisher which publishes [MatchedItem]
     */
    init(
        matchedItemPublisher: AnyPublisher<[MatchedItem], Never> = MatchedItemStorage.shared.matchedItems.eraseToAnyPublisher()
    ) {
        cancellable = matchedItemPublisher.sink { matchedItems in
            print("Updating pastMatchedItems")
            self.pastMatchedItems = matchedItems
        }
    }
}
