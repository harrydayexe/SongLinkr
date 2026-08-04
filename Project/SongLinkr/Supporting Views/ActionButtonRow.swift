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
            .matchedGeometryEffect(id: "ctaPrimary", in: namespace)
            .shadow(color: .orange.opacity(0.4), radius: 13, y: 5)

            Button(action: secondaryAction) {
                Image(systemName: compact ? "plus" : "waveform")
                    .font(.title3.weight(.bold))
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
