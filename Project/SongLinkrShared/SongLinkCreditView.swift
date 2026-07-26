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
        VStack {
            Text("Powered by Song.Link", comment: "Acknowledgement to the API used")
                .font(.headline)
            Button(action: {
                if let url = URL(string: "https://song.link/") {
                    openURL(url)
                }
            }) {
                HStack {
                    Image(systemName: "safari")
                    Text("Visit Song.Link", comment: "Text which links to the Song.Link website")
                }
            }
        }
        .padding()
    }
}

#Preview {
    SongLinkCreditView()
}
