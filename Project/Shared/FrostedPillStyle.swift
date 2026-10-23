//
//  FrostedPillStyle.swift
//  SongLinkr
//
//  Created by Harry Day on 08/08/2026.
//

import SwiftUI

struct FrostedPillStyle<S: InsettableShape>: ViewModifier {
    var shape: S
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .background {
                shape
                    .fill(colorScheme == .dark
                        ? Color(white: 0.5).opacity(0.22)
                        : Color.white.opacity(0.62))
                    .background(.ultraThinMaterial, in: shape)
                    .overlay {
                        shape.strokeBorder(
                            colorScheme == .dark
                                ? Color.white.opacity(0.12)
                                : Color.black.opacity(0.06),
                            lineWidth: 0.5
                        )
                    }
                    .shadow(color: .black.opacity(colorScheme == .dark ? 0 : 0.07),
                            radius: 6, y: 3)
            }
    }
}

extension View {
    /// Frosted pill surface (adaptive light/dark). Pass a shape for non-capsules,
    /// e.g. `.frostedPill(in: Circle())` for round icon buttons.
    func frostedPill(in shape: some InsettableShape = Capsule()) -> some View {
        modifier(FrostedPillStyle(shape: shape))
    }
}
