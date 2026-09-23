//
//  ResultsScrollView.swift
//  SongLinkr
//
//  Created by Harry Day on 08/08/2026.
//

import SwiftUI

struct ResultsScrollView: View {
    let namespace: Namespace.ID
    var result: ResultsModel?
    var isActive: Bool = true

    var body: some View {
        VStack(spacing: 0) {
            HeroArtSlot(heightFraction: HeroMetrics.artHeightFraction, namespace: namespace, isActive: isActive)
                .padding(.top, 26)

            TitleBlock(
                title: result?.mediaTitle ?? "",
                subtitle: result?.artistName ?? "",
                titleFont: .system(size: 24, weight: .bold),
                subtitleFont: .subheadline
            )
            .padding(.top, 18)

            PlatformList(platforms: result?.response ?? [])
                .contentMargins(.bottom, 100, for: .scrollContent)
                .scrollContentBackground(.hidden)
                // A fresh list per result, so it starts scrolled to the top
                .id(result?.id)
                .padding(.top, 4)
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace

    ZStack {
        GradientBackground()
        ResultsScrollView(namespace: namespace, result: .previewResults)
    }
}
