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
            .shadow(color: Color.lightShadow, radius: 8, x: -8, y: -8)
            .shadow(color: Color.darkShadow, radius: 8, x: 8, y: 8)
    }
}

extension View {
    func makeSkeumorphic() -> some View {
        self.modifier(NeumorphicShadowModifier())
    }
}
