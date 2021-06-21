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
    @StateObject var viewModel: RequestViewModel = .shared
    
    /// The user settings stored in the environment
    @EnvironmentObject var userSettings: UserSettings
    
    /// The URL the user is searching
    @State var searchURL: String = ""
    
    /// The selected tab
    @Binding var selectedTab: Int
    
    /// The function to start a request via the viewmodel to the server
    private func makeRequest() {
        if searchURL != "" {
            async {
                viewModel.normalInProgress = true
                await viewModel.getResults(for: searchURL, with: userSettings)
                viewModel.normalInProgress = false
            }
        }
    }
    
    /// The function to start a shazam match via the viewmodel
    private func startShazam() {
        print("Shazam Match Started")
        viewModel.startShazamMatch(userSettings: userSettings)
    }
    
    /// The function to stop recording and matching on Shazam
    private func stopShazam() {
        print("Shazam Match Cancelled")
        viewModel.stopMatching()
        viewModel.shazamState = .idle
    }
    
    var body: some View {
        NavigationView {
            SearchScreenView(
                searchURL: $searchURL,
                shazamInProgress: $viewModel.shazamState,
                normalInProgress: $viewModel.normalInProgress,
                makeRequest: makeRequest,
                startShazam: startShazam,
                stopShazam: stopShazam
            ).environmentObject(viewModel)
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
            // Alert if error
            .alert(isPresented: viewModel.showError) {
                Alert(
                    title: Text(viewModel.error?.localizedTitle ?? "Something went wrong"),
                    message: Text(viewModel.error?.localizedDescription ?? "Please try again later"),
                    dismissButton: .cancel({
                    // Reset both
                    viewModel.shazamState = .idle
                    viewModel.normalInProgress = false
                    viewModel.errorDescription = nil
                })
                )
            }
            // Results view
            .sheet(isPresented: self.viewModel.showResults) {
                ResultsView(
                    showResults: self.viewModel.showResults,
                    results: self.viewModel.resultsObject!,
                    saveFunction: viewModel.saveCachedItem
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
