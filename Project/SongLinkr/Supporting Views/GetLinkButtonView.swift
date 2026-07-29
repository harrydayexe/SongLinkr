//
//  GetLinkButtonView.swift
//  SongLinkr
//
//  Created by Harry Day on 05/07/2020.
//

import SwiftUI

struct GetLinkButtonView: View {
    let callInProgress: Bool

    var body: some View {
        VStack {
            if !self.callInProgress {
                Label("Search Link", systemImage: "link")
            } else {
                ProgressView("Loading")
            }
        }
    }
}

#Preview {
    @Previewable @State var callInProgress = false

    Button {
        callInProgress.toggle()
    } label: {
        GetLinkButtonView(callInProgress: callInProgress)
    }
    .buttonStyle(.glass)
    .tint(.accentColor)
    .controlSize(.large)
    .keyboardShortcut(.defaultAction)
    .padding()
}
