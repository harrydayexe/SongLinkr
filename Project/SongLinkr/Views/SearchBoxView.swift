//
//  SearchBoxView.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

struct SearchBoxView: View {
    let namespace: Namespace.ID
    let isSource: Bool
    @Binding var urlText: String
    var isSearching: Bool = false
    var isShazamListening: Bool = false
    let searchAction: () -> Void
    let shazamAction: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Spacer()
                SongLinkrLogoView(size: 92, cornerRadius: 23, namespace: namespace, isSource: isSource)
                TitleBlock(
                    title: "SongLinkr",
                    subtitle: String(localized: "Any song. Every platform.", comment: "Tagline under the app name on the home screen"),
                    titleFont: .system(size: 28, weight: .bold),
                    subtitleFont: .subheadline
                )
                .padding(.top, 22)
            }
            .frame(maxHeight: .infinity)

            InputPillView(
                namespace: namespace,
                isSource: isSource,
                urlText: $urlText,
                onSubmit: searchAction
            )
            .padding(.top, 36)

            VStack(spacing: 0) {
                ActionButtonRow(
                    isResults: false,
                    isSource: isSource,
                    namespace: namespace,
                    isSearching: isSearching,
                    searchDisabled: urlText.isEmpty,
                    isShazamListening: isShazamListening,
                    primaryAction: searchAction,
                    secondaryAction: shazamAction
                )
                .padding(.top, 16)

                Text("…or identify what’s playing around you", comment: "Hint under the search button pointing at the Shazam button")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top, 14)

                Spacer()
            }
            .frame(maxHeight: .infinity)
        }
        .padding(.horizontal, 28)
    }
}

#Preview {
    @Previewable @Namespace var morph

    ZStack {
        GradientBackground()
        SearchBoxView(namespace: morph, isSource: true, urlText: .constant(""), searchAction: {}, shazamAction: {})
    }
    .environment(UserSettings())
}
