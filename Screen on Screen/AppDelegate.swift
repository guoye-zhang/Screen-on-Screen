//
//  AppDelegate.swift
//  ProjectorViewer
//
//  Created by Guoye Zhang on 15/6/3.
//  Copyright (c) 2015 Guoye Zhang. All rights reserved.
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
            onTopMenuItem.state = .on
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func applicationDidChangeScreenParameters(_ notification: Notification) {
        updateDisplays()
    }
    
    @objc func display(_ sender: NSMenuItem) {
        screenMenu.item(at: Utility.displayNo)?.state = .off
        Utility.displayNo = sender.tag
        screenMenu.item(at: Utility.displayNo)?.state = .on
    }
    
    @IBAction func zoom(_ sender: NSMenuItem) {
        Utility.scale = Double(sender.tag) / 100
    }
    
    @IBAction func top(_ sender: NSMenuItem) {
        if sender.state == .off {
            Utility.onTop = true
            sender.state = .on
        } else {
            Utility.onTop = false
            sender.state = .off
        }
    }
    
    private func updateDisplays() {
        Utility.updateDisplays()
        screenMenu.removeAllItems()
        let displayNo = Utility.displayNo
        for index in Utility.displays.indices {
            let item = NSMenuItem(title: "\(index)", action: #selector(AppDelegate.display(_:)), keyEquivalent: "")
            item.tag = index
            if index == displayNo {
                item.state = .on
            }
            screenMenu.addItem(item)
        }
    }
    
    private func updateZoom() {
        for item in zoomMenu.items {
            item.state = .off
        }
        switch Utility.scale {
        case 1:
            zoomMenu.item(at: 0)!.state = .on
        case 0.75:
            zoomMenu.item(at: 1)!.state = .on
        case 0.5:
            zoomMenu.item(at: 2)!.state = .on
        case 0.33:
            zoomMenu.item(at: 3)!.state = .on
        case 0.25:
            zoomMenu.item(at: 4)!.state = .on
        default: break
        }
    }
}
