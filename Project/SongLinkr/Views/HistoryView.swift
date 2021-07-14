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
        NavigationView {
            List {
                ForEach(viewModel.pastMatchedItems, id: \.self) { item in
                    HistoryViewListItem(item: item)
                        .swipeActions {
                            // Delete button
                            Button(
                                role: .destructive
                            ) {
                                viewModel.deleteItem(with: item.originURL)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                            // Search the link again
                            Button(action: {
                                guard let URLString = item.originURL?.absoluteString else {
                                    print("Could not Open")
                                    #warning("Fix this")
                                    return
                                }
                                
                                UIApplication.shared.open(URL(string: "songlinkr:\(URLString)")!)
                            }) {
                                Label("Search Again", systemImage: "magnifyingglass.circle")
                            }.tint(.accentColor)
                        }
                }
                .onDelete(perform: viewModel.deleteItem(at:))
            }
            .toolbar {
                EditButton()
            }
        .navigationTitle(Text("History"))
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HistoryView(viewModel: historyViewModel)
        }
    }
}

extension PreviewProvider {
    static var historyViewModel: HistoryViewModel {
        HistoryViewModel(
            matchedItemPublisher: MatchedItemStorage.shared.matchedItems.eraseToAnyPublisher()
        )
    }
}
