//
//  PasteClearButton.swift
//  SongLinkr
//
//  Created by Harry Day on 08/08/2026.
//
import SwiftUI

struct PasteClearButton: View {
    @Binding var urlText: String

    var body: some View {
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
}
