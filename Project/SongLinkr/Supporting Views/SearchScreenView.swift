//
//  SearchScreenView.swift
//  SongLinkr
//
//  Created by Harry Day on 20/06/2021
//  
//
//  Twitter: https://twitter.com/realharryday
//  Github: https://github.com/harryday123
//


import SwiftUI

struct SearchScreenView: View {
    /// The URL the user has entered
    @Binding var searchURL: String
    
    /// Declares if the shazam process is in progress
    @Binding var shazamInProgress: RequestViewModel.ShazamState
    
    /// Declares if the normal process is in progress
    @Binding var normalInProgress: Bool
    
    /// The function to start the request
    let makeRequest: () -> Void
    
    /// The function to use to run the request
    let startShazam: () -> Void
    
    /// The function to stop recording and matching on Shazam
    let stopShazam: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            MainTextView(searchURL: self.$searchURL)
            GetLinkButton(searchURL: $searchURL, inProgress: $normalInProgress, makeRequest: makeRequest)
            ShazamButton(shazamState: $shazamInProgress, startShazam: startShazam, stopShazam: stopShazam)
            Spacer()
        }
    }
}

struct SearchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreenView(searchURL: .constant(""), shazamInProgress: .constant(.idle), normalInProgress: .constant(false), makeRequest: {}, startShazam: {}, stopShazam: {})
    }
}
