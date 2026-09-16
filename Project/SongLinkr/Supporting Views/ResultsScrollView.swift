//
//  ResultsScrollView.swift
//  SongLinkr
//
//  Created by Harry Day on 08/08/2026.
//

import SwiftUI

struct ResultsScrollView: View {
    let namespace: Namespace.ID
    let isSource: Bool
    let result: ResultsModel

    var body: some View {
        VStack(spacing: 0) {
            ArtworkView(size: 190, cornerRadius: 24, artworkURL: result.artworkURL, namespace: namespace, isSource: isSource)
                .padding(.top, 26)

            TitleBlock(
                title: result.mediaTitle,
                subtitle: result.artistName,
                titleFont: .system(size: 24, weight: .bold),
                subtitleFont: .subheadline
            )
            .padding(.top, 18)

            PlatformList(platforms: result.response)
                .contentMargins(.bottom, 100, for: .scrollContent)
                .scrollContentBackground(.hidden)
                .padding(.top, 4)
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace

    ZStack {
        GradientBackground()
        ResultsScrollView(namespace: namespace, isSource: true, result: .previewResults)
    }
}
