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

    @Namespace private var heroNamespace
    @State private var phase: SearchPhase = .home
    @State private var searchURL: String = ""
    @State private var linkCopied = false
    /// The last result, kept after returning home so the results content and artwork
    /// can animate out intact rather than emptying mid-transition.
    @State private var displayedResult: ResultsModel?
    /// URL shown in the compact bar, captured on entering results so clearing
    /// `searchURL` on the way home doesn't swap the text mid-transition.
    @State private var resultsURLText: String = ""
    /// URL bar slot bottoms in the morph space; they define the wipe band.
    @State private var wipeEdges: [MorphWipe.Edge: CGFloat] = [:]
    /// Bottom of the screen in the morph space, including the bottom safe area.
    @State private var screenBottom: CGFloat = 0

    /// Pending URL written by SendToSongLinkrIntent or HistoryView; cleared after processing.
    @AppStorage("pendingDeepLinkURL") private var pendingDeepLinkURLString: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()

                // Both layouts stay mounted: the active one's slots position the heroes, and
                // the wipe band (opened by the URL bar rising) uncovers one layout while
                // erasing the other
                SearchBoxView(namespace: heroNamespace, isActive: !phase.isResults, onWipeEdgeChange: updateWipeEdge)
                    .wipeMask(top: wipeBand.top, bottom: wipeBand.bottom, revealsBand: false)

                ResultsView(namespace: heroNamespace, result: displayedResult, isActive: phase.isResults, onWipeEdgeChange: updateWipeEdge, onDismiss: returnHome)
                    .wipeMask(top: wipeBand.top, bottom: wipeBand.bottom, revealsBand: true)
            }
            .coordinateSpace(.morph)
            .onGeometryChange(for: CGFloat.self) { proxy in
                proxy.size.height + proxy.safeAreaInsets.bottom
            } action: { bottom in
                screenBottom = bottom
            }
            // An overlay, not a ZStack sibling: the heroes size themselves from the slots, so
            // they must never be able to size the layouts in return (e.g. a long URL's ideal
            // width widening the ZStack, which widens the slots, which widens the heroes…)
            .overlay { heroLayer }
            // Morph between home and results whenever a search finishes or is cleared
            .onChange(of: searchModel.results?.id) { _, id in
                if id != nil, let results = searchModel.results {
                    linkCopied = false
                    // Swap the (hidden) results content without animation; only the morph animates
                    displayedResult = results
                    resultsURLText = searchURL.isEmpty ? (results.pageUrl?.absoluteString ?? "") : searchURL
                    // Clear the spinner in the same transaction as the morph so it fades
                    // straight into "Share" instead of flashing "Search" first
                    withAnimation(morphAnimation) {
                        searchModel.normalInProgress = false
                        phase = .results(results)
                    }
                    autoOpenIfNeeded(results)
                } else {
                    shazamMatcher.shazamState = .idle
                    withAnimation(morphAnimation) { phase = .home }
                }
            }
            // Handle deep links from the songlinkr:// URL scheme, e.g. the share extension
            .onOpenURL { deepLinkURL in
                searchModel.results = nil
                if let songLink = URL(string: deepLinkURL.absoluteString.replacingOccurrences(of: "songlinkr:", with: "")) {
                    searchURL = songLink.absoluteString
                    makeRequest()
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

    // MARK: Wipe

    /// Results show inside this band and home outside it. The top follows the URL bar's
    /// bottom edge (same spring as the bar). On home the band is closed there, so nothing of
    /// the results peeks between the bar and the actions; on results it runs to the screen's
    /// bottom to include what's beneath the actions.
    private var wipeBand: (top: CGFloat, bottom: CGFloat) {
        guard phase.isResults else {
            let closed = wipeEdges[.homeInput] ?? 0
            return (closed, closed)
        }
        return (wipeEdges[.resultsInput] ?? 0, screenBottom)
    }

    private func updateWipeEdge(_ edge: MorphWipe.Edge, to y: CGFloat) {
        wipeEdges[edge] = y
    }

    // MARK: Heroes

    /// The one instance of each shared element. Each follows whichever layout's slot is
    /// inserted, so a phase change animates its frame while only its content crossfades.
    /// Transparent areas pass touches through to the layouts beneath.
    private var heroLayer: some View {
        ZStack {
            HeroArtView(artworkURL: displayedResult?.artworkURL, showsArtwork: phase.isResults)
                // The artwork sits above the results header, so it needs the swipe itself
                .onSwipeDown { if phase.isResults { returnHome() } }
                .heroFollower(.art, in: heroNamespace)

            InputPillView(
                compact: phase.isResults,
                urlText: $searchURL,
                compactText: resultsURLText,
                onSubmit: makeRequest,
                onClear: returnHome
            )
            .heroFollower(.input, in: heroNamespace)

            ActionButtonRow(
                isResults: phase.isResults,
                shareURL: displayedResult?.pageUrl,
                isSearching: searchModel.normalInProgress,
                searchDisabled: searchURL.isEmpty,
                isShazamListening: shazamMatcher.shazamState == .matching,
                copyConfirmed: linkCopied,
                primaryAction: makeRequest,
                secondaryAction: phase.isResults ? copyLink : toggleShazam
            )
            .heroFollower(.actions, in: heroNamespace)
        }
    }

    // MARK: Actions

    private func makeRequest() {
        guard !searchURL.isEmpty else { return }
        Task {
            withAnimation { searchModel.normalInProgress = true }
            await searchModel.getResults(for: searchURL, with: userSettings)
            // On success the morph clears this in the same transaction as the phase change
            if searchModel.results == nil {
                withAnimation { searchModel.normalInProgress = false }
            }
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
        withAnimation(morphAnimation) { searchURL = "" }
        searchModel.results = nil
    }

    /// Copies the song.link URL and shows a checkmark briefly before reverting to the copy icon.
    private func copyLink() {
        guard let pageURL = displayedResult?.pageUrl else { return }
        UIPasteboard.general.string = pageURL.absoluteString
        withAnimation { linkCopied = true }
        Task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation { linkCopied = false }
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
