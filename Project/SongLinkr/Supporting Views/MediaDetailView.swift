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
    let displaySaveButton: Bool
    let saveFunction: @MainActor () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.offWhite)
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
                
                // If the result is from shazam and default save to library is off
                if displaySaveButton {
                    Button(action: {
                        saveFunction()
                    }) {
                        Label("Add to Shazam Library", systemImage: "plus.circle")
                    }
                    // Button Styling
                    .tint(.accentColor)
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
            }.padding(.bottom)
        }
        .padding(33)
    }
}

struct MediaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MediaDetailView(
            artworkURL: URL(stringLiteral: "https://m.media-amazon.com/images/I/51jNytp9pxL._AA500.jpg"),
            mediaTitle: "Humble",
            artistName: "Kendrick Lamar",
            displaySaveButton: false,
            saveFunction: {}
        ).preferredColorScheme(.dark).padding()
    }
}
