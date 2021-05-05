//
//  ContentView.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import SwiftUI

struct ContentView: View {
    /// The app state stored in the environment
    @EnvironmentObject var store: AppStore
    
    /// The user settings stored in the environment
    @EnvironmentObject var userSettings: UserSettings
    
    /// The URL the user is searching
    @State var searchURL: String = ""
    
    /// The selected tab
    @Binding var selectedTab: Int
    
    /// Whether to show the search results
    private var showResults: Binding<Bool> { Binding(
        get: { self.store.state.searchResults != [] },
        // If new value is false then clear the results
        set: { if !$0 { self.store.send(.setSearchResults(with: [])) }}
    )
    }
    
    private var searchResults: [PlatformLinks] {
        var temp = store.state.searchResults
        if userSettings.sortOption == .popularity {
            temp.sort(by: <)
        } else {
            temp.sort {
                $0.id.rawValue < $1.id.rawValue
            }
        }
        if userSettings.defaultAtTop {
            return temp.moveDefaultFirst(with: userSettings.defaultPlatform)
        } else {
            return temp
        }
    }
    
    var body: some View {
        ZStack {
            Color("AppBlue")
                .edgesIgnoringSafeArea(.all)
            VStack {
                MainTextView(searchURL: self.$searchURL)
                GetLinkButton(searchURL: $searchURL)
            }
        }
        .onAppear(perform: {
            if UIPasteboard.general.hasURLs {
                if let copiedURL = UIPasteboard.general.url {
                    self.searchURL = "\(copiedURL)"
                }
            }
        })
        .onOpenURL(perform: { deepLinkURL in
            self.showResults.wrappedValue = false
            self.selectedTab = 0
            if let songLink = URL(string: deepLinkURL.absoluteString.replacingOccurrences(of: "songlinkr:", with: "")) {
                self.searchURL = songLink.absoluteString
            }
        })
        .sheet(isPresented: self.showResults) {
            ResultsView(showResults: self.showResults, response: searchResults)
                // Auto open
                .onAppear {
                    if userSettings.autoOpen && !store.state.originEntityID.contains(userSettings.defaultPlatform.entityName) {
                        if let defaultPlatformIndex = store.state.searchResults.firstIndex(where: { $0.id == userSettings.defaultPlatform }) {
                            let defaultPlatform = store.state.searchResults[defaultPlatformIndex]
                            DispatchQueue.main.async {
                                UIApplication.shared.open(defaultPlatform.nativeAppUriMobile ?? defaultPlatform.url)
                            }
                        }
                    }
                }
        }
        .accessibilityAction(.magicTap) {
            if self.searchURL != "" {
                // Start the call
                store.send(.updateCallInProgress(newValue: true))
                // Request the data
                store.send(.getSearchResults(from: .search(with: self.searchURL)))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(selectedTab: .constant(0))
            ContentView(selectedTab: .constant(0))
                .preferredColorScheme(.dark)
        }
            .environmentObject(UserSettings())
            .environmentObject(AppStore(initialState: .init(), reducer: appReducer, environment: World()))
    }
}
