//
//  CameraController.swift
//  Instagram
//
//  Created by Vinh Le on 3/1/20.
//  Copyright © 2020 Vinh Le. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    private let output = AVCapturePhotoOutput()
    
    let captureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "capture_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "cancel_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup capture session layer first
        // so that following Buttons display above the layer
        setupCaptureSession()
        
        view.addSubview(captureButton)
        captureButton.anchor(top: nil, bottom: view.bottomAnchor, left: nil, right: nil, paddingTop: 0, paddingBottom: 24, paddingLeft: 0, paddingRight: 0, width: nil, height: nil)
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, bottom: nil, left: nil, right: view.rightAnchor, paddingTop: 48, paddingBottom: 0, paddingLeft: 0, paddingRight: 24, width: nil, height: nil)
    }
}

//
// Setup photo capturing session
//
extension CameraController: AVCapturePhotoCaptureDelegate {
    fileprivate func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        // Find the default capturing device.
        // Setup input
        guard let capturingDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            // Wrap the capturing device in a capture device input.
            let input = try AVCaptureDeviceInput(device: capturingDevice)
            // If the input can be added, add it to the session.
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let error {
            print("Failed to setup capturing input", error)
        }
        
        
        // Setup output
        if captureSession.canAddOutput(self.output) {
            captureSession.addOutput(self.output)
        }
        
        // Setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    @objc func handleCapturePhoto() {
        let settings = AVCapturePhotoSettings()
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else {return}
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        
        self.output.capturePhoto(with: settings, delegate: self)
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    // Capture the photo
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let error = error {
            print("Error in handling photo output", error)
        }
        
        guard let imageData = photo.fileDataRepresentation() else {return}
        let dataProvider = CGDataProvider(data: imageData as CFData)
        guard let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent) as CGImage? else {return}
        
        let image = UIImage(cgImage: cgImageRef, scale: 1, orientation: .right)
        
        let photoPreviewView = PhotoPreview()
        view.addSubview(photoPreviewView)
        photoPreviewView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: nil, height: nil)
        photoPreviewView.previewImageView.image = image
    }

}
