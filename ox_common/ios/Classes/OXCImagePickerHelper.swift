//
//  OXCImagePickerHelper.swift
//  ox_common
//
//  Created by zhw on 2023/10/20.
//

import UIKit
import ZLPhotoBrowser
import Photos

class OXCImagePickerHelper {

    static func getPickerPaths(params: [String: Any]?, result: @escaping FlutterResult) {
        
        guard let window = UIApplication.shared.delegate?.window as? UIWindow, let currentController = window.rootViewController else {
            return
        }
        
        let selectCount = params?["selectCount"] as? Int ?? 0
        let compressSize = (params?["compressSize"] as? Int ?? 0) * 1024
        let galleryMode = params?["galleryMode"] as? String ?? ""
        let enableCrop = params?["enableCrop"] as? Bool ?? false
        var height = params?["height"] as? Int ?? 0
        var width = params?["width"] as? Int ?? 0
        if width <= 0 || height <= 0 {
            width = 0
            height = 1
        }
        let showCamera = params?["showCamera"] as? Bool ?? false
        let isShowGif = params?["isShowGif"] as? Bool ?? false
        let cameraMimeType = params?["cameraMimeType"] as? String ?? ""
        
        let configuration = ZLPhotoConfiguration.default()
        let configurationUI = ZLPhotoUIConfiguration.default()
        
        configuration.maxSelectCount = selectCount
        configuration.allowTakePhotoInLibrary = showCamera
        configuration.allowSelectOriginal = false
        configuration.downloadVideoBeforeSelecting = true
        configuration.allowSelectGif = isShowGif
        configurationUI.cellCornerRadio = 5
        
        // Video
        if cameraMimeType == "video" || galleryMode == "video" || galleryMode == "all" {
            if let videoRecordMinSecond = params?["videoRecordMinSecond"] as? Int {
                configuration.cameraConfiguration.minRecordDuration = videoRecordMinSecond
            }
            if let videoSelectMinSecond = params?["videoSelectMinSecond"] as? Int {
                configuration.minSelectVideoDuration = videoSelectMinSecond
            }
            if let videoRecordMaxSecond = params?["videoRecordMaxSecond"] as? Int {
                configuration.cameraConfiguration.maxRecordDuration = videoRecordMaxSecond
            }
            if let videoSelectMaxSecond = params?["videoSelectMaxSecond"] as? Int {
                configuration.maxSelectVideoDuration = videoSelectMaxSecond;
            }
        }
        
        // Editing
        configuration.allowEditImage = enableCrop
        if enableCrop && selectCount == 1 {
            configuration.editAfterSelectThumbnailImage = false
        } else {
            configuration.editAfterSelectThumbnailImage = true
        }
        
        configuration.editImageConfiguration.tools_objc = [1]
        let ratio = ZLImageClipRatio(title: "", whRatio: Double(width) / Double(height), isCircle: false)
        configuration.editImageConfiguration.clipRatios = [ratio]
        
        if let colorString = params?["uiColor"] as? [String: Any] {
            self.colorChange(colorString: colorString, configuration: configurationUI)
        }
        
        if !cameraMimeType.isEmpty {
            if cameraMimeType == "photo" {
                configuration.allowMixSelect = false
                configuration.cameraConfiguration.allowTakePhoto = true
                configuration.cameraConfiguration.allowRecordVideo = false
                configuration.allowSelectImage = true
                configuration.allowSelectVideo = false
            } else if cameraMimeType == "video" {
                configuration.allowMixSelect = true
                configuration.cameraConfiguration.allowTakePhoto = false
                configuration.cameraConfiguration.allowRecordVideo = true
                configuration.allowSelectImage = false
                configuration.allowSelectVideo = true
            }
            
            let camera = ZLCustomCamera()
            camera.takeDoneBlock = { (image: UIImage?, videoUrl: URL?) in
                if let image = image {
                    
                    guard let originData = image.jpegData(compressionQuality: 1) else {
                        return
                    }
                    var size = 1.0
                    if originData.count > compressSize {
                        size = Double(compressSize) / Double(originData.count)
                    }
                    
                    guard let compressData = image.jpegData(compressionQuality: size) else {
                        return
                    }
                    
                    let compressImage = UIImage(data: compressData)
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyyMMddHHmmss"
                    let x = arc4random() % 10000
                    let name = "\(formatter.string(from: Date()))01\(x)"
                    let fileExtension = imageType(data: compressData)
                    let jpgPath = (NSHomeDirectory() as NSString).appendingPathComponent("Documents/\(name).\(fileExtension)")

                    try? compressData.write(to: URL(fileURLWithPath: jpgPath))

                    let photoDic: [String: String] = [
                        "thumbPath": jpgPath,
                        "path": jpgPath
                    ]

                    let arr = [photoDic]
                    result(arr) // Assuming result is a closure or function you want to call with `arr` as argument.
                    return
                }
            }
            
            
            currentController.showDetailViewController(camera, sender: nil)
            
        } else {
            
            let ac = ZLPhotoPreviewSheet()
            
            if galleryMode == "all" {
                configuration.allowMixSelect = true
                ZLPhotoConfiguration.default().cameraConfiguration.allowTakePhoto = true
                ZLPhotoConfiguration.default().cameraConfiguration.allowRecordVideo = true
                configuration.allowSelectImage = true
                configuration.allowSelectVideo = true
            } else if galleryMode == "image" {
                configuration.allowMixSelect = false
                ZLPhotoConfiguration.default().cameraConfiguration.allowTakePhoto = true
                ZLPhotoConfiguration.default().cameraConfiguration.allowRecordVideo = false
                configuration.allowSelectImage = true
                configuration.allowSelectVideo = false
            } else if galleryMode == "video" {
                configuration.allowMixSelect = true  // As per the comment, allowing mix selection
                ZLPhotoConfiguration.default().cameraConfiguration.allowTakePhoto = false
                ZLPhotoConfiguration.default().cameraConfiguration.allowRecordVideo = true
                configuration.allowSelectImage = false
                configuration.allowSelectVideo = true
            }

            var resultArr = [[String: Any?]]()
            ac.cancelBlock = {
                let arr: [Any] = []
                result(arr)
            }
            ac.selectImageBlock = { modelList, isSelectOriginal in
                if modelList.count > 0 {
                    self.saveImageView(0, imagePHAsset: modelList, resultArr: resultArr, compressSize: compressSize, result: result)
                }
            }
            
            ac.showPhotoLibrary(sender: currentController)
        }
    }
    
