//
//  InputPillView.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

struct InputPillView: View {
    @Binding var urlText: String

    let compact: Bool
    let namespace: Namespace.ID
    let onPaste: () -> Void
    let onClear: () -> Void

    @FocusState private var focused: Bool

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
                }
                .buttonStyle(.glass)
            } else {
                TextField("Paste a song link…", text: $urlText)
                    .focused($focused)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.URL)
                    .submitLabel(.search)
                Group {
                    if urlText.isEmpty {
                        Button(action: onPaste) {
                            Image(systemName: "document.on.clipboard")
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        Button(action: onClear) {
                            Image(systemName: "xmark")
                        }
                        .buttonStyle(.glass)
                    }
                }
            }
        }
        .padding(.leading, 18)
        .padding(.trailing, 8)
        .frame(height: compact ? 46 : 54)
        .glassEffect(.regular, in: .capsule)
        .matchedGeometryEffect(id: "input", in: namespace)
    }
}

#Preview("No Input") {
    @Previewable @FocusState var inputFocused: Bool
    @Previewable @Namespace var morph

    InputPillView(urlText: .constant(""), compact: false, namespace: morph, onPaste: {}, onClear: {})
}

#Preview("Some Input") {
    @Previewable @FocusState var inputFocused: Bool
    @Previewable @Namespace var morph

    InputPillView(urlText: .constant("https://music.apple.com/gb/album/better-than-yours/1812078323?i=1812078931"), compact: false, namespace: morph, onPaste: {}, onClear: {})
}

#Preview("Compacted") {
    @Previewable @FocusState var inputFocused: Bool
    @Previewable @Namespace var morph

    InputPillView(
        urlText: .constant("https://music.apple.com/gb/album/better-than-yours/1812078323?i=1812078931"),
        compact: true,
        namespace: morph,
        onPaste: {},
        onClear: {}
    )
}
