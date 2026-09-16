//
//  ActionButtonRow.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

/// Shared element "cta": Search pill + Shazam circle on the home screen morph
/// into the Share song.link bar + add-to-Shazam-library circle on results.
struct ActionButtonRow: View {
    let isResults: Bool
    let isSource: Bool
    let namespace: Namespace.ID

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
                .matchedGeometryEffect(id: "ctaPrimary", in: namespace, isSource: isSource)
                .shadow(color: .orange.opacity(0.4), radius: 13, y: 5)

            secondaryButton
                .frostedPill(in: .circle)
                .matchedGeometryEffect(id: "ctaSecondary", in: namespace, isSource: isSource)
        }
    }

    // MARK: Primary

    @ViewBuilder
    private var primaryButton: some View {
        if isResults {
            if let shareURL {
                ShareLink(item: shareURL) {
                    primaryLabel(Text("Share song.link", comment: "Button title, shares the universal song.link URL"), systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.plain)
            } else {
                Button {} label: {
                    primaryLabel(Text("Share song.link", comment: "Button title, shares the universal song.link URL"), systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.plain)
                .disabled(true)
                .opacity(0.5)
            }
        } else {
            Button(action: primaryAction) {
                primaryLabel(
                    Text("Search", comment: "Button title, searches for the entered link"),
                    systemImage: "magnifyingglass",
                    showsProgress: isSearching
                )
            }
            .buttonStyle(.plain)
            .disabled(searchDisabled || isSearching)
            .opacity(searchDisabled && !isSearching ? 0.6 : 1)
        }
    }

    private func primaryLabel(_ title: Text, systemImage: String, showsProgress: Bool = false) -> some View {
        ZStack {
            if showsProgress {
                ProgressView()
                    .tint(.white)
            } else {
                Label { title } icon: { Image(systemName: systemImage) }
            }
        }
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

    // MARK: Secondary

    private var secondaryButton: some View {
        Button(action: secondaryAction) {
            Group {
                if isResults {
                    Image(systemName: saveConfirmed ? "checkmark" : "plus")
                } else {
                    Image(systemName: "waveform")
                        .symbolEffect(.variableColor.iterative, isActive: isShazamListening)
                }
            }
            .font(.title3.weight(.bold))
            .foregroundStyle(.orange)
            .frame(width: 52, height: 52)
        }
        .buttonStyle(.plain)
        .disabled(isResults && (!canSaveToLibrary || saveConfirmed))
        .opacity(isResults && !canSaveToLibrary && !saveConfirmed ? 0.4 : 1)
    }
}

#Preview("Home") {
    @Previewable @Namespace var morph

    VStack(alignment: .trailing) {
        Spacer()
        ActionButtonRow(isResults: false, isSource: true, namespace: morph)
    }
    .padding(.horizontal, 28)
}

#Preview("Home — listening") {
    @Previewable @Namespace var morph

    VStack(alignment: .trailing) {
        Spacer()
        ActionButtonRow(isResults: false, isSource: true, namespace: morph, isShazamListening: true)
    }
    .padding(.horizontal, 28)
}

#Preview("Results") {
    @Previewable @Namespace var morph

    VStack(alignment: .trailing) {
        Spacer()
        ActionButtonRow(
            isResults: true,
            isSource: true,
            namespace: morph,
            shareURL: URL(string: "https://song.link/s/3NivHilTTTs8SQwp51yG0X"),
            canSaveToLibrary: true
        )
    }
    .padding(.horizontal, 16)
}
