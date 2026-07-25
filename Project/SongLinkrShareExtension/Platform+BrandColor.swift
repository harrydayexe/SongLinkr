import SwiftUI
import SongLinkrNetworkCore

extension Platform {
    var brandColor: Color {
        switch self {
        case .spotify:                return Color(red: 29/255,  green: 185/255, blue: 84/255)
        case .appleMusic:             return Color(red: 250/255, green: 87/255,  blue: 193/255)
        case .itunes:                 return Color(red: 234/255, green: 76/255,  blue: 192/255)
        case .youtube, .youtubeMusic: return Color(red: 255/255, green: 0,       blue: 0)
        case .google, .googleStore:   return Color(red: 66/255,  green: 133/255, blue: 244/255)
        case .pandora:                return Color(red: 0,       green: 160/255, blue: 238/255)
        case .deezer:                 return Color(red: 254/255, green: 171/255, blue: 46/255)
        case .tidal:                  return Color(red: 0,       green: 0,       blue: 0)
        case .amazonMusic:            return Color(red: 0,       green: 168/255, blue: 225/255)
        case .amazonStore:            return Color(red: 255/255, green: 153/255, blue: 0)
        case .soundcloud:             return Color(red: 254/255, green: 80/255,  blue: 0)
        case .napster:                return Color(red: 253/255, green: 184/255, blue: 19/255)
        case .yandex:                 return Color(red: 255/255, green: 92/255,  blue: 92/255)
        case .spinrilla:              return Color(red: 64/255,  green: 14/255,  blue: 83/255)
        case .audius:                 return Color(red: 204/255, green: 0,       blue: 168/255)
        case .audiomack:              return Color(red: 255/255, green: 162/255, blue: 0)
        default:                      return .secondary
        }
    }
}
