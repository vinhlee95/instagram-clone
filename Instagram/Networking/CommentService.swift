//
//  Comment.swift
//  Instagram
//
//  Created by Vinh Le on 3/23/20.
//  Copyright © 2020 Vinh Le. All rights reserved.
//

import Firebase

class CommentService {
    private var commentPath = "comments"
    private var userService = UserService()
    
    typealias FetchCommentResults = ([Comment]) -> Void
    typealias CreateCommentResult = () -> Void
    
    func fetchComments (postId: String, completion: @escaping FetchCommentResults) {
        var comments = [Comment]()
        Database.database().reference().child(commentPath).child(postId).observeSingleEvent(of: .value) { (snapshot) in
            guard let commentDictionaries = snapshot.value as? [String: Any] else {return}
            commentDictionaries.forEach { (key, value) in
                guard let commentDictionary = value as? [String: Any] else {return}
                guard let userId = commentDictionary["userId"] as? String else {return}
                
                self.userService.fetchUser(userId) { (user) in
                    let comment = Comment(dictionary: commentDictionary)
                    comment.user = user
                    comments.append(comment)
                }
            }
            
            completion(comments)
        }
    }
    
    func createComment (postId: String, comment: Comment, completion: @escaping CreateCommentResult) {          Database.database().reference().child(commentPath).child(postId).childByAutoId().updateChildValues(comment.commentDictionary) { (error, ref) in
            if let error = error {
                print("Error in creating new commment", error)
                return
            }
            
            print("Create comment success")
            completion()
        }
    }
}
