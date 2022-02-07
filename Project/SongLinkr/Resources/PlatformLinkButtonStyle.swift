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
                        .background(Color.spotifyGreen)
                        .cornerRadius(15.0)
                case Platform.itunes:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient(gradient: Color.itunesGrad, startPoint: .top, endPoint: .bottom))
                        .cornerRadius(15.0)
                case Platform.appleMusic:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient(gradient: Color.appleMusicGrad, startPoint: .topLeading, endPoint: .bottomTrailing))
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
                        .background(Color.pandoraBlue)
                        .cornerRadius(15.0)
                case Platform.deezer:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient(gradient: Color.deezerGrad, startPoint: .topLeading, endPoint: .bottomLeading))
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
                        .background(Color.amazonBlue)
                        .cornerRadius(15.0)
                case Platform.amazonStore:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.amazonOrange)
                        .cornerRadius(15.0)
                case Platform.soundcloud:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.soundcloudOrange)
                        .cornerRadius(15.0)
                case Platform.napster:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.napsterYellow)
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
                        .background(Color.spinrillaPurple)
                        .cornerRadius(15.0)
                case Platform.audius:
                    configuration.label
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color.audiusColour)
                        .cornerRadius(15.0)
                default:
                    configuration.label
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.secondary)
                        .cornerRadius(15.0)
            }
        }
            
    }
}
