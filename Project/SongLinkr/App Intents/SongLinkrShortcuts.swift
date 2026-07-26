import AppIntents

struct SongLinkrShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: MatchURLToPlatformIntent(),
            phrases: [
                "Match URL with \(.applicationName)",
                "Convert music link with \(.applicationName)"
            ],
            shortTitle: "Match URL to Platform",
            systemImageName: "music.note.list"
        )
        AppShortcut(
            intent: SendToSongLinkrIntent(),
            phrases: [
                "Send to \(.applicationName)"
            ],
            shortTitle: "Send to SongLinkr",
            systemImageName: "arrow.up.forward.app"
        )
    }
}
