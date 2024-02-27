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
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
    private func openApp() {
        
        getShareMedia {
            guard let scheme = URL(string: "oxchat://shareMessageWithScheme") else {
                return
            }
            self.extensionContext?.open(scheme)
        }
    }
    
    private func getShareMedia(completion: @escaping () -> Void) {
        
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem else {
            return
        }
        
        if let attachments = extensionItem.attachments {
            for itemProvider in attachments {
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                    itemProvider.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil) { (data, error) in
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
