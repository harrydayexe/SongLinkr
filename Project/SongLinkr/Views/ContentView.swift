//
//  ContentView.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import SwiftUI
import SongLinkrNetworkCore

struct ContentView: View {
    /// The app state stored in the environment
    @StateObject var viewModel: RequestViewModel = RequestViewModel()
    
    /// The user settings stored in the environment
    @EnvironmentObject var userSettings: UserSettings
    
    /// The URL the user is searching
    @State var searchURL: String = ""
    
    /// The selected tab
    @Binding var selectedTab: Int
    
    private func makeRequest(inProgress: Binding<Bool>) {
        if searchURL != "" {
            async {
                inProgress.wrappedValue = true
                await viewModel.getResults(for: searchURL, with: userSettings)
                inProgress.wrappedValue = false
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                MainTextView(searchURL: self.$searchURL)
                GetLinkButton(searchURL: $searchURL, makeRequest: makeRequest).environmentObject(viewModel)
                ShazamButton()
            }
            // Check pasteboard for URLs
            .onAppear(perform: {
                if UIPasteboard.general.hasURLs {
                    if let copiedURL = UIPasteboard.general.url {
                        self.searchURL = "\(copiedURL)"
                    }
                }
            })
            // Handle Deeplinks
            .onOpenURL(perform: { deepLinkURL in
                self.viewModel.showResults.wrappedValue = false
                self.selectedTab = 0
                if let songLink = URL(string: deepLinkURL.absoluteString.replacingOccurrences(of: "songlinkr:", with: "")) {
                    self.searchURL = songLink.absoluteString
                }
            })
            // Results view
            .sheet(isPresented: self.viewModel.showResults) {
                ResultsView(
                    showResults: self.viewModel.showResults,
                    results: self.viewModel.resultsObject!
                )
                // Auto open
                    .onAppear {
                        // If auto open is on and the origin platform is not the default platform
                        if userSettings.autoOpen && !self.viewModel.originEntityID.contains(userSettings.defaultPlatform.entityName) {
                            // Try to get the default platform index
                            if let defaultPlatformIndex = self.viewModel.resultsObject?.response.firstIndex(where: {
                                $0.id == userSettings.defaultPlatform
                            }) {
                                // Get the default platform
                                if let defaultPlatform = self.viewModel.resultsObject?.response[defaultPlatformIndex] {
                                    DispatchQueue.main.async {
                                        UIApplication.shared.open(defaultPlatform.nativeAppUriMobile ?? defaultPlatform.url)
                                    }
                                }
                            }
                        }
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selectedTab: .constant(0))
            .environmentObject(UserSettings())
    }
}
