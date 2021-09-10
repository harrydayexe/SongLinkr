//
//  PlatformLinkButtonView.swift
//  SongLinkr
//
//  Created by Harry Day on 06/07/2020.
//

import SwiftUI
import SongLinkrNetworkCore

struct PlatformLinkButtonView: View {
    @State var platform: PlatformLinks
    
    var body: some View {
        Button(action: {
            UIApplication.shared.open(platform.nativeAppUriMobile ?? platform.url)
        }) {
            HStack {
                Image(platform.id.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 50, maxWidth: 75, minHeight: 50, maxHeight: 75)
                Text(platform.id.displayName)
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .minimumScaleFactor(0.5)
                    .padding()
                Spacer()
            }
            .frame(minWidth: 200, maxWidth: 400, minHeight: 50, maxHeight: 75)
        }
        .buttonStyle(PlatformLinkButtonStyle(platform: platform.id))
    }
}

struct PlatformLinkButtonView_Previews: PreviewProvider {
    static let platforms = [PlatformLinks(id: Platform.yandex, url: URL(string: "https://music.yandex.ru/track/59994505")!),
        PlatformLinks(id: Platform.youtube, url: URL(string: "https://www.youtube.com/watch?v=QfnVrp2bPuE")!),
        PlatformLinks(id: Platform.google, url: URL(string: "https://play.google.com/music/m/Tpubjccp2vd46677axbqaec726i?signup_if_needed=1")!),
        PlatformLinks(id: Platform.youtubeMusic, url: URL(string: "https://music.youtube.com/watch?v=QfnVrp2bPuE")!),
        PlatformLinks(id: Platform.amazonStore, url: URL(string: "https://amazon.com/dp/B081QMVJ42?tag=songlink0d-20")!),
        PlatformLinks(id: Platform.soundcloud, url: URL(string: "https://soundcloud.com/inzo_music/inzo-angst")!),
        PlatformLinks(id: Platform.itunes, url: URL(string: "https://geo.music.apple.com/us/album/_/1488452376?i=1488452377&mt=1&app=itunes&at=1000lHKX")!, nativeAppUriMobile: URL(string: "itmss://itunes.apple.com/us/album/_/1488452376?i=1488452377&mt=1&app=itunes&at=1000lHKX")!, nativeAppUriDesktop: URL(string: "itmss://itunes.apple.com/us/album/_/1488452376?i=1488452377&mt=1&app=itunes&at=1000lHKX")!),
        PlatformLinks(id: Platform.amazonMusic, url: URL(string: "https://music.amazon.com/albums/B081QNFXHB?trackAsin=B081QMVJ42&do=play")!),
        PlatformLinks(id: Platform.appleMusic, url: URL(string: "https://geo.music.apple.com/us/album/_/1488452376?i=1488452377&mt=1&app=music&at=1000lHKX")!, nativeAppUriMobile: URL(string: "itmss://itunes.apple.com/us/album/_/1488452376?i=1488452377&mt=1&app=music&at=1000lHKX")!, nativeAppUriDesktop: URL(string: "music://itunes.apple.com/us/album/_/1488452376?i=1488452377&mt=1&app=music&at=1000lHKX")!),
        PlatformLinks(id: Platform.googleStore, url: URL(string: "https://play.google.com/store/music/album?id=Btq6ws6c5cdsrc2kookzr2ujmkm&tid=song-Tpubjccp2vd46677axbqaec726i")!),
        PlatformLinks(id: Platform.spotify, url: URL(string: "https://open.spotify.com/track/3NivHilTTTs8SQwp51yG0X")!),
        PlatformLinks(id: Platform.pandora, url: URL(string: "https://pandora.app.link/?$desktop_url=https%3A%2F%2Fwww.pandora.com%2FTR%3A26063002&$ios_deeplink_path=pandorav4%3A%2F%2Fbackstage%2Ftrack%3Ftoken%3DTR%3A26063002&$android_deeplink_path=pandorav4%3A%2F%2Fbackstage%2Ftrack%3Ftoken%3DTR%3A26063002")!),
        PlatformLinks(id: Platform.deezer, url: URL(string: "https://www.deezer.com/track/811904832")!),
        PlatformLinks(id: Platform.tidal, url: URL(string: "https://listen.tidal.com/track/123030090")!),
        PlatformLinks(id: Platform.napster, url: URL(string: "http://napster.com/artist/art.19296515/album/alb.246588025/track/tra.246588040")!)
    ]
    
    static var previews: some View {
        Group {
            /*
            ForEach(platforms) { platform in
                PlatformLinkButtonView(platform: platform)
                    .previewDisplayName(platform.id.displayName)
            }*/
            PlatformLinkButtonView(platform: platforms[13])
            PlatformLinkButtonView(platform: platforms[5])
        }
        .previewLayout(.fixed(width: 400, height: 300))
    }
}
