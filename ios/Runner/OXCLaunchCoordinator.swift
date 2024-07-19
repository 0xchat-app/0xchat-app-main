//
//  OXCLaunchCoordinator.swift
//  Runner
//
//  Created by Zharlie on 2024/3/25.
//

import UIKit
import Flutter

class OXCLaunchCoordinator: NSObject {

    static let shared = OXCLaunchCoordinator()
    
    let mainController: FlutterViewController = FlutterViewController()
    
    func start(window: UIWindow) {
        registeFlutterPlugin(window: window)
        registeNotification()
    }
    
    func registeFlutterPlugin(window: UIWindow) {

        let navController = window.rootViewController as? UINavigationController ?? UINavigationController()
    
        GeneratedPluginRegistrant.register(with: mainController)
        if let plugin = mainController.registrar(forPlugin: "OXPerference") {
            OXPerferencePlugin.register(with:plugin)
        }
        OXCNavigator.register(with: mainController.engine)
        
        navController.setViewControllers([mainController], animated: false)
        window.rootViewController = navController
    }
    
    func registeNotification() -> Void {
        if #available(iOS 10.0, *) {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.delegate = self
            notificationCenter.requestAuthorization(options:[.sound, .alert, .badge]) { (granted, error) in
                if (granted) {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                    
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings.init(types: [.sound, .alert, .badge], categories: nil))
        }
    }
}

extension OXCLaunchCoordinator: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .alert, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
