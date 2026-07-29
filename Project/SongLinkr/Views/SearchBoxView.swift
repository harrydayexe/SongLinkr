//
//  SearchBoxView.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

struct SearchBoxView: View {
    let namespace: Namespace.ID
    @State private var urlText: String = ""

    @Binding var searchPhase: SearchPhase

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            ArtworkView(size: 92, cornerRadius: 23, showsIcon: true, artworkURL: nil, namespace: namespace)
            TitleBlock(
                title: "SongLinkr",
                subtitle: "Any song. Every platform.",
                titleFont: .largeTitle.bold()
            )
            .padding(.top, 22)
            InputPillView(urlText: $urlText, compact: false, namespace: namespace, onPaste: {}, onClear: {})
                .padding(.top, 36)
            ActionButtonRow(compact: false, namespace: namespace, primaryAction: {}, secondaryAction: {})
                .padding(.top, 16)
            Text("…or identify what’s playing around you")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.top, 14)
            Spacer()
        }
        .padding(.horizontal, 28)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    // TODO: Do this page
                }) {
                    Image(systemName: "gear")
                }
            }
        }
    }
}

#Preview {
    @Previewable @Namespace var morph

    NavigationView {
        SearchBoxView(namespace: morph, searchPhase: .constant(.home))
    }
}
