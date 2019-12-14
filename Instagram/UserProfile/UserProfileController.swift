//
//  UserProfileController.swift
//  Instagram
//
//  Created by Vinh Le on 12/9/19.
//  Copyright © 2019 Vinh Le. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        guard let userId = Auth.auth().currentUser?.uid else {return}
        fetchUser(userId)
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        header.user = self.user
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    fileprivate func fetchUser(_ userId: String) {
        Database.database().reference().child("users").child(userId).observeSingleEvent(of: .value) { (snapshot, error) in
            if let error = error {
                print("Error in getting user data", error)
            }
            
            guard let fetchedUser = snapshot.value as? [String: String] else {return}
            self.user = User(name: fetchedUser["username"] ?? "", profileImageUrl: fetchedUser["avatar_url"] ?? "")
            
            let username = self.user?.name
            self.navigationItem.title = username
            self.collectionView?.reloadData()
        }
    }
}