    private static func colorChange(colorString: [String: Any], configuration: ZLPhotoUIConfiguration) {
        let colorType = stringChangeColor(colorString: colorString)
        let light = colorString["l"] as? Int ?? 0
        
        // 相册列表界面背景色
        let configurationUI = ZLPhotoUIConfiguration.default()
        configurationUI.albumListBgColor = .white
        configurationUI.previewVCBgColor = .white
        // 分割线颜色
        configurationUI.separatorColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 0.98)
        // 小图界面背景色
        configurationUI.thumbnailBgColor = .white
        
        // 预览快速选择模式下 拍照/相册/取消 的背景颜色
        if light <= 179 {
            configurationUI.navBarColor = colorType
            configurationUI.navTitleColor = .white
            configurationUI.navBarColorOfPreviewVC = colorType
            configurationUI.bottomToolViewBtnNormalTitleColor = .white
            configurationUI.bottomToolViewBtnNormalBgColor = colorType
            configurationUI.bottomToolViewBtnDisableBgColor = colorType
            configurationUI.bottomToolViewBtnNormalBgColorOfPreviewVC = colorType
            configurationUI.cameraRecodeProgressColor = colorType
            configurationUI.indexLabelBgColor = colorType
            configurationUI.bottomToolViewBgColor = colorType
            configurationUI.navEmbedTitleViewBgColor = colorType
        } else {
            configurationUI.navBarColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
            configurationUI.navTitleColor = .black
            configurationUI.navBarColorOfPreviewVC = .black
            configurationUI.bottomToolViewBtnNormalBgColor = .black
            configurationUI.bottomToolViewBtnDisableBgColor = .black
            configurationUI.cameraRecodeProgressColor = .black
            configurationUI.indexLabelBgColor = .black
            configurationUI.bottomToolViewBgColor = .white
            configurationUI.navEmbedTitleViewBgColor = .white
        }
        
