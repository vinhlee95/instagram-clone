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
    var user: User?
    private let cellId = "cellId"
    private var posts = [Post]()
    
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
//
extension HomeController {
    fileprivate func fetchPosts() {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        let userPostsRef = Database.database().reference().child("posts").child(userId)
        
        userService.fetchUser(userId) { (user, error) in
            self.user = user
        }
        
        userPostsRef.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            guard let user = self.user else {return}
            let post = Post(user: user, dictionary: dictionary)
            self.posts.insert(post, at: 0)
            self.collectionView.reloadData()
        }) { (error) in
            print("Error in getting posts", error)
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
