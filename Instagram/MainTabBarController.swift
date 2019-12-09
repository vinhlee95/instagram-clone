//
//  MainTabBarController.swift
//  Instagram
//
//  Created by Vinh Le on 12/8/19.
//  Copyright © 2019 Vinh Le. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userProfileController = UserProfileController()
        let navController = UINavigationController(rootViewController: userProfileController)
        
        viewControllers = [navController]
    }
}
