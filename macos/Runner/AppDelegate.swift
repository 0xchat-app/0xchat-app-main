import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
    
    var mainWindow: MainFlutterWindow?
    
    override func applicationDidFinishLaunching(_ notification: Notification) {
        let window = MainFlutterWindow()
        window.setStyleMask(true, .titled)
        window.setStyleMask(true, .closable)
        window.setStyleMask(true, .miniaturizable)
        window.setStyleMask(true, .resizable)
        window.makeKeyAndOrderFront(nil)
        mainWindow = window
    }
    
    override func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if let window = mainWindow {
            if !flag {
                window.makeKeyAndOrderFront(nil)
            }
        }
        return true
    }
    
    override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
