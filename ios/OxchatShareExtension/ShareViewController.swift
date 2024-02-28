//
//  ShareViewController.swift
//  OxChatShareExtension
//
//  Created by Zharlie on 2024/2/26.
//

import UIKit
import Social
import CoreServices

class ShareViewController: SLComposeServiceViewController {
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        openApp()
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
    private func openURL(url: NSURL) -> Bool {
        do {
            let application = try self.sharedApplication()
            return application.performSelector(inBackground: "openURL:", with: url) != nil
        }
        catch {
            return false
        }
    }

    private func sharedApplication() throws -> UIApplication {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application
            }

            responder = responder?.next
        }

        throw NSError(domain: "UIInputViewController+sharedApplication.swift", code: 1, userInfo: nil)
    }
    
    private func openApp() {
        
        getShareMedia {
            guard let scheme = NSURL(string: "oxchat://shareMessageWithScheme") else {
                self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                return
            }
            self.openURL(url: scheme)
            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        }
    }
    
    private func getShareMedia(completion: @escaping () -> Void) {
        
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem else {
            return
        }
        
        if let attachments = extensionItem.attachments {
            for itemProvider in attachments {
                let urlIdentifier = kUTTypeURL as String
                if itemProvider.hasItemConformingToTypeIdentifier(urlIdentifier) {
                    itemProvider.loadItem(forTypeIdentifier: urlIdentifier, options: nil) { (data, error) in
                        if let url = data as? URL {
                            AppGroupHelper.saveDataForGourp(
                                url.absoluteString,
                                forKey: AppGroupHelper.shareDataKey
                            )
                            completion()
                        }
                    }
                }
            }
        }
    }
}
