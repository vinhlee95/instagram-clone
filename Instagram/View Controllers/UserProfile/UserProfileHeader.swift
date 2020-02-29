//
//  UserProfileHeader.swift
//  Instagram
//
//  Created by Vinh Le on 12/10/19.
//  Copyright © 2019 Vinh Le. All rights reserved.
//

import UIKit

class UserProfileHeader: UICollectionViewCell {
    private var userService = UserService()
    
    var user: User? {
        didSet {
            setProfileImage()
            usernameLabel.text = user?.name
        }
    }
    var ownUser: User? {
        didSet {
            setEditButtonTitle()
        }
    }
    
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
    
    lazy var editProfileOrFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleEditOrFollow), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(profileImageView)
        self.fetchOwnUser()
        profileImageView.anchor(top: topAnchor, bottom: nil, left: self.leftAnchor, right: nil, paddingTop: 12, paddingBottom: 0, paddingLeft: 12, paddingRight: 0, width: 80, height: 80)
        
        profileImageView.layer.cornerRadius = 80/2
        profileImageView.layer.masksToBounds = true
        renderBottomToolbar()
        renderUsernameLabel()
        renderInfoLabelGroup()
        renderEditProfileOrFollowButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func fetchOwnUser() {
        guard let userId = userService.getCurrentUserId() else {return}
        userService.fetchUser(userId) { (user, error) in
            self.ownUser = user
        }
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
    
    fileprivate func renderEditProfileOrFollowButton() {
        addSubview(editProfileOrFollowButton)
        editProfileOrFollowButton.anchor(top: postLabel.bottomAnchor, bottom: nil, left: profileImageView.rightAnchor, right: rightAnchor, paddingTop: 4, paddingBottom: 0, paddingLeft: 12, paddingRight: 12, width: nil, height: 35)
    }
    
    fileprivate func setProfileImage() {
        guard let profileImageUrl = self.user?.profileImageUrl else {return}
        self.profileImageView.download(from: profileImageUrl)
    }
    
    fileprivate func setEditButtonTitle() {
        guard let userId = userService.getCurrentUserId() else {return}
        guard let currentUserId = self.user?.id else {return}
        
        if(userId == currentUserId) {
            editProfileOrFollowButton.setTitle("Edit profile", for: .normal)
        } else {
            if self.didFollow(userId: currentUserId) {
                 editProfileOrFollowButton.setTitle("Unfollow", for: .normal)
            } else {
                 editProfileOrFollowButton.setTitle("Follow", for: .normal)
            }
        }
    }
}

//
// Handle edit profile or follow
//
extension UserProfileHeader {
    @objc func handleEditOrFollow() {
        guard let userId = userService.getCurrentUserId() else {return}
        guard let profileUserId = self.user?.id else {return}
        
        if(userId == profileUserId) {
            print("Edit")
        } else {
            handleFollowUser(userId: profileUserId)
        }
    }
    
    fileprivate func handleFollowUser(userId: String) {
        if didFollow(userId: userId) {
            userService.unfollowUser(userId: userId) { () in
                self.editProfileOrFollowButton.setTitle("Follow", for: .normal)
                // Update own user's following list
                guard let previousFollowing = self.ownUser?.following else {return}
                self.ownUser?.following = previousFollowing.filter({ (followingId) -> Bool in
                    return followingId != userId
                })
            }
        } else {
            guard let ownUser = self.ownUser else {return}
            userService.followUser(userId: userId, user: ownUser) { () in
                self.editProfileOrFollowButton.setTitle("Unfollow", for: .normal)
                // Update own user's following list
                self.ownUser?.following.append(userId)
            }
        }
    }
    
    fileprivate func didFollow(userId: String) -> Bool {
        guard let followingUsers = self.ownUser?.following else {return false}
        return followingUsers.contains { (followingUserId) -> Bool in
            return followingUserId == userId
        }
    }
}
