//
//  GetLinkButton.swift
//  SongLinkr
//
//  Created by Harry Day on 06/07/2020.
//

import Foundation
import SwiftUI

struct GetLinkButton: View {
    @Binding var searchURL: String
    @Binding var inProgress: Bool
    let makeRequest: () -> Void

    var body: some View {
        Button(action: makeRequest) {
            GetLinkButtonView(callInProgress: inProgress)
        }
        .tint(.accentColor)
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .keyboardShortcut(.defaultAction)
        .padding()
        .disabled(searchURL == "")
    }
}

#Preview {
    GetLinkButton(searchURL: .constant("Hi"), inProgress: .constant(false), makeRequest: {})
}
