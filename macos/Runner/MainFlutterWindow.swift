import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        initializeWindow()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initializeWindow()
    }
    
    func initializeWindow() {
        let flutterViewController = FlutterViewController()
        self.contentViewController = flutterViewController
        self.setFrame(CGRectZero, display: false)
        RegisterGeneratedPlugins(registry: flutterViewController)
    }
}
