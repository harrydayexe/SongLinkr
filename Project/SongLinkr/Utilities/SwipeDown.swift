//
//  SwipeDown.swift
//  SongLinkr
//
//  Created by Harry Day on 23/09/2026.
//

import SwiftUI

/// How far down the finger must travel (or be heading) before the drag counts as a swipe.
private let swipeDownThreshold: CGFloat = 40

extension View {
    /// Calls `action` when the user swipes down over this view.
    ///
    /// Drags that end short, travel upwards, or are mostly horizontal are ignored. The
    /// predicted end position is included so a quick flick counts even if the finger
    /// lifts early.
    func onSwipeDown(perform action: @escaping () -> Void) -> some View {
        gesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    let distance = max(value.translation.height, value.predictedEndTranslation.height)
                    guard distance > swipeDownThreshold,
                          distance > abs(value.translation.width) else { return }
                    action()
                }
        )
    }
}
