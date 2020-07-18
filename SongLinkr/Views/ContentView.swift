//
//  ContentView.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import SwiftUI

struct ContentView: View {
    @State var callInProgress: Bool = false
    @State var searchURL: String = ""
    @State var showResults: Bool = false
    @State var response: [PlatformLinks] = []
    
    var body: some View {
        ZStack {
            Color("AppBlue")
                .edgesIgnoringSafeArea(.all)
            VStack {
                MainTextView(searchURL: self.$searchURL)
                GetLinkButton(callInProgress: self.$callInProgress, searchURL: self.$searchURL, showResults: self.$showResults, response: self.$response)
            }
        }
        .onAppear(perform: {
            if UIPasteboard.general.hasURLs {
                if let copiedURL = UIPasteboard.general.url {
                    self.searchURL = "\(copiedURL)"
                }
            }
        })
        .sheet(isPresented: self.$showResults) {
            ResultsView(showResults: self.$showResults, response: self.$response)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
