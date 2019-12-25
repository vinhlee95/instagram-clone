//
//  LoginController.swift
//  Instagram
//
//  Created by Vinh Le on 12/24/19.
//  Copyright © 2019 Vinh Le. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    let header: UIView = {
        let header = UIView()
        header.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        
        // Add Instagram logo to the header
        let logo = UIImageView(image: UIImage(named: "logo2"))
        logo.contentMode = .scaleAspectFit
        header.addSubview(logo)
        
        logo.anchor(top: nil, bottom: nil, left: nil, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 200, height: 40)
        logo.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
        logo.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
        
        return header
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account? Sign up", for: .normal)
        button.addTarget(self, action: #selector(onSignupClick), for: .touchUpInside)
        return button
    }()
    
    // Add light color to status bar so that texts are white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white
        
        // Render UI elements
        renderSignupButton()
        renderHeader()
    }
    
    //
    // Render Sign up button
    //
    fileprivate func renderSignupButton() {
        self.view.addSubview(signupButton)
        signupButton.anchor(top: nil, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: -10, paddingLeft: 0, paddingRight: 0, width: nil, height: 50)
    }
    
    //
    // Handle sign up
    //
    @objc func onSignupClick() {
        let signupController = SignupController()
        navigationController?.pushViewController(signupController, animated: true)
    }
    
    //
    // Render Header
    //
    fileprivate func renderHeader() {
        self.view.addSubview(header)
        header.anchor(top: view.topAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: nil, height: 150)
    }
}
