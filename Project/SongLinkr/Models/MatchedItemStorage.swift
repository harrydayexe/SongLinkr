//
//  MatchedItemStorage.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2021
//
//
//  Twitter: https://twitter.com/realharryday
//  Github: https://github.com/harryday123
//

import Combine
import CoreData
import Foundation

class MatchedItemStorage: NSObject, ObservableObject {
    var matchedItems = CurrentValueSubject<[MatchedItem], Never>([])
    private let matchedItemsFetchController: NSFetchedResultsController<MatchedItem>
    
    private var itemStore: [MatchedItem] = []

    /// Whether the initial fetch failed.
    ///
    /// When this is `true` an empty `matchedItems` means the store could not be
    /// read, not that there is no history to show. The fetched results
    /// controller never built a result set in that case, so this stays `true`
    /// for the lifetime of the instance.
    private(set) var loadFailed = false

    /// The persistence controller
    private let persistenceController: PersistenceController
    
    /// The view context
    private var viewContext: NSManagedObjectContext {
        persistenceController.container.viewContext
    }
    
    /// Singleton Instance
    static var shared: MatchedItemStorage = .init()
    
    /**
      Initialise a MatchedItemStorage with a specificed PersistenceController
     - Parameter persistenceController: The `PersistenceController` to use. Defaults to Shared
      */
    private init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
        
        let fetchRequest = MatchedItem.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: false)
        ]
        
        matchedItemsFetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: persistenceController.container.viewContext,
            sectionNameKeyPath: nil, cacheName: nil
        )
        
        super.init()
        
        matchedItemsFetchController.delegate = self
        
        do {
            try matchedItemsFetchController.performFetch()
            matchedItems.value = matchedItemsFetchController.fetchedObjects ?? []
            itemStore = matchedItemsFetchController.fetchedObjects ?? []
        } catch {
            // A failed fetch is non-fatal, but it is not recoverable either: the
            // controller has no result set and won't retry the fetch. Flag it so
            // the history can say it failed to load instead of showing its empty
            // state, which would claim the user has no history at all.
            loadFailed = true
            print("Could not fetch matched items: \(error.localizedDescription)")
        }
    }
    
    func add(isShazamMatch: Bool, mediaArtist: String?, mediaArtworkURL: URL?, mediaTitle: String?, originURL: URL?, timestamp: Date?) {
        let newItem = MatchedItem(context: self.viewContext)
        newItem.isShazamMatch = isShazamMatch
        newItem.mediaArtist = mediaArtist
        newItem.mediaArtworkURL = mediaArtworkURL
        newItem.mediaTitle = mediaTitle
        newItem.originURL = originURL
        newItem.timestamp = timestamp

        persist()
    }

    func delete(url: URL) {
        guard let object = itemStore.first(where: { $0.originURL == url }) else { return }
        viewContext.delete(object)
        persist()
    }

    /// Saves pending changes, discarding them if the save fails.
    ///
    /// The rollback matters for two reasons. A rejected insert or delete left
    /// pending would be retried by every later save and fail the same way,
    /// breaking all history writes for the rest of the session. It also keeps
    /// the UI honest: the fetched results controller has already reported the
    /// change, so reverting it puts the history back in step with the store
    /// rather than showing an item as added or deleted when it wasn't.
    private func persist() {
        do {
            try persistenceController.save()
        } catch {
            viewContext.rollback()
            print("Could not save history change: \(error.localizedDescription)")
        }
    }
}

extension MatchedItemStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let matchedItems = controller.fetchedObjects as? [MatchedItem] else { return }
        
        self.matchedItems.value = matchedItems
        self.itemStore = matchedItems
    }
}
