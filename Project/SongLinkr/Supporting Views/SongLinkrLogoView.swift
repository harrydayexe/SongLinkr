//
//  SongLinkrLogoView.swift
//  SongLinkr
//
//  Created by Harry Day on 04/08/2026.
//

import SwiftUI

struct SongLinkrLogoView: View {
    var size: CGFloat
    var cornerRadius: CGFloat
    var namespace: Namespace.ID

    var body: some View {
        ZStack {
            LinearGradient(gradient: .orangeGradient, startPoint: .topLeading, endPoint: .bottomTrailing)
            #warning("Update this to the the SongLinkr logo")
            Image(systemName: "link")
                .font(.system(size: size * 0.43, weight: .bold))
                .foregroundStyle(.white)
        }
        .frame(width: size, height: size)
        .clipShape(.rect(cornerRadius: cornerRadius))
        .shadow(color: .orange.opacity(0.4), radius: 13, y: 5)
        .matchedGeometryEffect(id: "art", in: namespace)
    }
}

#Preview {
    @Previewable @Namespace var morph

    SongLinkrLogoView(size: 98, cornerRadius: 24, namespace: morph)
}
