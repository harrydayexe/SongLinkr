//
//  ArtworkView.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

/// Hero "art": the SongLinkr logo on home morphs into the result's artwork.
///
/// A single view whose frame follows the active slot. The logo is always drawn underneath
/// and the artwork fades over it, so the square never dips in opacity mid-morph.
struct HeroArtView: View {
    var artworkURL: URL?
    var showsArtwork: Bool

    var body: some View {
        ZStack {
            SongLinkrLogoView()
            ArtworkView(artworkURL: artworkURL)
                .morphCrossfade(visible: showsArtwork)
        }
        .clipShape(.rect(cornerRadius: HeroMetrics.artCornerRadius))
        .shadow(color: .orange.opacity(0.4), radius: showsArtwork ? 22 : 13, y: showsArtwork ? 9 : 5)
    }
}

/// Fills whatever size it is given, fading the image in once loaded.
struct ArtworkView: View {
    var artworkURL: URL?

    var body: some View {
        AsyncImage(url: artworkURL, transaction: Transaction(animation: .smooth)) { phase in
            if let image = phase.image {
                image.resizable().scaledToFill()
            } else {
                Color.clear
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
