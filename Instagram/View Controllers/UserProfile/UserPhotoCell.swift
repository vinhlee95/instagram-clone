//
//  UserPhotoCell.swift
//  Instagram
//
//  Created by Vinh Le on 1/1/20.
//  Copyright © 2020 Vinh Le. All rights reserved.
//

import UIKit

class UserPhotoCell: UICollectionViewCell {
    
    var imageUrl: String? {
        didSet {
            self.renderImageCell()
        }
    }
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        
        // Anchoring photo image view
        // so that it is entirely fit within the cell
        photoImageView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: nil, height: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
// Render image cell
//
extension UserPhotoCell {
    fileprivate func renderImageCell() {
        guard let url = self.imageUrl else {return}
        self.photoImageView.download(from: url, self.imageUrl)
    }
}
