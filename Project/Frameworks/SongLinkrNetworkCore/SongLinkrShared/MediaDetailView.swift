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
    @State private var hasBeenSaved = false
    let artworkURL: URL?
    let mediaTitle: String
    let artistName: String
    var displaySaveButton: Bool = false
    var saveFunction: (@MainActor () async -> Bool)? = nil

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
                    ZStack {
                        ProgressView()
                            .zIndex(1)
                    }
                    .aspectRatio(1, contentMode: .fit)
                }
                .accessibility(label: Text("The artwork for the media in the results", comment: "Accessibility label"))
                Group {
                    Text(mediaTitle)
                        .font(.title).fontWeight(.semibold)
                    Text(artistName)
                        .font(.title2)
                }.padding(.horizontal)

                if displaySaveButton, let saveFunction {
                    Button(action: {
                        Task() {
                            hasBeenSaved = await saveFunction()
                        }
                    }) {
                        if !hasBeenSaved {
                            Label("Add to Shazam Library", systemImage: "plus.circle")
                        } else {
                            Label("Added to Shazam Library", systemImage: "checkmark.circle")
                        }
                    }
                    .tint(.accentColor)
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .disabled(hasBeenSaved)
                }
            }.padding(.bottom)
        }
        .padding(33)
    }
}

#Preview {
    MediaDetailView(
        artworkURL: URL(stringLiteral: "https://m.media-amazon.com/images/I/51jNytp9pxL._AA500.jpg"),
        mediaTitle: "Humble",
        artistName: "Kendrick Lamar",
        displaySaveButton: true,
        saveFunction: { return false }
    ).preferredColorScheme(.dark).padding()
}
