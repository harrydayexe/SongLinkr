import SongLinkrNetworkCore
import SwiftUI

struct ResultsList: View {
    let platforms: [PlatformLinks]
    let title: String?
    let artist: String?
    let artworkURL: URL?

    var gridItemLayout = [GridItem(.adaptive(minimum: 250))]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItemLayout, spacing: 20) {
                if title != nil || artist != nil || artworkURL != nil {
                    MediaDetailView(
                        artworkURL: artworkURL,
                        mediaTitle: title ?? "",
                        artistName: artist ?? ""
                    )
                }

                ForEach(platforms) { platform in
                    PlatformLinkButtonView(platform: platform)
                }

                SongLinkCreditView()
            }
            .padding()
        }
        .background(Color.offWhite)
    }
}
