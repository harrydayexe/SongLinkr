//
//  ColumnControls.swift
//  SongLinkr
//
//  Created by Harry Day on 23/10/2026.
//

import SwiftUI

/// Controls stacked in the status bar column when bars are vertical (iPhone Duo). Drawn above
/// both layouts rather than inside them, so the wipe masks never clip the column.
/// Navigation stays put in both phases; Share and Copy join it on results, replacing the
/// actions row at the bottom of the screen.
struct ColumnControls: View {
    /// The side the system puts vertical bars on.
    let edge: HorizontalEdge
    let isResults: Bool
    var shareURL: URL?
    var copyConfirmed: Bool = false
    var copyAction: () -> Void = {}

    /// Width of the status bar column, which the system reports as that edge's safe area.
    @State private var columnWidth: CGFloat = 0

    var body: some View {
        VStack(spacing: 12) {
            resultActions
                .morphCrossfade(visible: isResults)

            NavigationButtons(axis: .vertical)
        }
        // Centred in the column, like the system places the back button. The overlay ends at
        // the safe area, so negative padding reaches into the column.
        .frame(width: columnWidth)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: edge == .leading ? .bottomLeading : .bottomTrailing)
        .padding(edge == .leading ? .leading : .trailing, -columnWidth)
        .padding(.bottom)
        .onGeometryChange(for: CGFloat.self) { proxy in
            edge == .leading ? proxy.safeAreaInsets.leading : proxy.safeAreaInsets.trailing
        } action: { width in
            columnWidth = width
        }
    }

    private var resultActions: some View {
        GlassButtonGroup(axis: .vertical) {
            Group {
                if let shareURL {
                    ShareLink(item: shareURL) {
                        Image(systemName: "square.and.arrow.up")
                    }
                } else {
                    Button {} label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .disabled(true)
                }
            }
            .frame(minWidth: 44, minHeight: 44)
            .accessibilityLabel(Text("Share song.link", comment: "Button title, shares the universal song.link URL"))

            Button(action: copyAction) {
                Image(systemName: copyConfirmed ? "checkmark" : "doc.on.doc")
                    .contentTransition(.symbolEffect(.replace))
                    .frame(minWidth: 44, minHeight: 44)
            }
            .disabled(shareURL == nil || copyConfirmed)
            .accessibilityLabel(Text("Copy song.link", comment: "Accessibility label for the button that copies the universal song.link URL"))
        }
    }
}
