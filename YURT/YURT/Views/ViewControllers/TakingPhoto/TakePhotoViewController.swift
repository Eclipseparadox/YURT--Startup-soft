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

protocol SttTakePhotoDelegate: class {
    func close(isUsePhoto: Bool)
}

class TakePhotoViewController: SttViewController<TakePhotoPresenter>, TakePhotoDelegate, AVCapturePhotoCaptureDelegate, SttTakePhotoDelegate {
    
    let captureSession = AVCaptureSession()
    
    var previewLayer: CALayer!
    
    var captureDevice: AVCaptureDevice!
    var photoOutput: AVCapturePhotoOutput?
    var takedPhoto: UIImage!
    
    @IBOutlet weak var btnTakePhoto: UIButton!
    @IBAction func takePhotoClick(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            takedPhoto = UIImage(data: imageData)
            performSegue(withIdentifier: "previewPhoto", sender: nil)
        }
    }
    @IBAction func cancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnTakePhoto.createCircle()
    }
    
    private var fistStart = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if fistStart {
            fistStart = false
            prepareCamer()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "previewPhoto" {
            let previewC = segue.destination as! PreviewPhotoViewController
            previewC.image = takedPhoto
            previewC.delegate = self
        }
    }
    
    func close(isUsePhoto: Bool) {
        if isUsePhoto {
            dismiss(animated: true, completion: nil)
        }
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
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
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
