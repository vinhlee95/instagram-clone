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
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        guard let userId = Auth.auth().currentUser?.uid else {return}
        fetchUser(userId)
    }
    
    fileprivate func fetchUser(_ userId: String) {
        Database.database().reference().child("users").child(userId).observeSingleEvent(of: .value) { (snapshot, error) in
            if let error = error {
                print("Error in getting user data", error)
            }
            
            guard let user = snapshot.value as? [String: Any] else {return}
            print(user)
            let username = user["username"] as! String
            self.navigationItem.title = username
        }
    }
}
