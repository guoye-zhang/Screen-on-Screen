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
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        updateDisplays()
        updateZoom()
        NotificationCenter.default.addObserver(forName: .scaleChange, object: nil, queue: nil) { _ in
            self.updateZoom()
        }
        if Utility.onTop {
            onTopMenuItem.state = NSOnState
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func applicationDidChangeScreenParameters(_ notification: Notification) {
        updateDisplays()
    }
    
    func display(_ sender: NSMenuItem) {
        screenMenu.item(at: Utility.displayNo)?.state = NSOffState
        Utility.displayNo = sender.tag
        screenMenu.item(at: Utility.displayNo)?.state = NSOnState
    }
    
    @IBAction func zoom(_ sender: NSMenuItem) {
        Utility.scale = Double(sender.tag) / 100
    }
    
    @IBAction func top(_ sender: NSMenuItem) {
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
        for index in Utility.displays.indices {
            let item = NSMenuItem(title: "\(index)", action: #selector(AppDelegate.display(_:)), keyEquivalent: "")
            item.tag = index
            if index == displayNo {
                item.state = NSOnState
            }
            screenMenu.addItem(item)
        }
    }
    
    func updateZoom() {
        for item in zoomMenu.items {
            item.state = NSOffState
        }
        switch Utility.scale {
        case 1:
            zoomMenu.item(at: 0)!.state = NSOnState
        case 0.75:
            zoomMenu.item(at: 1)!.state = NSOnState
        case 0.5:
            zoomMenu.item(at: 2)!.state = NSOnState
        case 0.33:
            zoomMenu.item(at: 3)!.state = NSOnState
        case 0.25:
            zoomMenu.item(at: 4)!.state = NSOnState
        default: break
        }
    }
}
