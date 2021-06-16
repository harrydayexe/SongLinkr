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
            .shadow(color: ColorManager.dropShadow, radius: 15, x: 10, y: 10)
            .shadow(color: Color.white, radius: 15, x: -10, y: -10)
    }
}

extension View {
    func makeSkeumorphic() -> some View {
        self.modifier(NeumorphicShadowModifier())
    }
}
