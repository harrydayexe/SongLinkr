//
//  SearchBoxView.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

struct SearchBoxView: View {
    let namespace: Namespace.ID
    let isSource: Bool
    let searchAction: () -> Void
    @State private var urlText: String = ""

    @Binding var searchPhase: SearchPhase

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Spacer()
                SongLinkrLogoView(size: 92, cornerRadius: 23, namespace: namespace)
                TitleBlock(
                    title: "SongLinkr",
                    subtitle: "Any song. Every platform.",
                    titleFont: .largeTitle.bold()
                )
                .padding(.top, 22)
            }
            .frame(maxHeight: .infinity)

            InputPillView(urlText: $urlText)
                .padding(.top, 36)

            VStack(spacing: 0) {
                ActionButtonRow(isResults: false, isSource: isSource, namespace: namespace, primaryAction: searchAction, secondaryAction: {})
                    .padding(.top, 16)
                Spacer()
            }
            .frame(maxHeight: .infinity)
        }
        .padding(.horizontal, 28)
    }
}

#Preview {
    @Previewable @Namespace var morph

    NavigationView {
        SearchBoxView(namespace: morph, isSource: true, searchAction: {}, searchPhase: .constant(.home))
    }
    .environment(UserSettings())
}
