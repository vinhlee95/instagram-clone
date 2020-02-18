//
//  PostService.swift
//  Instagram
//
//  Created by Vinh Le on 2/17/20.
//  Copyright © 2020 Vinh Le. All rights reserved.
//

import Firebase

class PostService {
    //
    // Variables
    //
    var errorMessage = ""
    var posts = [Post]()
    
    //
    // Typealias
    //
    typealias FetchPostResult = ([Post], String) -> Void
    
    //
    // Internal methods
    //
    func fetchPosts(user: User, completion: @escaping FetchPostResult) {
        guard let userId = user.id else {return}
        let userPostsRef = Database.database().reference().child("posts").child(userId)
        userPostsRef.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            let post = Post(user: user, dictionary: dictionary)
            self.posts.insert(post, at: 0)
            completion(self.posts, self.errorMessage)
        }) { (error) in
            print("Error in getting posts", error)
        }
    }
}
