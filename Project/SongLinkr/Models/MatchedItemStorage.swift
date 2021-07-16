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


import Foundation
import Combine
import CoreData

class MatchedItemStorage: NSObject, ObservableObject {
    var matchedItems = CurrentValueSubject<[MatchedItem], Never>([])
    private let matchedItemsFetchController: NSFetchedResultsController<MatchedItem>
    
    private var itemStore: [MatchedItem] = []
    
    /// The persistence controller
    private let persistenceController: PersistenceController
    
    /// The view context
    private var viewContext: NSManagedObjectContext {
        persistenceController.container.viewContext
    }
    
    /// Singleton Instance
    static var shared: MatchedItemStorage = MatchedItemStorage()
    
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
            print("Could not fetch objects")
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
        
        persistenceController.save()
    }
    
    func delete(url: URL) {
        guard let object = itemStore.first(where: { $0.originURL == url }) else { return }
        viewContext.delete(object)
        print("in delete")
        persistenceController.save()
    }
}

extension MatchedItemStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let matchedItems = controller.fetchedObjects as? [MatchedItem] else { return }
        
        print("Updated Context, reloading now")
        
        self.matchedItems.value = matchedItems
        self.itemStore = matchedItems
    }
}
