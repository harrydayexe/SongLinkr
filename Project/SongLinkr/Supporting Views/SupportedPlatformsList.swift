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

import SongLinkrNetworkCore
import SwiftUI

struct SupportedPlatformsList: View {
    var body: some View {
        List {
            ForEach(
                Platform.allCases.filter { $0 != .unknown },
                id: \.self
            ) { platform in
                PlatformListRow(platform: platform, showArrow: false)
            }
        }
    }
}

#Preview {
    SupportedPlatformsList()
}
