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
    let shareAction: () -> Void

    var body: some View {
        VStack {
            ArtworkView(size: 190, cornerRadius: 24, artworkURL: result.artworkURL, namespace: namespace)
                .padding()

            TitleBlock(title: result.mediaTitle, subtitle: result.artistName, subtitleFont: .subheadline)
                .padding(.bottom)

            PlatformList(platforms: result.response).contentMargins(.bottom, 100, for: .scrollContent)
                .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace

    ResultsScrollView(namespace: namespace, isSource: true, result: .previewResults, shareAction: {})
}
