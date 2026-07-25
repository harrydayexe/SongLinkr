import Foundation
import Combine
import SongLinkrNetworkCore

@MainActor
final class ShareExtensionViewModel: ObservableObject {
    enum State {
        case loading
        case results(platforms: [PlatformLinks], title: String?, artist: String?, artworkURL: URL?)
        case error(String)
    }

    @Published var state: State = .loading

    func load(url: URL) {
        Task {
            do {
                let network = Network.shared
                let encoded = Network.encodeURL(from: url.absoluteString)
                let response = try await network.request(from: .search(with: encoded))
                let platforms = network.fixDictionaries(response: response)
                    .sorted { $0.id.displayRank < $1.id.displayRank }
                let (artist, title) = Network.getSongNameAndArtist(from: response)
                let artworkURL = Network.getArtworkURL(from: response)
                state = .results(platforms: platforms, title: title, artist: artist, artworkURL: artworkURL)
            } catch let error as Network.DataLoaderError {
                state = .error(error.errorDescription ?? "Something went wrong.")
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
}
