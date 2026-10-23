//
//  VerticalBarEdge.swift
//  SongLinkr
//
//  Created by Harry Day on 23/10/2026.
//

import SwiftUI

extension EnvironmentValues {
    /// The side of the screen the system puts vertical bars on, beside the status bar
    /// (iPhone Duo). Nil when bars run along the top and bottom, and before iOS 27.1.
    /// Set by `HomeScreen` from `toolbarVerticalEdge`.
    @Entry var verticalBarEdge: HorizontalEdge? = nil
}

extension View {
    /// Reports the system's vertical bar edge as it changes. Apply inside a navigation
    /// container; that's where the system resolves it.
    func onVerticalBarEdgeChange(perform action: @escaping (HorizontalEdge?) -> Void) -> some View {
        modifier(VerticalBarEdgeReader(action: action))
    }
}

private struct VerticalBarEdgeReader: ViewModifier {
    let action: (HorizontalEdge?) -> Void

    func body(content: Content) -> some View {
        if #available(iOS 27.1, *) {
            content.modifier(SystemVerticalBarEdgeReader(action: action))
        } else {
            content
        }
    }
}

@available(iOS 27.1, *)
private struct SystemVerticalBarEdgeReader: ViewModifier {
    @Environment(\.toolbarVerticalEdge) private var edge
    let action: (HorizontalEdge?) -> Void

    func body(content: Content) -> some View {
        content.onChange(of: edge, initial: true) { _, edge in
            action(edge)
        }
    }
}
