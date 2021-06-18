//
//  MediaDetailView.swift
//  SongLinkr
//
//  Created by Harry Day on 15/06/2021
//  
//
//  Twitter: https://twitter.com/realharryday
//  Github: https://github.com/harryday123
//


import SwiftUI

struct MediaDetailView: View {
    let artworkURL: URL?
    let mediaTitle: String
    let artistName: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
                .makeSkeumorphic()

            VStack {
                AsyncImage(url: artworkURL) { image in
                    image
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .padding()
                } placeholder: {
                    // Placeholder view for when image is loading
                    ZStack {
                        // Standard progress view
                        ProgressView()
                            .zIndex(1)
                    }
                    .aspectRatio(1, contentMode: .fit)
                }
                .accessibility(label: Text("The artwork for the song or album results are shown for"))
                Text(mediaTitle)
                    .font(.title).fontWeight(.semibold)
                Text(artistName)
                    .font(.title2)
                    .padding(.bottom)
            }
        }
        .padding(33)
    }
}

struct MediaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MediaDetailView(
            artworkURL: URL(stringLiteral: "https://m.media-amazon.com/images/I/418XoY1l0PL._AA500.jpg"),
            mediaTitle: "Kitchen",
            artistName: "Kid Cudi"
        ).padding()
    }
}