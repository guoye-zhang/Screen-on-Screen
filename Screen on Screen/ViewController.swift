//
//  ViewController.swift
//  ProjectorViewer
//
//  Created by 张国晔 on 15/6/3.
//  Copyright (c) 2015年 Shandong University. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {
    var captureLayer: CALayer? {
        didSet {
            oldValue?.removeFromSuperlayer()
            if let captureLayer = captureLayer {
                view.layer!.addSublayer(captureLayer)
                captureLayer.frame = view.bounds
            }
        }
    }
    var captureSession: AVCaptureSession? {
        didSet {
            oldValue?.stopRunning()
            if let captureSession = captureSession {
                captureLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                captureSession.startRunning()
            } else {
                captureLayer = nil
            }
        }
    }
    var displaySize: NSSize? {
        didSet {
            if let displaySize = displaySize {
                preferredContentSize = displaySize
                updateSize()
            }
        }
    }
    var displayID: CGDirectDisplayID? {
        didSet {
            if let displayID = displayID {
                let captureSession = AVCaptureSession()
                captureSession.addInput(AVCaptureScreenInput(displayID: displayID))
                let width = CGDisplayPixelsWide(displayID)
                let height = CGDisplayPixelsHigh(displayID)
                displaySize = NSSize(width: width, height: height)
                self.captureSession = captureSession
            } else {
                captureSession = nil
            }
        }
    }
    
    private let notificationCenter = NSNotificationCenter.defaultCenter()
    
    override func viewWillAppear() {
        super.viewWillAppear()
        view.window!.movableByWindowBackground = true
        view.layer!.backgroundColor = NSColor.blackColor().CGColor
        notificationCenter.addObserverForName(Utility.Notification.DisplayChange, object: nil, queue: nil) { _ in
            if self.displayID != Utility.displayID {
                self.displayID = Utility.displayID
            }
            self.updateSize()
        }
        notificationCenter.addObserverForName(Utility.Notification.ScaleChange, object: nil, queue: nil) { _ in
            self.updateSize()
        }
        if Utility.onTop {
            view.window!.level = Int(CGWindowLevelForKey(.FloatingWindowLevelKey))
        }
        notificationCenter.addObserverForName(Utility.Notification.OnTopChange, object: nil, queue: nil) { _ in
            self.view.window!.level = Int(CGWindowLevelForKey(Utility.onTop ? .FloatingWindowLevelKey : .NormalWindowLevelKey))
        }
    }
    
    override func viewWillLayout() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        captureLayer?.frame = view.bounds
        CATransaction.commit()
    }
    
    func updateSize() {
        if let displaySize = displaySize {
            view.window?.setContentSize(displaySize * CGFloat(Utility.scale))
        }
    }
    
    @IBAction func scale(sender: NSMagnificationGestureRecognizer) {
        Utility.scale += Double(sender.magnification) / 50
    }
}

func *(size: NSSize, scale: CGFloat) -> NSSize {
    return NSSize(width: size.width * scale, height: size.height * scale)
}
