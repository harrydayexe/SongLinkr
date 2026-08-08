//
//  HomeScreen.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

import SwiftUI

struct HomeScreen: View {
    @Namespace private var morphNamespace
    @State private var phase: SearchPhase = .home

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()

                switch phase {
                case .home:
                    SearchBoxView(namespace: morphNamespace, searchPhase: $phase)
                case .results(let result):
                    ResultsView(result: result)
                }
            }
            .animation(morphAnimation, value: phase.isResults)
        }
    }
}

#Preview {
    HomeScreen()
}
