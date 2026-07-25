import SwiftUI

struct ShareExtensionView: View {
    @ObservedObject var viewModel: ShareExtensionViewModel
    let dismiss: () -> Void
    let openURL: (URL) -> Void

    var body: some View {
        NavigationView {
            contentView
                .navigationTitle("SongLinkr")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", action: dismiss)
                    }
                }
        }
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .loading:
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.5)
                Text("Looking up links…")
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .results(let platforms, let title, let artist, let artworkURL):
            ResultsList(
                platforms: platforms,
                title: title,
                artist: artist,
                artworkURL: artworkURL,
                openURL: openURL
            )

        case .error(let message):
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.circle")
                    .font(.system(size: 44))
                    .foregroundColor(.red)
                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
