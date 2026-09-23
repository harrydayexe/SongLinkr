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
                .heroSlot(.input, in: namespace, isActive: isActive)
                .wipeEdge(.homeInput, onChange: onWipeEdgeChange)
                .padding(.top, 36)

            VStack(spacing: 0) {
                Color.clear
                    .frame(height: metrics.actionsHeight)
                    .heroSlot(.actions, in: namespace, isActive: isActive)
                    .wipeEdge(.homeActions, onChange: onWipeEdgeChange)
                    .padding(.top, 16)

                Text("…or identify what’s playing around you", comment: "Hint under the search button pointing at the Shazam button")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top, 14)

                Spacer(minLength: 0)
            }
            .frame(maxHeight: .infinity)
        }
        .padding(.horizontal, 28)
        .overlay(alignment: .topTrailing) {
            navigationButtons
                .padding(.trailing)
                // Sits above the URL bar's resting place, so it fades rather than being wiped
                .morphCrossfade(visible: isActive)
        }
        .allowsHitTesting(isActive)
        .accessibilityHidden(!isActive)
    }

    /// History and Settings. Part of the layout rather than the toolbar: removing toolbar
    /// items collapses the navigation bar, shifting the safe area mid-morph.
    private var navigationButtons: some View {
        HStack(spacing: 0) {
            NavigationLink {
                HistoryView()
            } label: {
                Image(systemName: "clock")
                    .frame(minWidth: 44, minHeight: 44)
            }
            .accessibilityLabel(Text("History", comment: "Accessibility label for the history button"))

            NavigationLink {
                SettingsView()
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .frame(minWidth: 44, minHeight: 44)
            }
            .accessibilityLabel(Text("Settings", comment: "Accessibility label for the settings button"))
        }
        .buttonStyle(.plain)
        .foregroundStyle(.primary)
        .padding(.horizontal, 4)
        .glassEffect(.regular.interactive(), in: .capsule)
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
