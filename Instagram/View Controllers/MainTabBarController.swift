//
//  MainTabBarController.swift
//  Instagram
//
//  Created by Vinh Le on 12/8/19.
//  Copyright © 2019 Vinh Le. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if user has already logged in
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                self.present(loginController, animated: true, completion: nil)
            }
            
            return
        }
        
        // Define collection flow layout
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: userProfileController)
        
        // Set tabBar item icon image and tint color
        navController.tabBarItem.image = UIImage(named: "profile_unselected")
        navController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        tabBar.tintColor = .black
        
        viewControllers = [navController, UIViewController()]
    }
}
