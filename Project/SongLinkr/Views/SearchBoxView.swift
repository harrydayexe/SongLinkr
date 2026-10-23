//
//  SearchBoxView.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

/// Home layout. Reserves slots for the hero elements (drawn by `HomeScreen`) and owns
/// the content that only exists on home. Stays mounted while results are shown; the
/// wipe mask in `HomeScreen` erases and reveals it.
struct SearchBoxView: View {
    let namespace: Namespace.ID
    var isActive: Bool
    var onWipeEdgeChange: (MorphWipe.Edge, CGFloat) -> Void

    private var metrics = HeroMetrics()

    /// Set when bars sit in a column beside the content (iPhone Duo), nil when they run along the top.
    @Environment(\.verticalBarEdge) private var verticalBarEdge

    init(namespace: Namespace.ID, isActive: Bool = true, onWipeEdgeChange: @escaping (MorphWipe.Edge, CGFloat) -> Void = { _, _ in }) {
        self.namespace = namespace
        self.isActive = isActive
        self.onWipeEdgeChange = onWipeEdgeChange
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                HeroArtSlot(heightFraction: HeroMetrics.logoHeightFraction, namespace: namespace, isActive: isActive)
                TitleBlock(
                    title: "SongLinkr",
                    subtitle: String(localized: "Any song. Every platform.", comment: "Tagline under the app name on the home screen"),
                    titleFont: .system(size: 28, weight: .bold),
                    subtitleFont: .subheadline
                )
                .padding(.top, 22)
            }
            .frame(maxHeight: .infinity)

            Color.clear
                .frame(height: metrics.inputHeight)
                .frame(maxWidth: metrics.homeControlsMaxWidth)
                .heroSlot(.input, in: namespace, isActive: isActive)
                .wipeEdge(.homeInput, onChange: onWipeEdgeChange)
                .padding(.top, 36)

            VStack(spacing: 0) {
                Color.clear
                    .frame(height: metrics.actionsHeight)
                    .frame(maxWidth: metrics.homeControlsMaxWidth)
                    .heroSlot(.actions, in: namespace, isActive: isActive)
                    .padding(.top, 16)

                Text("…or identify what’s playing around you", comment: "Hint under the search button pointing at the Shazam button")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top, 14)

                Spacer(minLength: 0)
            }
            .frame(maxHeight: .infinity)
        }
        // The capped slots no longer fill the width, so stretch the layout explicitly to
        // keep the navigation buttons overlay pinned to the screen's corner
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 28)
        .overlay(alignment: .topTrailing) {
            // With vertical bars, HomeScreen puts these in the status bar column instead
            if verticalBarEdge == nil {
                NavigationButtons()
                    .padding(.trailing)
                    // Sits above the URL bar's resting place, so it fades rather than being wiped
                    .morphCrossfade(visible: isActive)
            }
        }
        .allowsHitTesting(isActive)
        .accessibilityHidden(!isActive)
    }
}

#Preview {
    @Previewable @Namespace var morph

    NavigationStack {
        ZStack {
            GradientBackground()
            SearchBoxView(namespace: morph)
        }
    }
}
