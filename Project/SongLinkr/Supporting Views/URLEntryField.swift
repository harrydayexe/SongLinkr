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
            Image(systemName: "magnifyingglass")
                .font(Font.body.weight(.semibold))
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)

            TextField("Paste a URL", text: self.$searchURL, prompt: Text(verbatim: "URL"))
                .textFieldStyle(.plain)
                .frame(maxWidth: 700)
                .keyboardType(.URL)
                .textContentType(.URL)
                .accessibilityAddTraits(.isSearchField)
                .accessibilityLabel(Text("URL Search Field", comment: "Accessibility label"))
                .accessibilityHint(Text("Paste a URL to search for matches on other platforms.", comment: "Accessibility label"))

            if !searchURL.isEmpty {
                Button(action: {
                    self.searchURL = ""
                }) {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text("Clear Search Bar", comment: "Accessibility label"))
            } else {
                PasteButton(payloadType: URL.self) { urls in
                    if let url = urls.first {
                        searchURL = url.absoluteString
                    }
                }
                .buttonBorderShape(.capsule)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .glassEffect()
    }
}

#Preview {
    URLEntryField(searchURL: .constant(""))
        .padding()
}

#Preview {
    URLEntryField(searchURL: .constant("https://spotify.com/test/song"))
        .padding()
}
