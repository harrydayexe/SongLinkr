//
//  ColorManager.swift
//  SongLinkr
//
//  Created by Harry Day on 06/07/2020.
//

import Foundation
import SwiftUI

/**
 This object provides type safe, predefined colors to use
 */
struct ColorManager {
    /**
     This is a gradient of the iTunes Store colours from top to bottom. use with a `LinearGradient` from top to bottom.
     */
    static let itunesGrad = Gradient(colors: [
        Color(red: 234/255, green: 76/255, blue: 192/255),
        Color(red: 217/255, green: 72/255, blue: 221/255),
        Color(red: 204/255, green: 69/255, blue: 242/255)])
    
    /**
     This is the spotify green color asset.
     */
    static let spotifyGreen = Color("SpotifyGreen")
    
    /**
     This is the Apple Music background gradient
     */
    static let appleMusicGrad = Gradient(colors: [
        Color(red: 250/255, green: 87/255, blue: 193/255),
        Color(red: 177/255, green: 102/255, blue: 204/255)
    ])
    
    /**
     This is the Pandora Blue
     */
    static let pandoraBlue = Color(red: 0/255, green: 160/255, blue: 238/255)
    
    /**
     This is the deezer Linear Gradient
     */
    static let deezerGrad = Gradient(colors: [
        Color(red: 254/255, green: 171/255, blue: 46/255),
        Color(red: 216/255, green: 27/255, blue: 96/255)
    ])
    
    /**
     This is the Amazon Prime Blue
     */
    static let amazonBlue = Color(red: 0, green: 168/255, blue: 225/255)
    
    /**
     This is the Amazon Orange Color
     */
    static let amazonOrange = Color(red: 255/255, green: 153/255, blue: 0)
    
    /**
     The Soundcloud Orange Color
     */
    static let soundcloudOrange = Color(red: 254/255, green: 80/255, blue: 0)
    
    /**
     The Napster Yellow
     */
    static let napsterYellow = Color(red: 253/255, green: 184/255, blue: 19/255)
    
    /**
     The Spinrilla purple
     */
    static let spinrillaPurple = Color(red: 64/255, green: 14/255, blue: 83/255)
}

struct ColorManager_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Text("")
            ColorManager.pandoraBlue
        }
    }
}
