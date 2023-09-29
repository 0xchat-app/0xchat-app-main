import Flutter
import UIKit
import AVFoundation

public class OxCallingPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "ox_calling", binaryMessenger: registrar.messenger())
        let instance = OxCallingPlugin()
        instance.setup()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAudioSessionRouteChange(notification:)), name: AVAudioSession.routeChangeNotification, object: nil)
    }
    
    @objc func handleAudioSessionRouteChange(notification: Notification) {
        
        guard let reasonValue = notification.userInfo?[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue),
              reason == .categoryChange else {
            return
        }
        
        guard let description = notification.userInfo?[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription,
              let previousPortType = description.outputs.first?.portType else {
            return
        }
        
        let currentPortType = AVAudioSession.sharedInstance().currentRoute.outputs.first?.portType
        if (currentPortType != previousPortType) {
            let _ = setSpeaker(previousPortType == .builtInSpeaker)
        }
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
        result(setSpeaker(isSpeakerOn))
    }
    
    private func setSpeaker(_ isSpeakerOn: Bool) -> Bool {
        let audioSession = AVAudioSession.sharedInstance()
        let audioPort: AVAudioSession.PortOverride = isSpeakerOn ? .speaker : .none
        do {
            try audioSession.overrideOutputAudioPort(audioPort)
            return true
        } catch {
            print("setSpeakerStatus error: \(error)")
            return false
        }
    }
    
    private func isSpeakerOn(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let audioSession = AVAudioSession.sharedInstance()
        let outputs = audioSession.currentRoute.outputs.first?.portType
        result(outputs == .builtInSpeaker)
    }
}
