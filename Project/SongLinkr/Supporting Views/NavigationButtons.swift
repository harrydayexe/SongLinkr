//
//  NavigationButtons.swift
//  SongLinkr
//
//  Created by Harry Day on 23/10/2026.
//

import SwiftUI

/// History and Settings. Part of the layout rather than the toolbar: removing toolbar
/// items collapses the navigation bar, shifting the safe area mid-morph.
struct NavigationButtons: View {
    /// Horizontal beside the URL bar; vertical in a side status bar column (iPhone Duo).
    var axis: Axis = .horizontal

    var body: some View {
        GlassButtonGroup(axis: axis) {
            NavigationLink(value: AppDestination.history) {
                Image(systemName: "clock")
                    .frame(minWidth: 44, minHeight: 44)
            }
            .accessibilityLabel(Text("History", comment: "Accessibility label for the history button"))

            NavigationLink(value: AppDestination.settings) {
                Image(systemName: "slider.horizontal.3")
                    .frame(minWidth: 44, minHeight: 44)
            }
            .accessibilityLabel(Text("Settings", comment: "Accessibility label for the settings button"))
        }
    }
}

/// Icon buttons sharing one glass capsule, laid out along `axis`.
struct GlassButtonGroup<Content: View>: View {
    var axis: Axis = .horizontal
    @ViewBuilder var content: Content

    var body: some View {
        let layout = axis == .horizontal ? AnyLayout(HStackLayout(spacing: 0)) : AnyLayout(VStackLayout(spacing: 0))

        layout { content }
            .buttonStyle(.plain)
            .foregroundStyle(.primary)
            .padding(axis == .horizontal ? .horizontal : .vertical, 4)
            .glassEffect(.regular.interactive(), in: .capsule)
    }
}
