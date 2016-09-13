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
            let displayNo = UserDefaults.standard.integer(forKey: Keys.display)
            if displayNo >= displays.count {
                return displays.count > 1 ? 1 : 0
            }
            return displayNo
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.display)
            NotificationCenter.default.post(name: .displayChange, object: nil)
        }
    }
    
    static var displayID: CGDirectDisplayID? {
        return displayNo < displays.count ? displays[displayNo] : nil
    }
    
    static var scale: Double {
        get {
            let scale = UserDefaults.standard.double(forKey: Keys.scale)
            return scale == 0 ? 0.5 : scale
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.scale)
            NotificationCenter.default.post(name: .scaleChange, object: nil)
        }
    }
    
    static var onTop: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.onTop)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.onTop)
            NotificationCenter.default.post(name: .onTopChange, object: nil)
        }
    }
    
    static func updateDisplays() {
        let screens = NSScreen.screens() ?? []
        displays = screens.map { ($0.deviceDescription["NSScreenNumber"] as! NSNumber).uint32Value }
        if displays.count > 1 && displayNo == 0 {
            displayNo = 1
        } else {
            NotificationCenter.default.post(name: .displayChange, object: nil)
        }
    }
    
    private struct Keys {
        static let display = "Display"
        static let scale = "Scale"
        static let onTop = "OnTop"
    }
}

extension Notification.Name {
    static let displayChange = Notification.Name("DisplayChange")
    static let scaleChange = Notification.Name("ScaleChange")
    static let onTopChange = Notification.Name("OnTopChange")
}
