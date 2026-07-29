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
    @Binding var selectedTab: AppTab

    /// The View model for the view
    @StateObject private var viewModel = HistoryViewModel()

    /// Pending URL picked up by ContentView to trigger a new search.
    @AppStorage("pendingDeepLinkURL") private var pendingDeepLinkURL: String = ""

    init(
        selectedTab: Binding<AppTab>,
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

    @ViewBuilder
    private func swipeActionsContent(for item: MatchedItem) -> some View {
        Button(role: .destructive) {
            viewModel.deleteItem(with: item.originURL)
        } label: {
            Label("Delete", systemImage: "trash")
        }

        Button {
            guard let urlString = item.originURL?.absoluteString else {
                print("Could not Open")
                #warning("Fix this")
                return
            }
            pendingDeepLinkURL = urlString
            selectedTab = .search
        } label: {
            Label("Search Again", systemImage: "magnifyingglass.circle")
        }
        .tint(.accentColor)
    }

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Shazam Matches")) {
                    ForEach(shazamItems, id: \.self) { item in
                        HistoryViewListItem(item: item)
                            .swipeActions { swipeActionsContent(for: item) }
                    }
                    .onDelete(perform: viewModel.deleteShazamItem(at:))
                }.headerProminence(.increased)

                Section(header: Text("URL Matches")) {
                    ForEach(nonShazamItems, id: \.self) { item in
                        HistoryViewListItem(item: item)
                            .swipeActions { swipeActionsContent(for: item) }
                    }
                    .onDelete(perform: viewModel.deleteNonShazamItem(at:))
                }.headerProminence(.increased)
            }
            .listStyle(.insetGrouped)
            .toolbar {
                EditButton()
            }
            .navigationTitle(Text("History"))
            .toolbarMinimizationBehavior(.onScrollDown, for: .navigationBar)
        }
    }
}

#Preview {
    HistoryView(
        selectedTab: .constant(.history),
        viewModel: HistoryViewModel(
            matchedItemPublisher: MatchedItemStorage.shared.matchedItems.eraseToAnyPublisher()
        )
    )
}
