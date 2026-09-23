//
//  GradientBackground.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

struct GradientBackground: View {
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
            RadialGradient(colors: [.orange.opacity(0.22), .clear],
                           center: .topLeading, startRadius: 0, endRadius: 380)
            RadialGradient(colors: [.orange.opacity(0.18), .clear],
                           center: .bottomTrailing, startRadius: 0, endRadius: 360)
        }
        .ignoresSafeArea()
    }
}
