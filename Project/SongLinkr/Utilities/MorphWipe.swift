//
//  MorphWipe.swift
//  SongLinkr
//
//  Created by Harry Day on 23/09/2026.
//

import SwiftUI

/// The home ↔ results wipe. Results content is only visible in the band between the URL bar
/// and the actions row, and home content only outside it. As the bar rises and the actions
/// drop, the band opens and uncovers the results while erasing home; reversing closes it.
///
/// The band's edges are the heroes' centers, animated with the same spring as the heroes, so
/// they stay attached to them and the seams sit beneath their bodies.
enum MorphWipe {
    /// Positions that define the band, measured from the hero slots.
    enum Edge: Hashable {
        case homeInput
        case homeActions
        case resultsInput
    }
}

extension CoordinateSpaceProtocol where Self == NamedCoordinateSpace {
    /// Shared by the layouts' edge measurements and the wipe masks.
    static var morph: Self { .named("morph") }
}

extension View {
    /// Reports this view's vertical center in the morph space as a wipe edge.
    func wipeEdge(_ edge: MorphWipe.Edge, onChange: @escaping (MorphWipe.Edge, CGFloat) -> Void) -> some View {
        onGeometryChange(for: CGFloat.self) { proxy in
            proxy.frame(in: .morph).midY
        } action: { midY in
            onChange(edge, midY)
        }
    }

    /// Masks this view to the inside (`revealsBand`) or outside of the band `top...bottom`,
    /// given in the morph space.
    func wipeMask(top: CGFloat, bottom: CGFloat, revealsBand: Bool) -> some View {
        mask {
            GeometryReader { proxy in
                let originY = proxy.frame(in: .morph).minY
                WipeShape(top: top - originY, bottom: bottom - originY, revealsBand: revealsBand)
            }
        }
    }
}

/// Animatable band so the edges interpolate with the morph rather than jumping.
private nonisolated struct WipeShape: Shape {
    var top: CGFloat
    var bottom: CGFloat
    let revealsBand: Bool

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(top, bottom) }
        set { (top, bottom) = (newValue.first, newValue.second) }
    }

    func path(in rect: CGRect) -> Path {
        // Overdraw by a full height either side so content that extends into the
        // safe areas (e.g. the bottom fade) isn't clipped at the view's bounds
        let minY = rect.minY - rect.height
        let maxY = rect.maxY + rect.height
        let bandTop = min(max(top, minY), maxY)
        let bandBottom = min(max(bottom, bandTop), maxY)

        var path = Path()
        if revealsBand {
            path.addRect(CGRect(x: rect.minX, y: bandTop, width: rect.width, height: bandBottom - bandTop))
        } else {
            path.addRect(CGRect(x: rect.minX, y: minY, width: rect.width, height: bandTop - minY))
            path.addRect(CGRect(x: rect.minX, y: bandBottom, width: rect.width, height: maxY - bandBottom))
        }
        return path
    }
}
