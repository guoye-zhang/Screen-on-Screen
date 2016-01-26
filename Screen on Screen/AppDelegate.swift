//
//  AppDelegate.swift
//  ProjectorViewer
//
//  Created by 张国晔 on 15/6/3.
//  Copyright (c) 2015年 Shandong University. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var screenMenu: NSMenu!
    @IBOutlet weak var zoomMenu: NSMenu!
    @IBOutlet weak var onTopMenuItem: NSMenuItem!
    
    private let notificationCenter = NSNotificationCenter.defaultCenter()
    
    func applicationDidFinishLaunching(notification: NSNotification) {
        updateDisplays()
        updateZoom()
        notificationCenter.addObserverForName(Utility.Notification.ScaleChange, object: nil, queue: nil) { _ in
            self.updateZoom()
        }
        if Utility.onTop {
            onTopMenuItem.state = NSOnState
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
    
    func applicationDidChangeScreenParameters(notification: NSNotification) {
        updateDisplays()
    }
    
    func display(sender: NSMenuItem) {
        screenMenu.itemAtIndex(Utility.displayNo)?.state = NSOffState
        Utility.displayNo = sender.tag
        screenMenu.itemAtIndex(Utility.displayNo)?.state = NSOnState
    }
    
    @IBAction func zoom(sender: NSMenuItem) {
        Utility.scale = Double(sender.tag) / 100
    }
    
    @IBAction func top(sender: NSMenuItem) {
        if sender.state == NSOffState {
            Utility.onTop = true
            sender.state = NSOnState
        } else {
            Utility.onTop = false
            sender.state = NSOffState
        }
    }
    
    func updateDisplays() {
        Utility.updateDisplays()
        screenMenu.removeAllItems()
        let displayNo = Utility.displayNo
        for (index, display) in enumerate(Utility.displays) {
            let item = NSMenuItem(title: "\(index)", action: "display:", keyEquivalent: "")
            item.tag = index
            if index == displayNo {
                item.state = NSOnState
            }
            screenMenu.addItem(item)
        }
    }
    
    func updateZoom() {
        for item in zoomMenu.itemArray as! [NSMenuItem] {
            item.state = NSOffState
        }
        switch Utility.scale {
        case 1:
            zoomMenu.itemAtIndex(0)!.state = NSOnState
        case 0.75:
            zoomMenu.itemAtIndex(1)!.state = NSOnState
        case 0.5:
            zoomMenu.itemAtIndex(2)!.state = NSOnState
        case 0.33:
            zoomMenu.itemAtIndex(3)!.state = NSOnState
        case 0.25:
            zoomMenu.itemAtIndex(4)!.state = NSOnState
        default: break
        }
    }
}
