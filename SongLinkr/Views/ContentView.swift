//
//  ContentView.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import SwiftUI

struct ContentView: View {
    @State var searchURL: String = ""
    @State var showResults: Bool = false
    
    var body: some View {
        ZStack {
            Color("AppBlue")
                .edgesIgnoringSafeArea(.all)
            MainTextView(searchURL: $searchURL, showResults: $showResults)
        }
        .sheet(isPresented: $showResults) {
            ResultsView(showResults: $showResults)
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
