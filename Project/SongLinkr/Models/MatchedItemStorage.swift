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
    
    // Singleton Instance
    static var shared: MatchedItemStorage = MatchedItemStorage()
    
    // Singleton Instance for a preview setup
    static var preview: MatchedItemStorage = MatchedItemStorage(persistenceController: .preview)
    
    /**
     Initialise a MatchedItemStorage with a specificed PersistenceController
    - Parameter persistenceController: The `PersistenceController` to use. Defaults to Shared
     */
    private init(persistenceController: PersistenceController = .shared) {
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
        } catch {
            print("Could not fetch objects")
        }
    }
}

extension MatchedItemStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let matchedItems = controller.fetchedObjects as? [MatchedItem] else { return }
        
        print("Updated Context, reloading now")
        
        self.matchedItems.value = matchedItems
    }
}
