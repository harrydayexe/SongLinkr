//
//  ActionButtonRow.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

struct ActionButtonRow: View {
    let isResults: Bool
    let isSource: Bool
    let namespace: Namespace.ID
    let primaryAction: () -> Void
    let secondaryAction: () -> Void

    var body: some View {
        HStack {
            Button(action: primaryAction) {
                Label(isResults ? "Share song.link" : "Search",
                      systemImage: isResults ? "square.and.arrow.up" : "magnifyingglass")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        LinearGradient(
                            gradient: .orangeGradient,
                            startPoint: UnitPoint(x: 0.5, y: -0.5),
                            endPoint: .bottom
                        ),
                        in: .capsule
                    )
            }
            .buttonStyle(.plain)
            .matchedGeometryEffect(id: "ctaPrimary", in: namespace, isSource: isSource)
            .shadow(color: .orange.opacity(0.4), radius: 13, y: 5)

            Button(action: secondaryAction) {
                Image(systemName: isResults ? "plus" : "waveform")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.orange)
                    .frame(width: 52, height: 52)
            }
            .frostedPill(in: .circle)
            .matchedGeometryEffect(id: "ctaSecondary", in: namespace, isSource: isSource)
        }
    }
}

#Preview("Expanded") {
    @Previewable @Namespace var morph

    ActionButtonRow(isResults: false, isSource: true, namespace: morph, primaryAction: {}, secondaryAction: {})
}

#Preview("Compacted") {
    @Previewable @Namespace var morph

    ActionButtonRow(isResults: true, isSource: true, namespace: morph, primaryAction: {}, secondaryAction: {})
}
