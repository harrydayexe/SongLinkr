//
//  ResultsView.swift
//  SongLinkr
//
//  Created by Harry Day on 28/06/2020.
//

import SongLinkrNetworkCore
import StoreKit
import SwiftUI

struct ResultsView: View {
    @Environment(UserSettings.self) var userSettings
    @Environment(SearchModel.self) var searchModel
    @Environment(\.dismiss) private var dismiss

    @State private var showShareSheet = false
    @State private var shareSheetURL: URL = "https://song.link"

    let results: ResultsModel
    let saveFunction: @MainActor () async -> Bool

    var gridItemLayout = [GridItem(.adaptive(minimum: 250))]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                    MediaDetailView(
                        artworkURL: results.artworkURL,
                        mediaTitle: results.mediaTitle,
                        artistName: results.artistName,
                        displaySaveButton: results.isFromShazam && !userSettings.saveToShazamLibrary,
                        saveFunction: saveFunction
                    )

                    ForEach(results.response) { platform in
                        PlatformLinkButtonView(platform: platform)
                            .contextMenu {
                                Button(action: {
                                    shareSheetURL = platform.url
                                    showShareSheet = true
                                }) {
                                    Text("Share", comment: "A context menu item, launches the share sheet")
                                    Image(systemName: "square.and.arrow.up")
                                }

                                Button(action: { UIPasteboard.general.url = platform.url }) {
                                    Text("Copy", comment: "A context menu item, copies the link to clipboard")
                                    Image(systemName: "doc.on.doc")
                                }

                                Button(action: { UIApplication.shared.open(platform.url) }) {
                                    Text("Open", comment: "A context menu item, opens the link")
                                    Image(systemName: "safari")
                                }

                                if platform.nativeAppUriMobile != nil {
                                    Button(action: { UIApplication.shared.open(platform.nativeAppUriMobile!) }) {
                                        Text("Open in App", comment: "A context menu item, opens the link in the relevant music app")
                                        Image(systemName: "square.on.square")
                                    }
                                }
                            }
                    }
                    SongLinkCreditView()
                }
                .popover(
                    isPresented: $showShareSheet,
                    attachmentAnchor: .point(.bottom),
                    arrowEdge: .bottom
                ) {
                    ShareSheet(activityItems: [shareSheetURL])
                }
            }
            .navigationTitle(Text("Pick your platform", comment: "The modal view title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding()
        .background(Color.offWhite)
        .onAppear {
            guard userSettings.autoOpen else { return }
            guard searchModel.originEntityID != "shazam" else { return }
            guard !searchModel.originEntityID.contains(userSettings.defaultPlatform.entityName) else { return }
            if let defaultPlatform = results.response.first(where: { $0.id == userSettings.defaultPlatform }) {
                UIApplication.shared.open(defaultPlatform.nativeAppUriMobile ?? defaultPlatform.url)
            }
        }
    }
}

#Preview {
    let response = [
        PlatformLinks(id: Platform.yandex, url: URL(string: "https://music.yandex.ru/track/59994505")!),
        PlatformLinks(id: Platform.youtube, url: URL(string: "https://www.youtube.com/watch?v=QfnVrp2bPuE")!),
        PlatformLinks(id: Platform.spotify, url: URL(string: "https://open.spotify.com/track/3NivHilTTTs8SQwp51yG0X")!),
        PlatformLinks(id: Platform.appleMusic, url: URL(string: "https://geo.music.apple.com/us/album/_/1488452376?i=1488452377&mt=1&app=music&at=1000lHKX")!, nativeAppUriMobile: URL(string: "itmss://itunes.apple.com/us/album/_/1488452376?i=1488452377&mt=1&app=music&at=1000lHKX")!, nativeAppUriDesktop: URL(string: "music://itunes.apple.com/us/album/_/1488452376?i=1488452377&mt=1&app=music&at=1000lHKX")!),
    ].sorted(by: { $0.id.rawValue < $1.id.rawValue })

    let results = ResultsModel(
        artworkURL: URL(string: "https://m.media-amazon.com/images/I/51jNytp9pxL._AA500.jpg"),
        mediaTitle: "Humble",
        artistName: "Kendrick Lamar",
        isFromShazam: true,
        response: response
    )

    let model = SearchModel()
    Color.clear
        .sheet(isPresented: .constant(true)) {
            ResultsView(results: results, saveFunction: { true })
                .environment(UserSettings())
                .environment(model)
        }
}
