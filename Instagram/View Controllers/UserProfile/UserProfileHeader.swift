//
//  UserProfileHeader.swift
//  Instagram
//
//  Created by Vinh Le on 12/10/19.
//  Copyright © 2019 Vinh Le. All rights reserved.
//

import UIKit

class UserProfileHeader: UICollectionViewCell {
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "User name"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postLabel: UILabel = {
        let label = UILabel()
        label.addAttributeText(primaryText: "11", secondaryText: "posts")
        return label
    }()
    
    let followerLabel: UILabel = {
        let label = UILabel()
        label.addAttributeText(primaryText: "1000", secondaryText: "followers")
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.addAttributeText(primaryText: "1M", secondaryText: "following")
        return label
    }()
    
    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        return button
    }()
    
    var user: User? {
        didSet {
            setProfileImage()
            usernameLabel.text = user?.name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, bottom: nil, left: self.leftAnchor, right: nil, paddingTop: 12, paddingBottom: 0, paddingLeft: 12, paddingRight: 0, width: 80, height: 80)
        
        profileImageView.layer.cornerRadius = 80/2
        profileImageView.layer.masksToBounds = true
        renderBottomToolbar()
        renderUsernameLabel()
        renderInfoLabelGroup()
        renderEditProfileButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func renderBottomToolbar() {
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stackView.distribution = .fillEqually
        addSubview(stackView)

        stackView.anchor(top: nil, bottom: self.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: nil, height: 50)
        
        let borderTopView = UIView()
        borderTopView.backgroundColor = UIColor.lightGray
        addSubview(borderTopView)
        borderTopView.anchor(top: stackView.topAnchor, bottom: nil, left: stackView.leftAnchor, right: stackView.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: nil, height: 0.5)
        
        let borderBottomView = UIView()
        borderBottomView.backgroundColor = UIColor.lightGray
        addSubview(borderBottomView)
        borderBottomView.anchor(top: stackView.bottomAnchor, bottom: nil, left: stackView.leftAnchor, right: stackView.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: nil, height: 0.5)
    }
    
    fileprivate func renderUsernameLabel() {
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, bottom: gridButton.topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingBottom: 0, paddingLeft: 12, paddingRight: 0, width: nil, height: nil)
    }
    
    fileprivate func renderInfoLabelGroup() {
        let stackView = UIStackView(arrangedSubviews: [postLabel, followerLabel, followingLabel])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: topAnchor, bottom: nil, left: profileImageView.rightAnchor, right: rightAnchor, paddingTop: 12, paddingBottom: 0, paddingLeft: 12, paddingRight: 12, width: nil, height: 50)
    }
    
    fileprivate func renderEditProfileButton() {
        addSubview(editProfileButton)
        editProfileButton.anchor(top: postLabel.bottomAnchor, bottom: nil, left: profileImageView.rightAnchor, right: rightAnchor, paddingTop: 4, paddingBottom: 0, paddingLeft: 12, paddingRight: 12, width: nil, height: 35)
    }
    
    fileprivate func setProfileImage() {
        guard let profileImageUrl = self.user?.profileImageUrl else {return}
        self.profileImageView.download(from: profileImageUrl)
    }
}
