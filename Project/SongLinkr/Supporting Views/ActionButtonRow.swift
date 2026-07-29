//
//  ActionButtonRow.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

struct ActionButtonRow: View {
    var compact: Bool
    var namespace: Namespace.ID
    var primaryAction: () -> Void
    var secondaryAction: () -> Void

    var body: some View {
        HStack(spacing: compact ? 10 : 12) {
            Button(action: primaryAction) {
                Label(compact ? "Share song.link" : "Search",
                      systemImage: compact ? "square.and.arrow.up" : "magnifyingglass")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .tint(.orange)
            .matchedGeometryEffect(id: "ctaPrimary", in: namespace)

            Button(action: secondaryAction) {
                Image(systemName: compact ? "plus" : "waveform")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.orange)
                    .frame(width: 52, height: 52)
            }
            .glassEffect(.regular, in: .circle)
            .matchedGeometryEffect(id: "ctaSecondary", in: namespace)
        }
    }
}

#Preview("Expanded") {
    @Previewable @Namespace var morph

    ActionButtonRow(compact: false, namespace: morph, primaryAction: {}, secondaryAction: {})
}

#Preview("Compacted") {
    @Previewable @Namespace var morph

    ActionButtonRow(compact: true, namespace: morph, primaryAction: {}, secondaryAction: {})
}
