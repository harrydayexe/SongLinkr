//
//  HeroElement.swift
//  SongLinkr
//
//  Created by Harry Day on 23/09/2026.
//

import SwiftUI

/// Shared elements that morph between the home and results layouts.
///
/// Each element is rendered exactly once, in `HomeScreen`'s hero layer. Both layouts stay
/// mounted and reserve space for it with `heroSlot(_:in:isActive:)`; the hero follows the
/// active slot via `heroFollower(_:in:)`. Switching the active layout therefore animates a
/// single view's frame; only the content inside it crossfades.
enum HeroElement: Hashable {
    /// The SongLinkr logo on home, the artwork on results.
    case art
    /// The URL text field on home, the compact URL bar on results.
    case input
    /// Search + Shazam on home, Share + save to library on results.
    case actions
}

/// Registers the slot only while active. Toggling inserts one slot and removes the other in
/// the same transaction, which is what matchedGeometryEffect interpolates cleanly; flipping
/// ids or `isSource` on persistent slots distorts the hero's size mid-flight.
private struct HeroSlotModifier: ViewModifier {
    let element: HeroElement
    let namespace: Namespace.ID
    let isActive: Bool

    func body(content: Content) -> some View {
        if isActive {
            content.matchedGeometryEffect(id: element, in: namespace, isSource: true)
        } else {
            content
        }
    }
}

extension View {
    /// Publishes this view's frame as the destination for `element` while `isActive`.
    /// Only one slot per element may be active at a time; switching which one is active
    /// inside an animation moves the hero. Apply to layout-only views (e.g. `Color.clear`),
    /// as toggling replaces the view.
    func heroSlot(_ element: HeroElement, in namespace: Namespace.ID, isActive: Bool = true) -> some View {
        modifier(HeroSlotModifier(element: element, namespace: namespace, isActive: isActive))
    }

    /// Sizes and positions this view to match the active slot for `element`.
    ///
    /// The matched size is proposed to the content, so the content must be flexible
    /// (no fixed `.frame(width:height:)` inside) for size changes to animate.
    func heroFollower(_ element: HeroElement, in namespace: Namespace.ID) -> some View {
        matchedGeometryEffect(id: element, in: namespace, isSource: false)
    }
}

/// Sizes shared by the hero slots, kept in one place so both layouts agree.
struct HeroMetrics: DynamicProperty {
    @ScaledMetric(relativeTo: .body) var inputHeight: CGFloat = 54
    @ScaledMetric(relativeTo: .subheadline) var compactInputHeight: CGFloat = 46
    @ScaledMetric(relativeTo: .headline) var actionsHeight: CGFloat = 52

    /// Logo height as a fraction of the screen's usable height on home.
    static let logoHeightFraction: CGFloat = 0.11
    /// Artwork height as a fraction of the screen's usable height on results.
    static let artHeightFraction: CGFloat = 0.22
    /// Constant radius, so the square reads as an app icon when small and as artwork when large.
    static let artCornerRadius: CGFloat = 24
}

/// Square slot for the `.art` hero, sized relative to the screen's usable height.
struct HeroArtSlot: View {
    let heightFraction: CGFloat
    let namespace: Namespace.ID
    var isActive: Bool = true

    var body: some View {
        Color.clear
            .aspectRatio(1, contentMode: .fit)
            .heroSlot(.art, in: namespace, isActive: isActive)
            .containerRelativeFrame(.vertical) { height, _ in height * heightFraction }
    }
}
