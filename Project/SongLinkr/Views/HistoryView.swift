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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    /// The smallest a grid tile may be; scales with Dynamic Type so titles stay readable.
    @ScaledMetric(relativeTo: .headline) private var gridTileMinimumWidth: CGFloat = 160

    /// Wide windows (iPad, Mac) show a grid of artwork; compact widths
    /// (iPhone, Slide Over, narrow Split View) keep the list.
    private var usesGrid: Bool {
        horizontalSizeClass == .regular
    }

    /// Driven by the toolbar's edit button
    @State private var editMode: EditMode = .inactive

    private var isEditing: Bool {
        editMode.isEditing
    }

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
            } else if usesGrid {
                historyGrid
            } else {
                historyList
            }
        }
        .scrollContentBackground(.hidden)
        .background { GradientBackground() }
        .environment(\.editMode, $editMode)
        .toolbar {
            // The grid has no edit mode; deleting is done from each tile's context menu.
            if !viewModel.pastMatchedItems.isEmpty && !usesGrid {
                // Symbol-only rather than EditButton, so it can join a vertical bar (iPhone Duo)
                Button {
                    withAnimation { editMode = isEditing ? .inactive : .active }
                } label: {
                    Label {
                        isEditing ? Text("Done") : Text("Edit")
                    } icon: {
                        Image(systemName: isEditing ? "checkmark" : "pencil")
                    }
                }
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

    /// Adaptive columns fit as many tiles as the window width allows, so the
    /// grid reflows for any iPad size or window size.
    private var historyGrid: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: gridTileMinimumWidth), spacing: 20, alignment: .top)],
                alignment: .leading,
                spacing: 28
            ) {
                if !shazamItems.isEmpty {
                    gridSection("Shazam Matches", items: shazamItems)
                }

                if !nonShazamItems.isEmpty {
                    gridSection("URL Matches", items: nonShazamItems)
                }
            }
            .padding()
        }
    }

    private func gridSection(_ title: LocalizedStringKey, items: [MatchedItem]) -> some View {
        Section {
            ForEach(items, id: \.self) { item in
                HistoryGridItem(item: item)
                    .contextMenu { swipeActionsContent(for: item) }
            }
        } header: {
            Text(title)
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)
                .accessibilityAddTraits(.isHeader)
        }
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
