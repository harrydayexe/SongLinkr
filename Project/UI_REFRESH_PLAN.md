# SongLinkr iOS 27 refresh plan

Goal: min target iOS 27, Swift 6 language mode with full concurrency checking, `@Observable` view models, Liquid Glass UI replacing the neumorphic design.

## Phase 1 — Project settings (do first)

- `IPHONEOS_DEPLOYMENT_TARGET = 27.0` everywhere (app, share extension, SongLinkrNetworkCore — some configs still say 16.0, app says 26.5).
- `SWIFT_VERSION = 6.0` (currently 5.0 — no strict concurrency is being enforced at all).
- Add `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` (approachable concurrency is already on). App code becomes implicitly `@MainActor`; mark hot paths `nonisolated`/`@concurrent` deliberately.
- Build in Xcode 27 and fix errors incrementally. Note `UIDesignRequiresCompatibility` is removed in Xcode 27 — Liquid Glass applies on recompile whether you restyle or not.

## Phase 2 — Model & concurrency layer

- `Network`: `static var shared` → `static let` (or make `Network` an actor). Mutable statics are data races under Swift 6.
- `RequestViewModel`: delete the singleton. Own it with `@State` in `SongLinkrApp`/`MainTabView`, inject with `.environment(...)`.
- Split `RequestViewModel` (it does networking, Shazam audio, and presentation):
  - `SearchModel` (`@Observable @MainActor`) — search, results, error state.
  - `ShazamMatcher` (`@Observable`) — owns `SHSession`/`AVAudioEngine`. Replace `SHSessionDelegate` + `DispatchQueue.main.async` with `SHSession.results` async sequence (`for await result in session.results`). Use `AVAudioApplication.requestRecordPermission()` async API.
- `UserSettings` → `@Observable`, drop Combine. Keep `didSet` → UserDefaults writes or back with `UserDefaults` directly.
- `HistoryViewModel`: fix strong `self` capture in the `sink`. Better: migrate Core Data → SwiftData, use `@Query` in `HistoryView`, delete this VM entirely. (Optional, largest single lift — can be deferred.)
- Error/results presentation: replace custom `Binding<Bool>` computed properties with `.sheet(item: $model.results)` and iOS 27 `.alert(item: $model.error)`. Make `ResultsModel`/error `Identifiable`. Removes the `resultsObject!` force unwrap.

## Phase 3 — Mechanical view modernisation

| Old | New |
|---|---|
| `NavigationView` | `NavigationStack` |
| `.tabItem` + tag Ints | `Tab(value:)` builder + `AppTab` enum |
| `@StateObject` / `@EnvironmentObject` | `@State` / `@Environment` with `@Observable` |
| `.foregroundColor` | `.foregroundStyle` |
| `.cornerRadius(15)` | `.clipShape(.rect(cornerRadius: 15))` or button border shapes |
| `.accessibility(label:)` etc. | `.accessibilityLabel`, `.accessibilityAddTraits`, `.accessibilityHint` |
| `Alert(...)` struct | `.alert(item:)` with buttons builder |
| `ShareSheet` / `ActivityView` wrapper | `ShareLink` |
| `UIApplication.shared.open` | `@Environment(\.openURL)` |
| `UIPasteboard.general.url` in `onAppear` | `PasteButton` / `UIPasteboard.detectPatterns` (avoids paste permission prompt) |
| `print(...)` | `Logger` (OSLog) |

Also fix: double `.buttonStyle` on GetLinkButton/ShazamButton; `#warning("Fix this")` in HistoryView; "Search again" should call the search model directly instead of round-tripping through the `songlinkr:` URL scheme; deduplicate the swipe-actions closure in HistoryView.

## Phase 4 — Liquid Glass design

Delete: `NeumorphicShadowModifier`, `Color.offWhite` backgrounds, `GetLinkButtonStyle` gradient, flat-colour `PlatformLinkButtonStyle`.

- **Search screen**: capsule glass text field; `.buttonStyle(.glassProminent)` for Get Links; `.glassEffect(.regular.interactive())` Shazam button. `.toolbarMinimizeBehavior` where scrolling exists.
- **Results**: blurred artwork as full-bleed backdrop (`backgroundExtensionEffect` where applicable); platform links as capsule glass buttons inside a `GlassEffectContainer`, tinted with brand colour: `.glassEffect(.regular.tint(platform.color).interactive())`. Share via `ShareLink` in `ToolbarItem(placement: .topBarPinnedTrailing)`.
- **Tab bar**: `Tab(role: .search)` for main screen; consider `Tab(role: .prominent)` (iOS 27) for Shazam as a standout listen button.
- **History**: standard `List` styling (system glass chrome comes free), keep swipe actions, `.toolbarMinimizeBehavior(.onScrollDown, for: .navigationBar)`.
- Test against the iOS 27 user transparency slider and Reduce Transparency accessibility setting.

## Phase 5 — Verify

- Full build with Swift 6 strict concurrency, zero warnings.
- Run SongLinkrNetworkCore tests; consider migrating XCTest → Swift Testing.
- Test share extension and App Intents paths (they share the singletons being removed).
- Light/dark, Dynamic Type, VoiceOver pass on the three main screens.
