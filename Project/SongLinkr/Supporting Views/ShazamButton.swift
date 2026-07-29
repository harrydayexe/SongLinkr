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
        .controlSize(.large)
        .padding()
        .buttonStyle(.plain)
        .glassEffect(.regular.tint(.blue.opacity(0.3)).interactive(), in: .capsule)
        .disabled(shazamState == .matchFound || shazamState == .finished)
    }
}

// MARK: Preview Code

#Preview("Animation") {
    @Previewable @State var state: ShazamMatcher.ShazamState = .idle

    ShazamButton(shazamState: $state, startShazam: {}, stopShazam: {})
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
                Task { @MainActor in
                    let all = ShazamMatcher.ShazamState.allCases
                    let idx = all.firstIndex(of: state)!
                    state = all[(idx + 1) % all.count]
                }
            }
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
