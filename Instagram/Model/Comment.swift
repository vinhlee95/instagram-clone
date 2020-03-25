//
//  Comment.swift
//  Instagram
//
//  Created by Vinh Le on 3/23/20.
//  Copyright © 2020 Vinh Le. All rights reserved.
//
import UIKit

class Comment {
    var user: User?
    let userId: String
    let body: String
    let creationDate: Date
    
    init(dictionary: [String: Any]) {
        self.body = dictionary["body"] as? String ?? ""
        let secondsFrom1979 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1979)
        self.userId = dictionary["userId"] as? String ?? ""
    }
}

extension Comment {
    var commentDictionary: [String: Any] {
        return ["body": body, "userId": userId, "creationDate": creationDate.timeIntervalSince1970]
    }
}
