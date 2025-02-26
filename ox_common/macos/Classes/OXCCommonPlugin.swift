import Cocoa
import FlutterMacOS

public class OXCCommonPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ox_common", binaryMessenger: registrar.messenger)
    let instance = OXCCommonPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "hasImages":
        result(ClipboardHelper.hasImages())
    case "getImages":
        result(ClipboardHelper.getImages())
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
