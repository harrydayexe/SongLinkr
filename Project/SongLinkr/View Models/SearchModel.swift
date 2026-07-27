//
//  SearchModel.swift
//  SongLinkr
//

import Foundation
import ShazamKit
import SongLinkrNetworkCore

@Observable @MainActor
class SearchModel {
    // MARK: Properties

    var results: ResultsModel?
    var error: RequestError?
    var normalInProgress = false
    private(set) var originEntityID: String = ""

    private let network: Network

    // MARK: Init

    init(network: Network = .shared) {
        self.network = network
    }

    // MARK: Error

    enum RequestError: Error {
        case network(Network.DataLoaderError)
        case shazam(SHError)
        case missingInformation
        case cacheEmpty
        case unknown(Error)
        case matchNotFound
    }

    // MARK: Search

    func getResults(
        for searchString: String,
        with settings: UserSettings?,
        title: String? = nil,
        artist: String? = nil,
        artworkURL: URL? = nil,
        fromShazam: Bool = false
    ) async {
        let endpoint: Endpoint

        do {
            if let searchURL = URLComponents(string: searchString),
               let host = searchURL.host,
               host.contains("shazam.com") {
                let url = try await getAppleMusicURL(from: searchURL)
                endpoint = generateEndpoint(with: url.absoluteString)
            } else {
                endpoint = generateEndpoint(with: searchString)
            }
        } catch {
            self.error = (error as? RequestError) ?? .unknown(error)
            return
        }

        do {
            var results = try await makeRequest(
                with: endpoint,
                title: title,
                artist: artist,
                knownArtworkURL: artworkURL,
                fromShazam: fromShazam
            )

            if let settings, settings.sortOption == .popularity {
                results.response.sort(by: <)
            } else {
                results.response.sort { $0.id.rawValue < $1.id.rawValue }
            }

            if let settings, settings.defaultAtTop {
                results.response.moveDefaultFirst(with: settings.defaultPlatform)
            }

            MatchedItemStorage.shared.add(
                isShazamMatch: results.isFromShazam,
                mediaArtist: results.artistName,
                mediaArtworkURL: results.artworkURL,
                mediaTitle: results.mediaTitle,
                originURL: URL(string: searchString),
                timestamp: Date()
            )

            self.results = results
        } catch {
            if let error = error as? Network.DataLoaderError {
                self.error = .network(error)
            } else {
                self.error = .unknown(error)
            }
        }
    }

    private func getAppleMusicURL(from shazamURL: URLComponents) async throws -> URL {
        assert(shazamURL.host!.contains("shazam.com"), "URL is not from shazam.com")

        guard shazamURL.path.contains("/track/") else {
            throw RequestError.network(.invalidURL)
        }

        guard let range = shazamURL.path.range(of: "/[\\d]+", options: .regularExpression) else {
            throw RequestError.network(.invalidURL)
        }

        var trackID = shazamURL.path[range].dropFirst()
        if let index = trackID.firstIndex(of: "/") {
            trackID.removeSubrange(index...)
        }

        do {
            let mediaItem = try await SHMediaItem.fetch(shazamID: String(trackID))
            guard let appleMusicURL = mediaItem.appleMusicURL else {
                throw RequestError.missingInformation
            }
            return appleMusicURL
        } catch {
            if let error = error as? RequestError { throw error }
            else if let error = error as? SHError { throw RequestError.shazam(error) }
            else { throw RequestError.unknown(error) }
        }
    }

    private func generateEndpoint(with input: String) -> Endpoint {
        .search(with: Network.encodeURL(from: input))
    }

    private func makeRequest(
        with endpoint: Endpoint,
        title: String? = nil,
        artist: String? = nil,
        knownArtworkURL: URL? = nil,
        fromShazam: Bool = false
    ) async throws -> ResultsModel {
        let response = try await network.request(from: endpoint)

        var artworkURL = Network.getArtworkURL(from: response)
        var (artistName, mediaTitle) = Network.getSongNameAndArtist(from: response)

        if let title { mediaTitle = title }
        if let artist { artistName = artist }
        if let url = knownArtworkURL { artworkURL = url }

        // Shazam matches always come in via Apple Music URL, so do not treat Apple Music
        // as the origin — otherwise auto-open would fire even when it's not the user's default.
        if fromShazam {
            self.originEntityID = "shazam"
        } else {
            self.originEntityID = response.entityUniqueId
        }

        let platformLinks = network.fixDictionaries(response: response)

        return ResultsModel(
            artworkURL: artworkURL,
            mediaTitle: mediaTitle ?? "",
            artistName: artistName ?? "",
            isFromShazam: fromShazam,
            response: platformLinks
        )
    }
}

// MARK: - RequestError: LocalizedError

extension SearchModel.RequestError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .network(let error):
            return error.localizedDescription
        case .shazam(let error):
            return error.localizedDescription
        case .missingInformation:
            return String(
                localized: "The song was matched by Shazam but not enough information was returned. Please try again later.",
                comment: "Error message"
            )
        case .cacheEmpty:
            return String(
                localized: "The media cache was empty so the song was not saved. Please try again later",
                comment: "Error message"
            )
        case .unknown(let error):
            return error.localizedDescription
        case .matchNotFound:
            return String(
                localized: "No match was found in the Shazam Library",
                comment: "Error message"
            )
        }
    }

    var localizedTitle: String? {
        switch self {
        case .network(let error):
            return error.errorTitle
        case .missingInformation:
            return String(localized: "Some information was missing", comment: "Error message title")
        case .cacheEmpty:
            return String(localized: "An error occured whilst saving to Shazam Library", comment: "Error message title")
        case .unknown:
            return String(localized: "An unknown error occured", comment: "Error message title")
        case .matchNotFound:
            return String(localized: "No Match Found", comment: "Error message title")
        default:
            return String(localized: "Something went wrong", comment: "Error message title")
        }
    }
}

// MARK: - RequestError: Identifiable

extension SearchModel.RequestError: Identifiable {
    var id: String {
        switch self {
        case .network(let e): "network:\(e)"
        case .shazam(let e): "shazam:\(e)"
        case .missingInformation: "missingInformation"
        case .cacheEmpty: "cacheEmpty"
        case .unknown(let e): "unknown:\(e.localizedDescription)"
        case .matchNotFound: "matchNotFound"
        }
    }
}
