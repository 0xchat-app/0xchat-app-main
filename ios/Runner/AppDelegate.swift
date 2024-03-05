import UIKit
import Flutter
import ox_push


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        if let navController = self.window.rootViewController as? UINavigationController,
           let flutterController = navController.viewControllers.first as? FlutterViewController {
            GeneratedPluginRegistrant.register(with: flutterController)
            if let plugin = flutterController.registrar(forPlugin: "OXPerference") {
                OXPerferencePlugin.register(with:plugin)
            }
            OXCNavigator.register(with: flutterController.engine)
        }
        
        registeNotification()
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
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
    
    @available(iOS 10.0, *)
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .alert, .badge])
    }
    
    @available(iOS 10.0, *)
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    
    override func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
    }

    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenStr = deviceToken.map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
        print(deviceTokenStr)
        OXPushPlugin.channel()?.invokeMethod("savePushToken", arguments: deviceTokenStr)
    }
    
    override func applicationDidBecomeActive(_ application: UIApplication) {
        signal(SIGPIPE, SIG_IGN)
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    override func applicationWillEnterForeground(_ application: UIApplication) {
        signal(SIGPIPE, SIG_IGN)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        var urlStr = url.absoluteString
        
        if url.host == "shareLinkWithScheme" {
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true),
                let text = AppGroupHelper.loadDataForGourp(forKey: AppGroupHelper.shareDataKey) as? String {
                
                var queryItems = (urlComponents.queryItems ?? [])
                queryItems.append(URLQueryItem(name: "text", value: text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))
                urlComponents.queryItems = queryItems
             
                urlStr = urlComponents.url?.absoluteString ?? urlStr
                
                AppGroupHelper.saveDataForGourp(nil, forKey: AppGroupHelper.shareDataKey)
            }
        }
        
        let userDefault = UserDefaults.standard
        userDefault.setValue(urlStr, forKey: OPENURLAPP)
        userDefault.synchronize()
        
        return true
    }
}
