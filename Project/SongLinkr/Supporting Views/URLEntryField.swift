//
//  URLEntryField.swift
//  SongLinkr
//
//  Created by Harry Day on 24/05/2021
//  
//
//  Twitter: https://twitter.com/realharryday
//  Github: https://github.com/harryday123
//


import SwiftUI

struct URLEntryField: View {
    /// The binding to the property where the user input is stored
    @Binding var searchURL: String
    
    var body: some View {
        HStack {
            // Search Icon
            Image(systemName: "magnifyingglass")
                .font(Font.body.weight(.semibold))
                .foregroundColor(.gray)
                .accessibility(hidden: true)
            
            // Search Field
            TextField("Paste a URL", text: self.$searchURL, prompt: Text(verbatim: "URL"))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 700)
                .keyboardType(.URL)
                .textContentType(.URL)
                .accessibility(addTraits: .isSearchField)
                .accessibility(label: Text("URL Search Field", comment: "Accessibility label"))
                .accessibility(hint: Text("Paste a URL to search for matches on other platforms.", comment: "Accessibility label"))
            
            if !searchURL.isEmpty {
                Button(action: {
                    self.searchURL = ""
                }) {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.gray)
                }
                .accessibility(label: Text("Clear Search Bar", comment: "Accessibility label"))
            }
        }
    }
}

#Preview {
    URLEntryField(searchURL: .constant(""))
}

#Preview {
    URLEntryField(searchURL: .constant("https://spotify.com/test/song"))
}
