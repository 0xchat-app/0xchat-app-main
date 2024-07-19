//
//  OCXCrashManager.swift
//  Runner
//
//  Created by Zharlie on 2024/3/20.
//

import UIKit
import Zip
import ox_common

class OCXCrashManager {
    
    struct FileConstants {
        static let dbInfoFileName = "dbInfo.txt"
        static let exportFileName = "0xchatExportData.zip"
    }
    
    static let shared = OCXCrashManager()
    private let crashCountKey = "crashCount"
    private let normalLaunchThreshold: TimeInterval = 5
    private var crashCount = 0
    private let crashLimit = 5
    
    var continueCallback: (() -> Void)?
    
    var showCrashAlert: Bool {
        get {
            crashCount > crashLimit
        }
    }
    
    var rootViewController: UIViewController? {
        get {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                return windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController
            }
            return nil
        }
    }
    
    private init() {}
    
    func appLaunched() {
        crashCount = UserDefaults.standard.integer(forKey: crashCountKey)
        crashCount += 1
        UserDefaults.standard.set(crashCount, forKey: crashCountKey)
        
        if !showCrashAlert {
            DispatchQueue.main.asyncAfter(deadline: .now() + normalLaunchThreshold) {
                self.resetCrashCount()
            }
        }
    }
    
    func showWarningDialog() {
        let alertController = UIAlertController(title: "Warning", message: "The app has crashed several times on startup. Please check for issues.", preferredStyle: .alert)
        
        let exportAction = UIAlertAction(title: "Export Data", style: .default) { _ in
            self.exportData()
        }
        
        let continueAction = UIAlertAction(title: "Continue", style: .cancel) { _ in
            self.resetCrashCount()
            self.continueCallback?()
        }
        
        alertController.addAction(exportAction)
        alertController.addAction(continueAction)
        
        
        guard let window = UIApplication.shared.delegate?.window, let controller = window?.rootViewController else {
            return
        }
        
        controller.present(alertController, animated: true)
    }
}

// MARK: -
extension OCXCrashManager {
    
    private func resetCrashCount() {
        UserDefaults.standard.set(0, forKey: "crashCount")
    }
    
    private func showAlertView(message: String, confirmButtonTitle: String = "Dismiss") {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: confirmButtonTitle, style: .default)
        alert.addAction(confirmAction)
        
        rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    private func zipFiles() -> URL? {
        do {
            let documentsPath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let documentsContents = try FileManager.default.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: nil, options: [])
            
            // Filter out.db and.db2 files
            let dbFiles = documentsContents.filter { $0.pathExtension == "db" || $0.pathExtension == "db2" }
            if dbFiles.isEmpty {
                throw NSError(domain: "DB files is empty", code: 1)
            }
            
            // Create a txt file that contains a JSON map of the file list
            guard let jsonMapFilePath = createDBInfoJsonFile(for: dbFiles) else {
                throw NSError(domain: "DB info is empty", code: 1)
            }
            
            // Prepare compressed files, including database files and DB-info txt files
            var filesToZip = dbFiles
            filesToZip.append(jsonMapFilePath)
            
            let tempZipPath = FileManager.default.temporaryDirectory.appendingPathComponent(FileConstants.exportFileName)
            
            try Zip.zipFiles(paths: filesToZip, zipFilePath: tempZipPath, password: nil, progress: nil)
            
            return tempZipPath
        } catch {
            showAlertView(message: error.localizedDescription)
            return nil
        }
    }
    
    private func exportData() {
        guard let exportFile = zipFiles(), let sender = rootViewController else {
            return
        }
        
        OXCFileHelper.exportFile(atPath: exportFile.path, sender: sender) { completed in
            self.showWarningDialog()
        }
    }
}

// MARK: - DB
extension OCXCrashManager {
    
    private func parseFileNameToLocalKey(fileName: String) -> String {
        let fileBaseName = URL(fileURLWithPath: fileName).deletingPathExtension().lastPathComponent
        if fileBaseName.hasPrefix("cashu-") {
            let pubkey = String(fileBaseName.dropFirst("cashu-".count))
            return "flutter.#forever#cashuDBpwd" + pubkey
        } else {
            let pubkey = fileBaseName
            return "flutter.#forever#dbpw+" + pubkey
        }
    }
    
    private func createDBInfoJsonFile(for files: [URL]) -> URL? {
        let jsonMap: [String: String] = files.reduce(into: [:]) { result, fileUrl in
            let fileName = fileUrl.lastPathComponent
            
            let localKey = parseFileNameToLocalKey(fileName: fileName)
            if let pwdValueWithQuotes = UserDefaults.standard.string(forKey: localKey) {
                let password = pwdValueWithQuotes.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                result[fileName] = password
            }
        }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonMap, options: .prettyPrinted),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return nil
        }
        
        let tempFilePath = FileManager.default.temporaryDirectory.appendingPathComponent(FileConstants.dbInfoFileName)
        
        do {
            try jsonString.write(to: tempFilePath, atomically: true, encoding: .utf8)
            return tempFilePath
        } catch {
            showAlertView(message: error.localizedDescription)
            return nil
        }
    }
    
    private func readJsonMapFromFile(at fileURL: URL) -> [String: String]? {
        do {
            let data = try Data(contentsOf: fileURL)
            if let jsonMap = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
                return jsonMap
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}
