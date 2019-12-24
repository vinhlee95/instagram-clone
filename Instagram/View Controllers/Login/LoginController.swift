//
//  LoginController.swift
//  Instagram
//
//  Created by Vinh Le on 12/24/19.
//  Copyright © 2019 Vinh Le. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account? Sign up", for: .normal)
        button.addTarget(self, action: #selector(onSignupClick), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        self.view.backgroundColor = .white
        renderSignupButton()
    }
    
    //
    // Render Sign up button
    //
    fileprivate func renderSignupButton() {
        self.view.addSubview(signupButton)
        signupButton.anchor(top: nil, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: nil, height: 50)
    }
    
    //
    // Handle sign up
    //
    @objc func onSignupClick() {
        let signupController = SignupController()
        navigationController?.pushViewController(signupController, animated: true)
    }
}
