//
//  File.swift
//  ox_common
//
//  Created by water on 2025/2/25.
//

import UIKit

class ClipboardHelper {

    static func hasImages() -> Bool {
        return UIPasteboard.general.hasImages
    }

    static func getImages() -> [String] {
        guard let image = UIPasteboard.general.image else {
            return []
        }

        let fileManager = FileManager.default
        let tempDir = NSTemporaryDirectory()
        let filename = "clipboard_image_\(UUID().uuidString).png"
        let filePath = tempDir.appending(filename)
        let fileURL = URL(fileURLWithPath: filePath)

        if let data = image.pngData() {
            do {
                try data.write(to: fileURL)
                return [filePath]
            } catch {
                print("Failed to save image to \(filePath): \(error)")
            }
        }
        return []
    }
    
    static func copyImageToClipboard(imagePath: String) -> Bool {
        if let uiImage = UIImage(contentsOfFile: imagePath) {
            UIPasteboard.general.image = uiImage
            return true
        } else {
            return false
        }
    }
}
