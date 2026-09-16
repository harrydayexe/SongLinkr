//
//  ResultsView.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

struct ResultsView: View {
    let namespace: Namespace.ID
    let isSource: Bool
    let result: ResultsModel
    /// The searched URL shown in the compact bar at the top.
    var searchURL: String = ""
    var canSaveToLibrary: Bool = false
    var saveConfirmed: Bool = false
    let closeAction: () -> Void
    var saveAction: () -> Void = {}

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                InputPillView(
                    namespace: namespace,
                    isSource: isSource,
                    compact: true,
                    urlText: .constant(searchURL),
                    onClear: closeAction
                )
                .padding(.horizontal, 16)

                ResultsScrollView(namespace: namespace, isSource: isSource, result: result)
            }

            ActionButtonRow(
                isResults: true,
                isSource: isSource,
                namespace: namespace,
                shareURL: result.pageUrl,
                canSaveToLibrary: canSaveToLibrary,
                saveConfirmed: saveConfirmed,
                secondaryAction: saveAction
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            .background {
                LinearGradient(
                    colors: [.clear, Color(.systemGroupedBackground).opacity(0.95)],
                    startPoint: .top,
                    endPoint: UnitPoint(x: 0.5, y: 0.45)
                )
                .padding(.top, -40)
                .ignoresSafeArea(edges: .bottom)
            }
            .zIndex(1)
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace

    ZStack {
        GradientBackground()
        ResultsView(
            namespace: namespace,
            isSource: true,
            result: .previewResults,
            searchURL: "https://open.spotify.com/track/3NivHilTTTs8SQwp51yG0X",
            canSaveToLibrary: true,
            closeAction: {}
        )
    }
}
