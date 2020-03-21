//
//  PhotoPreviewController.swift
//  Instagram
//
//  Created by Vinh Le on 3/20/20.
//  Copyright © 2020 Vinh Le. All rights reserved.
//

import UIKit

class PhotoPreview: UIView {
    var previewImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(previewImageView)
        previewImageView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: nil, height: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
