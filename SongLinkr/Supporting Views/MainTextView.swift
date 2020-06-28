//
//  MainTextView.swift
//  SongLinkr
//
//  Created by Harry Day on 28/06/2020.
//

import SwiftUI

struct MainTextView: View {
    @Binding var searchURL: String
    @Binding var showResults: Bool
    
    var body: some View {
        VStack {
            Text("SongLinkr")
                .foregroundColor(.primary)
                .font(.largeTitle)
                .fontWeight(.bold)
            TextField("Paste a URL to share", text: $searchURL)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {self.showResults.toggle()}) {
                HStack {
                    Image(systemName: "link")
                    Text("Search Link")
                }
                .padding()
            }
            .buttonStyle(GetLinkButtonStyle())
            .padding()
        }
    }
}

struct MainTextView_Previews: PreviewProvider {
    static var previews: some View {
        MainTextView(searchURL: .constant(""), showResults: .constant(false))
    }
}
