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
    private let postPath = "posts"
    
    //
    // Typealias
    //
    typealias FetchPostResult = ([Post]) -> Void
    typealias CreatePostResult = () -> Void
    
    //
    // Internal methods
    //
    func fetchPosts(user: User, completion: @escaping FetchPostResult) {
        guard let userId = user.id else {return}
        let userPostsRef = Database.database().reference().child(postPath).child(userId)
        var posts = [Post]()
        
        userPostsRef.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            let post = Post(user: user, dictionary: dictionary)
            posts.insert(post, at: 0)
            completion(posts)
        }) { (error) in
            print("Error in getting posts", error)
        }
    }
    
    
    func fetchPostsByUser(user: User, completion: @escaping FetchPostResult) {
        guard let userId = user.id else {return}
        let userPostsRef = Database.database().reference().child(postPath).child(userId)
        var posts = [Post]()
        
        userPostsRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            dictionaries.forEach { (key, value) in
                guard let dictionary = value as? [String: Any] else {return}
                let post = Post(user: user, dictionary: dictionary)
                posts.append(post)
            }
            completion(posts)
        }
    }
    
    func createPost(userId: String, post: Post, completion: @escaping CreatePostResult) {
        let userPostRef = Database.database().reference().child(postPath).child(userId)
        let ref = userPostRef.childByAutoId()
        ref.updateChildValues(post.postDictionary) { (error, ref) in
            if let error = error {
                print("Error in create a new post", error)
                return
            }
            
            print("Successfully save image url to db")
            completion()
        }
    }
}
