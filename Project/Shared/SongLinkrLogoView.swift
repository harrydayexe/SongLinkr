//
//  SongLinkrLogoView.swift
//  SongLinkr
//
//  Created by Harry Day on 04/08/2026.
//

import SwiftUI

/// Fills whatever size it is given; the glyph scales with it.
struct SongLinkrLogoView: View {
    /// Glyph size relative to the tile's width.
    private let glyphScale: CGFloat = 0.43

    var body: some View {
        LinearGradient(gradient: .orangeGradient, startPoint: .topLeading, endPoint: .bottomTrailing)
            .overlay {
                GeometryReader { proxy in
                    #warning("Update this to the the SongLinkr logo")
                    Image(systemName: "link")
                        .font(.system(size: proxy.size.width * glyphScale, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                }
            }
    }
}

#Preview {
    SongLinkrLogoView()
        .frame(width: 92, height: 92)
        .clipShape(.rect(cornerRadius: 24))
}
