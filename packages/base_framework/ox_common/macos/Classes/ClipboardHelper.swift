//
//  File.swift
//  ox_common
//
//  Created by water on 2025/2/25.
//

import Cocoa

class ClipboardHelper {

    static func hasImages() -> Bool {
        NSPasteboard.general.canReadObject(forClasses: [NSImage.self], options: nil)
    }

    static func getImages() -> [String] {
        let pasteboard = NSPasteboard.general
        guard let images = pasteboard.readObjects(forClasses: [NSImage.self], options: nil) as? [NSImage] else {
            return []
        }

        var filePaths: [String] = []
        for image in images {
            let filePath = saveImageToFile(image)
            if !filePath.isEmpty {
                filePaths.append(filePath)
            }
        }
        return filePaths
    }
    
    static func copyImageToClipboard(imagePath: String) -> Bool {
        if let nsImage = NSImage(contentsOfFile: imagePath) {
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.writeObjects([nsImage])
            return true
        } else {
            return false
        }
    }
}

extension ClipboardHelper {
    
    private static func saveImageToFile(_ image: NSImage) -> String {
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [:]) else {
            return ""
        }

        let tempDir = FileManager.default.temporaryDirectory
        let filePath = tempDir.appendingPathComponent("clipboard_image_\(UUID().uuidString).png")

        do {
            try pngData.write(to: filePath)
            return filePath.path
        } catch {
            return ""
        }
    }
}
