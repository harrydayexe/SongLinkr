import AppIntents
import SongLinkrNetworkCore

struct MatchURLToPlatformIntent: AppIntent {
    static let title: LocalizedStringResource = "Match URL to Platform"
    static let description = IntentDescription("Convert a music link to links on all supported platforms")

    @Parameter(title: "URL")
    var url: URL

    @Parameter(title: "Choose Specific Platform", default: false)
    var chooseSpecificPlatform: Bool

    @Parameter(title: "Target Platform")
    var targetPlatform: SongLinkrPlatform?

    func perform() async throws -> some IntentResult & ReturnsValue<[URL]> {
        let network = Network.shared
        let encodedURL = Network.encodeURL(from: url.absoluteString)
        let response = try await network.request(from: .search(with: encodedURL))
        let platformLinks = network.fixDictionaries(response: response)

        if chooseSpecificPlatform, let target = targetPlatform {
            return .result(value: platformLinks.filter { $0.id == target.asPlatform }.map { $0.url })
        }
        return .result(value: platformLinks.map { $0.url })
    }
}
