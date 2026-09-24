//
//  PlatformList.swift
//  SongLinkr
//
//  Created by Harry Day on 08/08/2026.
//

import SongLinkrNetworkCore
import SwiftUI

struct PlatformList: View {
    @Environment(\.openURL) private var openURL

    let platforms: [PlatformLinks]

    var body: some View {
        List {
            Section {
                ForEach(platforms) { platform in
                    Button {
                        openURL(platform.nativeAppUriMobile ?? platform.url)
                    } label: {
                        PlatformListRow(platform: platform.id)
                    }
                    .contextMenu { contextMenuContent(for: platform) }
                }
            } header: {
                Text("Listen On", comment: "Heading above a list of platforms")
            } footer: {
                SongLinkCreditView()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
            }
        }
    }

    @ViewBuilder
    private func contextMenuContent(for platform: PlatformLinks) -> some View {
        Button {
            openURL(platform.url)
        } label: {
            Label {
                Text("Open", comment: "A context menu item, opens the link")
            } icon: {
                Image(systemName: "arrow.up.right")
            }
        }

        if let nativeURL = platform.nativeAppUriMobile {
            Button {
                openURL(nativeURL)
            } label: {
                Label {
                    Text("Open in App", comment: "A context menu item, opens the link in the relevant music app")
                } icon: {
                    Image(systemName: "square.on.square")
                }
            }
        }

        Button {
            UIPasteboard.general.url = platform.url
        } label: {
            Label {
                Text("Copy", comment: "A context menu item, copies the link to clipboard")
            } icon: {
                Image(systemName: "doc.on.doc")
            }
        }

        ShareLink(item: platform.url) {
            Label {
                Text("Share", comment: "A context menu item, launches the share sheet")
            } icon: {
                Image(systemName: "square.and.arrow.up")
            }
        }
    }
}

struct PlatformListRow: View {
    let platform: Platform
    var showArrow: Bool = true

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 9)
                .fill(platform.tileBackground)
                .frame(width: 36, height: 36)
                .overlay {
                    if platform.iconName.isEmpty {
                        Image(systemName: "music.note")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.white)
                    } else {
                        Image(platform.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                    }
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 9)
                        .strokeBorder(.primary.opacity(0.08), lineWidth: 0.5)
                }

            Text(platform.displayName)
                .foregroundStyle(.primary)

            Spacer()

            if showArrow {
                Image(systemName: "arrow.up.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 6)
    }
}

#if DEBUG
#Preview {
    PlatformList(platforms: .previewPlatformLinks)
}
#endif
