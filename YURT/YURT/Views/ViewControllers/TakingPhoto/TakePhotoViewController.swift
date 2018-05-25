//
//  TakePhotoViewController.swift
//  YURT
//
//  Created by Standret on 25.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class TakePhotoViewController: SttViewController<TakePhotoPresenter>, TakePhotoDelegate {
    
    let captureSession = AVCaptureSession()
    var previewLayer: CALayer!
    
    var captureDevice: AVCaptureDevice!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareCamer()
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func prepareCamer() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices
        if devices.count > 0 {
            captureDevice = devices.first
            beginSession()
        }
    }
    
    func beginSession() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
        }
        catch {
            Log.error(message: "\(error)", key: "Capture error")
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        self.previewLayer = previewLayer
        self.view.layer.insertSublayer(previewLayer, at: 0)
        self.previewLayer.frame = self.view.layer.frame
        print(self.view.layer.frame)
        captureSession.startRunning()
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString): NSNumber(value: kCVPixelFormatType_32BGRA)] as [String:Any]
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        
        captureSession.commitConfiguration()
    }
}
