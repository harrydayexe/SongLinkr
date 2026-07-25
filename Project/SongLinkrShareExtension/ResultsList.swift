import SwiftUI
import SongLinkrNetworkCore

struct ResultsList: View {
    let platforms: [PlatformLinks]
    let title: String?
    let artist: String?
    let artworkURL: URL?
    let openURL: (URL) -> Void

    var body: some View {
        List {
            if title != nil || artist != nil || artworkURL != nil {
                Section {
                    HStack(spacing: 12) {
                        if let artworkURL {
                            AsyncImage(url: artworkURL) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color.secondary.opacity(0.2)
                            }
                            .frame(width: 56, height: 56)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            if let title {
                                Text(title).font(.headline)
                            }
                            if let artist {
                                Text(artist)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

            Section("Pick your platform") {
                ForEach(platforms) { platform in
                    PlatformRow(platform: platform, openURL: openURL)
                }
            }
        }
    }
}
