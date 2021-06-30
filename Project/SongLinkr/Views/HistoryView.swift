//
//  HistoryView.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2021
//  
//
//  Twitter: https://twitter.com/realharryday
//  Github: https://github.com/harryday123
//


import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    
    init(
        viewModel: HistoryViewModel = HistoryViewModel()
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
            ForEach(viewModel.pastMatchedItems, id: \.self) { item in
                Label(item.mediaTitle ?? "", image: "shazam.fill")
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(
            viewModel: HistoryViewModel(
                matchedItemPublisher: MatchedItemStorage.preview.matchedItems.eraseToAnyPublisher()
            )
        )
    }
}
