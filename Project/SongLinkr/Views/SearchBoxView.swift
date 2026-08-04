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

            InputPillView(urlText: $urlText, compact: false, namespace: namespace, onPaste: {}, onClear: {})
                .padding(.top, 36)

            VStack(spacing: 0) {
                ActionButtonRow(compact: false, namespace: namespace, primaryAction: {}, secondaryAction: {})
                    .padding(.top, 16)
                Spacer()
            }
            .frame(maxHeight: .infinity)
        }
        .padding(.horizontal, 28)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView()
                } label: {
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
    .environment(UserSettings())
}
