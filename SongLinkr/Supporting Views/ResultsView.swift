//
//  ResultsView.swift
//  SongLinkr
//
//  Created by Harry Day on 28/06/2020.
//

import SwiftUI

struct ResultsView: View {
    @Binding var showResults: Bool
    
    var body: some View {
        NavigationView {
            Text("List of platforms")
                .navigationBarTitle(Text("Pick your platform"), displayMode: .inline)
                .navigationBarItems(trailing: Button("Done", action: {
                    self.showResults = false
                }))
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(showResults: .constant(true))
    }
}
