//
//  InputPillView.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

/// Shared element "input": centered input pill on the home screen morphs into
/// the compact URL bar docked at the top of the results screen.
struct InputPillView: View {
    let namespace: Namespace.ID
    let isSource: Bool
    var compact: Bool = false
    @Binding var urlText: String
    var onSubmit: () -> Void = {}
    var onClear: () -> Void = {}

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "link")
                .foregroundStyle(.tertiary)

            if compact {
                Text(urlText)
                    .font(.subheadline)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button(action: onClear) {
                    Image(systemName: "xmark")
                        .font(.footnote.weight(.bold))
                }
                .buttonBorderShape(.circle)
                .buttonStyle(.bordered)
                .foregroundStyle(.secondary)
            } else {
                TextField("Paste a song link…", text: $urlText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.URL)
                    .submitLabel(.search)
                    .onSubmit(onSubmit)

                PasteClearButton(urlText: $urlText)
            }
        }
        .padding(.leading)
        .padding(.trailing, 8)
        .frame(height: compact ? 46 : 54)
        .frostedPill()
        .matchedGeometryEffect(id: "input", in: namespace, isSource: isSource)
    }
}

#Preview("Animation") {
    @Previewable @State var inputText = ""
    @Previewable @Namespace var morph

    InputPillView(namespace: morph, isSource: true, urlText: $inputText)
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(2))
                if inputText.isEmpty {
                    inputText = "https://music.apple.com/gb/album/better-than-yours/1812078323?i=1812078931"
                } else {
                    inputText = ""
                }
            }
        }
}

#Preview("No Input") {
    @Previewable @Namespace var morph
    InputPillView(namespace: morph, isSource: true, urlText: .constant(""))
}

#Preview("Compact") {
    @Previewable @Namespace var morph
    InputPillView(namespace: morph, isSource: true, compact: true, urlText: .constant("https://music.apple.com/gb/album/better-than-yours/1812078323?i=1812078931"))
        .padding(.horizontal)
}
