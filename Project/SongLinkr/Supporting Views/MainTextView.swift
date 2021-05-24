//
//  MainTextView.swift
//  SongLinkr
//
//  Created by Harry Day on 28/06/2020.
//

import SwiftUI

struct MainTextView: View {
    /// The binding to the property where the user input is stored
    @Binding var searchURL: String
    
    /// Determines if the clear button should be shown
    @State private var isEditing: Bool = false
    
    var body: some View {
        VStack {
            Text("SongLinkr")
                .foregroundColor(.primary)
                .font(.largeTitle)
                .fontWeight(.bold)
                .accessibility(addTraits: .isHeader)
            
            URLEntryField(searchURL: self.$searchURL)
                .padding()
        }
    }
}

struct MainTextView_Previews: PreviewProvider {
    static var previews: some View {
        MainTextView(searchURL: .constant(""))
    }
}
