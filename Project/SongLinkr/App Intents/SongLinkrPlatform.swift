import AppIntents
import SongLinkrNetworkCore

// AppEnum requires the enum to be defined in the same module as the conformance,
// so this mirrors Platform from SongLinkrNetworkCore with the same raw values.
enum SongLinkrPlatform: String, AppEnum {
    case spotify
    case itunes
    case appleMusic
    case youtube
    case youtubeMusic
    case google
    case googleStore
    case pandora
    case deezer
    case tidal
    case amazonStore
    case amazonMusic
    case soundcloud
    case napster
    case yandex
    case spinrilla
    case audius
    case audiomack

    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Platform"

    static let caseDisplayRepresentations: [SongLinkrPlatform: DisplayRepresentation] = [
        .spotify:      "Spotify",
        .itunes:       "iTunes",
        .appleMusic:   "Apple Music",
        .youtube:      "YouTube",
        .youtubeMusic: "YouTube Music",
        .google:       "Google",
        .googleStore:  "Google Store",
        .pandora:      "Pandora",
        .deezer:       "Deezer",
        .tidal:        "Tidal",
        .amazonStore:  "Amazon Store",
        .amazonMusic:  "Amazon Music",
        .soundcloud:   "SoundCloud",
        .napster:      "Napster",
        .yandex:       "Yandex",
        .spinrilla:    "Spinrilla",
        .audius:       "Audius",
        .audiomack:    "Audiomack",
    ]

    var asPlatform: Platform {
        Platform(rawValue: self.rawValue) ?? .unknown
    }
}
