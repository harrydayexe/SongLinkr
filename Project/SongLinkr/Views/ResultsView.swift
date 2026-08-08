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
            Spacer()
            ActionButtonRow(isResults: true, isSource: isSource, namespace: namespace, primaryAction: shareAction, secondaryAction: {})
                .padding()
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace

    ResultsView(namespace: namespace, isSource: true, result: .previewResults, shareAction: {})
}
