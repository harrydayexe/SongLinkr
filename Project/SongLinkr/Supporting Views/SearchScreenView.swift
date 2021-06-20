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
    @Binding var shazamInProgress: Bool
    
    /// Declares if the normal process is in progress
    @Binding var normalInProgress: Bool
    
    /// The function to start the request
    let makeRequest: () -> Void
    
    /// The function to use to run the request
    let startShazam: () -> Void
    
    var body: some View {
        VStack {
            MainTextView(searchURL: self.$searchURL)
            GetLinkButton(searchURL: $searchURL, inProgress: $normalInProgress, makeRequest: makeRequest)
            ShazamButton(inProgress: $shazamInProgress, startShazam: startShazam)
        }
    }
}

struct SearchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreenView(searchURL: .constant(""), shazamInProgress: .constant(false), normalInProgress: .constant(false), makeRequest: {}, startShazam: {})
    }
}
