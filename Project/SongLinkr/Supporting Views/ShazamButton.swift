//
//  ShazamButton.swift
//  SongLinkr
//
//  Created by Harry Day on 20/06/2021
//  
//
//  Twitter: https://twitter.com/realharryday
//  Github: https://github.com/harryday123
//


import SwiftUI

struct ShazamButton: View {
    /// The view model for making a request
    @EnvironmentObject var viewModel: RequestViewModel
    
    /// The user settings stored in the environment
    @EnvironmentObject var userSettings: UserSettings
    
    /// Declares whether a request is being made
    @Binding var inProgress: Bool
    
    /// The function to use to start a shazam match
    let startShazam: () -> Void
    
    var body: some View {
        Button(action: {
            startShazam()
        }) {
            Label("Shazam Match", image: "shazam.fill")
        }
        // Button Styling
        .tint(.blue)
        .buttonStyle(.bordered)
        .controlSize(.large)
        .controlProminence(.increased)
    }
}

struct ShazamButton_Previews: PreviewProvider {
    static var previews: some View {
        ShazamButton(inProgress: .constant(false), startShazam: {})
            .previewLayout(.fixed(width: 300, height: 100))
    }
}
