//
//  Platform+iconName.swift
//  SongLinkr
//
//  Created by Harry Day on 06/07/2020.
//

import Foundation

public extension SongLinkAPIResponse.Platform {
    /// The name of the icon for a platform
    var iconName: String {
        switch self {
            case .spotify:
                return "SpotifyLogoWhite"
            case .itunes:
                return "iTunesLogoWhite"
            case .appleMusic:
                return "AppleMusicLogoWhite"
            case .youtube:
                return "YouTubeLogoWhite"
            case .youtubeMusic:
                return "YouTubeLogoWhite"
            case .google:
                return "PlayMusicLogo"
            case .googleStore:
                return "PlayStoreLogo"
            case .pandora:
                return "PandoraLogoWhite"
            case .deezer:
                return "DeezerLogoWhite"
            case .tidal:
                return "TidalLogoWhite"
            case .amazonStore:
                return "AmazonLogoWhite"
            case .amazonMusic:
                return "PrimeLogoWhite"
            case .soundcloud:
                return "SoundcloudLogoWhite"
            case .napster:
                return "NapsterLogoWhite"
            case .yandex:
                return "YandexLogoColor"
            case .spinrilla:
                return "SpinrillaLogoWhite"
            case .audius:
                return "AudiusLogo"
        }
    }
}
