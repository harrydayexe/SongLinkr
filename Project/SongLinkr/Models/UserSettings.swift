//
//  UserSettings.swift
//  SongLinkr
//
//  Created by Harry Day on 19/07/2020.
//

import Foundation
import Combine
import SwiftUI

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
    
    init() {
        let defaultPlatform = UserDefaults.standard.object(forKey: "defaultPlatform") as? String ?? Platform.youtube.rawValue
        self.defaultPlatform = Platform(rawValue: defaultPlatform)!
        self.autoOpen = UserDefaults.standard.object(forKey: "autoOpen") as? Bool ?? false
    }
}
