//
//  PhotoPreviewController.swift
//  Instagram
//
//  Created by Vinh Le on 3/20/20.
//  Copyright © 2020 Vinh Le. All rights reserved.
//

import UIKit
import Photos

class PhotoPreview: UIView {
    let previewImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "cancel_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "save_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(previewImageView)
        previewImageView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: nil, height: nil)
    
        addSubview(cancelButton)
        cancelButton.anchor(top: topAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: 36, paddingBottom: 0, paddingLeft: 24, paddingRight: 0, width: nil, height: nil)
        
        addSubview(saveButton)
        saveButton.anchor(top: nil, bottom: bottomAnchor, left: leftAnchor, right: nil, paddingTop: 0, paddingBottom: 36, paddingLeft: 24, paddingRight: 0, width: nil, height: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleCancel() {
        self.removeFromSuperview()
    }
    
    @objc func handleSave() {
        guard let savedImage = previewImageView.image else {return}
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: savedImage)
        }) { (success, error) in
            if let error = error {
                print("Error in saving photo to camera roll", error)
                return
            }
            
            DispatchQueue.main.async {
                let successLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
                successLabel.text = "Success"
                successLabel.textAlignment = .center
                successLabel.textColor = .white
                successLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                successLabel.center = self.center
                self.addSubview(successLabel)
                successLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                    successLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }) { (completed) in
                    UIView.animate(withDuration: 0.25, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        successLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                    }) { (completed) in
                        successLabel.removeFromSuperview()
                    }
                }
            }
        }
    }
}
