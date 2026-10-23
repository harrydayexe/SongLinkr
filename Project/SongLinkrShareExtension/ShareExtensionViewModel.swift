import Foundation
import Observation
import SongLinkrNetworkCore
import UniformTypeIdentifiers

@Observable
final class ShareExtensionViewModel {
    struct Result {
        let platforms: [PlatformLinks]
        let title: String
        let artist: String
        let artworkURL: URL?
        /// The song.link page for the result, shared from the action bar.
        let pageURL: URL
    }

    struct Failure {
        let title: String
        let message: String
        /// Whether trying again could succeed, i.e. a link was found but the lookup failed.
        let canRetry: Bool
    }

    enum State {
        case loading
        case results(Result)
        case failed(Failure)
    }

    private(set) var state: State = .loading

    /// The URL shared into the extension, kept so a failed lookup can be retried.
    private(set) var sharedURL: URL?

    /// Opens the shared link in SongLinkr, which searches it and adds it to History.
    var openInAppURL: URL? {
        sharedURL.flatMap { URL(string: "songlinkr:\($0.absoluteString)") }
    }

    private let inputItems: [NSExtensionItem]
    private let network: Network

    init(inputItems: [NSExtensionItem], network: Network = .shared) {
        self.inputItems = inputItems
        self.network = network
    }

    /// Reads the shared link and looks it up. Call from `.task` so it is cancelled on dismissal.
    func start() async {
        guard sharedURL == nil else { return }
        guard let url = await Self.firstURL(in: inputItems) else {
            state = .failed(Failure(
                title: String(localized: "No Link Found", comment: "Share extension error title"),
                message: String(
                    localized: "SongLinkr couldn't find a link in what was shared.",
                    comment: "Share extension error message, shown when no URL could be read from the shared item"
                ),
                canRetry: false
            ))
            return
        }
        sharedURL = url
        await lookUp(url)
    }

    func retry() async {
        guard let sharedURL else { return }
        await lookUp(sharedURL)
    }

    private func lookUp(_ url: URL) async {
        state = .loading

        do {
            let response = try await network.request(from: .search(with: Network.encodeURL(from: url.absoluteString)))
            let (artist, title) = Network.getSongNameAndArtist(from: response)
            state = .results(Result(
                // The app's default "Popularity" sort; the extension can't read the user's setting
                platforms: network.fixDictionaries(response: response).sorted(by: <),
                title: title ?? "",
                artist: artist ?? "",
                artworkURL: Network.getArtworkURL(from: response),
                pageURL: response.pageUrl
            ))
        } catch {
            // Dismissed mid-request; the network layer reports this as a network error
            guard !Task.isCancelled else { return }

            let dataLoaderError = error as? Network.DataLoaderError
            state = .failed(Failure(
                title: dataLoaderError?.errorTitle
                    ?? String(localized: "Something went wrong", comment: "Error message title"),
                message: error.localizedDescription,
                canRetry: true
            ))
        }
    }

    private static func firstURL(in items: [NSExtensionItem]) async -> URL? {
        let providers = items
            .flatMap { $0.attachments ?? [] }
            .filter { $0.hasItemConformingToTypeIdentifier(UTType.url.identifier) }

        for provider in providers {
            if let url = try? await provider.loadURL(), url.scheme?.hasPrefix("http") == true {
                return url
            }
        }
        return nil
    }
}

private extension NSItemProvider {
    func loadURL() async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            _ = loadObject(ofClass: URL.self) { url, error in
                if let url {
                    continuation.resume(returning: url)
                } else {
                    continuation.resume(throwing: error ?? URLError(.badURL))
                }
            }
        }
    }
}
