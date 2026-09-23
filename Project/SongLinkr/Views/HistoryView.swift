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
    @Environment(\.dismiss) private var dismiss

    /// The View model for the view
    @StateObject private var viewModel = HistoryViewModel()

    /// Pending URL picked up by HomeScreen to trigger a new search.
    @AppStorage("pendingDeepLinkURL") private var pendingDeepLinkURL: String = ""

    init(viewModel: HistoryViewModel = HistoryViewModel()) {
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

        // `originURL` is optional in the model, so there is nothing to search
        // again for when it is missing. The button is disabled in that case.
        Button {
            guard let urlString = item.originURL?.absoluteString else { return }
            // HomeScreen watches this key and kicks off the search.
            pendingDeepLinkURL = urlString
            dismiss()
        } label: {
            Label("Search Again", systemImage: "magnifyingglass.circle")
        }
        .tint(.accentColor)
        .disabled(item.originURL == nil)
    }

    var body: some View {
        Group {
            if viewModel.pastMatchedItems.isEmpty {
                // A failed load also leaves the list empty, so it gets its own
                // message rather than claiming there is no history.
                if viewModel.loadFailed {
                    ContentUnavailableView {
                        Label("Couldn't Load History", systemImage: "exclamationmark.triangle")
                    } description: {
                        Text("Your saved history couldn't be read. Reopening SongLinkr may fix it.")
                    }
                } else {
                    ContentUnavailableView {
                        Label("No History", systemImage: "clock.arrow.circlepath")
                    } description: {
                        Text("Songs you convert or Shazam show up here. Paste a link on the home screen to convert your first one.")
                    }
                }
            } else {
                historyList
            }
        }
        .scrollContentBackground(.hidden)
        .background { GradientBackground() }
        .toolbar {
            if !viewModel.pastMatchedItems.isEmpty {
                EditButton()
            }
        }
        .navigationTitle(Text("History"))
        .toolbarMinimizationBehavior(.onScrollDown, for: .navigationBar)
    }

    /// Each section is only rendered when it has items, so a history made up of
    /// only one kind of match doesn't show an empty heading for the other.
    private var historyList: some View {
        List {
            if !shazamItems.isEmpty {
                Section(header: Text("Shazam Matches")) {
                    ForEach(shazamItems, id: \.self) { item in
                        HistoryViewListItem(item: item)
                            .swipeActions { swipeActionsContent(for: item) }
                    }
                    .onDelete(perform: viewModel.deleteShazamItem(at:))
                }.headerProminence(.increased)
            }

            if !nonShazamItems.isEmpty {
                Section(header: Text("URL Matches")) {
                    ForEach(nonShazamItems, id: \.self) { item in
                        HistoryViewListItem(item: item)
                            .swipeActions { swipeActionsContent(for: item) }
                    }
                    .onDelete(perform: viewModel.deleteNonShazamItem(at:))
                }.headerProminence(.increased)
            }
        }
        .listStyle(.insetGrouped)
    }
}

#Preview {
    NavigationStack {
        HistoryView(
            viewModel: HistoryViewModel(
                matchedItemPublisher: MatchedItemStorage.shared.matchedItems.eraseToAnyPublisher()
            )
        )
    }
}
