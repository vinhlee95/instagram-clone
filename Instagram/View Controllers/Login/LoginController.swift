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
    
    // Email text field
    let emailTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your email"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = UIColor(white: 0, alpha: 0.03)
//        textfield.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        
        return textfield
    }()
    
    // Password text field
    let passwordTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Password"
        textfield.isSecureTextEntry = true
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = UIColor(white: 0, alpha: 0.03)
//        textfield.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        
        return textfield
    }()
    
    // Sign up button
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        
//        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        
        return button
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign up", attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.rgb(red: 77, green: 166, blue: 255)]))
       
        button.setAttributedTitle(attributedTitle, for: .normal)
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
        renderLoginForm()
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
    
    //
    // Render login form
    //
    fileprivate func renderLoginForm() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        self.view.addSubview(stackView)
        stackView.anchor(top: header.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 20, paddingRight: 20, width: nil, height: 140)
    }
}
