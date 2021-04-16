//
//  MainTextView.swift
//  SongLinkr
//
//  Created by Harry Day on 28/06/2020.
//

import SwiftUI

struct MainTextView: View {
    @Binding var searchURL: String
    
    var body: some View {
        VStack {
            Text("SongLinkr")
                .foregroundColor(.primary)
                .font(.largeTitle)
                .fontWeight(.bold)
            TextField("Paste a URL to share", text: self.$searchURL)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 700)
                .padding()
                .keyboardType(.URL)
                .textContentType(.URL)
        }
    }
}

struct MainTextView_Previews: PreviewProvider {
    static var previews: some View {
        MainTextView(searchURL: .constant(""))
    }
}
