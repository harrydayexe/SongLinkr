//
//  PlatformLinkButtonStyle.swift
//  SongLinkr
//
//  Created by Harry Day on 06/07/2020.
//

import Foundation
import SongLinkrNetworkCore
import SwiftUI

struct PlatformLinkButtonStyle: ButtonStyle {
    let platform: Platform

    func makeBody(configuration: Self.Configuration) -> some View {
        ZStack {
            ConcentricRectangle()
                .fill(.thinMaterial)
                .ignoresSafeArea()
                .zIndex(.infinity * -1)

            configuration.label
                .padding()
        }
        .containerShape(
            .rect(cornerRadius: 24)
        )
    }
}

#Preview("Light") {
    List {
        ForEach(Platform.allCases, id: \.self) { platform in
            Button {} label: {
                HStack {
                    Text(platform.displayName)
                        .font(.largeTitle)
                        .fontWeight(.medium)
                        .padding()
                    Spacer()
                }
            }
            .buttonStyle(PlatformLinkButtonStyle(platform: platform))
        }
    }
    .listStyle(.plain)
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    List {
        ForEach(Platform.allCases, id: \.self) { platform in
            Button {} label: {
                HStack {
                    Text(platform.displayName)
                        .font(.largeTitle)
                        .fontWeight(.medium)
                        .padding()
                    Spacer()
                }
            }
            .buttonStyle(PlatformLinkButtonStyle(platform: platform))
        }
    }
    .listStyle(.plain)
    .preferredColorScheme(.dark)
}
