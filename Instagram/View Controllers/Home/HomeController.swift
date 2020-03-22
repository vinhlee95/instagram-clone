//
//  HomeController.swift
//  Instagram
//
//  Created by Vinh Le on 1/6/20.
//  Copyright © 2020 Vinh Le. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, HomeCellDelegate {
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
        
        // Set up navigation bar
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera3")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleOpenCamera))
        
        // Fetch posts
        fetchPosts()
        
        // Refreshing posts data
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshPosts), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        // Observe new post notification from PhotoShareController
        // to update the data automatically
        NotificationCenter.default.addObserver(self, selector: #selector(handleObserveNewPost), name: PhotoShareController.newPostName, object: nil)
    }
}

//
// Handle Camera
//
extension HomeController {
    @objc func handleOpenCamera() {
        let cameraController = CameraController()
        cameraController.modalPresentationStyle = .fullScreen
        self.present(cameraController, animated: true, completion: nil)
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
            self.collectionView.refreshControl?.endRefreshing()
            posts.forEach { (post) in
                self.posts.append(post)
            }
            
            // Sort posts by creation date
            self.posts = self.posts.sorted(by: { (post, nextPost) -> Bool in
                return post.creationDate.compare(nextPost.creationDate) == .orderedDescending
            })
            
            self.collectionView.reloadData()
        }
    }
}

//
// Data refreshing when
// * Pulling down from top
// * New post
//
extension HomeController {
    @objc func handleRefreshPosts() {
        self.posts.removeAll()
        fetchPosts()
    }
    
    @objc func handleObserveNewPost() {
        handleRefreshPosts()
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
        if posts.count > indexPath.item {
            let post = posts[indexPath.item]
            cell.post = post
        }
        
        cell.delegate = self
        
        return cell
    }
    
    func didTapComment(post: Post) {
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewLayout())
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
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
