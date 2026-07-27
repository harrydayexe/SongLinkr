import AppIntents

struct SendToSongLinkrIntent: AppIntent {
    static let title: LocalizedStringResource = "Send to SongLinkr"
    static let description = IntentDescription("Open a music link in SongLinkr")
    static let openAppWhenRun: Bool = true

    @Parameter(title: "URL")
    var url: URL

    func perform() async throws -> some IntentResult {
        UserDefaults.standard.set(url.absoluteString, forKey: "pendingDeepLinkURL")
        return .result()
    }
}
