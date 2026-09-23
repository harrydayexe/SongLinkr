//
//  ArtworkView.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

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
