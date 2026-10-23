import SwiftUI
import UIKit

final class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = ShareExtensionViewModel(
            inputItems: extensionContext?.inputItems.compactMap { $0 as? NSExtensionItem } ?? []
        )

        let contentView = ShareExtensionView(viewModel: viewModel) { [weak self] in
            self?.extensionContext?.cancelRequest(withError: CocoaError(.userCancelled))
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
    }

    /// Share extensions can't use `UIApplication.shared` or `NSExtensionContext.open(_:)`, so
    /// this reaches the application through the responder chain, the established workaround.
    private func openExternalURL(_ url: URL) {
        var responder: UIResponder? = self
        while let current = responder {
            if let application = current as? UIApplication {
                application.open(url) { [weak self] success in
                    // Stay open if nothing could handle the link, so the user can pick another
                    if success {
                        self?.extensionContext?.completeRequest(returningItems: nil)
                    }
                }
                return
            }
            responder = current.next
        }
    }
}
