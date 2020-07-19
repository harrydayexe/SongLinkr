//
//  UserSettings.swift
//  SongLinkr
//
//  Created by Harry Day on 19/07/2020.
//

import Foundation
import Combine

class UserSettings: ObservableObject {
    @Published var defaultPlatform: Platform {
        didSet {
            UserDefaults.standard.set(defaultPlatform.rawValue, forKey: "defaultPlatform")
        }
    }
    
    init() {
        let defaultPlatform = UserDefaults.standard.object(forKey: "defaultPlatform") as? String ?? Platform.youtube.rawValue
        self.defaultPlatform = Platform(rawValue: defaultPlatform)!
    }
}
