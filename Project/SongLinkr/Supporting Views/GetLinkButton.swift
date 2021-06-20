//
//  GetLinkButton.swift
//  SongLinkr
//
//  Created by Harry Day on 06/07/2020.
//

import Foundation
import SwiftUI

struct GetLinkButton: View {
    /// The view model for making a request
    @EnvironmentObject var viewModel: RequestViewModel
    
    /// The user settings stored in the environment
    @EnvironmentObject var userSettings: UserSettings
    
    /// The URL the user has entered
    @Binding var searchURL: String
    
    /// Declares whether a request is being made
    @State private var inProgress = false
    
    /// Declares whether an error has occured
    private var showError: Binding<Bool> { Binding(
        get: { viewModel.errorDescription != nil },
        set: { if !$0 { viewModel.errorDescription = nil }}
    )
    }
    
    var body: some View {
        Button(action: {
            if searchURL != "" {
                async {
                    inProgress = true
                    await viewModel.getResults(for: searchURL, with: userSettings)
                    inProgress = false
                }
            }
        }) {
            GetLinkButtonView(callInProgress: inProgress && !showError.wrappedValue)
        }
        // Button Styling
        .tint(.accentColor)
        .buttonStyle(.bordered)
        .controlSize(.large)
        .controlProminence(.increased)
        // Keyboard Shortcut
        .keyboardShortcut(.defaultAction)
        // Alert if error
        .alert(isPresented: showError) {
            Alert(title: Text(viewModel.errorDescription?.0 ?? "Unknown Error Occured"), message: Text(viewModel.errorDescription?.1 ?? "An Unknown Error Occured. Please Try Again"), dismissButton: .cancel({
                inProgress = false
                viewModel.errorDescription = nil
            }))
        }
        .padding()
        // Disable if no URL
        .disabled(self.searchURL == "")
    }
}

struct GetLinkButton_Previews: PreviewProvider {
    static let viewModel = RequestViewModel()
    
    static var previews: some View {
        GetLinkButton(searchURL: .constant("Hi"))
            .previewLayout(.fixed(width: 300, height: 100))
            .environmentObject(UserSettings())
            .environmentObject(self.viewModel)
    }
}
