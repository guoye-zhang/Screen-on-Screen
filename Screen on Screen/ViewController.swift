//
//  ViewController.swift
//  ProjectorViewer
//
//  Created by Guoye Zhang on 15/6/3.
//  Copyright (c) 2015 Guoye Zhang. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {
    private var captureLayer: CALayer? {
        didSet {
            oldValue?.removeFromSuperlayer()
            if let captureLayer = captureLayer {
                view.layer!.addSublayer(captureLayer)
                captureLayer.frame = view.bounds
            }
        }
    }
    private var captureSession: AVCaptureSession? {
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
    private var displaySize: NSSize? {
        didSet {
            updateSize()
        }
    }
    private var displayID: CGDirectDisplayID? {
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
    
    override func viewWillAppear() {
        super.viewWillAppear()
        view.window!.isMovableByWindowBackground = true
        view.layer!.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        NotificationCenter.default.addObserver(forName: .displayChange, object: nil, queue: nil) { _ in
            if self.displayID != Utility.displayID {
                self.displayID = Utility.displayID
            }
            self.updateSize()
        }
        NotificationCenter.default.addObserver(forName: .scaleChange, object: nil, queue: nil) { _ in
            self.updateSize()
        }
        if Utility.onTop {
            view.window!.level = .floating
        }
        NotificationCenter.default.addObserver(forName: .onTopChange, object: nil, queue: nil) { _ in
            self.view.window!.level = Utility.onTop ? .floating : .normal
        }
    }
    
    override func viewWillLayout() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        captureLayer?.frame = view.bounds
        CATransaction.commit()
    }
    
    private func updateSize() {
        if let displaySize = displaySize {
            view.window!.setContentSize(displaySize * CGFloat(Utility.scale))
        }
    }
    
    @IBAction func scale(_ sender: NSMagnificationGestureRecognizer) {
        Utility.scale += Double(sender.magnification) / 5
        sender.magnification = 0
    }
}

func *(size: NSSize, scale: CGFloat) -> NSSize {
    return NSSize(width: size.width * scale, height: size.height * scale)
}
