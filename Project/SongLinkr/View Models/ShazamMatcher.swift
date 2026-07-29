//
//  ShazamMatcher.swift
//  SongLinkr
//

import Foundation
import ShazamKit

@Observable
class ShazamMatcher {
    // MARK: Properties

    var shazamState: ShazamState = .idle

    private var shazamItemCache: SHMediaItem?
    private var session: SHManagedSession
    private var userSettingsSnapshot: UserSettings?
    private let searchModel: SearchModel

    // MARK: Init

    init(searchModel: SearchModel, session: SHManagedSession = SHManagedSession()) {
        self.searchModel = searchModel
        self.session = session
    }

    // MARK: ShazamState

    enum ShazamState: Equatable, CaseIterable {
        case idle
        case matching
        case matchFound
        case finished
    }

    // MARK: Matching

    func startShazamMatch(userSettings snapshot: UserSettings?) {
        userSettingsSnapshot = snapshot
        shazamState = .matching

        Task {
            let result = await session.result()

            guard shazamState != .idle else { return }

            switch result {
            case .match(let match):
                guard let matchedItem = match.mediaItems.first else {
                    searchModel.error = .matchNotFound
                    return
                }
                guard let appleMusicURLString = matchedItem.appleMusicURL?.absoluteString else {
                    searchModel.error = .missingInformation
                    return
                }
                shazamState = .matchFound
                shazamItemCache = matchedItem
                await searchModel.getResults(
                    for: appleMusicURLString,
                    with: userSettingsSnapshot,
                    title: matchedItem.title,
                    artist: matchedItem.artist,
                    artworkURL: matchedItem.artworkURL,
                    fromShazam: true
                )
                shazamState = .finished
                if let settings = userSettingsSnapshot, settings.saveToShazamLibrary {
                    Task {
                        do {
                            try await addToShazamLibrary(item: matchedItem)
                        } catch {
                            searchModel.error = (error as? SearchModel.RequestError) ?? .unknown(error)
                        }
                    }
                }

            case .noMatch:
                searchModel.error = .matchNotFound

            case .error(let error, _):
                if let shError = error as? SHError {
                    searchModel.error = .shazam(shError)
                } else {
                    searchModel.error = .unknown(error)
                }
            }
        }
    }

    func stopMatching() {
        session.cancel()
    }

    // MARK: Shazam Library

    private func addToShazamLibrary(item: SHMediaItem) async throws {
        do {
            try await SHLibrary.default.addItems([item])
        } catch {
            if let shError = error as? SHError {
                throw SearchModel.RequestError.shazam(shError)
            } else {
                throw SearchModel.RequestError.unknown(error)
            }
        }
    }

    func saveCachedItem() async -> Bool {
        guard let cachedItem = shazamItemCache else {
            searchModel.error = .cacheEmpty
            return false
        }
        do {
            try await addToShazamLibrary(item: cachedItem)
            return true
        } catch {
            searchModel.error = (error as? SearchModel.RequestError) ?? .unknown(error)
            return false
        }
    }
}
