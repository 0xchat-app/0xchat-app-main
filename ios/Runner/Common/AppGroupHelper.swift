//
//  AppGroupHelper.swift
//  Runner
//
//  Created by Zharlie on 2024/2/27.
//

import Foundation

class AppGroupHelper {
    static let appGroupId = "group.0xchat.app"
    static let shareDataKey = "0xchatShareTempDataKey"
    
    static func saveDataForGourp(_ value: Any?, forKey key: String) {
        guard let userDefaults = UserDefaults(suiteName: AppGroupHelper.appGroupId) else {
            return
        }
        userDefaults.set(value, forKey: key)
    }
    
    static func loadDataForGourp(forKey key: String) -> Any? {
        guard let userDefaults = UserDefaults(suiteName: AppGroupHelper.appGroupId) else {
            return nil
        }
        return userDefaults.object(forKey: key)
    }
}
