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

    var body: some View {
        VStack {
            Text(verbatim: "SongLinkr")
                .foregroundStyle(.primary)
                .font(.largeTitle)
                .fontWeight(.bold)
                .accessibilityAddTraits(.isHeader)

            URLEntryField(searchURL: self.$searchURL)
                .padding()
        }
    }
}

#Preview {
    MainTextView(searchURL: .constant(""))
}
