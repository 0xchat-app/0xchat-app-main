//
//  Tools.swift
//  Runner
//
//  Created by Zzz on 2024/12/4.
//

import Foundation
import UniformTypeIdentifiers

class Tools {
    static func getFileType(from url: URL) -> String {
        let fileExtension = url.pathExtension.lowercased()

        if #available(iOS 14.0, *) {
            if let type = UTType(filenameExtension: fileExtension) {
                if type.conforms(to: .image) {
                    return "image"
                } else if type.conforms(to: .pdf) {
                    return "pdf"
                } else if type.conforms(to: .video) || type.conforms(to: .movie) {
                    return "video"
                } else if type.conforms(to: .audio) {
                    return "audio"
                } else {
                    return "unknown"
                }
            }
        } else {
            let mimeType = mimeTypeForExtension(fileExtension)
            switch mimeType {
            case "image", "image/jpeg", "image/png", "image/gif", "image/bmp":
                return "image"
            case "audio", "audio/mpeg", "audio/wav", "audio/mp3", "audio/aac":
                return "audio"
            case "video", "video/mp4", "video/quicktime":
                return "video"
            case "application/pdf":
                return "pdf"
            default:
                return "unknown"
            }
        }
        return "unknown"
    }
    
    private static func mimeTypeForExtension(_ ext: String) -> String {
        let mimeTypes: [String: String] = [
            "jpg": "image/jpeg",
            "jpeg": "image/jpeg",
            "png": "image/png",
            "gif": "image/gif",
            "bmp": "image/bmp",
            "mp3": "audio/mp3",
            "wav": "audio/wav",
            "aac": "audio/aac",
            "mp4": "video/mp4",
            "mov": "video/quicktime",
            "pdf": "application/pdf"
        ]
        
        return mimeTypes[ext] ?? "unknown"
    }
}
