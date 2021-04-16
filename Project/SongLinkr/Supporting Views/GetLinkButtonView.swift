//
//  GetLinkButtonView.swift
//  SongLinkr
//
//  Created by Harry Day on 05/07/2020.
//

import SwiftUI

struct GetLinkButtonView: View {
    @Binding var callInProgress: Bool
    
    var body: some View {
        VStack {
            if !self.callInProgress {
                HStack {
                Image(systemName: "link")
                Text("Search Link")
                }
            } else {
                ProgressView("Loading")
            }
        }
    }
}

struct GetLinkButtonView_Previews: PreviewProvider {
    static var previews: some View {
        GetLinkButtonView(callInProgress: .constant(false))
    }
}
