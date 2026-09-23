//
//  HomeScreen.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

struct HomeScreen: View {
    @Environment(SearchModel.self) private var searchModel
    @Environment(ShazamMatcher.self) private var shazamMatcher
    @Environment(UserSettings.self) private var userSettings
    @Environment(\.openURL) private var openURL

    @Namespace private var morphNamespace
    @State private var phase: SearchPhase = .home
    @State private var searchURL: String = ""
    @State private var savedToShazamLibrary = false

    /// Pending URL written by SendToSongLinkrIntent or HistoryView; cleared after processing.
    @AppStorage("pendingDeepLinkURL") private var pendingDeepLinkURLString: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()

                if case .results(let result) = phase {
                    ResultsView(
                        namespace: morphNamespace,
                        isSource: phase.isResults,
                        result: result,
                        searchURL: searchURL.isEmpty ? (result.pageUrl?.absoluteString ?? "") : searchURL,
                        canSaveToLibrary: result.isFromShazam && !userSettings.saveToShazamLibrary,
                        saveConfirmed: savedToShazamLibrary,
                        closeAction: returnHome,
                        saveAction: saveToShazamLibrary
                    )
                    .transition(.opacity)
                    // Explicit zIndex keeps the outgoing screen above the background while it
                    // transitions out; without it the ZStack draws it behind and it vanishes
                    .zIndex(1)
                } else {
                    SearchBoxView(
                        namespace: morphNamespace,
                        isSource: !phase.isResults,
                        urlText: $searchURL,
                        isSearching: searchModel.normalInProgress,
                        isShazamListening: shazamMatcher.shazamState == .matching,
                        searchAction: makeRequest,
                        shazamAction: toggleShazam
                    )
                    .transition(.opacity)
                    .zIndex(1)
                }
            }
            .toolbar {
                if !phase.isResults {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            HistoryView()
                        } label: {
                            Image(systemName: "clock")
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                        }
                    }
                }
            }
            // Morph between home and results whenever a search finishes or is cleared
            .onChange(of: searchModel.results?.id) { _, id in
                if id != nil, let results = searchModel.results {
                    savedToShazamLibrary = false
                    withAnimation(morphAnimation) { phase = .results(results) }
                    autoOpenIfNeeded(results)
                } else {
                    shazamMatcher.shazamState = .idle
                    withAnimation(morphAnimation) { phase = .home }
                }
            }
            // Handle deep links from the songlinkr:// URL scheme
            .onOpenURL { deepLinkURL in
                searchModel.results = nil
                if let songLink = URL(string: deepLinkURL.absoluteString.replacingOccurrences(of: "songlinkr:", with: "")) {
                    searchURL = songLink.absoluteString
                }
            }
            // Handle URLs queued by SendToSongLinkrIntent or HistoryView via UserDefaults
            .onChange(of: pendingDeepLinkURLString) { _, urlString in
                guard !urlString.isEmpty, let url = URL(string: urlString) else { return }
                searchModel.results = nil
                searchURL = url.absoluteString
                pendingDeepLinkURLString = ""
                makeRequest()
            }
            // Error alert
            .alert(
                searchModel.error?.localizedTitle ?? String(localized: "Something went wrong", comment: "Generic error title"),
                isPresented: Binding(
                    get: { searchModel.error != nil },
                    set: { if !$0 { resetAfterError() } }
                ),
                presenting: searchModel.error
            ) { _ in
                Button(String(localized: "OK"), role: .cancel, action: resetAfterError)
            } message: { error in
                Text(error.localizedDescription)
            }
        }
    }

    // MARK: Actions

    private func makeRequest() {
        guard !searchURL.isEmpty else { return }
        Task {
            searchModel.normalInProgress = true
            await searchModel.getResults(for: searchURL, with: userSettings)
            searchModel.normalInProgress = false
        }
    }

    private func toggleShazam() {
        if shazamMatcher.shazamState == .matching {
            shazamMatcher.stopMatching()
            shazamMatcher.shazamState = .idle
        } else {
            shazamMatcher.startShazamMatch(userSettings: userSettings)
        }
    }

    private func returnHome() {
        searchURL = ""
        searchModel.results = nil
    }

    private func saveToShazamLibrary() {
        Task {
            if await shazamMatcher.saveCachedItem() {
                savedToShazamLibrary = true
            }
        }
    }

    private func resetAfterError() {
        shazamMatcher.shazamState = .idle
        searchModel.normalInProgress = false
        searchModel.error = nil
    }

    private func autoOpenIfNeeded(_ results: ResultsModel) {
        guard userSettings.autoOpen else { return }
        guard searchModel.originEntityID != "shazam" else { return }
        guard !searchModel.originEntityID.contains(userSettings.defaultPlatform.entityName) else { return }
        if let defaultPlatform = results.response.first(where: { $0.id == userSettings.defaultPlatform }) {
            openURL(defaultPlatform.nativeAppUriMobile ?? defaultPlatform.url)
        }
    }
}

#Preview {
    let model = SearchModel()
    HomeScreen()
        .environment(UserSettings())
        .environment(model)
        .environment(ShazamMatcher(searchModel: model))
}
