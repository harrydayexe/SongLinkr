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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    /// The smallest a grid tile may be; scales with Dynamic Type so names stay readable.
    @ScaledMetric(relativeTo: .subheadline) private var gridTileMinimumWidth: CGFloat = 110

    let platforms: [PlatformLinks]

    var body: some View {
        // Wide windows (iPad, Mac) show a grid of platform tiles; compact widths
        // (iPhone, Slide Over, narrow Split View) keep the list.
        if horizontalSizeClass == .regular {
            platformGrid
        } else {
            platformList
        }
    }

    private func open(_ platform: PlatformLinks) {
        openURL(platform.nativeAppUriMobile ?? platform.url)
    }

    /// Adaptive columns fit as many tiles as the window width allows. The maximum keeps
    /// the logos from ballooning when only a few columns fit.
    private var platformGrid: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: gridTileMinimumWidth, maximum: gridTileMinimumWidth * 1.4), spacing: 20, alignment: .top)],
                spacing: 24
            ) {
                Section {
                    ForEach(platforms) { platform in
                        Button {
                            open(platform)
                        } label: {
                            PlatformGridTile(platform: platform.id)
                        }
                        .buttonStyle(.plain)
                        .hoverEffect()
                        .contextMenu { contextMenuContent(for: platform) }
                    }
                } header: {
                    Text("Listen On", comment: "Heading above a list of platforms")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityAddTraits(.isHeader)
                } footer: {
                    SongLinkCreditView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                }
            }
            .padding()
        }
    }

    private var platformList: some View {
        List {
            Section {
                ForEach(platforms) { platform in
                    Button {
                        open(platform)
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

/// A grid tile: the platform's brand-coloured icon tile with its name underneath.
struct PlatformGridTile: View {
    let platform: Platform

    var body: some View {
        VStack(spacing: 8) {
            // Square tile sized by the grid column. The icon scales with it, keeping the
            // same proportions as the list row's 22pt icon on a 36pt tile.
            GeometryReader { proxy in
                let side = proxy.size.width
                RoundedRectangle(cornerRadius: side * 0.25)
                    .fill(platform.tileBackground)
                    .overlay {
                        if platform.iconName.isEmpty {
                            Image(systemName: "music.note")
                                .font(.system(size: side * 0.35, weight: .bold))
                                .foregroundStyle(.white)
                        } else {
                            Image(platform.iconName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: side * 0.6, height: side * 0.6)
                        }
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: side * 0.25)
                            .strokeBorder(.primary.opacity(0.08), lineWidth: 0.5)
                    }
            }
            .aspectRatio(1, contentMode: .fit)
            .accessibilityHidden(true)

            Text(platform.displayName)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .contentShape(.rect)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    PlatformList(platforms: .previewPlatformLinks)
}
