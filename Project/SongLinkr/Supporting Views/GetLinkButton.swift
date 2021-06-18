//
//  GetLinkButton.swift
//  SongLinkr
//
//  Created by Harry Day on 06/07/2020.
//

import Foundation
import SwiftUI

struct GetLinkButton: View {
    /// The store object in the environment
    @EnvironmentObject var store: AppStore
    
    /// The URL the user has entered
    @Binding var searchURL: String
    
    /// Declares whether an error has occured
    private var showError: Binding<Bool> { Binding(
        get: { self.store.state.errorDescription != nil },
        set: { if !$0 { self.store.send(.clearErrorDescription) }}
    )}
    
    var body: some View {
        Button(action: {
            if self.searchURL != "" {
                // Start the call
                store.send(.updateCallInProgress(newValue: true))
                // Request the data
                store.send(.getSearchResults(from: .search(with: self.searchURL)))
            }
        }) {
            GetLinkButtonView(callInProgress: self.store.state.callInProgress && !self.showError.wrappedValue)
        }
        // Button Styling
        .tint(.accentColor)
        .buttonStyle(.bordered)
        .controlSize(.large)
        .controlProminence(.increased)
        // Keyboard Shortcut
        .keyboardShortcut(.defaultAction)
        // Alert if error
        .alert(isPresented: self.showError) {
            Alert(title: Text(store.state.errorDescription?.0 ?? "Unknown Error Occured"), message: Text(store.state.errorDescription?.1 ?? "An Unknown Error Occured. Please Try Again"), dismissButton: .cancel({
                store.send(.updateCallInProgress(newValue: false))
            }))
        }
        .padding()
        // Disable if no URL
        .disabled(self.searchURL == "")
    }
}

struct GetLinkButton_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World")
    }
}
