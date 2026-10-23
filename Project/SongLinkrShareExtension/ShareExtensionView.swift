import SongLinkrNetworkCore
import SwiftUI

struct ShareExtensionView: View {
    let viewModel: ShareExtensionViewModel
    let dismiss: () -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()
                content
            }
            .navigationTitle(Text(verbatim: "SongLinkr"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close, action: dismiss)
                }
            }
        }
        .task { await viewModel.start() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView {
                Text("Looking up links…", comment: "Share extension loading message")
            }
            .controlSize(.large)

        case .results(let result):
            ShareResultsView(result: result, openInAppURL: viewModel.openInAppURL)

        case .failed(let failure):
            ContentUnavailableView {
                Label(failure.title, systemImage: "exclamationmark.triangle")
            } description: {
                Text(failure.message)
            } actions: {
                if failure.canRetry {
                    Button {
                        Task { await viewModel.retry() }
                    } label: {
                        Text("Try Again", comment: "Button title, retries a failed search")
                    }
                    .buttonStyle(.glassProminent)
                }
            }
        }
    }
}

/// Mirrors the app's results layout: the list scrolls beneath the artwork and title, with
/// the actions pinned to the bottom.
private struct ShareResultsView: View {
    @Environment(\.openURL) private var openURL
    @ScaledMetric(relativeTo: .headline) private var actionsHeight: CGFloat = 52

    let result: ShareExtensionViewModel.Result
    var openInAppURL: URL?

    var body: some View {
        PlatformList(platforms: result.platforms)
            .scrollContentBackground(.hidden)
            .safeAreaBar(edge: .top, spacing: 4) { header }
            .scrollEdgeEffectStyle(.soft, for: .top)
            .safeAreaBar(edge: .bottom) { actions }
    }

    private var header: some View {
        VStack(spacing: 0) {
            ZStack {
                SongLinkrLogoView()
                ArtworkView(artworkURL: result.artworkURL)
                    .clipShape(.rect(cornerRadius: 24))
            }
            .aspectRatio(1, contentMode: .fit)
            .shadow(color: .orange.opacity(0.4), radius: 22, y: 9)
            .containerRelativeFrame(.vertical) { height, _ in height * 0.22 }
            .accessibilityHidden(true)
            .padding(.top, 12)

            TitleBlock(
                title: result.title,
                subtitle: result.artist,
                titleFont: .system(size: 24, weight: .bold),
                subtitleFont: .subheadline
            )
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .padding(.top, 18)
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isHeader)
        }
    }

    private var actions: some View {
        HStack(spacing: 12) {
            ShareLink(item: result.pageURL) {
                Label {
                    Text("Share song.link", comment: "Button title, shares the universal song.link URL")
                } icon: {
                    Image(systemName: "square.and.arrow.up")
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(.capsule)
            }
            .buttonStyle(.plain)
            .background(
                LinearGradient(
                    gradient: .orangeGradient,
                    startPoint: UnitPoint(x: 0.5, y: -0.5),
                    endPoint: .bottom
                ),
                in: .capsule
            )
            .shadow(color: .orange.opacity(0.4), radius: 13, y: 5)

            if let openInAppURL {
                Button {
                    openURL(openInAppURL)
                } label: {
                    Image(systemName: "arrow.up.forward.app")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.orange)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(.circle)
                }
                .buttonStyle(.plain)
                .aspectRatio(1, contentMode: .fit)
                .frostedPill(in: .circle)
                .accessibilityLabel(Text("Open in SongLinkr", comment: "Share extension button, opens the shared link in the SongLinkr app"))
            }
        }
        .frame(height: actionsHeight)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

#Preview("Results") {
    ZStack {
        GradientBackground()
        ShareResultsView(
            result: ShareExtensionViewModel.Result(
                platforms: .previewPlatformLinks,
                title: "Humble",
                artist: "Kendrick Lamar",
                artworkURL: URL(string: "https://m.media-amazon.com/images/I/51jNytp9pxL._AA500.jpg"),
                pageURL: URL(string: "https://song.link/s/3NivHilTTTs8SQwp51yG0X")!
            ),
            openInAppURL: URL(string: "songlinkr:https://open.spotify.com/track/3NivHilTTTs8SQwp51yG0X")
        )
    }
}
