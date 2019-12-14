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
        iv.backgroundColor = .red
        return iv
    }()
    
    var user: User? {
        didSet {
            setProfileImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
        self.contentView.addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: 10, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80/2
        profileImageView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setProfileImage() {
        guard let profileImageUrl = self.user?.profileImageUrl else {return}
        guard let url = URL(string: profileImageUrl) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error in setting user profile image", error)
                return
            }
            
            guard let data = data else {return}
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
        }.resume()
    }
}
