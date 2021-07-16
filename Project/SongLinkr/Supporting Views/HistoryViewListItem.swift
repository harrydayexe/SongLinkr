//
//  HistoryViewListItem.swift
//  SongLinkr
//
//  Created by Harry Day on 30/06/2021
//  
//
//  Twitter: https://twitter.com/realharryday
//  Github: https://github.com/harryday123
//


import SwiftUI

struct HistoryViewListItem: View {
    let item: MatchedItem
    
    var title: String {
        switch (item.mediaTitle, item.mediaArtist) {
            case (nil, nil):
                return ""
            
            case (let x, nil):
                return x!
                
            case (nil, let x):
                return x!
            
            case (let x, let y):
                return "\(x!) - \(y!)"
        }
    }
    
    var body: some View {
        HStack {
            AsyncImage(url: item.mediaArtworkURL) { image in
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .frame(maxHeight: 100)
            } placeholder: {
                // Placeholder view for when image is loading
                ProgressView()
                .aspectRatio(1, contentMode: .fit)
            }
            .accessibility(label: Text("The artwork for the media in the results", comment: "Accessibility label"))
            
            VStack(alignment: .leading) {
                Text(title).bold()
                Text(item.timestamp?.formatted(.dateTime) ?? "")
                Text(item.originURL?.host ?? "").foregroundColor(.secondary)
            }.padding(.leading)
        }
    }
}

struct HistoryViewListItem_Previews: PreviewProvider {
    static var item: MatchedItem {
        let item = MatchedItem(context: PersistenceController.preview.container.viewContext)
        item.isShazamMatch = false
        item.mediaArtist = "Artist Name"
        item.mediaArtworkURL = URL(string: "https://m.media-amazon.com/images/I/51jNytp9pxL._AA500.jpg")
        item.mediaTitle = "Song Title"
        item.originURL = URL(string: "https://songlinkr.harryday.xyz/")
        item.timestamp = Date(timeIntervalSinceNow: TimeInterval(1000))
        return item
    }
    
    static var previews: some View {
        List {
            ForEach(0..<5) { _ in
                HistoryViewListItem(item: item)
            }
        }
    }
}
