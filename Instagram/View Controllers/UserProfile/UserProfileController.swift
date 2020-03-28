//
//  UserProfileController.swift
//  Instagram
//
//  Created by Vinh Le on 12/9/19.
//  Copyright © 2019 Vinh Le. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController {
    //
    // Variables
    //
    var userService = UserService()
    var postService = PostService()
    var user: User?
    var userId: String?
    var hasPosts = true

    private let cellId = "cellId"
    private let headerId = "headerId"
    private let headerHeight: CGFloat = 200
    private let cellPerRow: CGFloat = 3
    private var posts = [Post]()
    private let count: UInt = 5
    
    //
    // Override methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        guard let userId = (self.userId ?? Auth.auth().currentUser?.uid) else {return}
        userService.fetchUser(userId) { (user) in
            self.user = user
            guard let username = user?.name else {return}
            
            self.navigationItem.title = username
            self.collectionView?.reloadData()
        }
        
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(UserPhotoCell.self, forCellWithReuseIdentifier: cellId)
        
        renderLogoutButton()
        fetchPosts()
    }
    
    fileprivate func renderLogoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear"), style: .plain, target: self, action: #selector(onGearIconClick))
    }
    
    @objc func onGearIconClick() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                // Preset login view
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
                
            } catch let error {
                print("Error in loggin user out", error)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

}

//
// Cell data source
//
extension UserProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeader
        header.user = self.user
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserPhotoCell
        
        if(indexPath.item == self.posts.count - 1 && self.hasPosts) {
            self.fetchPosts()
        }
        
        let post = posts[indexPath.item]
        cell.imageUrl = post.imageUrl
        
        return cell
    }
}

//
// Collection view flow layout
//
extension UserProfileController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    // Configure size for each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalGap = cellPerRow - 1
        let width = (view.frame.width - totalGap) / cellPerRow
        return CGSize(width: width, height: width)
    }
    
    // Add line spacing between rows
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // Add spacing between items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //
    // Internal methods
    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: headerHeight)
    }
}

//
// Fetch posts
//
extension UserProfileController {
    fileprivate func fetchPosts() {
        guard let userId = (self.userId ?? Auth.auth().currentUser?.uid) else {return}
        var cursor: String?
        
        userService.fetchUser(userId) { (user) in
            guard let user = user else {return}
            if self.posts.count > 0 {
                cursor = self.posts.last?.id
            }
            
            self.postService.paginatePosts(user: user, cursor: cursor, count: self.count) { (posts) in
                if posts.count < self.count-1 {
                    self.hasPosts = false
                }
                
                posts.forEach { (post) in
                    self.posts.append(post)
                    self.collectionView.reloadData()
                }
            }
        }
    }
}
