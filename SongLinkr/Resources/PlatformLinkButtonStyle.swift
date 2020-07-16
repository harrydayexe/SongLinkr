//
//  PlatformLinkButtonStyle.swift
//  SongLinkr
//
//  Created by Harry Day on 06/07/2020.
//

import Foundation
import SwiftUI


struct PlatformLinkButtonStyle: ButtonStyle {
    let platform: SongLinkAPIResponse.Platform
    
    func makeBody(configuration: Self.Configuration) -> some View {
        VStack {
            switch platform {
                case SongLinkAPIResponse.Platform.spotify:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(ColorManager.spotifyGreen)
                        .cornerRadius(15.0)
                case SongLinkAPIResponse.Platform.itunes:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient(gradient: ColorManager.itunesGrad, startPoint: .top, endPoint: .bottom))
                        .cornerRadius(15.0)
                case SongLinkAPIResponse.Platform.appleMusic:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient(gradient: ColorManager.appleMusicGrad, startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(15.0)
                case SongLinkAPIResponse.Platform.youtube, SongLinkAPIResponse.Platform.youtubeMusic:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(15.0)
                case SongLinkAPIResponse.Platform.googleStore, SongLinkAPIResponse.Platform.google:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.secondary)
                        .cornerRadius(15.0)
                case SongLinkAPIResponse.Platform.pandora:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(ColorManager.pandoraBlue)
                        .cornerRadius(15.0)
                case SongLinkAPIResponse.Platform.deezer:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient(gradient: ColorManager.deezerGrad, startPoint: .topLeading, endPoint: .bottomLeading))
                        .cornerRadius(15.0)
                case SongLinkAPIResponse.Platform.tidal:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(15.0)
                case SongLinkAPIResponse.Platform.amazonMusic:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(ColorManager.amazonBlue)
                        .cornerRadius(15.0)
                case SongLinkAPIResponse.Platform.amazonStore:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(ColorManager.amazonOrange)
                        .cornerRadius(15.0)
                case SongLinkAPIResponse.Platform.soundcloud:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(ColorManager.soundcloudOrange)
                        .cornerRadius(15.0)
                case SongLinkAPIResponse.Platform.napster:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(ColorManager.napsterYellow)
                        .cornerRadius(15.0)
                case SongLinkAPIResponse.Platform.yandex:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.secondary)
                        .cornerRadius(15.0)
                case SongLinkAPIResponse.Platform.spinrilla:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(ColorManager.spinrillaPurple)
                        .cornerRadius(15.0)
            }
        }
            
    }
}
