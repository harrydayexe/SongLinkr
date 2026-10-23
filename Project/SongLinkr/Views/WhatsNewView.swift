//
//  WhatsNewView.swift
//  SongLinkr
//
//  Created by Harry Day on 23/09/2026.
//

import SwiftUI

struct WhatsNewView: View {
    @Environment(\.dismiss) private var dismiss

    let whatsNew: WhatsNew

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                SongLinkrLogoView()
                    .frame(width: 92, height: 92)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 48)
                    .accessibilityHidden(true)

                Text("Welcome to SongLinkr", comment: "What's New sheet title")
                    .font(.largeTitle.bold())

                VStack(alignment: .leading, spacing: 24) {
                    ForEach(whatsNew.features) { feature in
                        FeatureRow(feature: feature)
                    }
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 24)
        }
        .scrollBounceBehavior(.basedOnSize)
        .safeAreaInset(edge: .bottom) {
            Button {
                dismiss()
            } label: {
                Text("Continue", comment: "Dismisses the What's New sheet")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .controlSize(.extraLarge)
            .padding(.horizontal, 32)
            .padding(.bottom, 16)
        }
    }
}

private struct FeatureRow: View {
    let feature: WhatsNew.Feature

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: feature.symbol)
                .font(.title)
                .foregroundStyle(.tint)
                .frame(width: 44)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(feature.title)
                    .font(.headline)
                Text(feature.description)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            WhatsNewView(whatsNew: WhatsNew.releases[0])
        }
}
