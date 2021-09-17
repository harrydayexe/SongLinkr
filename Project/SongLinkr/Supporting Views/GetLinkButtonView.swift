//
//  GetLinkButtonView.swift
//  SongLinkr
//
//  Created by Harry Day on 05/07/2020.
//

import SwiftUI

struct GetLinkButtonView: View {
    let callInProgress: Bool
    
    var body: some View {
        VStack {
            if !self.callInProgress {
                Label("Search Link", systemImage: "link")
            } else {
                ProgressView("Loading")
                    .tint(.secondary)
            }
        }
    }
}

struct GetLinkButtonView_Previews: PreviewProvider {
    static var previews: some View {
        GetLinkButtonView(callInProgress: true)
    }
}
