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
    var titleFont: Font

    var body: some View {
        VStack(spacing: 4) {
            Text(title).font(titleFont)
            Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
        }
    }
}

#Preview {
    TitleBlock(title: "SongLinkr", subtitle: "Any song. Every platform.", titleFont: .largeTitle.bold())
}
