//
//  PlatformTint.swift
//  SongLinkr
//
//  Created by Harry Day on 16/09/2026.
//

import SongLinkrNetworkCore
import SwiftUI

extension SongLinkAPIResponse.Platform {
    /// Brand-coloured background for the icon tile shown next to a platform's name.
    var tileBackground: AnyShapeStyle {
        switch self {
        case .spotify:
            AnyShapeStyle(Color.spotifyGreen)
        case .itunes:
            AnyShapeStyle(LinearGradient(
                colors: [.itunesColor1, .itunesColor2, .itunesColor3],
                startPoint: .top, endPoint: .bottom
            ))
        case .appleMusic:
            AnyShapeStyle(LinearGradient(gradient: .appleMusicGrad, startPoint: .top, endPoint: .bottom))
        case .youtube, .youtubeMusic:
            AnyShapeStyle(Color.youtubeColour)
        case .google, .googleStore:
            AnyShapeStyle(Color.white)
        case .pandora:
            AnyShapeStyle(Color.pandoraBlue)
        case .deezer:
            AnyShapeStyle(LinearGradient(gradient: .deezerGrad, startPoint: .top, endPoint: .bottom))
        case .tidal:
            AnyShapeStyle(Color.black)
        case .amazonStore:
            AnyShapeStyle(Color.amazonOrange)
        case .amazonMusic:
            AnyShapeStyle(Color.amazonBlue)
        case .soundcloud:
            AnyShapeStyle(Color.soundcloudOrange)
        case .napster:
            AnyShapeStyle(Color.napsterYellow)
        case .yandex:
            AnyShapeStyle(Color.white)
        case .spinrilla:
            AnyShapeStyle(Color.spinrillaPurple)
        case .audius:
            AnyShapeStyle(Color.audiusColour)
        case .audiomack:
            AnyShapeStyle(Color.audiomackColour)
        case .unknown:
            AnyShapeStyle(Color.gray)
        }
    }
}
