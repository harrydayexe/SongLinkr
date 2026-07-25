import SwiftUI
import SongLinkrNetworkCore

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

private struct ResultsList: View {
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

private struct PlatformRow: View {
    let platform: PlatformLinks
    let openURL: (URL) -> Void

    var body: some View {
        Button {
            openURL(platform.url)
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(platform.id.brandColor)
                        .frame(width: 36, height: 36)
                    Image(platform.id.iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                Text(platform.id.displayName)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .buttonStyle(.borderless)
        .contentShape(Rectangle())
        .swipeActions(edge: .trailing) {
            Button {
                UIPasteboard.general.url = platform.url
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
            }
            .tint(.blue)
        }
    }
}

private extension Platform {
    var brandColor: Color {
        switch self {
        case .spotify:                return Color(red: 29/255,  green: 185/255, blue: 84/255)
        case .appleMusic:             return Color(red: 250/255, green: 87/255,  blue: 193/255)
        case .itunes:                 return Color(red: 234/255, green: 76/255,  blue: 192/255)
        case .youtube, .youtubeMusic: return Color(red: 255/255, green: 0,       blue: 0)
        case .google, .googleStore:   return Color(red: 66/255,  green: 133/255, blue: 244/255)
        case .pandora:                return Color(red: 0,       green: 160/255, blue: 238/255)
        case .deezer:                 return Color(red: 254/255, green: 171/255, blue: 46/255)
        case .tidal:                  return Color(red: 0,       green: 0,       blue: 0)
        case .amazonMusic:            return Color(red: 0,       green: 168/255, blue: 225/255)
        case .amazonStore:            return Color(red: 255/255, green: 153/255, blue: 0)
        case .soundcloud:             return Color(red: 254/255, green: 80/255,  blue: 0)
        case .napster:                return Color(red: 253/255, green: 184/255, blue: 19/255)
        case .yandex:                 return Color(red: 255/255, green: 92/255,  blue: 92/255)
        case .spinrilla:              return Color(red: 64/255,  green: 14/255,  blue: 83/255)
        case .audius:                 return Color(red: 204/255, green: 0,       blue: 168/255)
        case .audiomack:              return Color(red: 255/255, green: 162/255, blue: 0)
        default:                      return .secondary
        }
    }
}
