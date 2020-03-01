//
//  Post.swift
//  Instagram
//
//  Created by Vinh Le on 1/1/20.
//  Copyright © 2020 Vinh Le. All rights reserved.
//
import UIKit

typealias TimeInterval = Double

struct Post {
    let imageUrl: String
    let caption: String
    let imageWidth: CGFloat?
    let imageHeight: CGFloat?
    let creationDate: Date
    let user: User?
    
    init(user: User?, dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        self.imageWidth = dictionary["imageWidth"] as? CGFloat ?? 0
        self.imageHeight = dictionary["imageHeight"] as? CGFloat ?? 0
        
        let secondsFrom1979 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1979)
        self.user = user
    }
}

extension Post {
    var postDictionary: [String: Any] {
        return ["imageUrl": imageUrl, "caption": caption, "imageWidth": imageWidth, "imageHeight": imageHeight, "creationDate": creationDate.timeIntervalSince1970]
    }
}
