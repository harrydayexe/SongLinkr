//
//  ColorManager.swift
//  SongLinkr
//
//  Created by Harry Day on 06/07/2020.
//

import Foundation
import SwiftUI

extension Color {
    /// This is a gradient of the iTunes Store colours from top to bottom. use with a `LinearGradient` from top to bottom.
    static let itunesColor1 = Color(red: 234/255, green: 76/255, blue: 192/255)
    static let itunesColor2 = Color(red: 217/255, green: 72/255, blue: 221/255)
    static let itunesColor3 = Color(red: 204/255, green: 69/255, blue: 242/255)
    
    /// This is the Pandora Blue
    static let pandoraBlue = Color(red: 0/255, green: 160/255, blue: 238/255)
    
    /// This is the Amazon Prime Blue
    static let amazonBlue = Color(red: 0, green: 168/255, blue: 225/255)
    
    /// This is the Amazon Orange Color
    static let amazonOrange = Color(red: 255/255, green: 153/255, blue: 0)
    
    /// The Soundcloud Orange Color
    static let soundcloudOrange = Color(red: 254/255, green: 80/255, blue: 0)
    
    /// The Napster Yellow
    static let napsterYellow = Color(red: 253/255, green: 184/255, blue: 19/255)
    
    /// The Spinrilla purple
    static let spinrillaPurple = Color(red: 64/255, green: 14/255, blue: 83/255)
    
    /// This is the Audiomack color asset.
    static let audiomackColour = Color(red: 255/255, green: 162/255, blue: 0/255)
    
    /// The Spotify Brand Green color.
    static let spotifyGreen = Color(red: 30/255, green: 215/255, blue: 96/255)
    
    /// The Audius color
    static let audiusColour = Color(UIColor { traits in
        switch traits.userInterfaceStyle {
        case .dark:
            return UIColor(red: 73/255, green: 11/255, blue: 122/255, alpha: 1)
        default:
            return UIColor(red: 253/255, green: 243/255, blue: 252/255, alpha: 1)
        }
    })
    
    /// The YouTube Red brand colour.
    static let youtubeColour = Color(red: 255/255, green: 0/255, blue: 51/255)
}

extension Gradient {
    /// This is the Apple Music background gradient
    static let appleMusicGrad = Gradient(colors: [
        Color(red: 250/255, green: 87/255, blue: 193/255),
        Color(red: 177/255, green: 102/255, blue: 204/255)
    ])
    
    /// This is the deezer Linear Gradient
    static let deezerGrad = Gradient(colors: [
        Color(red: 254/255, green: 171/255, blue: 46/255),
        Color(red: 216/255, green: 27/255, blue: 96/255)
    ])

    static let orangeGradient = Gradient(colors: [Color(red: 1, green: 0.70, blue: 0.25),
                                                  Color(red: 1, green: 0.54, blue: 0.00)])
}
