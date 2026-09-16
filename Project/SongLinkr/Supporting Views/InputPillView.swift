//
//  InputPillView.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

struct InputPillView: View {
    @Binding var urlText: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "link")
                .foregroundStyle(.tertiary)

            TextField("Paste a song link…", text: $urlText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(.URL)
                .submitLabel(.search)

            PasteClearButton(urlText: $urlText)
        }
        .padding(.leading)
        .padding(.trailing, 8)
        .frame(height: 54)
        .frostedPill()
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
