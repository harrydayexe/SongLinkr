//
//  TextField+Cancellable.swift
//  SongLinkr
//
//  Created by Harry Day on 17/04/2021.
//

import SwiftUI


struct Cancellable: ViewModifier {
    @Binding var isEditing: Bool
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content
            // Default styling for iOS
            .padding(7)
            .padding(.horizontal, 25)
            .cornerRadius(8)
            // Clear Button
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .font(Font.body.weight(.semibold))
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                    
                    if isEditing {
                        Button(action: {
                            self.text = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }
            )
            .padding(.horizontal, 10)
    }
}

//extension View {
//    func cancellable(with text: String) -> some View {
//        self.modifier(Cancellable(isEditing: <#T##Bool#>, text: <#T##Binding<String>#>))
//    }
//}
