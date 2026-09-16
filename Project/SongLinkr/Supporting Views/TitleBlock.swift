//
//  TitleBlock.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

struct TitleBlock: View {
    var title: String
    var subtitle: String
    var subtitleFont: Font

    var body: some View {
        VStack(spacing: 4) {
            Text(title).font(.largeTitle.bold())
            Text(subtitle).font(subtitleFont).foregroundStyle(.secondary)
        }
    }
}

#Preview {
    TitleBlock(title: "SongLinkr", subtitle: "Any song. Every platform.", subtitleFont: .subheadline)
}
