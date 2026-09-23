//
//  HeroArtView.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

/// Hero "art": the SongLinkr logo on home morphs into the result's artwork.
///
/// A single view whose frame follows the active slot. The logo is always drawn underneath
/// and the artwork fades over it. The logo keeps its own squircle while the artwork is clipped
/// to `artCornerRadius`, so the corners fill in as the artwork fades up.
struct HeroArtView: View {
    var artworkURL: URL?
    var showsArtwork: Bool

    var body: some View {
        ZStack {
            SongLinkrLogoView()
            ArtworkView(artworkURL: artworkURL)
                .clipShape(.rect(cornerRadius: HeroMetrics.artCornerRadius))
                .morphCrossfade(visible: showsArtwork)
        }
        .shadow(color: .orange.opacity(0.4), radius: showsArtwork ? 22 : 13, y: showsArtwork ? 9 : 5)
    }
}

#Preview {
    @Previewable @State var showsArtwork = false

    HeroArtView(
        artworkURL: URL(string: "https://m.media-amazon.com/images/I/51jNytp9pxL._AA500.jpg"),
        showsArtwork: showsArtwork
    )
    .frame(width: showsArtwork ? 190 : 92, height: showsArtwork ? 190 : 92)
    .onTapGesture { withAnimation(morphAnimation) { showsArtwork.toggle() } }
}
