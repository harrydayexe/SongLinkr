//
//  ActionViewController.swift
//  SongLinkrActionWithView
//
//  Created by Harry Day on 23/04/2021.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Get the item[s] we're handling from the extension context.
        
        guard let extensionItem = extensionContext!.inputItems.first as? NSExtensionItem else {
            print("No Extension Item")
            return
        }
        guard let attachments = extensionItem.attachments else {
            print("No Attachments")
            return
        }
        
        let itemProvider = attachments.first!
        let propertyList = String("public.url")
        
        
        if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
            itemProvider.loadItem(forTypeIdentifier: propertyList, options: nil) { (item, error) in
                guard let url = item as? URL else { return }
                print("URL retrieved: \(url.absoluteString)")
                
                OperationQueue.main.addOperation {
                    self.redirectToHostApp(with: url.absoluteString)
                    self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
                }
            }
        } else {
            print("error")
        }
    }
    
    func redirectToHostApp(with urlString: String) {
        let url = URL(string: "songlinkr:\(urlString)")
        let selectorOpenURL = sel_registerName("openURL:")
        let context = NSExtensionContext()
        context.open(url! as URL, completionHandler: nil)
        
        var responder = self as UIResponder?
        
        while (responder != nil){
            if responder?.responds(to: selectorOpenURL) == true{
                responder?.perform(selectorOpenURL, with: url)
            }
            responder = responder!.next
        }
    }
}
