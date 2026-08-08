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

                SearchBoxView(
                    namespace: morphNamespace,
                    isSource: !phase.isResults,
                    searchAction: {
                        withAnimation(morphAnimation) { phase = .results(.previewResults) }
                    },
                    searchPhase: $phase
                )
                .opacity(phase.isResults ? 0 : 1)

                ResultsView(
                    namespace: morphNamespace,
                    isSource: phase.isResults,
                    result: phase.result ?? .previewResults,
                    shareAction: {
                        withAnimation(morphAnimation) { phase = .home }
                    }
                )
                .opacity(phase.isResults ? 1 : 0)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
        }
    }
}

#Preview {
    HomeScreen()
}
