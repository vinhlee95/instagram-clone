//
//  PhotoPreviewController.swift
//  Instagram
//
//  Created by Vinh Le on 3/20/20.
//  Copyright © 2020 Vinh Le. All rights reserved.
//

import UIKit

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
        print("Save image")
    }
}
