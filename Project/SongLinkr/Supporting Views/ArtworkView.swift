//
//  ArtworkView.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

struct ArtworkView: View {
    var size: CGFloat
    var cornerRadius: CGFloat
    var artworkURL: URL?
    var namespace: Namespace.ID

    var body: some View {
        AsyncImage(url: artworkURL) { image in
            image.resizable().scaledToFill()
        } placeholder: {
            placeholderGradient
        }
        .frame(width: size, height: size)
        .clipShape(.rect(cornerRadius: cornerRadius))
        .shadow(color: .orange.opacity(0.4), radius: 22, y: 9)
        .matchedGeometryEffect(id: "art", in: namespace)
    }

    private var placeholderGradient: some View {
        LinearGradient(colors: [.orange.opacity(0.8), .pink, .purple],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

#Preview {
    @Previewable @Namespace var morph

    ArtworkView(size: 190, cornerRadius: 24, artworkURL: URL(string: "https://m.media-amazon.com/images/I/51jNytp9pxL._AA500.jpg"), namespace: morph)
}
