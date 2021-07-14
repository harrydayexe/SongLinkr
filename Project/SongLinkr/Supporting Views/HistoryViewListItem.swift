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
    
    var body: some View {
        HStack {
            AsyncImage(url: item.mediaArtworkURL) { image in
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding()
            } placeholder: {
                // Placeholder view for when image is loading
                ProgressView()
                .aspectRatio(1, contentMode: .fit)
            }
            .accessibility(label: Text("The artwork for the media in the results", comment: "Accessibility label"))
            
            VStack {
                Text(item.mediaTitle ?? "")
                Text(item.mediaArtist ?? "")
                Text(item.timestamp?.formatted(.dateTime) ?? "")
            }
        }.padding()
    }
}

struct HistoryViewListItem_Previews: PreviewProvider {
    static var previews: some View {
        HistoryViewListItem(item: historyViewModel.pastMatchedItems.first!)
    }
}
