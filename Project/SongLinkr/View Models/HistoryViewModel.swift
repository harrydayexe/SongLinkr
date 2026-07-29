//
//  HistoryViewModel.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2021
//

import Combine
import Foundation

class HistoryViewModel: ObservableObject {
    /// The MatchItems found in CoreData
    @Published var pastMatchedItems: [MatchedItem] = []

    private var cancellable: AnyCancellable?
    private let itemStorage: MatchedItemStorage

    init(
        matchedItemPublisher: AnyPublisher<[MatchedItem], Never> = MatchedItemStorage.shared.matchedItems.eraseToAnyPublisher()
    ) {
        itemStorage = .shared

        cancellable = matchedItemPublisher.sink { [weak self] matchedItems in
            self?.pastMatchedItems = matchedItems
        }
    }

    func deleteShazamItem(at offsets: IndexSet) {
        let urlsToDelete = offsets.compactMap { pastMatchedItems.filter { $0.isShazamMatch }[$0].originURL }
        for url in urlsToDelete {
            itemStorage.delete(url: url)
        }
    }

    func deleteNonShazamItem(at offsets: IndexSet) {
        let urlsToDelete = offsets.compactMap { pastMatchedItems.filter { !$0.isShazamMatch }[$0].originURL }
        for url in urlsToDelete {
            itemStorage.delete(url: url)
        }
    }

    func deleteItem(with originURL: URL?) {
        guard let url = originURL else { return }
        itemStorage.delete(url: url)
    }
}
