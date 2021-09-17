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
    
    /// Matched Item Storage
    private let itemStorage: MatchedItemStorage
    
    /**
     Initialise a HistoryViewModel with an AnyPublisher for [MatchedItem]
     - Parameter matchedItemPublisher: The AnyPublisher which publishes [MatchedItem]
     */
    init(
        matchedItemPublisher: AnyPublisher<[MatchedItem], Never> = MatchedItemStorage.shared.matchedItems.eraseToAnyPublisher()
    ) {
        itemStorage = .shared
        
        cancellable = matchedItemPublisher.sink { matchedItems in
            print("Updating pastMatchedItems")
            self.pastMatchedItems = matchedItems
        }
    }
    
    func deleteShazamItem(at offsets: IndexSet) {
        // Get the URLs to delete
        let urlsToDelete = offsets.compactMap { self.pastMatchedItems.filter({ $0.isShazamMatch })[$0].originURL }
        
        for url in urlsToDelete {
            itemStorage.delete(url: url)
        }
    }
    
    func deleteNonShazamItem(at offsets: IndexSet) {
        // Get the URLs to delete
        let urlsToDelete = offsets.compactMap { self.pastMatchedItems.filter({ !$0.isShazamMatch })[$0].originURL }
        
        for url in urlsToDelete {
            itemStorage.delete(url: url)
        }
    }
    
    func deleteItem(with originURL: URL?) {
        guard let url = originURL else {
            print("Could not delete")
            return
        }
        
        itemStorage.delete(url: url)
    }
}
