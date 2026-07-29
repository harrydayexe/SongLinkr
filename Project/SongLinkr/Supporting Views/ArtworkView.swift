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
    var showsIcon: Bool
    var artworkURL: URL?
    var namespace: Namespace.ID

    var body: some View {
        Group {
            if let artworkURL {
                AsyncImage(url: artworkURL) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    placeholderGradient
                }
            } else {
                LinearGradient(
                    colors: [Color(red: 1, green: 0.70, blue: 0.25),
                             Color(red: 1, green: 0.54, blue: 0.00)],
                    startPoint: .top, endPoint: .bottom
                )
                Image(systemName: "link") // TODO: Update this to songlinkr logo
                    .font(.system(size: size * 0.43, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .frame(width: size, height: size)
        .clipShape(.rect(cornerRadius: cornerRadius))
        .shadow(color: .orange.opacity(0.4),
                radius: showsIcon ? 13 : 22, y: showsIcon ? 5 : 9)
        .matchedGeometryEffect(id: "art", in: namespace)
    }

    private var placeholderGradient: some View {
        LinearGradient(colors: [.orange.opacity(0.8), .pink, .purple],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

#Preview("Animation") {
    @Previewable @Namespace var morph
    @Previewable @State var phase: SearchPhase = .home

    NavigationStack {
        switch phase {
        case .home:
            ArtworkView(size: 92, cornerRadius: 23, showsIcon: true, artworkURL: nil, namespace: morph)
        case .results:
            ArtworkView(size: 190, cornerRadius: 24, showsIcon: false, artworkURL: URL(string: "https://m.media-amazon.com/images/I/51jNytp9pxL._AA500.jpg"), namespace: morph)
        }
    }
    .animation(morphAnimation, value: phase.isResults)
    .onAppear {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            Task { @MainActor in
                let all: [SearchPhase] = [.home, .results(ResultsModel(artworkURL: nil, mediaTitle: "", artistName: "", isFromShazam: false, response: [], pageUrl: nil))]
                let idx = all.firstIndex(of: phase)!
                phase = all[(idx + 1) % all.count]
            }
        }
    }
}

#Preview("Icon Mode") {
    @Previewable @Namespace var morph

    ArtworkView(size: 92, cornerRadius: 23, showsIcon: true, artworkURL: nil, namespace: morph)
}

#Preview("Artwork Mode") {
    @Previewable @Namespace var morph

    ArtworkView(size: 190, cornerRadius: 24, showsIcon: false, artworkURL: URL(string: "https://m.media-amazon.com/images/I/51jNytp9pxL._AA500.jpg"), namespace: morph)
}
