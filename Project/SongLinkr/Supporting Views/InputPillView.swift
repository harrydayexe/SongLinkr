//
//  InputPillView.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

struct InputPillView: View {
    @Binding var urlText: String

    @FocusState private var focused: Bool
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "link")
                .foregroundStyle(.tertiary)

            TextField("Paste a song link…", text: $urlText)
                .focused($focused)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(.URL)
                .submitLabel(.search)

            ZStack {
                if urlText.isEmpty {
                    PasteButton(payloadType: URL.self) { urls in
                        if let url = urls.first {
                            urlText = url.absoluteString
                        }
                    }
                    .buttonBorderShape(.circle)
                    .labelStyle(.iconOnly)
                    .transition(.opacity.combined(with: .scale(scale: 0.7)))
                } else {
                    Button(action: {
                        urlText = ""
                    }) {
                        Image(systemName: "xmark")
                            .font(.footnote.weight(.bold))
                    }
                    .buttonBorderShape(.circle)
                    .buttonStyle(.bordered)
                    .foregroundStyle(.secondary)
                    .transition(.opacity.combined(with: .scale(scale: 0.7)))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: urlText.isEmpty)
        }
        .padding(.leading)
        .padding(.trailing, 8)
        .frame(height: 54)
        .frostedPill()
        .animation(.easeInOut(duration: 0.15), value: urlText.isEmpty)
    }
}

#Preview("Animation") {
    @Previewable @State var inputText = ""

    InputPillView(urlText: $inputText)
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
    InputPillView(urlText: .constant(""))
}

#Preview("Some Input") {
    InputPillView(urlText: .constant("https://music.apple.com/gb/album/better-than-yours/1812078323?i=1812078931"))
}
