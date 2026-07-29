//
//  SearchPhase.swift
//  SongLinkr
//
//  Created by Harry Day on 29/07/2026.
//

enum SearchPhase: Equatable {
    case home
    case results(ResultsModel)

    var isResults: Bool { if case .results = self { true } else { false } }
}
