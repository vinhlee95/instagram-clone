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
        view.addSubview(captureButton)
        captureButton.anchor(top: nil, bottom: view.bottomAnchor, left: nil, right: nil, paddingTop: 0, paddingBottom: 24, paddingLeft: 0, paddingRight: 0, width: nil, height: nil)
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, bottom: nil, left: nil, right: view.rightAnchor, paddingTop: 48, paddingBottom: 0, paddingLeft: 0, paddingRight: 24, width: nil, height: nil)
        
        setupCaptureSession()
    }
}

//
// Setup photo capturing session
//
extension CameraController {
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
        let output = AVCapturePhotoOutput()
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        
        // Setup output previoew
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    @objc func handleCapturePhoto() {
        print("Capture!")
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
}
