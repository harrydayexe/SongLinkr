//
//  UserSettings.swift
//  SongLinkr
//
//  Created by Harry Day on 19/07/2020.
//

import Foundation
import Combine
import SwiftUI
import SongLinkrNetworkCore

/**
 Stores the users current preferences and saves them to UserDefaults
 */
class UserSettings: ObservableObject {
    @Published var defaultPlatform: Platform {
        didSet {
            UserDefaults.standard.set(defaultPlatform.rawValue, forKey: "defaultPlatform")
        }
    }
    
    @Published var autoOpen: Bool {
        didSet {
            UserDefaults.standard.set(autoOpen, forKey: "autoOpen")
        }
    }
    
    @Published var sortOption: SortOptions {
        didSet {
            UserDefaults.standard.set(sortOption.rawValue, forKey: "sortOption")
        }
    }
    
    @Published var defaultAtTop: Bool {
        didSet {
            UserDefaults.standard.set(defaultAtTop, forKey: "defaultAtTop")
        }
    }
    
    @Published var saveToShazamLibrary: Bool {
        didSet {
            UserDefaults.standard.set(saveToShazamLibrary, forKey: "saveToShazamLibrary")
        }
    }
    
    init() {
        let defaultPlatform = UserDefaults.standard.object(forKey: "defaultPlatform") as? String ?? Platform.youtube.rawValue
        self.defaultPlatform = Platform(rawValue: defaultPlatform) ?? Platform.youtube
        self.autoOpen = UserDefaults.standard.object(forKey: "autoOpen") as? Bool ?? false
        let sortOption = UserDefaults.standard.object(forKey: "sortOption") as? String ?? SortOptions.popularity.rawValue
        self.sortOption = SortOptions(rawValue: sortOption) ?? SortOptions.popularity
        self.defaultAtTop = UserDefaults.standard.object(forKey: "defaultAtTop") as? Bool ?? true
        self.saveToShazamLibrary = UserDefaults.standard.object(forKey: "saveToShazamLibrary") as? Bool ?? false
    }
    
    enum SortOptions: String, CaseIterable {
        case alphabetically = "Alphabetically"
        case popularity = "Popularity"
        
        var localisedName: String {
            switch self {
                case .alphabetically:
                    return String(localized: "Alphabetically", comment: "Platform Sort Option")
                case .popularity:
                    return String(localized: "Popularity", comment: "Platform Sort Option")
            }
        }
    }
}
