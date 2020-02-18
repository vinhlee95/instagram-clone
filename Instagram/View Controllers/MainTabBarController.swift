//
//  MainTabBarController.swift
//  Instagram
//
//  Created by Vinh Le on 12/8/19.
//  Copyright © 2019 Vinh Le. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // Disable selection on Plus navigation item
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            
            // Present photo selection view
            let photoCollectionLayout = UICollectionViewFlowLayout()
            let photoSelectionController = PhotoSelectionController(collectionViewLayout: photoCollectionLayout)
            
            // Add navigation controller for top bar (that has Cancel and Next buttons)
            let navController = UINavigationController(rootViewController: photoSelectionController)
            
            present(navController, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        // Check if user has already logged in
        // if not, show login view
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
            
            return
        }
        
        setupViewController()
    }
    
    func setupViewController() {
        // Home and Navigation controller
        let homeLayout = UICollectionViewFlowLayout()
        let homeController = HomeController(collectionViewLayout: homeLayout)
        let homeNavController = self.templateNavController(UIImage(named: "home_unselected")!, UIImage(named: "home_selected")!, homeController)
        
        // Search and Navigation controller
        let searchController = UserSearchController(collectionViewLayout: UICollectionViewFlowLayout())
        let searchNavController = self.templateNavController(UIImage(named: "search_unselected")!, UIImage(named: "search_selected")!, searchController)
        
        // Search and Navigation controller
        let plusNavController = self.templateNavController(UIImage(named: "plus_unselected")!, UIImage(named: "plus_unselected")!)
        
        // Like and Navigation controller
        let likeNavController = self.templateNavController(UIImage(named: "like_unselected")!, UIImage(named: "like_selected")!)
        
        // Profile view controller
        let userProfileLayout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: userProfileLayout)
        
        // Profile navigation controller
        let userProfileNavController = self.templateNavController(UIImage(named: "profile_selected")!, UIImage(named: "profile_unselected")!, userProfileController)
        
        tabBar.tintColor = .black
        viewControllers = [homeNavController, searchNavController, plusNavController, likeNavController, userProfileNavController]
        
        // Add image insets for tabBar items
        // so that icons are vertically aligned
        guard let tabBarItems = tabBar.items else {return}
        
        for item in tabBarItems {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    //
    // Setup nav controller, add selected and unselected icons
    //
    fileprivate func templateNavController(_ unselectedImage: UIImage, _ selectedImage: UIImage, _ viewController: UIViewController? = UIViewController()) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController ?? UIViewController())
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        
        
        return navController
    }
}

