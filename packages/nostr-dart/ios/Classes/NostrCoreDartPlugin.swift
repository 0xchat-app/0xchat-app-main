import Flutter
import UIKit

public class NostrCoreDartPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.oxchat.nostrcore", binaryMessenger: registrar.messenger())
        let instance = NostrCoreDartPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let params = call.arguments as? [String : Any]
        switch call.method {
        case "verifySignature":
            guard let publicKey = params?["pubKey"] as? FlutterStandardTypedData,
                  let message = params?["hash"] as? FlutterStandardTypedData,
                  let signature = params?["signature"] as? FlutterStandardTypedData else {
                return
            }
            result(CryptoUtils.schnorrVerify(publicKey: publicKey.data, message: message.data, signature: signature.data))
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
