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
    
    /// Determines if the clear button should be shown
    @State private var isEditing: Bool = false
    
    var body: some View {
        HStack {
            // Search Icon
            Image(systemName: "magnifyingglass")
                .font(Font.body.weight(.semibold))
                .foregroundColor(.gray)
                .accessibility(hidden: true)
            
            // Search Field
            TextField("Paste a URL", text: self.$searchURL, prompt: Text("URL"))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 700)
                .keyboardType(.URL)
                .textContentType(.URL)
                .onTapGesture {
                    self.isEditing = true
                }
                .accessibility(addTraits: .isSearchField)
                .accessibility(label: Text("URL Search Field"))
                .accessibility(hint: Text("Paste a URL to search for matches on other platforms."))
            
            if isEditing {
                Button(action: {
                    self.searchURL = ""
                }) {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.gray)
                }
                .accessibility(label: Text("Clear Search Bar"))
            }
        }
    }
}

struct URLEntryFieldPreview: PreviewProvider {
    static var previews: some View {
        URLEntryField(searchURL: .constant(""))
    }
}
