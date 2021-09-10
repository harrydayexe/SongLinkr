//
//  SupportedPlatformsList.swift
//  SongLinkr
//
//  Created by Harry Day on 16/07/2021
//  
//
//  Twitter: https://twitter.com/realharryday
//  Github: https://github.com/harryday123
//


import SwiftUI
import SongLinkrNetworkCore

struct SupportedPlatformsList: View {
    var body: some View {
        List {
            ForEach(Platform.allCases, id: \.self) { platform in
                Text(platform.displayName)
            }
        }
    }
}

struct SupportedPlatformsList_Previews: PreviewProvider {
    static var previews: some View {
        SupportedPlatformsList()
    }
}
