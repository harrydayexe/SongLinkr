//
//  ResultsView.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

/// Results layout. Reserves slots for the hero elements (drawn by `HomeScreen`) and owns
/// the content that only exists on results. Stays mounted on home so the wipe mask in
/// `HomeScreen` can uncover it rather than it being inserted.
struct ResultsView: View {
    let namespace: Namespace.ID
    /// The last result shown; kept after returning home so it can be wiped away intact.
    var result: ResultsModel?
    var isActive: Bool
    var onWipeEdgeChange: (MorphWipe.Edge, CGFloat) -> Void

    private var metrics = HeroMetrics()

    init(
        namespace: Namespace.ID,
        result: ResultsModel?,
        isActive: Bool = true,
        onWipeEdgeChange: @escaping (MorphWipe.Edge, CGFloat) -> Void = { _, _ in }
    ) {
        self.namespace = namespace
        self.result = result
        self.isActive = isActive
        self.onWipeEdgeChange = onWipeEdgeChange
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Color.clear
                    .frame(height: metrics.compactInputHeight)
                    .heroSlot(.input, in: namespace, isActive: isActive)
                    .wipeEdge(.resultsInput, onChange: onWipeEdgeChange)
                    .padding(.horizontal)

                ResultsScrollView(namespace: namespace, result: result, isActive: isActive)
            }

            Color.clear
                .frame(height: metrics.actionsHeight)
                .heroSlot(.actions, in: namespace, isActive: isActive)
                .padding(.horizontal)
                .padding(.bottom, 8)
                .background {
                    // Fades the list out beneath the actions hero, which is drawn above this layout
                    LinearGradient(
                        colors: [.clear, Color(.systemGroupedBackground).opacity(0.95)],
                        startPoint: .top,
                        endPoint: UnitPoint(x: 0.5, y: 0.45)
                    )
                    .padding(.top, -40)
                    .ignoresSafeArea(edges: .bottom)
                }
        }
        .allowsHitTesting(isActive)
        .accessibilityHidden(!isActive)
    }
}

#Preview {
    @Previewable @Namespace var namespace

    ZStack {
        GradientBackground()
        ResultsView(namespace: namespace, result: .previewResults)
    }
}
