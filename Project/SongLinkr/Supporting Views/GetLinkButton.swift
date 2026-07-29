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
        .buttonStyle(.glass)
        .tint(.accentColor)
        .controlSize(.large)
        .keyboardShortcut(.defaultAction)
        .padding()
        .disabled(searchURL == "")
    }
}

#Preview("URL Entered, not in progress") {
    GetLinkButton(searchURL: .constant("Hi"), inProgress: .constant(false), makeRequest: {})
}

#Preview("URL Entered, in progress") {
    GetLinkButton(searchURL: .constant("Hi"), inProgress: .constant(true), makeRequest: {})
}

#Preview("URL Not Entered") {
    GetLinkButton(searchURL: .constant(""), inProgress: .constant(false), makeRequest: {})
}
