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
    /// The selected tab
    @Binding var selectedTab: Int
    
    /// The View model for the view
    @StateObject private var viewModel = HistoryViewModel()
    
    init(
        selectedTab: Binding<Int>,
        viewModel: HistoryViewModel = HistoryViewModel()
    ) {
        _selectedTab = selectedTab
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    /// The matched items from shazam
    private var shazamItems: [MatchedItem] {
        viewModel.pastMatchedItems.filter({ $0.isShazamMatch })
    }
    
    /// The matched items not from shazam
    private var nonShazamItems: [MatchedItem] {
        viewModel.pastMatchedItems.filter({ !$0.isShazamMatch })
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Shazam Matches")) {
                    ForEach(shazamItems, id: \.self) { item in
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
                                    
                                    // Open the link
                                    UIApplication.shared.open(URL(string: "songlinkr:\(URLString)")!)
                                    // Switch to the right tab
                                    selectedTab = 0
                                }) {
                                    Label("Search Again", systemImage: "magnifyingglass.circle")
                                }.tint(.accentColor)
                            }
                    }
                    .onDelete(perform: viewModel.deleteShazamItem(at:))
                }.headerProminence(.increased)
                
                Section(header: Text("URL Matches")) {
                    ForEach(nonShazamItems, id: \.self) { item in
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
                                    
                                    // Open the link
                                    UIApplication.shared.open(URL(string: "songlinkr:\(URLString)")!)
                                    // Switch to the right tab
                                    selectedTab = 0
                                }) {
                                    Label("Search Again", systemImage: "magnifyingglass.circle")
                                }.tint(.accentColor)
                            }
                    }
                    .onDelete(perform: viewModel.deleteNonShazamItem(at:))
                }.headerProminence(.increased)
            }
            .listStyle(.insetGrouped)
            .toolbar {
                EditButton()
            }
            .navigationTitle(Text("History"))
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(selectedTab: .constant(1), viewModel: historyViewModel)
    }
}

extension PreviewProvider {
    static var historyViewModel: HistoryViewModel {
        HistoryViewModel(
            matchedItemPublisher: MatchedItemStorage.shared.matchedItems.eraseToAnyPublisher()
        )
    }
}
