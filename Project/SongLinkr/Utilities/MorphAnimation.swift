//
//  MorphAnimation.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

/// Moves and resizes the heroes, and drives the wipe between layouts.
let morphAnimation: Animation = .spring(response: 0.55, dampingFraction: 0.85)

/// Hero content swaps in place: the outgoing content clears quickly, then the incoming
/// content fades in, so the two are never readable on top of each other.
enum MorphCrossfade {
    static let fadeOut: Animation = .easeOut(duration: 0.15)
    static let fadeIn: Animation = .easeInOut(duration: 0.25).delay(0.12)
}

extension View {
    /// Hero content that swaps in place. Both states stay mounted so they move with the hero
    /// (content removed mid-flight is frozen where it was); the hidden one ignores touches
    /// and accessibility.
    func morphCrossfade(visible: Bool) -> some View {
        animation(visible ? MorphCrossfade.fadeIn : MorphCrossfade.fadeOut) { content in
            content.opacity(visible ? 1 : 0)
        }
        .allowsHitTesting(visible)
        .accessibilityHidden(!visible)
    }
}
