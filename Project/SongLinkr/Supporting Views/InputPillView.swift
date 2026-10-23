//
//  InputPillView.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

/// Hero "input": centered input pill on the home screen morphs into the compact URL bar
/// docked at the top of the results screen. Fills whatever size it is given; only the
/// field and trailing button crossfade.
struct InputPillView: View {
    var compact: Bool = false
    @Binding var urlText: String
    /// Text shown in the compact bar; falls back to `urlText`.
    var compactText: String? = nil
    var onSubmit: () -> Void = {}
    var onClear: () -> Void = {}

    @FocusState private var isFieldFocused: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "link")
                .foregroundStyle(.tertiary)

            ZStack(alignment: .leading) {
                TextField("Paste a song link…", text: $urlText)
                    .focused($isFieldFocused)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.URL)
                    .submitLabel(.search)
                    .onSubmit(onSubmit)
                    .morphCrossfade(visible: !compact)

                Text(compactText ?? urlText)
                    .font(.subheadline)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .morphCrossfade(visible: compact)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            ZStack {
                PasteClearButton(urlText: $urlText)
                    .morphCrossfade(visible: !compact)

                Button(action: onClear) {
                    Image(systemName: "xmark")
                        .font(.footnote.weight(.bold))
                }
                .buttonBorderShape(.circle)
                .buttonStyle(.bordered)
                .foregroundStyle(.secondary)
                .morphCrossfade(visible: compact)
            }
        }
        .padding(.leading)
        .padding(.trailing, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frostedPill()
        // The field stays mounted while hidden, so drop focus to dismiss the keyboard
        .onChange(of: compact) { _, isCompact in
            if isCompact { isFieldFocused = false }
        }
    }
}

#Preview("Animation") {
    @Previewable @State var inputText = ""
    @Previewable @State var compact = false

    InputPillView(compact: compact, urlText: $inputText)
        .frame(height: compact ? 46 : 54)
        .padding(.horizontal, compact ? 16 : 28)
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(2))
                if inputText.isEmpty {
                    inputText = "https://music.apple.com/gb/album/better-than-yours/1812078323?i=1812078931"
                } else {
                    withAnimation(morphAnimation) { compact.toggle() }
                    if !compact { inputText = "" }
                }
            }
        }
}

#Preview("No Input") {
    InputPillView(urlText: .constant(""))
        .frame(height: 54)
}

#Preview("Compact") {
    InputPillView(compact: true, urlText: .constant("https://music.apple.com/gb/album/better-than-yours/1812078323?i=1812078931"))
        .frame(height: 46)
        .padding(.horizontal)
}
