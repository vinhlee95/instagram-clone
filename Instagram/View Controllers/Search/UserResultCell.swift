//
//  UserResultCell.swift
//  Instagram
//
//  Created by Vinh Le on 2/19/20.
//  Copyright © 2020 Vinh Le. All rights reserved.
//

import UIKit

class UserResultCell: UICollectionViewCell {
    //
    // Variables
    //
    private var profileImageSize = CGFloat(40)
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .blue
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let profileNameView: UILabel = {
        let label = UILabel()
        label.text = "Vinh Le"
        return label
    }()
    
    let separatorView: UIView = {
        let sv = UIView()
        sv.backgroundColor = .gray
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)        
        renderProfileImageView()
        renderProfileNameView()
        renderSeparatorView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func renderProfileImageView() {
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, bottom: nil, left: leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: profileImageSize, height: profileImageSize)
        profileImageView.layer.cornerRadius = profileImageSize/2
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    fileprivate func renderProfileNameView() {
        addSubview(profileNameView)
        profileNameView.anchor(top: topAnchor, bottom: bottomAnchor, left: profileImageView.rightAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: nil, height: nil)
    }
    
    fileprivate func renderSeparatorView() {
        addSubview(separatorView)
        separatorView.anchor(top: nil, bottom: bottomAnchor, left: profileNameView.leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: nil, height: 0.5)
    }
}
