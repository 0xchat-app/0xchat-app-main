import Flutter
import UIKit
import MobileCoreServices
import Foundation
import Photos

public class SwiftOXCCommonPlugin: NSObject, FlutterPlugin, UINavigationControllerDelegate {
    
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    var result:FlutterResult?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ox_common", binaryMessenger: registrar.messenger())
    let instance = SwiftOXCCommonPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

    
    
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    print("=====>ox_common \(call.method)")
    self.result = result
    switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "getImageFromCamera":
            do {
                print("=====>getImageFromCamera")
                let params = call.arguments as? [String : Any]
                var allowEditing = false
                if let isNeedTailor = params?["isNeedTailor"] as? Bool {
                    allowEditing = isNeedTailor
                }
                getImageFromCamera(allowEditing: allowEditing)
            }
            break
        case "getImageFromGallery":
            do {
                let params = call.arguments as? [String : Any]
                var allowEditing = false
                if let isNeedTailor = params?["isNeedTailor"] as? Bool {
                    allowEditing = isNeedTailor
                }
                getImageFromGallery(allowEditing: allowEditing)
            }
            break
        case "getVideoFromCamera":
            getVideoFromCamera()
            
        case "getCompressionImg":
            do {
                let params = call.arguments as? [String : Any]
                guard let filePath = params?["filePath"] as? String else {
                    return result(nil)
                }
                
                guard let quality = params?["quality"] as? Int else {
                    return result(filePath)
                }
                getCompressionImg(filePath: filePath, quality: quality,result: result)
            }
            break;
        case "saveImageToGallery":
            saveImageToGallery(call.arguments as? [String:Any], result: result)
        case "callIOSSysShare":
            callIOSSysShare(call.arguments as? [String:Any], result: result)
        case "getDeviceId":
            getDeviceId(result: result)
        break;
        default:
            break;
    }
  }
    
    
    func getDeviceId(result:FlutterResult) {
        if let uuid = UserDefaults.standard.string(forKey: "com.ox.super_main.uuid") {
            result(uuid)
        }
        else {
            let uuid = UIDevice.current.identifierForVendor?.uuidString ?? NSUUID.init().uuidString
            UserDefaults.standard.set(uuid, forKey: "com.ox.super_main.uuid")
            UserDefaults.standard.synchronize()
            result(uuid)
        }
    }
    
    func getImageFromCamera(allowEditing: Bool) {
        DispatchQueue.main.async {
            self.imagePicker.mediaTypes = [kUTTypeImage as String]
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = allowEditing
            UIApplication.shared.delegate?.window??.rootViewController?.present(self.imagePicker, animated: true, completion: {
                
            });
        }
    }
    
    func getImageFromGallery(allowEditing: Bool) {
        DispatchQueue.main.async {
            self.imagePicker.mediaTypes = [kUTTypeImage as String]
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = allowEditing
            UIApplication.shared.delegate?.window??.rootViewController?.present(self.imagePicker, animated: true, completion: {
                
            });
        }
    }
    
    func getVideoFromCamera() {
        DispatchQueue.main.async {
            self.imagePicker.mediaTypes = [kUTTypeMovie as String]
            self.imagePicker.sourceType = .camera
            self.imagePicker.cameraDevice = .front
            UIApplication.shared.delegate?.window??.rootViewController?.present(self.imagePicker, animated: true, completion: {
                
            });
        }
    }
    
    func getCompressionImg(filePath:String, quality:Int, result: @escaping FlutterResult) {
        guard let image = UIImage.init(contentsOfFile: filePath) else {
            return result(nil)
        }
        let data = image.jpegData(compressionQuality: CGFloat(quality<0 ? 100 : quality)/100.0)
        let guid = ProcessInfo.processInfo.globallyUniqueString
        let tmpFile = "image_picker_\(guid).jpg"
        let tmpDirectory = NSTemporaryDirectory()
        let tmpPath = tmpDirectory.appending(tmpFile)
        if (FileManager.default.createFile(atPath: tmpPath, contents: data, attributes: nil)) {
            result(tmpPath)
        }
        else {
            result(nil)
        }
    }
    
    func saveImageToGallery(_ params:[String:Any]?,result:@escaping FlutterResult) {
        guard let param = params else {
            result("")
            return
        }
        
        guard let data = param["imageBytes"] as? FlutterStandardTypedData else {
            result("")
            return
        }

        guard  let image = UIImage.init(data: data.data) else {
            result("")
            return
        }
        
        var localIdentifier = ""
        PHPhotoLibrary.shared().performChanges {
            localIdentifier = PHAssetChangeRequest.creationRequestForAsset(from: image).placeholderForCreatedAsset?.localIdentifier ?? ""
        } completionHandler: { (success, error) in
            if success {
                let res = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil);
                guard let asset = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil).lastObject else {
                    result("")
                    return
                }
                PHImageManager.default().requestImageData(for: asset, options: nil) { (_, url, _, info) in
                    result("save success")
                }
            }
            else {
                result("")
            }
        };
    }
        
    func callIOSSysShare(_ params:[String:Any]?,result:@escaping FlutterResult) {
        guard let param = params else {
            result("")
            return
        }
        
        guard let data = param["imageBytes"] as? FlutterStandardTypedData else {
            result("")
            return
        }

        guard  let image = UIImage.init(data: data.data) else {
            result("")
            return
        }
        
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        UIApplication.shared.delegate?.window??.rootViewController?.present(activity, animated: true, completion: {
            
        });
    }
    
    
    func _nromalizedImage(image:UIImage) -> UIImage?{
        if image.imageOrientation == .up {
            return image
        }
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height))
        guard let normalizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        return normalizedImage
    }
    
    func _scaled(image:UIImage, maxWidth:Double, maxHeight: Double) -> UIImage? {
        let originWidth = Double(image.size.width)
        let originHeight = Double(image.size.height)
        
        let hasMaxWidth = maxWidth != 0.0
        let hasMaxHeight = maxHeight != 0.0
        
        var width = hasMaxWidth ? Double.minimum(maxWidth,originWidth) : originWidth
        var height = hasMaxHeight ? Double.minimum(maxHeight, originHeight) : originHeight
        
        let shouldDownScaleWidth = hasMaxWidth && maxWidth < originWidth
        let shouldDownScaleHeight = hasMaxHeight && maxHeight < originHeight
        let shouldDownScale = shouldDownScaleWidth || shouldDownScaleHeight
        if shouldDownScale {
            let downScaleWidth = floor((height / originHeight) * originWidth)
            let downScaleHeight = floor((width / originWidth) * originHeight)
            
            if (width < height) {
                if (!hasMaxWidth) {
                    width =  downScaleWidth
                }
                else {
                    height = downScaleHeight
                }
            }
            else if (height < width) {
                if(!hasMaxHeight) {
                    height = downScaleHeight
                }
                else {
                    width = downScaleWidth
                }
            }
            else {
                if originWidth < originHeight {
                    width = downScaleWidth
                }
                else {
                    height = downScaleHeight
                }
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: CGFloat(width), height: CGFloat(height)), false, 1.0)
        image.draw(in: CGRect.init(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        guard let normalizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        return normalizedImage
    }
    
    
    
}

extension SwiftOXCCommonPlugin: UIImagePickerControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        UIApplication.shared.delegate?.window??.rootViewController?.dismiss(animated: true, completion: nil)
        if let result = result {
            result(nil)
        }
        result = nil
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let mediaType = info[.mediaType] as? String else {
            UIApplication.shared.delegate?.window??.rootViewController?.dismiss(animated: true, completion: nil)
            return
        }
        
        if mediaType.contains(kUTTypeImage as String) {
            if let image = info[.editedImage] as? UIImage {
                self._dealData(image: image, completion: {(success, filePath) in
                    guard let result = self.result else {
                        UIApplication.shared.delegate?.window??.rootViewController?.dismiss(animated: true, completion: nil)
                        return
                    }
                    if success {
                        result(filePath)
                    }
                    else {
                        result(nil)
                    }
                    
                    UIApplication.shared.delegate?.window??.rootViewController?.dismiss(animated: true, completion: nil)
                })
                return
            }
            
            if let image = info[.originalImage] as? UIImage {
                self._dealData(image: image, completion: { (success, filePath) in
                    guard let result = self.result else {
                        UIApplication.shared.delegate?.window??.rootViewController?.dismiss(animated: true, completion: nil)
                        return
                    }
                    
                    if success {
                        result(filePath)
                    }
                    else {
                        result(nil)
                    }
                    UIApplication.shared.delegate?.window??.rootViewController?.dismiss(animated: true, completion: nil)
                })
                return
            }
            
            guard let result = self.result else {
                UIApplication.shared.delegate?.window??.rootViewController?.dismiss(animated: true, completion: nil)
                return
            }
            result(nil)
            UIApplication.shared.delegate?.window??.rootViewController?.dismiss(animated: true, completion: nil)
            
        }
        else if mediaType.contains(kUTTypeVideo as String) {
            guard let mediaUrl = info[.mediaURL] as? URL else {
                UIApplication.shared.delegate?.window??.rootViewController?.dismiss(animated: true, completion: nil)
                result = nil
                return
            }
            
            guard let result = self.result else {
                UIApplication.shared.delegate?.window??.rootViewController?.dismiss(animated: true, completion: nil)
                return
            }
            result(mediaUrl.path)
        }
        
        result = nil
        UIApplication.shared.delegate?.window??.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    func _dealData(image:UIImage, completion:@escaping((_ success: Bool,_ filePath: String?) -> Void)) {
        
        guard let norimalImage = self._nromalizedImage(image:image) else {
            completion(false, nil)
            return
        }
        
        let scale = UIScreen.main.scale
        guard  let scaleimage = self._scaled(image: norimalImage, maxWidth: Double(UIScreen.main.bounds.size.width * scale), maxHeight: Double(UIScreen.main.bounds.size.height * scale)) else {
            completion(false, nil)
            return
        }
        
        let data = scaleimage.jpegData(compressionQuality: 1.0)
        let guid = ProcessInfo.processInfo.globallyUniqueString
        let tmpFile = "image_picker_\(guid).jpg"
        let tmpDirectory = NSTemporaryDirectory()
        let tmpPath = tmpDirectory.appending(tmpFile)
        if (FileManager.default.createFile(atPath: tmpPath, contents: data, attributes: nil)) {
            completion(true, tmpPath)
        }
        else {
            completion(false, nil)
        }
    }
}
