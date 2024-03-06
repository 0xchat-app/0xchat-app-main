import Flutter
import UIKit

public class OXPushPlugin: NSObject, FlutterPlugin {
    
    public static var channel: FlutterMethodChannel?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "ox_push", binaryMessenger: registrar.messenger())
        let instance = OXPushPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        self.channel = channel
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
