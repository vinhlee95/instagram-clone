//
//  HomeCell.swift
//  Instagram
//
//  Created by Vinh Le on 1/6/20.
//  Copyright © 2020 Vinh Le. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {
    var post: Post? {
        didSet {
            self.renderPostDetails()
        }
    }
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let userprofileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .blue
        return iv
    }()
    
    let usernameView: UITextView = {
        let uv = UITextView()
        return uv
    }()
    
    let usernameLabelView: UILabel = {
        let label = UILabel()
        label.text = "User name"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    let optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add sub-views first to ensure following subviews have the same parent
        // https://stackoverflow.com/questions/35452908/swift-add-constraint-programmatically
        addSubview(userprofileImageView)
        addSubview(usernameLabelView)
        addSubview(photoImageView)
        addSubview(optionButton)
        
        anchorUserProfilePhoto()
        anchorUsernameLabel()
        anchorPostPhoto()
        anchorOptionButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func anchorUserProfilePhoto() {
        userprofileImageView.anchor(top: topAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: 8, paddingBottom: 8, paddingLeft: 8, paddingRight: 0, width: 40, height: 40)
        userprofileImageView.layer.cornerRadius = 40/2
    }
    
    fileprivate func anchorUsernameLabel() {
        usernameLabelView.anchor(top: topAnchor, bottom: photoImageView.topAnchor, left: userprofileImageView.rightAnchor, right: optionButton.leftAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: nil, height: nil)
    }
    
    fileprivate func anchorPostPhoto() {
        photoImageView.anchor(top: userprofileImageView.bottomAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: nil, height: nil)
    }
    
    fileprivate func anchorOptionButton() {
        optionButton.anchor(top: topAnchor, bottom: photoImageView.topAnchor, left: nil, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 8, width: nil, height: nil)
    }
}

//
// Render post details
//
extension HomeCell {
    fileprivate func renderPostDetails() {
        guard let post = self.post else {return}
        
        self.photoImageView.download(from: post.imageUrl, post.imageUrl)
    }
}