        configurationUI.albumListTitleColor = .black
        configurationUI.navViewBlurEffectOfPreview = UIBlurEffect(style: .light)
        configurationUI.navViewBlurEffectOfAlbumList = UIBlurEffect(style: .light)
        configurationUI.bottomViewBlurEffectOfPreview = UIBlurEffect(style: .light)
        configurationUI.bottomViewBlurEffectOfAlbumList = UIBlurEffect(style: .light)
    }

    private static func stringChangeColor(colorString: [String: Any]) -> UIColor {
        let alph = colorString["a"] as? Int ?? 0
        let red = colorString["r"] as? Int ?? 0
        let green = colorString["g"] as? Int ?? 0
        let blue = colorString["b"] as? Int ?? 0
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alph) / 255.0)
    }

    private static func imageType(data: Data) -> String {
        var c: UInt8 = 0
        data.copyBytes(to: &c, count: 1)
        
        switch c {
        case 0xFF:
            return "JPEG"
        case 0x89:
            return "PNG"
        case 0x47:
            return "GIF"
        case 0x49, 0x4D:
            return "PNG"
        case 0x52:
            return "PNG"
        case 0x00:
            return "PNG"
        default:
            return "PNG"
        }
    }
    
    private static func saveImageView(_ index: Int, imagePHAsset modelList: [ZLResultModel], resultArr: [[String: Any?]], compressSize: Int, result: @escaping FlutterResult) {
        
        if index == modelList.count {
            result(resultArr)
            return
        }
        
        let asset = modelList[index].asset
        let newIndex = index + 1
        
        if asset.mediaType == .video {
            
            let options = PHVideoRequestOptions()
            options.version = .current
            options.deliveryMode = .automatic
            options.isNetworkAccessAllowed = true
            
            let manager = PHImageManager.default()
            manager.requestAVAsset(forVideo: asset, options: options) { asset, audioMix, info in
                if let urlAsset = asset as? AVURLAsset {
                    let url = urlAsset.url
                    let subString = String(url.absoluteString.dropFirst(7))
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyyMMddHHmmss"
                    let name = "\(formatter.string(from: Date()))\(arc4random() % 10000)"
                    let jpgPath = "\(NSHomeDirectory())/Documents/\(name)"
                    
                    let img = self.getImage(from: subString)
                    try? img?.jpegData(compressionQuality: 1.0)?.write(to: URL(fileURLWithPath: jpgPath))
                    
                    let aPath3 = "\(NSHomeDirectory())/Documents/\(name)"
                    
                    var newArr = resultArr
                    newArr.append([
                        "thumbPath": aPath3,
                        "path": subString
                    ])
                    self.saveImageView(newIndex, imagePHAsset: modelList, resultArr: newArr, compressSize: compressSize, result: result)
                }
            }
            
        } else if asset.mediaType == .image {
            
            let option = PHImageRequestOptions()
            option.isNetworkAccessAllowed = true
            
            let manage = PHImageManager()
            manage.requestImageData(for: asset, options: option) { imageData, dataUTI, orientation, info in
                guard let imageData = imageData, let path = info?["PHImageFileURLKey"] as? URL else {
                    return
                }
                
                if let im = UIImage(data: imageData) {
                    let pathExtension = ((dataUTI ?? "") as NSString).pathExtension
                    let imageLast = "\(imageData.count).\(pathExtension)"
                    if !(dataUTI?.contains("gif") ?? false) && !(dataUTI?.contains("GIF") ?? false) {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyyMMddHHmmss"
                        let name = "\(formatter.string(from: Date()))\(imageLast)"
                        let jpgPath = "\(NSHomeDirectory())/Documents/\(name)"
                        
                        var data: Data? = im.jpegData(compressionQuality: 1.0)
                        if let dataLength = data?.count, dataLength > compressSize {
                            let rate = Float(compressSize) / Float(dataLength)
                            data = im.jpegData(compressionQuality: CGFloat(rate))
                        }
                        try? data?.write(to: URL(fileURLWithPath: jpgPath))
                        
                        var newArr = resultArr
                        newArr.append([
                            "thumbPath": jpgPath,
                            "path": jpgPath
                        ])
                        self.saveImageView(newIndex, imagePHAsset: modelList, resultArr: newArr, compressSize: compressSize, result: result)
                    } else {
                        // Handle GIF image
                        // The original Objective-C code has a method `createFile:suffix:` which appears to be a custom method.
                        // For the translation, I'll assume its purpose and replicate it.
                        let gifData = imageData
                        let str = createFile(data: gifData, suffix: ".gif")
                        
                        var newArr = resultArr
                        newArr.append([
                            "thumbPath": str,
                            "path": str
                        ])
                        self.saveImageView(newIndex, imagePHAsset: modelList, resultArr: newArr, compressSize: compressSize, result: result)
                    }
                }
            }
        }
    }

    private static func getImage(from videoURL: String) -> UIImage? {
        let asset = AVURLAsset(url: URL(fileURLWithPath: videoURL))
        let gen = AVAssetImageGenerator(asset: asset)
        gen.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        var actualTime = CMTimeMakeWithSeconds(0, preferredTimescale: 0)
        guard let image = try? gen.copyCGImage(at: time, actualTime: &actualTime) else {
            return nil
        }
        return UIImage(cgImage: image)
    }
    
    static func createFile(data: Data, suffix: String) -> String? {
        let tmpPath = temporaryFilePath(suffix: suffix)
        if FileManager.default.createFile(atPath: tmpPath, contents: data, attributes: nil) {
            return tmpPath
        } else {
            return nil
        }
        return tmpPath
    }
    
    static func temporaryFilePath(suffix: String) -> String {
        let fileExtension = "image_picker_\(suffix)"
        let guid = ProcessInfo.processInfo.globallyUniqueString
        let tmpFile = String(format: fileExtension, guid)
        let tmpDirectory = NSTemporaryDirectory()
        let tmpPath = (tmpDirectory as NSString).appendingPathComponent(tmpFile)
        return tmpPath
    }
}
