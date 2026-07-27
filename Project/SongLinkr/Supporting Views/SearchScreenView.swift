//
//  SearchScreenView.swift
//  SongLinkr
//
//  Created by Harry Day on 20/06/2021
//

import SwiftUI

struct SearchScreenView: View {
    @Binding var searchURL: String
    @Binding var shazamInProgress: ShazamMatcher.ShazamState
    @Binding var normalInProgress: Bool
    let makeRequest: () -> Void
    let startShazam: () -> Void
    let stopShazam: () -> Void

    var body: some View {
        VStack {
            Spacer()
            MainTextView(searchURL: $searchURL)
            GetLinkButton(searchURL: $searchURL, inProgress: $normalInProgress, makeRequest: makeRequest)
            ShazamButton(shazamState: $shazamInProgress, startShazam: startShazam, stopShazam: stopShazam)
            Spacer()
        }
    }
}

#Preview {
    SearchScreenView(
        searchURL: .constant(""),
        shazamInProgress: .constant(.idle),
        normalInProgress: .constant(false),
        makeRequest: {},
        startShazam: {},
        stopShazam: {}
    )
}
