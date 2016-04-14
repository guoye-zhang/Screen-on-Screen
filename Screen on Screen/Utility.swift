//
//  Utility.swift
//  ProjectorViewer
//
//  Created by 张国晔 on 15/6/3.
//  Copyright (c) 2015年 Shandong University. All rights reserved.
//

import Cocoa

struct Utility {
    static var displays = [CGDirectDisplayID]()
    
    static var displayNo: Int {
        get {
            let displayNo = userDefaults.integerForKey(Keys.Display)
            if displayNo >= displays.count {
                return displays.count > 1 ? 1 : 0
            }
            return displayNo
        }
        set {
            userDefaults.setInteger(newValue, forKey: Keys.Display)
            notificationCenter.postNotificationName(Notification.DisplayChange, object: nil)
        }
    }
    
    static var displayID: CGDirectDisplayID? {
        return displayNo < displays.count ? displays[displayNo] : nil
    }
    
    static var scale: Double {
        get {
            let scale = userDefaults.doubleForKey(Keys.Scale)
            return scale == 0 ? 0.5 : scale
        }
        set {
            userDefaults.setDouble(newValue, forKey: Keys.Scale)
            notificationCenter.postNotificationName(Notification.ScaleChange, object: nil)
        }
    }
    
    static var onTop: Bool {
        get {
            return userDefaults.boolForKey(Keys.OnTop)
        }
        set {
            userDefaults.setBool(newValue, forKey: Keys.OnTop)
            notificationCenter.postNotificationName(Notification.OnTopChange, object: nil)
        }
    }
    
    private static let userDefaults = NSUserDefaults.standardUserDefaults()
    private static let notificationCenter = NSNotificationCenter.defaultCenter()
    
    static func updateDisplays() {
        let screens = NSScreen.screens() ?? []
        displays = screens.map { ($0.deviceDescription["NSScreenNumber"] as! NSNumber).unsignedIntValue }
        if displays.count > 1 && displayNo == 0 {
            displayNo = 1
        } else {
            notificationCenter.postNotificationName(Notification.DisplayChange, object: nil)
        }
    }
    
    private struct Keys {
        static let Display = "Display"
        static let Scale = "Scale"
        static let OnTop = "OnTop"
    }
    
    struct Notification {
        static let DisplayChange = "DisplayChange"
        static let ScaleChange = "ScaleChange"
        static let OnTopChange = "OnTopChange"
    }
}
