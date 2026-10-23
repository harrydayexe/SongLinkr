//
//  SongLinkCreditView.swift
//  SongLinkr
//
//  Created by Harry Day on 18/07/2020.
//

import SwiftUI

struct SongLinkCreditView: View {
    @Environment(\.openURL) private var openURL

    var body: some View {
        Button(action: {
            if let url = URL(string: "https://song.link/") {
                openURL(url)
            }
        }) {
            HStack {
                Image(systemName: "safari")
                Text("Powered by Song.Link", comment: "Acknowledgement to the API used")
                    .font(.headline)
            }
        }
    }
}

#Preview {
    SongLinkCreditView()
}
