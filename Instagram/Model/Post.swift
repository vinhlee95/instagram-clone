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
    let creationDate: TimeInterval
}

extension Post {
    var postDictionary: [String: Any] {
        return ["imageUrl": imageUrl, "caption": caption, "imageWidth": imageWidth, "imageHeight": imageHeight, "creationDate": creationDate]
    }
}
