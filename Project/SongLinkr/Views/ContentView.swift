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
    @Binding var selectedTab: AppTab

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
            // Handle deep links from the songlinkr:// URL scheme
            .onOpenURL { deepLinkURL in
                searchModel.results = nil
                selectedTab = .search
                if let songLink = URL(string: deepLinkURL.absoluteString.replacingOccurrences(of: "songlinkr:", with: "")) {
                    searchURL = songLink.absoluteString
                }
            }
            // Handle URLs queued by SendToSongLinkrIntent or HistoryView via UserDefaults
            .onChange(of: pendingDeepLinkURLString) { _, urlString in
                guard !urlString.isEmpty, let url = URL(string: urlString) else { return }
                searchModel.results = nil
                selectedTab = .search
                searchURL = url.absoluteString
                pendingDeepLinkURLString = ""
                makeRequest()
            }
            // Reset shazam state when results sheet is dismissed
            .onChange(of: searchModel.results?.id) { _, id in
                if id == nil { shazamMatcher.shazamState = .idle }
            }
            // Error alert
            .alert(
                searchModel.error?.localizedTitle ?? String(localized: "Something went wrong", comment: "Generic error title"),
                isPresented: Binding(
                    get: { searchModel.error != nil },
                    set: { if !$0 {
                        shazamMatcher.shazamState = .idle
                        searchModel.normalInProgress = false
                        searchModel.error = nil
                    }}
                ),
                presenting: searchModel.error
            ) { _ in
                Button(String(localized: "OK"), role: .cancel) {
                    shazamMatcher.shazamState = .idle
                    searchModel.normalInProgress = false
                    searchModel.error = nil
                }
            } message: { error in
                Text(error.localizedDescription)
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
    ContentView(selectedTab: .constant(.search))
        .environment(UserSettings())
        .environment(model)
        .environment(ShazamMatcher(searchModel: model))
}
