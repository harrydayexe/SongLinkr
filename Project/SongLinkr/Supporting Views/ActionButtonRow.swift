//
//  ActionButtonRow.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

/// Hero "actions": Search pill + Shazam circle on the home screen morph into the
/// Share song.link bar + add-to-Shazam-library circle on results. Fills whatever size
/// it is given: the circle is as tall as the row and the pill takes the remaining width.
/// The pill and circle surfaces are shared; only their labels crossfade in place.
struct ActionButtonRow: View {
    let isResults: Bool

    /// The song.link page URL shared from the results screen.
    var shareURL: URL?
    var isSearching: Bool = false
    var searchDisabled: Bool = false
    var isShazamListening: Bool = false
    var canSaveToLibrary: Bool = false
    var saveConfirmed: Bool = false

    var primaryAction: () -> Void = {}
    var secondaryAction: () -> Void = {}

    var body: some View {
        HStack(spacing: 12) {
            primaryButton
                .background(
                    LinearGradient(
                        gradient: .orangeGradient,
                        startPoint: UnitPoint(x: 0.5, y: -0.5),
                        endPoint: .bottom
                    ),
                    in: .capsule
                )
                .opacity(primaryDimmed ? 0.6 : 1)
                .shadow(color: .orange.opacity(0.4), radius: 13, y: 5)

            secondaryButton
                .frostedPill(in: .circle)
        }
    }

    private var primaryDimmed: Bool {
        isResults ? shareURL == nil : searchDisabled && !isSearching
    }

    // MARK: Primary

    // Both buttons and all labels stay mounted and swap by opacity, so outgoing content
    // travels with the hero instead of being frozen in place while it's removed
    private var primaryButton: some View {
        ZStack {
            Button(action: primaryAction) {
                primaryLabel {
                    ProgressView()
                        .tint(.white)
                        .morphCrossfade(visible: isSearching)

                    Label {
                        Text("Search", comment: "Button title, searches for the entered link")
                    } icon: {
                        Image(systemName: "magnifyingglass")
                    }
                    .morphCrossfade(visible: !isSearching)
                }
            }
            .buttonStyle(.plain)
            .disabled(searchDisabled || isSearching)
            .morphCrossfade(visible: !isResults)

            shareButton
                .morphCrossfade(visible: isResults)
        }
    }

    @ViewBuilder
    private var shareButton: some View {
        let label = primaryLabel {
            Label {
                Text("Share song.link", comment: "Button title, shares the universal song.link URL")
            } icon: {
                Image(systemName: "square.and.arrow.up")
            }
        }

        if let shareURL {
            ShareLink(item: shareURL) { label }
                .buttonStyle(.plain)
        } else {
            Button {} label: { label }
                .buttonStyle(.plain)
                .disabled(true)
        }
    }

    private func primaryLabel(@ViewBuilder content: () -> some View) -> some View {
        ZStack { content() }
            .foregroundStyle(.white)
            .font(.headline)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(.capsule)
    }

    // MARK: Secondary

    private var secondaryButton: some View {
        Button(action: secondaryAction) {
            ZStack {
                Image(systemName: "waveform")
                    .symbolEffect(.variableColor.iterative, isActive: isShazamListening && !isResults)
                    .morphCrossfade(visible: !isResults)

                Image(systemName: saveConfirmed ? "checkmark" : "plus")
                    .contentTransition(.symbolEffect(.replace))
                    .morphCrossfade(visible: isResults)
            }
            .font(.title3.weight(.bold))
            .foregroundStyle(.orange)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(.circle)
        }
        .buttonStyle(.plain)
        .disabled(isResults && (!canSaveToLibrary || saveConfirmed))
        .opacity(isResults && !canSaveToLibrary && !saveConfirmed ? 0.4 : 1)
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview("Home") {
    VStack {
        Spacer()
        ActionButtonRow(isResults: false)
            .frame(height: 52)
    }
    .padding(.horizontal, 28)
}

#Preview("Home — listening") {
    VStack {
        Spacer()
        ActionButtonRow(isResults: false, isShazamListening: true)
            .frame(height: 52)
    }
    .padding(.horizontal, 28)
}

#Preview("Morph") {
    @Previewable @State var isResults = false

    VStack {
        Spacer()
        ActionButtonRow(
            isResults: isResults,
            shareURL: URL(string: "https://song.link/s/3NivHilTTTs8SQwp51yG0X"),
            canSaveToLibrary: true,
            primaryAction: { withAnimation(morphAnimation) { isResults.toggle() } },
            secondaryAction: { withAnimation(morphAnimation) { isResults.toggle() } }
        )
        .frame(height: 52)
    }
    .padding(.horizontal, isResults ? 16 : 28)
}
