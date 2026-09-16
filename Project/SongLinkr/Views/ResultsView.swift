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
    let shareAction: () -> Void

    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                ResultsScrollView(namespace: namespace, isSource: isSource, result: result, shareAction: shareAction)

                ActionButtonRow(isResults: true, isSource: isSource, namespace: namespace, primaryAction: shareAction, secondaryAction: {})
                    .padding()
                    .zIndex(1)
            }
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace

    ResultsView(namespace: namespace, isSource: true, result: .previewResults, shareAction: {})
}
