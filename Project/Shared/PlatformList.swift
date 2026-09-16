//
//  PlatformList.swift
//  SongLinkr
//
//  Created by Harry Day on 08/08/2026.
//

import SongLinkrNetworkCore
import SwiftUI

struct PlatformList: View {
    let platforms: [PlatformLinks]

    var body: some View {
        List {
            Section(header: Text("Listen On", comment: "Heading above a list of platforms")) {
                ForEach(platforms) { platform in
                    PlatformListRow(platform: platform.id)
                }
            }
        }
    }
}

struct PlatformListRow: View {
    let platform: Platform
    var showArrow: Bool = true

    var body: some View {
        HStack {
            #warning("Add icon here")
            Text(platform.displayName)
                .font(.title)
            Spacer()
            if showArrow {
                Image(systemName: "arrow.up.right")
                    .foregroundStyle(.tertiary)
                    .font(.callout)
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    PlatformList(platforms: .previewPlatformLinks)
}
