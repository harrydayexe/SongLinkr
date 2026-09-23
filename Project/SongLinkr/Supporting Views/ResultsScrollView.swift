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
    /// Collapses back to the search layout; the same action as the input bar's clear button.
    var onDismiss: () -> Void = {}

    var body: some View {
        PlatformList(platforms: result?.response ?? [])
            .contentMargins(.bottom, 100, for: .scrollContent)
            .scrollContentBackground(.hidden)
            // A fresh list per result, so it starts scrolled to the top
            .id(result?.id)
            // A bar rather than a header stacked above the list: the rows scroll underneath
            // the artwork and title instead of clipping at a hard edge
            .safeAreaBar(edge: .top, spacing: 4) { header }
            // Soft, so the rows stay visible through a progressive blur as they pass behind
            // the header; the automatic style is near-opaque under a bar this tall
            .scrollEdgeEffectStyle(.soft, for: .top)
    }

    private var header: some View {
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
        }
        // The bar otherwise shrinks to the art square, which would leave the swipe target
        // narrower than the list it covers
        .frame(maxWidth: .infinity)
        .contentShape(.rect)
        .onSwipeDown(perform: onDismiss)
    }
}

#Preview {
    @Previewable @Namespace var namespace

    ZStack {
        GradientBackground()
        ResultsScrollView(namespace: namespace, result: .previewResults)
    }
}
