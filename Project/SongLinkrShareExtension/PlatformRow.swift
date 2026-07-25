import SwiftUI
import SongLinkrNetworkCore

struct PlatformRow: View {
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
