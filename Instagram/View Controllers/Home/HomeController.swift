//
//  HomeController.swift
//  Instagram
//
//  Created by Vinh Le on 1/6/20.
//  Copyright © 2020 Vinh Le. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController {
    //
    // Variables
    //
    var userService = UserService()
    var postService = PostService()
    var user: User?
    private let cellId = "cellId"
    private var posts = [Post]()
    private var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
        
        fetchPosts()
    }
}

//
// Fetch posts data from Firebase
// Posts include own user and following users's
//
extension HomeController {
    fileprivate func fetchPosts() {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        userService.fetchUser(userId) { (user) in
            guard let user = user else {return}
            
            // Fetch own user's posts
            self.fetchUserPosts(user: user)
            
            
            // Fetch following users's posts
            user.following.forEach {(followingId) in
                guard let followingId = followingId else {return}
                self.userService.fetchUser(followingId) { (user) in
                    guard let followingUser = user else {return}
                    self.fetchUserPosts(user: followingUser)
                }
            }
        }
    }
    
    fileprivate func fetchUserPosts(user: User) {
        self.postService.fetchPostsByUser(user: user) { (posts) in
            posts.forEach { (post) in
                print("Append post", post.creationDate?.description)
                self.posts.append(post)
            }
            self.collectionView.reloadData()
        }
    }
}

//
// Configure cells
//
extension HomeController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCell
        let post = posts[indexPath.item]
        cell.post = post
        return cell
    }
}

//
// Configure sizing and insets for cell collection view
//
extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 + 8 // user profile image + paddings
        height += view.frame.width
        height += 40 // action buttons
        height += 60 // image caption label
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}
