//
//  GetLinkButtonStyle.swift
//  SongLinkr
//
//  Created by Harry Day on 28/06/2020.
//

import Foundation
import SwiftUI


struct GetLinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color("AppRed"), .accentColor]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15.0)
    }
}

struct GetLinkButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}) {
            Text(verbatim: "This is an example button")
        }
        .buttonStyle(GetLinkButtonStyle())
        .previewLayout(.fixed(width: 300, height: 100))
    }
}
