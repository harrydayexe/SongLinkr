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
    
    /// The URL the user has entered
    @Binding var searchURL: String
    
    /// Declares whether a request is being made
    @Binding var inProgress: Bool
    
    /// Declares whether an error has occured
    private var showError: Binding<Bool> { Binding(
        get: { viewModel.errorDescription != nil },
        set: { if !$0 { viewModel.errorDescription = nil }}
    )
    }
    
    /// The function to start the request
    let makeRequest: () -> Void
    
    var body: some View {
        Button(action: {
            makeRequest()
        }) {
            GetLinkButtonView(callInProgress: inProgress && !showError.wrappedValue)
        }
        // Button Styling
        .tint(.accentColor)
        .buttonStyle(.bordered)
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        // Keyboard Shortcut
        .keyboardShortcut(.defaultAction)
        .padding()
        // Disable if no URL
        .disabled(self.searchURL == "")
    }
}

struct GetLinkButton_Previews: PreviewProvider {
    static var previews: some View {
        GetLinkButton(searchURL: .constant("Hi"), inProgress: .constant(false), makeRequest: {})
            .previewLayout(.fixed(width: 300, height: 100))
            .environmentObject(RequestViewModel.shared)
    }
}
