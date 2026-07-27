//
//  ShazamButton.swift
//  SongLinkr
//
//  Created by Harry Day on 20/06/2021
//

import SwiftUI

struct ShazamButton: View {
    @Binding var shazamState: ShazamMatcher.ShazamState
    let startShazam: () -> Void
    let stopShazam: () -> Void

    var body: some View {
        Button(action: {
            if shazamState == .matching {
                stopShazam()
            } else {
                startShazam()
            }
        }) {
            switch shazamState {
            case .idle:
                Label("Match with Shazam", image: "shazam.fill")

            case .matching:
                ProgressView("Listening")
                    .tint(.secondary)

            case .matchFound:
                ProgressView("Shazam Match Found")
                    .tint(.secondary)

            case .finished:
                Label("Matches Found", systemImage: "checkmark.icloud")
            }
        }
        .tint(.blue)
        .buttonStyle(.bordered)
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .disabled(shazamState == .matchFound || shazamState == .finished)
    }
}

#Preview("Idle") {
    ShazamButton(shazamState: .constant(.idle), startShazam: {}, stopShazam: {})
}

#Preview("Matching") {
    ShazamButton(shazamState: .constant(.matching), startShazam: {}, stopShazam: {})
}

#Preview("Match Found") {
    ShazamButton(shazamState: .constant(.matchFound), startShazam: {}, stopShazam: {})
}

#Preview("Finished") {
    ShazamButton(shazamState: .constant(.finished), startShazam: {}, stopShazam: {})
}
