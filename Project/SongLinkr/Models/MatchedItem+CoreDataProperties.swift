//
//  MatchedItem+CoreDataProperties.swift
//  SongLinkr
//
//  Created by Harry Day on 10/07/2021
//  
//
//  Twitter: https://twitter.com/realharryday
//  Github: https://github.com/harryday123
//

//

import Foundation
import CoreData


extension MatchedItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MatchedItem> {
        return NSFetchRequest<MatchedItem>(entityName: "MatchedItem")
    }

    @NSManaged public var isShazamMatch: Bool
    @NSManaged public var mediaArtist: String?
    @NSManaged public var mediaArtworkURL: URL?
    @NSManaged public var mediaTitle: String?
    @NSManaged public var originURL: URL?
    @NSManaged public var timestamp: Date?

}
