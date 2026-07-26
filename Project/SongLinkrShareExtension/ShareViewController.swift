import UIKit
import SwiftUI
import UniformTypeIdentifiers

final class ShareViewController: UIViewController {
    private let viewModel = ShareExtensionViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        let contentView = ShareExtensionView(viewModel: viewModel) {
            self.extensionContext?.completeRequest(returningItems: nil)
        }
        .environment(\.openURL, OpenURLAction { [weak self] url in
            self?.openExternalURL(url)
            return .handled
        })

        let host = UIHostingController(rootView: contentView)
        addChild(host)
        host.view.frame = view.bounds
        host.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(host.view)
        host.didMove(toParent: self)

        Task { @MainActor in
            guard let url = await extractURL() else {
                viewModel.state = .error("Could not read the shared URL.")
                return
            }
            viewModel.load(url: url)
        }
    }

    // Share Extensions cannot use NSExtensionContext.open(_:) or UIApplication.shared.open(_:).
    // Traversing the responder chain to UIApplication is the established workaround.
    private func openExternalURL(_ url: URL) {
        var responder: UIResponder? = self
        while let r = responder {
            if let application = r as? UIApplication {
                application.open(url, options: [:]) { [weak self] _ in
                    self?.extensionContext?.completeRequest(returningItems: nil)
                }
                return
            }
            responder = r.next
        }
        // Fallback if UIApplication isn't reachable via responder chain
        UIPasteboard.general.url = url
        extensionContext?.completeRequest(returningItems: nil)
    }

    private func extractURL() async -> URL? {
        guard
            let item = extensionContext?.inputItems.first as? NSExtensionItem,
            let attachment = item.attachments?.first(where: {
                $0.hasItemConformingToTypeIdentifier(UTType.url.identifier)
            })
        else { return nil }

        return try? await withCheckedThrowingContinuation { continuation in
            attachment.loadObject(ofClass: NSURL.self) { nsurl, error in
                if let url = nsurl as? URL {
                    continuation.resume(returning: url)
                } else {
                    continuation.resume(throwing: error ?? URLError(.badURL))
                }
            }
        }
    }
}
