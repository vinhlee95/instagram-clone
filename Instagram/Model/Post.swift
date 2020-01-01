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
    let creationDate: TimeInterval?
    
    init(dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        self.imageWidth = dictionary["imageWidth"] as? CGFloat ?? 0
        self.imageHeight = dictionary["imageHeight"] as? CGFloat ?? 0
        self.creationDate = dictionary["creationDate"] as? TimeInterval ?? 0
    }
}

extension Post {
    var postDictionary: [String: Any] {
        return ["imageUrl": imageUrl, "caption": caption, "imageWidth": imageWidth, "imageHeight": imageHeight, "creationDate": creationDate]
    }
}
