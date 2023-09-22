import Flutter
import UIKit
import AVFoundation

public class OxCallingPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "ox_calling", binaryMessenger: registrar.messenger())
        let instance = OxCallingPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        let method = call.method
        switch method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "setSpeakerStatus":
            setSpeakerStatus(call, result)
        case "isSpeakerOn":
            isSpeakerOn(call, result)
            
        default:
            break
        }
    }
    
    private func setSpeakerStatus(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any], let isSpeakerOn = arguments["isSpeakerOn"] as? Bool else {
            return
        }
        let audioSession = AVAudioSession.sharedInstance()
        let audioPort: AVAudioSession.PortOverride = isSpeakerOn ? .speaker : .none
        do {
            try audioSession.overrideOutputAudioPort(audioPort)
            result(true)
        } catch {
            print("setSpeakerStatus error: \(error)")
            result(false)
        }
    }
    
    private func isSpeakerOn(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let audioSession = AVAudioSession.sharedInstance()
        let outputs = audioSession.currentRoute.outputs.first?.portType
        result(outputs == .builtInSpeaker)
    }
}
