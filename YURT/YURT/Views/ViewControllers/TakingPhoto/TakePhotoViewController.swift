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
    var dataOutput: AVCaptureVideoDataOutput!
    var captureDeviceInput: AVCaptureDeviceInput!
    var image: UIImage!
    
    private var isTaking = false
    
    @IBOutlet weak var CameraTitle: UILabel!
    @IBOutlet weak var btnTakePhoto: UIButton!
    @IBAction func takePhotoClick(_ sender: Any) {
        isTaking = true
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
        print ("capture")
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        if !isTaking {
            close()
        }
    }
    @IBAction func changeOrientation(_ sender: Any) {
        endSession()
        presenter.isFront = !presenter.isFront
        prepareCamera()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnTakePhoto.createCircle()
        hideNavigationBar = true
        hideTabBar = true
        style = .lightContent
        let range = (presenter.topMessage! as NSString).range(of: presenter.higlightMessage)
        let attribute = NSMutableAttributedString(string: presenter.topMessage)
        attribute.addAttributes([NSAttributedStringKey.foregroundColor: UIColor(named: "main")!], range: range)
        CameraTitle.attributedText = attribute
        
        _ = SttGlobalObserver.observableStatusApplication.subscribe(onNext: { [weak self] (status) in
            if status == .EnterBackgound {
                self?.close()
            }
        })
    }
    
    deinit {
        print ("take photo deinit")
    }
    
    private var fistStart = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if fistStart {
            fistStart = false
            prepareCamera()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "previewPhoto" {
            let previewC = segue.destination as! PreviewPhotoViewController
            previewC.image = image
            previewC.delegate = self
        }
    }
    
    func close(isUsePhoto: Bool) {
        if isUsePhoto {
            close(parametr: image)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            image = UIImage(data: imageData)?.fixOrientation()
            isTaking = false
            performSegue(withIdentifier: "previewPhoto", sender: nil)
            print ("output")
        }
    }
    
    func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: presenter.isFront ? .front : .back).devices
        if devices.count > 0 {
            captureDevice = devices.first
            beginSession()
        }
    }
    
    func endSession() {
        do {
            captureSession.removeInput(captureDeviceInput)
            captureSession.removeOutput(photoOutput!)
        }
        catch {
            SttLog.error(message: "\(error)", key: "Remove capture error")
        }
        
        captureSession.stopRunning()
        captureSession.removeOutput(dataOutput)
        
        captureSession.commitConfiguration()
    }
    
    func beginSession() {
        do {
            captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        }
        catch {
            SttLog.error(message: "\(error)", key: "Capture error")
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer = previewLayer
        self.view.layer.insertSublayer(previewLayer, at: 0)
        self.previewLayer.frame = self.view.layer.frame
        captureSession.startRunning()
        
        dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString): NSNumber(value: kCVPixelFormatType_32BGRA)] as [String:Any]
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        
        captureSession.commitConfiguration()
    }
}
