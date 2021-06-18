//
//  NeumorphicShadowModifier.swift
//  SongLinkr
//
//  Created by Harry Day on 16/06/2021
//  
//
//  Twitter: https://twitter.com/realharryday
//  Github: https://github.com/harryday123
//


import Foundation
import SwiftUI

struct NeumorphicShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
    }
}

extension View {
    func makeSkeumorphic() -> some View {
        self.modifier(NeumorphicShadowModifier())
    }
}
