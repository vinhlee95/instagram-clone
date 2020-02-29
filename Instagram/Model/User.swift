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
    var following: [String?] = []
    
    init(name: String, profileImageUrl: String, id: String, following: [String?] = []) {
        self.name = name
        self.profileImageUrl = profileImageUrl
        self.id = id
        self.following = following
    }
}
