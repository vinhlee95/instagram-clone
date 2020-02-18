//
//  User.swift
//  Instagram
//
//  Created by Vinh Le on 12/14/19.
//  Copyright © 2019 Vinh Le. All rights reserved.
//
import Firebase

struct User {
    let name: String
    let profileImageUrl: String
    var id: String?
    
    init(name: String, profileImageUrl: String, id: String) {
        self.name = name
        self.profileImageUrl = profileImageUrl
        self.id = id
    }
}
