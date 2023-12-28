//
//  OXCFileHelper.swift
//  ox_common
//
//  Created by zhw on 2023/12/18.
//

import UIKit

class OXCFileHelper {
    static func exportFile(atPath filePath: String, sender: UIViewController) {
        let fileURL = URL(fileURLWithPath: filePath)
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        
        // for iPad
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = sender.view
            popoverController.sourceRect = CGRect(x: sender.view.bounds.midX, y: sender.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        sender.present(activityViewController, animated: true, completion: nil)
        
    }
    
    static func importFile(sender: UIViewController, callback: @escaping (String) -> Void) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
        documentPicker.delegate = sender
        sender.documentPickerCallback = callback
        sender.present(documentPicker, animated: true)
    }
    
    
}

private var documentPickerCallbackKey: Void?

// UIDocumentPickerDelegate
extension UIViewController: UIDocumentPickerDelegate {
    
    public var documentPickerCallback: ((String) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &documentPickerCallbackKey) as? ((String) -> Void)
        }
        set {
            objc_setAssociatedObject(self, &documentPickerCallbackKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }
        documentPickerCallback?(selectedFileURL.path)
    }
}
