//  WelcomeBackPlusButton
//
//  Created by salexkidd on /8/31/2018.
//  Copyright © 2018 salexkidd. All rights reserved.

import Cocoa


let pluginName: String = "WelcomBackGreenPlusButton"

public var plugin: WBGPBWelcomeBackGreenPlusButton!

public var APP_BLACKLIST: [String] = []

public var CLS_BLACKLIST = ["NSStatusBarWindow"]

public var WBGPBMyKeyWindow: NSWindow!

public var WBGPBCurrentFrame: CGRect!

var WBGPBCachedFramePointer = UnsafeRawPointer(bitPattern: 1)!

public var WBPBBundleIdentifier: String
{
    get {
        guard let identifier = Bundle.main.bundleIdentifier else { return "" }
        return identifier
    }
}

let WBGPBWindowNotificationList = [
    NSNotification.Name.NSWindowDidBecomeMain,
    NSNotification.Name.NSWindowDidBecomeKey,
]

extension RuntimeHandler
{
    open override class func handleLoad()
    {
        plugin = WBGPBWelcomeBackGreenPlusButton.sharedInstance
        plugin.setUp()
        NSLog("%p Plugin setUp Complete.", pluginName)
    }
    
    open override class func handleInitialize() {}
}


public class WBGPBWelcomeBackGreenPlusButton: RuntimeHandler
{
    static public let sharedInstance: WBGPBWelcomeBackGreenPlusButton = WBGPBWelcomeBackGreenPlusButton()

    public func setUp()
    {
        WBGPBCachedFramePointer = withUnsafePointer(to: &WBGPBCachedFramePointer) { UnsafeRawPointer($0) }

        if ProcessInfo.processInfo.operatingSystemVersion.minorVersion < 9 { return }

        if APP_BLACKLIST.contains(WBPBBundleIdentifier) { return }
        
        WBGPBMyKeyWindow = NSApp.mainWindow

        for notificationName in WBGPBWindowNotificationList
        {
            NotificationCenter.default.addObserver(
                forName: notificationName,
                object: nil,
                queue: OperationQueue.main
            ) { notification in
                WBGPBMyKeyWindow = notification.object as! NSWindow
            }
        }
        NSLog("%@ load complete.", pluginName)
    }
}

extension NSWindow
{
    func _allowsFullScreen()      -> Bool { return true  }

    func canEnterFullScreenMode() -> Bool { return true  }

    func showsFullScreenButton()  -> Bool { return false }

    func _canEnterTileMode()      -> Bool { return false }

    func _allowedInDashboardSpaceWithCollectionBehavior(arg1: CUnsignedLongLong)           -> Bool { return true }

    func _allowedInOtherAppsFullScreenSpaceWithCollectionBehavior(arg1: CUnsignedLongLong) -> Bool { return true }
    
    @objc private func _WBPBGoFullScreen() { self.toggleFullScreen(self) }
    
    @objc private func _WBPBGoFillScreen()
    {
        if self.styleMask.contains(NSWindowStyleMask.fullScreen) {
            self.toggleFullScreen(self)
        } else {
            WBGPBCurrentFrame = self.frame
            let OSVersion = ProcessInfo.processInfo.operatingSystemVersion.minorVersion
            let futureFrame = OSVersion < 11 ? self._frameForFullScreenMode() : self._tileFrameForFullScreen()
            let screenFrame = self.screen?.visibleFrame
            let isMaximzed = WBGPBCurrentFrame.equalTo(screenFrame!)

            if !isMaximzed {
                let cachedFrameValue = NSValue(rect: NSRectFromCGRect(WBGPBCurrentFrame))
                objc_setAssociatedObject(self, WBGPBCachedFramePointer, cachedFrameValue, .OBJC_ASSOCIATION_RETAIN)
                self.setFrame(futureFrame, display: false)
            } else {
                if let cachedValue: NSValue = objc_getAssociatedObject(self, WBGPBCachedFramePointer) as? NSValue {
                    let cachedFrame = NSRectToCGRect(cachedValue.rectValue)
                    self.setFrame(cachedFrame, display: false)

                }
            }
        }
    }
    
    func _zoomButtonIsFullScreenButton() -> Bool
    {
        let pressedOptKey = NSEvent.modifierFlags().contains([NSEvent.ModifierFlags.option])
        
        if pressedOptKey {
            self.standardWindowButton(NSWindowButton.zoomButton)?.action = #selector(NSWindow._WBPBGoFullScreen)
            self.standardWindowButton(NSWindowButton.zoomButton)?.alphaValue = 0.5
        } else {
            self.standardWindowButton(NSWindowButton.zoomButton)?.action = #selector(NSWindow._WBPBGoFillScreen)
            self.standardWindowButton(NSWindowButton.zoomButton)?.alphaValue = 1.0

        }
        return false
    }
    
}
