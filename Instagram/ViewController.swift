//
//  ViewController.swift
//  Instagram
//
//  Created by Vinh Le on 11/17/19.
//  Copyright © 2019 Vinh Le. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    // Plus button
    let plusPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plush_photo"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // User name text field
    let usernameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "User name"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textfield.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        
        return textfield
    }()
    
    // Email text field
    let emailTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your email"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textfield.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        
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
        textfield.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        
        return textfield
    }()
    
    // Sign up button
    let signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleInputChange() {
        let isEmailValid = !emailTextField.text!.isEmpty
        let isPasswordValid = !passwordTextField.text!.isEmpty
        let isUsernameValid = !usernameTextField.text!.isEmpty
        
        // Disable the button and add disabled-blue background color
        guard isEmailValid && isPasswordValid && isUsernameValid else {
            signupButton.isEnabled = false
            signupButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
            return
        }
        
        // Enable the button and add bolder blue background
        signupButton.isEnabled = true
        signupButton.backgroundColor = .blue
    }
    
    @objc func handleSignup() {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let err = error {
                self.handleError(error: err, title: "Sign up failed")
                return
            }
            
            print("Sign up success: ", user ?? "")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(plusPhotoButton)
        
        plusPhotoButton.anchor(top: view.topAnchor, bottom: nil, left: nil, right: nil, paddingTop: 40, paddingBottom: 40, paddingLeft: 0, paddingRight: 0, width: 140, height: 140)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
        // Init input text fields
        setInputFields()
    }
    
    func handleError(error: Error, title: String) {
        print("ERROR \(error.localizedDescription)")
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func setInputFields() {
        // create a stack view
        let stackView = UIStackView(arrangedSubviews: [
            usernameTextField, emailTextField, passwordTextField, signupButton
        ])
    
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        // Add Stack view to view
        view.addSubview(stackView)
        
        // Add constraints
        stackView.anchor(top: plusPhotoButton.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 20, paddingRight: 20, width: 0, height: 200)
    }
}
