//
//  HistoryGridItem.swift
//  SongLinkr
//
//  Created by Harry Day on 03/10/2026.
//

import SwiftUI

/// A tile for the history grid: square artwork with the title and artist underneath.
struct HistoryGridItem: View {
    let item: MatchedItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // A square container sized by the grid column, so the artwork
            // fills it regardless of the image's own aspect ratio.
            RoundedRectangle(cornerRadius: 16)
                .fill(.quaternary)
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    ArtworkView(artworkURL: item.mediaArtworkURL)
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.mediaTitle ?? "")
                    .font(.headline)
                    .lineLimit(1)
                Text(item.mediaArtist ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    let item: MatchedItem = {
        let i = MatchedItem(context: PersistenceController.preview.container.viewContext)
        i.isShazamMatch = false
        i.mediaArtist = "Artist Name"
        i.mediaArtworkURL = URL(string: "https://m.media-amazon.com/images/I/51jNytp9pxL._AA500.jpg")
        i.mediaTitle = "Song Title"
        i.originURL = URL(string: "https://harryday.dev/songlinkr")
        i.timestamp = Date(timeIntervalSinceNow: TimeInterval(1000))
        return i
    }()
    ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 20)], spacing: 24) {
            ForEach(0..<8) { _ in
                HistoryGridItem(item: item)
            }
        }
        .padding()
    }
}
