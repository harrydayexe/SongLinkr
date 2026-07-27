//
//  ContentView.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import SongLinkrNetworkCore
import SwiftUI

struct ContentView: View {
    @Environment(SearchModel.self) private var searchModel
    @Environment(ShazamMatcher.self) private var shazamMatcher
    @Environment(UserSettings.self) private var userSettings

    @State var searchURL: String = ""
    @Binding var selectedTab: Int

    /// Pending URL written by SendToSongLinkrIntent; cleared after processing.
    @AppStorage("pendingDeepLinkURL") private var pendingDeepLinkURLString: String = ""

    private func makeRequest() {
        guard searchURL != "" else { return }
        Task {
            searchModel.normalInProgress = true
            await searchModel.getResults(for: searchURL, with: userSettings)
            searchModel.normalInProgress = false
        }
    }

    private func startShazam() {
        shazamMatcher.startShazamMatch(userSettings: userSettings)
    }

    private func stopShazam() {
        shazamMatcher.stopMatching()
        shazamMatcher.shazamState = .idle
    }

    var body: some View {
        @Bindable var searchModel = searchModel
        @Bindable var shazamMatcher = shazamMatcher

        NavigationStack {
            SearchScreenView(
                searchURL: $searchURL,
                shazamInProgress: $shazamMatcher.shazamState,
                normalInProgress: $searchModel.normalInProgress,
                makeRequest: makeRequest,
                startShazam: startShazam,
                stopShazam: stopShazam
            )
            // Check pasteboard for URLs
            .onAppear {
                if UIPasteboard.general.hasURLs, let copiedURL = UIPasteboard.general.url {
                    searchURL = "\(copiedURL)"
                }
            }
            // Handle deep links from the songlinkr:// URL scheme
            .onOpenURL { deepLinkURL in
                searchModel.results = nil
                selectedTab = 0
                if let songLink = URL(string: deepLinkURL.absoluteString.replacingOccurrences(of: "songlinkr:", with: "")) {
                    searchURL = songLink.absoluteString
                }
            }
            // Handle URLs queued by SendToSongLinkrIntent via UserDefaults
            .onChange(of: pendingDeepLinkURLString) { _, urlString in
                guard !urlString.isEmpty, let url = URL(string: urlString) else { return }
                searchModel.results = nil
                selectedTab = 0
                searchURL = url.absoluteString
                pendingDeepLinkURLString = ""
                makeRequest()
            }
            // Reset shazam state when results sheet is dismissed
            .onChange(of: searchModel.results?.id) { _, id in
                if id == nil { shazamMatcher.shazamState = .idle }
            }
            // Error alert
            .alert(item: $searchModel.error) { error in
                Alert(
                    title: Text(error.localizedTitle ?? String(localized: "Something went wrong", comment: "Generic error title")),
                    message: Text(error.localizedDescription),
                    dismissButton: .cancel {
                        shazamMatcher.shazamState = .idle
                        searchModel.normalInProgress = false
                    }
                )
            }
            // Results sheet
            .sheet(item: $searchModel.results) { results in
                ResultsView(
                    results: results,
                    saveFunction: shazamMatcher.saveCachedItem
                )
            }
        }
    }
}

#Preview {
    let model = SearchModel()
    ContentView(selectedTab: .constant(0))
        .environment(UserSettings())
        .environment(model)
        .environment(ShazamMatcher(searchModel: model))
}
