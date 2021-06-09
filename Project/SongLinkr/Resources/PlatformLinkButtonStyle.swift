//
//  PlatformLinkButtonStyle.swift
//  SongLinkr
//
//  Created by Harry Day on 06/07/2020.
//

import Foundation
import SwiftUI
import SongLinkrNetworkCore


struct PlatformLinkButtonStyle: ButtonStyle {
    let platform: Platform
    
    func makeBody(configuration: Self.Configuration) -> some View {
        VStack {
            switch platform {
                case Platform.spotify:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(ColorManager.spotifyGreen)
                        .cornerRadius(15.0)
                case Platform.itunes:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient(gradient: ColorManager.itunesGrad, startPoint: .top, endPoint: .bottom))
                        .cornerRadius(15.0)
                case Platform.appleMusic:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient(gradient: ColorManager.appleMusicGrad, startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(15.0)
                case Platform.youtube, Platform.youtubeMusic:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(15.0)
                case Platform.googleStore, Platform.google:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.secondary)
                        .cornerRadius(15.0)
                case Platform.pandora:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(ColorManager.pandoraBlue)
                        .cornerRadius(15.0)
                case Platform.deezer:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient(gradient: ColorManager.deezerGrad, startPoint: .topLeading, endPoint: .bottomLeading))
                        .cornerRadius(15.0)
                case Platform.tidal:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(15.0)
                case Platform.amazonMusic:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(ColorManager.amazonBlue)
                        .cornerRadius(15.0)
                case Platform.amazonStore:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(ColorManager.amazonOrange)
                        .cornerRadius(15.0)
                case Platform.soundcloud:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(ColorManager.soundcloudOrange)
                        .cornerRadius(15.0)
                case Platform.napster:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(ColorManager.napsterYellow)
                        .cornerRadius(15.0)
                case Platform.yandex:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.secondary)
                        .cornerRadius(15.0)
                case Platform.spinrilla:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(ColorManager.spinrillaPurple)
                        .cornerRadius(15.0)
                case Platform.audius:
                    configuration.label
                        .foregroundColor(.primary)
                        .padding()
                        .background(ColorManager.audiusColour)
                        .cornerRadius(15.0)
            }
        }
            
    }
}
