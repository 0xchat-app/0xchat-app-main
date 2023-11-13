//
//  OXCQRCodeHelper.swift
//  ox_common
//
//  Created by ZharlieW on 2023/11/13.
//

import UIKit
import Vision

class OXCQRCodeHelper {
    
    static func detectQRCode(_ image: UIImage?) -> [CIFeature]? {
        if let image = image, let ciImage = CIImage.init(image: image){
            var options: [String: Any];
            let context = CIContext();
            options = [CIDetectorAccuracy: CIDetectorAccuracyHigh];
            let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options);
            if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)){
                options = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1];
            } else {
                options = [CIDetectorImageOrientation: 1];
            }
            let features = qrDetector?.features(in: ciImage, options: options);
            return features;
        }
        return nil
    }
    
    static func detectBarCode(_ image: UIImage?, result: @escaping FlutterResult) {
        if let image = image, let ciImage = CIImage.init(image: image), #available(iOS 11.0, *) {
            var requestHandler: VNImageRequestHandler;
            if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)) {
                requestHandler = VNImageRequestHandler(ciImage: ciImage, orientation: CGImagePropertyOrientation(rawValue: ciImage.properties[(kCGImagePropertyOrientation as String)] as! UInt32) ?? .up, options: [:])
            } else {
                requestHandler = VNImageRequestHandler(ciImage: ciImage, orientation: .up, options: [:])
            }
            let request = VNDetectBarcodesRequest { (request,error) in
                var res: String? = nil;
                if let observations = request.results as? [VNBarcodeObservation], !observations.isEmpty {
                    let data: VNBarcodeObservation = observations.first!;
                    res = data.payloadStringValue;
                }
                DispatchQueue.main.async {
                    result(res);
                }
            }
            DispatchQueue.global(qos: .background).async {
                do{
                    try requestHandler.perform([request])
                } catch {
                    DispatchQueue.main.async {
                        result(nil);
                    }
                }
            }
        } else {
            result(nil);
        }
    }
}
