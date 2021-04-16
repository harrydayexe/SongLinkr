//
//  SongLinkCreditView.swift
//  SongLinkr
//
//  Created by Harry Day on 18/07/2020.
//

import SwiftUI

struct SongLinkCreditView: View {
    var body: some View {
        VStack {
            Text("Powered by Song.Link")
                .font(.headline)
            Button(action: {
                UIApplication.shared.open("https://song.link/")
            }) {
                HStack {
                    Image(systemName: "safari")
                    Text("Visit Song.Link")
                }
            }
        }
        .padding()
    }
}

struct SongLinkCreditView_Previews: PreviewProvider {
    static var previews: some View {
        SongLinkCreditView()
            .previewLayout(.fixed(width: 300, height: 100))
    }
}
