//
//  SongLinkrLogoView.swift
//  SongLinkr
//
//  Created by Harry Day on 04/08/2026.
//

import SwiftUI

/// The app icon, pre-masked to its own squircle, so callers must not clip it.
/// Fills whatever size it is given.
struct SongLinkrLogoView: View {
    var body: some View {
        Image(.songLinkrLogo)
            .resizable()
            .scaledToFit()
    }
}

#Preview {
    SongLinkrLogoView()
        .frame(width: 92, height: 92)
}
