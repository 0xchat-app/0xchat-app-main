import Cocoa
import FlutterMacOS

// Stub implementation for flutter_sound on macOS
// Provides empty implementations to allow compilation
public class FlutterSoundPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    // Empty registration - no actual functionality
    let channel = FlutterMethodChannel(name: "flutter_sound", binaryMessenger: registrar.messenger)
    let instance = FlutterSoundPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    // Return empty/error responses for all method calls
    result(FlutterMethodNotImplemented)
  }
}
